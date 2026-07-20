import socket
import struct
import time
from typing import Any


# -------------------- Network configuration --------------------

LISTEN_IP = "0.0.0.0"
LISTEN_PORT = 5001

EXPECTED_SOURCE_IP = "192.168.1.10"

SOCKET_TIMEOUT_S = 0.1
IDLE_TIMEOUT_S = 5.0
FINAL_GRACE_TIME_S = 1.0
RECEIVE_BUFFER_BYTES = 4 * 1024 * 1024


# -------------------- Test configuration --------------------

TARGET_FRAMES = 1000

EXPECTED_PACKET_COUNT = 4
EXPECTED_SAMPLES_PER_PACKET = 256
EXPECTED_SAMPLES_PER_FRAME = 1024

PROGRESS_PERIOD = 100
VERBOSE_FRAME_COUNT = 3


# -------------------- Packet format --------------------

HEADER_FMT = "<IHH"
HEADER_SIZE = struct.calcsize(HEADER_FMT)

SAMPLE_SIZE = struct.calcsize("<I")

EXPECTED_PAYLOAD_BYTES = (
    EXPECTED_SAMPLES_PER_PACKET * SAMPLE_SIZE
)

EXPECTED_DATAGRAM_BYTES = (
    HEADER_SIZE + EXPECTED_PAYLOAD_BYTES
)


# frame_id -> {
#     "packets": {packet_id: tuple(samples)},
#     "complete": bool,
#     "mismatch_count": int,
#     "first_mismatch": tuple(index, expected, received) | None
# }
frames: dict[int, dict[str, Any]] = {}


# -------------------- Statistics --------------------

raw_datagrams = 0
foreign_datagrams = 0
ignored_before_sync = 0
after_test_range = 0

malformed_datagrams = 0
unique_packets = 0
duplicate_packets = 0
conflicting_duplicates = 0
out_of_order_packets = 0

complete_frames_counter = 0
invalid_data_frames_counter = 0
invalid_samples_counter = 0

accepted_bytes = 0

first_frame_id: int | None = None
target_last_frame_id: int | None = None

highest_unique_key: tuple[int, int] | None = None

test_start_time: float | None = None
test_end_time: float | None = None
last_test_packet_time: float | None = None
grace_deadline: float | None = None

stop_reason = "unknown"


# -------------------- Helper functions --------------------

def validate_complete_frame(
    frame_id: int,
    frame: dict[str, Any],
) -> None:
    """
    Składa kompletną ramkę oraz sprawdza wzorzec 0...1023.
    """

    global invalid_data_frames_counter
    global invalid_samples_counter

    full_frame: list[int] = []

    for packet_id in range(EXPECTED_PACKET_COUNT):
        full_frame.extend(frame["packets"][packet_id])

    mismatch_count = 0
    first_mismatch = None

    if len(full_frame) != EXPECTED_SAMPLES_PER_FRAME:
        mismatch_count = abs(
            len(full_frame) - EXPECTED_SAMPLES_PER_FRAME
        )

        first_mismatch = (
            -1,
            EXPECTED_SAMPLES_PER_FRAME,
            len(full_frame),
        )
    else:
        for sample_index, received_value in enumerate(full_frame):
            expected_value = sample_index

            if received_value != expected_value:
                mismatch_count += 1

                if first_mismatch is None:
                    first_mismatch = (
                        sample_index,
                        expected_value,
                        received_value,
                    )

    frame["complete"] = True
    frame["mismatch_count"] = mismatch_count
    frame["first_mismatch"] = first_mismatch

    if mismatch_count != 0:
        invalid_data_frames_counter += 1
        invalid_samples_counter += mismatch_count

    if frame_id < first_frame_id + VERBOSE_FRAME_COUNT:
        print(
            f"FRAME COMPLETE: frame_id={frame_id}, "
            f"total_samples={len(full_frame)}, "
            f"mismatches={mismatch_count}"
        )
        print("Pierwsze 16 próbek:", full_frame[:16])

        if first_mismatch is not None:
            index, expected, received = first_mismatch

            print(
                f"Pierwszy błąd: sample={index}, "
                f"expected={expected}, received={received}"
            )


def format_id_list(values: list[int], limit: int = 20) -> str:
    if not values:
        return "-"

    visible = values[:limit]
    text = ", ".join(str(value) for value in visible)

    if len(values) > limit:
        text += f", ... (+{len(values) - limit})"

    return text


