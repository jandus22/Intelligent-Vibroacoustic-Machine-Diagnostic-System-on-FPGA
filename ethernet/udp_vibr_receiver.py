#!/usr/bin/env python3
"""Console receiver for the VIBR UDP protocol.

It:
- receives all three message types on one UDP port,
- assembles measurement frames using frame_id and packet_id,
- accepts packets in any order,
- associates the model result with the same frame_id,
- removes incomplete frames after a timeout,
- reports loss of board status messages.
"""

from __future__ import annotations

from dataclasses import dataclass, field
import argparse
import socket
import time
from typing import Dict, Optional

from udp_protocol import (
    BoardStatusPacket,
    ClassificationPacket,
    MeasurementPacket,
    ProtocolError,
    parse_datagram,
)


CLASS_NAMES = {
    0: "HEALTHY",
    1: "INNER_RING_FAULT",
    2: "OUTER_RING_FAULT",
    255: "UNKNOWN",
}

STATE_NAMES = {
    0: "BOOTING",
    1: "READY",
    2: "RUNNING",
    3: "ERROR",
}


@dataclass
class FrameState:
    frame_id: int
    packet_count: Optional[int] = None
    packets: Dict[int, MeasurementPacket] = field(default_factory=dict)
    classification: Optional[ClassificationPacket] = None
    created_monotonic: float = field(default_factory=time.monotonic)
    data_complete: bool = False
    values: tuple[int | float, ...] = ()


class FrameAssembler:
    def __init__(self, frame_timeout_s: float = 1.0, max_frames: int = 64):
        self.frame_timeout_s = frame_timeout_s
        self.max_frames = max_frames
        self.frames: Dict[int, FrameState] = {}
        self.completed_data_frames = 0
        self.timed_out_frames = 0
        self.duplicate_packets = 0

    def _get_frame(self, frame_id: int) -> FrameState:
        frame = self.frames.get(frame_id)
        if frame is None:
            self._enforce_capacity()
            frame = FrameState(frame_id=frame_id)
            self.frames[frame_id] = frame
        return frame

    def _enforce_capacity(self) -> None:
        if len(self.frames) < self.max_frames:
            return

        oldest_id = min(
            self.frames,
            key=lambda current_id: self.frames[current_id].created_monotonic,
        )
        del self.frames[oldest_id]
        self.timed_out_frames += 1
        print(f"DROP: frame={oldest_id}, reason=assembler_capacity")

    def add_measurement(self, packet: MeasurementPacket) -> None:
        header = packet.header
        frame = self._get_frame(header.frame_id)

        if frame.packet_count is None:
            frame.packet_count = header.packet_count
        elif frame.packet_count != header.packet_count:
            print(
                f"DROP: frame={header.frame_id}, inconsistent packet_count "
                f"{header.packet_count} != {frame.packet_count}"
            )
            return

        if header.packet_id in frame.packets:
            self.duplicate_packets += 1
            print(
                f"DUPLICATE: frame={header.frame_id}, "
                f"packet={header.packet_id}/{header.packet_count - 1}"
            )
            return

        frame.packets[header.packet_id] = packet
        print(
            f"RX DATA: frame={header.frame_id}, "
            f"packet={header.packet_id}/{header.packet_count - 1}, "
            f"first={packet.first_index}, count={packet.element_count}"
        )

        if len(frame.packets) == frame.packet_count:
            self._complete_data(frame)

    def _complete_data(self, frame: FrameState) -> None:
        ordered = sorted(
            frame.packets.values(),
            key=lambda current_packet: current_packet.first_index,
        )

        expected_index = 0
        values: list[int | float] = []

        for packet in ordered:
            if packet.first_index != expected_index:
                print(
                    f"DROP: frame={frame.frame_id}, "
                    f"index gap at {expected_index}, got {packet.first_index}"
                )
                return

            values.extend(packet.values)
            expected_index += packet.element_count

        frame.values = tuple(values)
        frame.data_complete = True
        self.completed_data_frames += 1

        print(
            f"FRAME COMPLETE: frame={frame.frame_id}, "
            f"elements={len(frame.values)}, "
            f"first16={list(frame.values[:16])}"
        )
        self._report_synchronization(frame)
        self._remove_if_fully_consumed(frame)

    def add_classification(self, packet: ClassificationPacket) -> None:
        frame = self._get_frame(packet.header.frame_id)
        frame.classification = packet

        class_name = CLASS_NAMES.get(
            packet.class_id,
            f"CLASS_{packet.class_id}",
        )
        scores = packet.scores_permille

        print(
            f"RX MODEL: frame={packet.header.frame_id}, "
            f"class={class_name}, "
            f"confidence={packet.confidence_permille / 10:.1f}%, "
            f"scores=[{scores[0] / 10:.1f}%, "
            f"{scores[1] / 10:.1f}%, "
            f"{scores[2] / 10:.1f}%], "
            f"inference={packet.inference_time_us} us"
        )

        self._report_synchronization(frame)
        self._remove_if_fully_consumed(frame)

    @staticmethod
    def _report_synchronization(frame: FrameState) -> None:
        if not frame.data_complete or frame.classification is None:
            return

        print(
            f"SYNC OK: frame={frame.frame_id}, "
            f"data_elements={len(frame.values)}, "
            f"model_class={CLASS_NAMES.get(frame.classification.class_id, 'UNKNOWN')}"
        )

    def _remove_if_fully_consumed(self, frame: FrameState) -> None:
        if frame.data_complete and frame.classification is not None:
            self.frames.pop(frame.frame_id, None)

    def cleanup_expired(self) -> None:
        now = time.monotonic()
        expired_ids = [
            frame_id
            for frame_id, frame in self.frames.items()
            if now - frame.created_monotonic > self.frame_timeout_s
        ]

        for frame_id in expired_ids:
            frame = self.frames.pop(frame_id)
            missing_data = not frame.data_complete
            missing_model = frame.classification is None
            self.timed_out_frames += 1

            print(
                f"TIMEOUT: frame={frame_id}, "
                f"missing_data={missing_data}, "
                f"missing_model={missing_model}, "
                f"received_packets={len(frame.packets)}/"
                f"{frame.packet_count if frame.packet_count is not None else '?'}"
            )


