"""VIBR UDP protocol version 1.

Every multibyte field uses network byte order (big-endian).
The module contains both parsing and packet-building helpers, which allows
the PC receiver to be tested before the FPGA application is modified.
"""

from __future__ import annotations

from dataclasses import dataclass
import struct
import time
from typing import Tuple, Union


MAGIC = b"VIBR"
PROTOCOL_VERSION = 1

MSG_MEASUREMENT = 0x01
MSG_CLASSIFICATION = 0x02
MSG_BOARD_STATUS = 0x03

DATA_TIME_SAMPLES = 0
DATA_FFT_MAGNITUDE = 1
DATA_FFT_COMPLEX = 2

FORMAT_INT32 = 0
FORMAT_FLOAT32 = 1
FORMAT_INT16 = 2

CLASS_HEALTHY = 0
CLASS_INNER_FAULT = 1
CLASS_OUTER_FAULT = 2
CLASS_UNKNOWN = 255

STATE_BOOTING = 0
STATE_READY = 1
STATE_RUNNING = 2
STATE_ERROR = 3

HEADER_STRUCT = struct.Struct("!4sBBHIHHHHQ")
MEAS_META_STRUCT = struct.Struct("!BBBBHH")
CLASS_STRUCT = struct.Struct("!BBHHHHHII")
STATUS_STRUCT = struct.Struct("!BBBBIIII")

HEADER_SIZE = HEADER_STRUCT.size
MEAS_META_SIZE = MEAS_META_STRUCT.size
CLASS_PAYLOAD_SIZE = CLASS_STRUCT.size
STATUS_PAYLOAD_SIZE = STATUS_STRUCT.size

assert HEADER_SIZE == 28
assert MEAS_META_SIZE == 8
assert CLASS_PAYLOAD_SIZE == 20
assert STATUS_PAYLOAD_SIZE == 20


class ProtocolError(ValueError):
    """Raised when a datagram does not conform to the VIBR protocol."""


@dataclass(frozen=True)
class CommonHeader:
    version: int
    message_type: int
    flags: int
    frame_id: int
    packet_id: int
    packet_count: int
    payload_length: int
    timestamp_us: int


@dataclass(frozen=True)
class MeasurementPacket:
    header: CommonHeader
    data_kind: int
    element_format: int
    channel: int
    first_index: int
    element_count: int
    values: Tuple[Union[int, float], ...]


@dataclass(frozen=True)
class ClassificationPacket:
    header: CommonHeader
    class_id: int
    class_count: int
    confidence_permille: int
    scores_permille: Tuple[int, int, int]
    inference_time_us: int
    model_version: int


@dataclass(frozen=True)
class BoardStatusPacket:
    header: CommonHeader
    board_state: int
    dma_state: int
    model_state: int
    ethernet_state: int
    last_frame_id: int
    dropped_frames: int
    uptime_ms: int
    last_error: int


ParsedPacket = Union[
    MeasurementPacket,
    ClassificationPacket,
    BoardStatusPacket,
]


def now_us() -> int:
    return time.time_ns() // 1_000


def _build_header(
    *,
    message_type: int,
    frame_id: int,
    packet_id: int,
    packet_count: int,
    payload_length: int,
    timestamp_us: int | None = None,
    flags: int = 0,
) -> bytes:
    if timestamp_us is None:
        timestamp_us = now_us()

    return HEADER_STRUCT.pack(
        MAGIC,
        PROTOCOL_VERSION,
        message_type,
        flags,
        frame_id,
        packet_id,
        packet_count,
        payload_length,
        0,
        timestamp_us,
    )