def print_summary() -> None:
    if first_frame_id is None or target_last_frame_id is None:
        print("\n========== TEST SUMMARY ==========")
        print("Test nie rozpoczął się.")
        print(f"Powód zakończenia: {stop_reason}")
        print(f"Odebrane datagramy: {raw_datagrams}")
        print("RESULT: FAIL")
        print("==================================")
        return

    missing_frame_ids: list[int] = []
    incomplete_frame_ids: list[int] = []

    missing_packets_in_incomplete_frames = 0
    complete_frames = 0
    valid_data_frames = 0

    for frame_id in range(
        first_frame_id,
        target_last_frame_id + 1,
    ):
        frame = frames.get(frame_id)

        if frame is None:
            missing_frame_ids.append(frame_id)
            continue

        packet_count = len(frame["packets"])

        if packet_count != EXPECTED_PACKET_COUNT:
            incomplete_frame_ids.append(frame_id)
            missing_packets_in_incomplete_frames += (
                EXPECTED_PACKET_COUNT - packet_count
            )
            continue

        complete_frames += 1

        if frame.get("mismatch_count", 0) == 0:
            valid_data_frames += 1

    missing_whole_frames = len(missing_frame_ids)
    incomplete_frames = len(incomplete_frame_ids)

    missing_packets_from_whole_frames = (
        missing_whole_frames * EXPECTED_PACKET_COUNT
    )

    total_missing_packets = (
        missing_packets_from_whole_frames
        + missing_packets_in_incomplete_frames
    )

    if (
        test_start_time is not None
        and test_end_time is not None
    ):
        duration = test_end_time - test_start_time
    else:
        duration = 0.0

    if duration > 0.0:
        frame_rate = complete_frames / duration
        udp_payload_rate_mbps = (
            accepted_bytes * 8.0 / duration / 1_000_000.0
        )
    else:
        frame_rate = 0.0
        udp_payload_rate_mbps = 0.0

    passed = (
        complete_frames == TARGET_FRAMES
        and valid_data_frames == TARGET_FRAMES
        and missing_whole_frames == 0
        and incomplete_frames == 0
        and total_missing_packets == 0
        and malformed_datagrams == 0
        and duplicate_packets == 0
        and out_of_order_packets == 0
        and invalid_data_frames_counter == 0
        and stop_reason == "all target frames completed"
    )

    print("\n========== TEST SUMMARY ==========")
    print(f"Zakres ramek:             {first_frame_id}..{target_last_frame_id}")
    print(f"Planowane ramki:          {TARGET_FRAMES}")
    print(f"Kompletne ramki:          {complete_frames}")
    print(f"Ramki z poprawnymi danymi:{valid_data_frames:>10}")
    print(f"Brakujące całe ramki:     {missing_whole_frames}")
    print(f"Niekompletne ramki:       {incomplete_frames}")
    print(f"Brakujące pakiety łącznie:{total_missing_packets:>10}")
    print(f"Unikalne pakiety:         {unique_packets}")
    print(f"Duplikaty pakietów:       {duplicate_packets}")
    print(f"Sprzeczne duplikaty:      {conflicting_duplicates}")
    print(f"Pakiety poza kolejnością: {out_of_order_packets}")
    print(f"Błędne datagramy:         {malformed_datagrams}")
    print(f"Ramki z błędnymi danymi:  {invalid_data_frames_counter}")
    print(f"Błędne próbki:            {invalid_samples_counter}")
    print(f"Datagramy obcego źródła:  {foreign_datagrams}")
    print(f"Pominięte przed startem:  {ignored_before_sync}")
    print(f"Czas testu:               {duration:.3f} s")
    print(f"Prędkość ramek:           {frame_rate:.2f} frame/s")
    print(f"Przepływność UDP payload: {udp_payload_rate_mbps:.3f} Mbit/s")
    print(f"Powód zakończenia:        {stop_reason}")

    if missing_frame_ids:
        print(
            "ID brakujących ramek:      "
            + format_id_list(missing_frame_ids)
        )

    if incomplete_frame_ids:
        print(
            "ID niekompletnych ramek:   "
            + format_id_list(incomplete_frame_ids)
        )

    print(f"RESULT:                   {'PASS' if passed else 'FAIL'}")
    print("==================================")


# -------------------- Socket initialization --------------------

sock = socket.socket(
    socket.AF_INET,
    socket.SOCK_DGRAM,
)

sock.setsockopt(
    socket.SOL_SOCKET,
    socket.SO_RCVBUF,
    RECEIVE_BUFFER_BYTES,
)

sock.settimeout(SOCKET_TIMEOUT_S)
sock.bind((LISTEN_IP, LISTEN_PORT))

actual_receive_buffer = sock.getsockopt(
    socket.SOL_SOCKET,
    socket.SO_RCVBUF,
)

print(f"Listening on {LISTEN_IP}:{LISTEN_PORT}")
print(f"Expected source: {EXPECTED_SOURCE_IP}")
print(f"Target frames: {TARGET_FRAMES}")
print(f"Expected datagram size: {EXPECTED_DATAGRAM_BYTES} B")
print(f"Socket receive buffer: {actual_receive_buffer} B")
print("Waiting for packet_id=0 to start at a frame boundary...")