def print_status(packet: BoardStatusPacket) -> None:
    print(
        "RX STATUS: "
        f"board={STATE_NAMES.get(packet.board_state, packet.board_state)}, "
        f"dma={STATE_NAMES.get(packet.dma_state, packet.dma_state)}, "
        f"model={STATE_NAMES.get(packet.model_state, packet.model_state)}, "
        f"ethernet={STATE_NAMES.get(packet.ethernet_state, packet.ethernet_state)}, "
        f"last_frame={packet.last_frame_id}, "
        f"dropped={packet.dropped_frames}, "
        f"uptime={packet.uptime_ms} ms, "
        f"last_error={packet.last_error}"
    )


def run_receiver(
    bind_ip: str,
    port: int,
    frame_timeout_s: float,
    board_timeout_s: float,
) -> None:
    assembler = FrameAssembler(frame_timeout_s=frame_timeout_s)
    last_status_monotonic: Optional[float] = None
    connection_warning_active = False

    with socket.socket(socket.AF_INET, socket.SOCK_DGRAM) as sock:
        sock.bind((bind_ip, port))
        sock.settimeout(0.2)

        print(f"Listening on {bind_ip}:{port}")

        while True:
            try:
                datagram, source = sock.recvfrom(2048)
            except socket.timeout:
                assembler.cleanup_expired()

                if (
                    last_status_monotonic is not None
                    and time.monotonic() - last_status_monotonic
                    > board_timeout_s
                    and not connection_warning_active
                ):
                    print(
                        f"BOARD TIMEOUT: no status for more than "
                        f"{board_timeout_s:.1f} s"
                    )
                    connection_warning_active = True
                continue
            except KeyboardInterrupt:
                print("\nReceiver stopped")
                break

            try:
                packet = parse_datagram(datagram)
            except ProtocolError as exc:
                print(
                    f"INVALID from={source}, bytes={len(datagram)}: {exc}"
                )
                continue

            if isinstance(packet, MeasurementPacket):
                assembler.add_measurement(packet)
            elif isinstance(packet, ClassificationPacket):
                assembler.add_classification(packet)
            elif isinstance(packet, BoardStatusPacket):
                print_status(packet)
                last_status_monotonic = time.monotonic()

                if connection_warning_active:
                    print("BOARD CONNECTION RESTORED")
                    connection_warning_active = False

            assembler.cleanup_expired()


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument("--bind", default="0.0.0.0")
    parser.add_argument("--port", type=int, default=5001)
    parser.add_argument("--frame-timeout", type=float, default=1.0)
    parser.add_argument("--board-timeout", type=float, default=2.5)
    return parser.parse_args()


if __name__ == "__main__":
    args = parse_args()
    run_receiver(
        bind_ip=args.bind,
        port=args.port,
        frame_timeout_s=args.frame_timeout,
        board_timeout_s=args.board_timeout,
    )