def _parse_header(data: bytes) -> CommonHeader:
    if len(data) < HEADER_SIZE:
        raise ProtocolError(
            f"Datagram too short: {len(data)} B, expected at least {HEADER_SIZE} B"
        )

    (
        magic,
        version,
        message_type,
        flags,
        frame_id,
        packet_id,
        packet_count,
        payload_length,
        _reserved,
        timestamp_us,
    ) = HEADER_STRUCT.unpack_from(data)

    if magic != MAGIC:
        raise ProtocolError(f"Invalid magic: {magic!r}")

    if version != PROTOCOL_VERSION:
        raise ProtocolError(
            f"Unsupported protocol version: {version}, expected {PROTOCOL_VERSION}"
        )

    expected_length = HEADER_SIZE + payload_length
    if len(data) != expected_length:
        raise ProtocolError(
            f"Invalid datagram length: {len(data)} B, header declares {expected_length} B"
        )

    if packet_count == 0:
        raise ProtocolError("packet_count cannot be zero")

    if packet_id >= packet_count:
        raise ProtocolError(
            f"packet_id={packet_id} outside packet_count={packet_count}"
        )

    return CommonHeader(
        version=version,
        message_type=message_type,
        flags=flags,
        frame_id=frame_id,
        packet_id=packet_id,
        packet_count=packet_count,
        payload_length=payload_length,
        timestamp_us=timestamp_us,
    )


def _decode_values(
    raw: bytes,
    element_format: int,
    element_count: int,
) -> Tuple[Union[int, float], ...]:
    format_map = {
        FORMAT_INT32: ("!i", 4),
        FORMAT_FLOAT32: ("!f", 4),
        FORMAT_INT16: ("!h", 2),
    }

    try:
        scalar_format, scalar_size = format_map[element_format]
    except KeyError as exc:
        raise ProtocolError(
            f"Unsupported element format: {element_format}"
        ) from exc

    expected_size = element_count * scalar_size
    if len(raw) != expected_size:
        raise ProtocolError(
            f"Measurement payload has {len(raw)} data bytes, "
            f"expected {expected_size}"
        )

    return tuple(value[0] for value in struct.iter_unpack(scalar_format, raw))


def parse_datagram(data: bytes) -> ParsedPacket:
    header = _parse_header(data)
    payload = memoryview(data)[HEADER_SIZE:]

    if header.message_type == MSG_MEASUREMENT:
        if len(payload) < MEAS_META_SIZE:
            raise ProtocolError("Measurement payload is too short")

        (
            data_kind,
            element_format,
            channel,
            _reserved,
            first_index,
            element_count,
        ) = MEAS_META_STRUCT.unpack_from(payload)

        values = _decode_values(
            bytes(payload[MEAS_META_SIZE:]),
            element_format,
            element_count,
        )

        return MeasurementPacket(
            header=header,
            data_kind=data_kind,
            element_format=element_format,
            channel=channel,
            first_index=first_index,
            element_count=element_count,
            values=values,
        )

    if header.message_type == MSG_CLASSIFICATION:
        if len(payload) != CLASS_PAYLOAD_SIZE:
            raise ProtocolError(
                f"Classification payload must have {CLASS_PAYLOAD_SIZE} B"
            )

        (
            class_id,
            class_count,
            confidence_permille,
            score_healthy,
            score_inner,
            score_outer,
            _reserved,
            inference_time_us,
            model_version,
        ) = CLASS_STRUCT.unpack(payload)

        return ClassificationPacket(
            header=header,
            class_id=class_id,
            class_count=class_count,
            confidence_permille=confidence_permille,
            scores_permille=(score_healthy, score_inner, score_outer),
            inference_time_us=inference_time_us,
            model_version=model_version,
        )

    if header.message_type == MSG_BOARD_STATUS:
        if len(payload) != STATUS_PAYLOAD_SIZE:
            raise ProtocolError(
                f"Board status payload must have {STATUS_PAYLOAD_SIZE} B"
            )

        (
            board_state,
            dma_state,
            model_state,
            ethernet_state,
            last_frame_id,
            dropped_frames,
            uptime_ms,
            last_error,
        ) = STATUS_STRUCT.unpack(payload)

        return BoardStatusPacket(
            header=header,
            board_state=board_state,
            dma_state=dma_state,
            model_state=model_state,
            ethernet_state=ethernet_state,
            last_frame_id=last_frame_id,
            dropped_frames=dropped_frames,
            uptime_ms=uptime_ms,
            last_error=last_error,
        )

    raise ProtocolError(
        f"Unsupported message type: 0x{header.message_type:02X}"
    )