# -------------------- Receive loop --------------------

try:
    while True:
        now = time.monotonic()

        if (
            grace_deadline is not None
            and now >= grace_deadline
        ):
            stop_reason = "final grace time expired"
            break

        try:
            data, addr = sock.recvfrom(2048)

        except socket.timeout:
            now = time.monotonic()

            if (
                grace_deadline is not None
                and now >= grace_deadline
            ):
                stop_reason = "final grace time expired"
                break

            if (
                test_start_time is not None
                and last_test_packet_time is not None
                and now - last_test_packet_time >= IDLE_TIMEOUT_S
            ):
                stop_reason = (
                    f"no test packets for {IDLE_TIMEOUT_S:.1f} s"
                )
                break

            continue

        raw_datagrams += 1
        now = time.monotonic()

        if addr[0] != EXPECTED_SOURCE_IP:
            foreign_datagrams += 1
            continue

        if len(data) < HEADER_SIZE:
            malformed_datagrams += 1

            print(
                f"ERROR: datagram too short from {addr}, "
                f"length={len(data)}"
            )
            continue

        frame_id, packet_id, packet_count = struct.unpack(
            HEADER_FMT,
            data[:HEADER_SIZE],
        )

        payload = data[HEADER_SIZE:]

        metadata_valid = (
            packet_count == EXPECTED_PACKET_COUNT
            and packet_id < EXPECTED_PACKET_COUNT
            and len(data) == EXPECTED_DATAGRAM_BYTES
            and len(payload) == EXPECTED_PAYLOAD_BYTES
            and len(payload) % SAMPLE_SIZE == 0
        )

        if not metadata_valid:
            malformed_datagrams += 1

            print(
                f"ERROR: malformed datagram: "
                f"frame={frame_id}, packet={packet_id}, "
                f"packet_count={packet_count}, "
                f"length={len(data)}"
            )
            continue

        samples = struct.unpack(
            f"<{EXPECTED_SAMPLES_PER_PACKET}I",
            payload,
        )

        # Test zaczynamy dopiero od początku nowej ramki.
        if first_frame_id is None:
            if packet_id != 0:
                ignored_before_sync += 1
                continue

            first_frame_id = frame_id
            target_last_frame_id = (
                first_frame_id + TARGET_FRAMES - 1
            )

            test_start_time = now
            last_test_packet_time = now

            print(
                f"Test started: frame range "
                f"{first_frame_id}..{target_last_frame_id}"
            )

        assert target_last_frame_id is not None
        assert first_frame_id is not None

        if frame_id < first_frame_id:
            ignored_before_sync += 1
            continue

        if frame_id > target_last_frame_id:
            after_test_range += 1

            if grace_deadline is None:
                grace_deadline = now + FINAL_GRACE_TIME_S

                print(
                    "Target range passed. "
                    "Waiting briefly for delayed packets..."
                )

            continue

        last_test_packet_time = now

        frame = frames.setdefault(
            frame_id,
            {
                "packets": {},
                "complete": False,
                "mismatch_count": 0,
                "first_mismatch": None,
            },
        )

        packets = frame["packets"]

        if packet_id in packets:
            duplicate_packets += 1

            if packets[packet_id] != samples:
                conflicting_duplicates += 1

                print(
                    f"ERROR: conflicting duplicate: "
                    f"frame={frame_id}, packet={packet_id}"
                )

            continue

        current_key = (frame_id, packet_id)

        if (
            highest_unique_key is not None
            and current_key < highest_unique_key
        ):
            out_of_order_packets += 1

        if (
            highest_unique_key is None
            or current_key > highest_unique_key
        ):
            highest_unique_key = current_key

        packets[packet_id] = samples

        unique_packets += 1
        accepted_bytes += len(data)

        if (
            len(packets) == EXPECTED_PACKET_COUNT
            and not frame["complete"]
        ):
            validate_complete_frame(frame_id, frame)
            complete_frames_counter += 1

            if (
                complete_frames_counter % PROGRESS_PERIOD
                == 0
            ):
                elapsed = now - test_start_time

                print(
                    f"PROGRESS: complete={complete_frames_counter}/"
                    f"{TARGET_FRAMES}, "
                    f"frame_id={frame_id}, "
                    f"duplicates={duplicate_packets}, "
                    f"out_of_order={out_of_order_packets}, "
                    f"malformed={malformed_datagrams}, "
                    f"time={elapsed:.2f}s"
                )

            if complete_frames_counter == TARGET_FRAMES:
                stop_reason = "all target frames completed"
                break

except KeyboardInterrupt:
    stop_reason = "stopped by user"

finally:
    test_end_time = time.monotonic()
    sock.close()
    print_summary()