#!/usr/bin/env python3
"""Local VIBR UDP transmitter that simulates the KR260 board."""

from __future__ import annotations

import argparse
import socket
import time

from udp_protocol import (
    CLASS_HEALTHY,
    CLASS_INNER_FAULT,
    CLASS_OUTER_FAULT,
    DATA_TIME_SAMPLES,
    STATE_RUNNING,
    build_classification_packet,
    build_measurement_packet,
    build_status_packet,
)


def scores_for_class(class_id: int) -> tuple[int, int, int]:
    scores = [50, 50, 50]
    scores[class_id] = 900
    return tuple(scores)


def run(destination_ip: str, port: int, period_s: float) -> None:
    frame_id = 0
    start = time.monotonic()
    last_status = 0.0

    with socket.socket(socket.AF_INET, socket.SOCK_DGRAM) as sock:
        print(f"Sending simulated board traffic to {destination_ip}:{port}")

        while True:
            frame_timestamp_us = time.time_ns() // 1_000
            values = list(range(1024))

            # Intentionally send packets out of order to test the assembler.
            for packet_id in (2, 0, 3, 1):
                first_index = packet_id * 256
                datagram = build_measurement_packet(
                    frame_id=frame_id,
                    packet_id=packet_id,
                    packet_count=4,
                    first_index=first_index,
                    values=values[first_index:first_index + 256],
                    data_kind=DATA_TIME_SAMPLES,
                    timestamp_us=frame_timestamp_us,
                )
                sock.sendto(datagram, (destination_ip, port))

            class_id = (
                CLASS_HEALTHY,
                CLASS_INNER_FAULT,
                CLASS_OUTER_FAULT,
            )[frame_id % 3]

            classification = build_classification_packet(
                frame_id=frame_id,
                class_id=class_id,
                confidence_permille=900,
                scores_permille=scores_for_class(class_id),
                inference_time_us=4_200,
                model_version=1,
                timestamp_us=frame_timestamp_us,
            )
            sock.sendto(classification, (destination_ip, port))

            now = time.monotonic()
            if now - last_status >= 1.0:
                status = build_status_packet(
                    frame_id=frame_id,
                    board_state=STATE_RUNNING,
                    dma_state=STATE_RUNNING,
                    model_state=STATE_RUNNING,
                    ethernet_state=STATE_RUNNING,
                    dropped_frames=0,
                    uptime_ms=int((now - start) * 1_000),
                    timestamp_us=frame_timestamp_us,
                )
                sock.sendto(status, (destination_ip, port))
                last_status = now

            print(f"TX frame={frame_id}, class={class_id}")
            frame_id += 1
            time.sleep(period_s)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument("--destination", default="127.0.0.1")
    parser.add_argument("--port", type=int, default=5001)
    parser.add_argument("--period", type=float, default=0.5)
    return parser.parse_args()


if __name__ == "__main__":
    args = parse_args()
    try:
        run(args.destination, args.port, args.period)
    except KeyboardInterrupt:
        print("\nTransmitter stopped")