def build_measurement_packet(
    *,
    frame_id: int,
    packet_id: int,
    packet_count: int,
    first_index: int,
    values: Tuple[Union[int, float], ...] | list[Union[int, float]],
    data_kind: int = DATA_FFT_MAGNITUDE,
    element_format: int = FORMAT_INT32,
    channel: int = 0,
    timestamp_us: int | None = None,
) -> bytes:
    scalar_formats = {
        FORMAT_INT32: "!i",
        FORMAT_FLOAT32: "!f",
        FORMAT_INT16: "!h",
    }

    try:
        scalar_format = scalar_formats[element_format]
    except KeyError as exc:
        raise ProtocolError(
            f"Unsupported element format: {element_format}"
        ) from exc

    values_tuple = tuple(values)
    meta = MEAS_META_STRUCT.pack(
        data_kind,
        element_format,
        channel,
        0,
        first_index,
        len(values_tuple),
    )
    encoded_values = b"".join(
        struct.pack(scalar_format, value) for value in values_tuple
    )
    payload = meta + encoded_values

    return _build_header(
        message_type=MSG_MEASUREMENT,
        frame_id=frame_id,
        packet_id=packet_id,
        packet_count=packet_count,
        payload_length=len(payload),
        timestamp_us=timestamp_us,
    ) + payload


def build_classification_packet(
    *,
    frame_id: int,
    class_id: int,
    confidence_permille: int,
    scores_permille: Tuple[int, int, int],
    inference_time_us: int,
    model_version: int = 1,
    class_count: int = 3,
    timestamp_us: int | None = None,
) -> bytes:
    if len(scores_permille) != 3:
        raise ProtocolError("Exactly three class scores are required")

    payload = CLASS_STRUCT.pack(
        class_id,
        class_count,
        confidence_permille,
        scores_permille[0],
        scores_permille[1],
        scores_permille[2],
        0,
        inference_time_us,
        model_version,
    )

    return _build_header(
        message_type=MSG_CLASSIFICATION,
        frame_id=frame_id,
        packet_id=0,
        packet_count=1,
        payload_length=len(payload),
        timestamp_us=timestamp_us,
    ) + payload


def build_status_packet(
    *,
    frame_id: int,
    board_state: int,
    dma_state: int,
    model_state: int,
    ethernet_state: int,
    dropped_frames: int,
    uptime_ms: int,
    last_error: int = 0,
    timestamp_us: int | None = None,
) -> bytes:
    payload = STATUS_STRUCT.pack(
        board_state,
        dma_state,
        model_state,
        ethernet_state,
        frame_id,
        dropped_frames,
        uptime_ms,
        last_error,
    )

    return _build_header(
        message_type=MSG_BOARD_STATUS,
        frame_id=frame_id,
        packet_id=0,
        packet_count=1,
        payload_length=len(payload),
        timestamp_us=timestamp_us,
    ) + payload


def _self_test() -> None:
    measurement = build_measurement_packet(
        frame_id=125,
        packet_id=0,
        packet_count=4,
        first_index=0,
        values=list(range(256)),
    )
    classification = build_classification_packet(
        frame_id=125,
        class_id=CLASS_INNER_FAULT,
        confidence_permille=934,
        scores_permille=(31, 934, 35),
        inference_time_us=4_200,
    )
    status = build_status_packet(
        frame_id=125,
        board_state=STATE_RUNNING,
        dma_state=STATE_RUNNING,
        model_state=STATE_RUNNING,
        ethernet_state=STATE_RUNNING,
        dropped_frames=0,
        uptime_ms=12_345,
    )

    parsed_measurement = parse_datagram(measurement)
    parsed_classification = parse_datagram(classification)
    parsed_status = parse_datagram(status)

    assert isinstance(parsed_measurement, MeasurementPacket)
    assert parsed_measurement.values[:4] == (0, 1, 2, 3)
    assert len(measurement) == 1060

    assert isinstance(parsed_classification, ClassificationPacket)
    assert parsed_classification.header.frame_id == 125
    assert parsed_classification.class_id == CLASS_INNER_FAULT

    assert isinstance(parsed_status, BoardStatusPacket)
    assert parsed_status.last_frame_id == 125

    print("VIBR protocol self-test: OK")
    print(f"measurement datagram:    {len(measurement)} B")
    print(f"classification datagram: {len(classification)} B")
    print(f"status datagram:         {len(status)} B")


if __name__ == "__main__":
    _self_test()
