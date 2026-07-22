import socket
import struct
import time
from typing import Any


# -------------------- Konfiguracja sieci --------------------

LISTEN_IP = "0.0.0.0"
LISTEN_PORT = 5001

EXPECTED_SOURCE_IP = "192.168.1.10"

SOCKET_TIMEOUT_S = 0.1
IDLE_TIMEOUT_S = 5.0

# Po zauważeniu ramki spoza badanego zakresu odbiornik
# jeszcze chwilę czeka na ewentualne opóźnione pakiety.
FINAL_GRACE_TIME_S = 1.0

RECEIVE_BUFFER_BYTES = 4 * 1024 * 1024


# -------------------- Konfiguracja testu --------------------

TARGET_FRAMES = 100_000

EXPECTED_PACKET_COUNT = 4
EXPECTED_SAMPLES_PER_PACKET = 256
EXPECTED_SAMPLES_PER_FRAME = 1024

# Ile ramek może pozostać otwartych przed uznaniem
# starszej ramki za utraconą lub niekompletną.
REORDER_WINDOW_FRAMES = 16

PROGRESS_PERIOD = 10_000
VERBOSE_FRAME_COUNT = 3


# -------------------- Format pakietu --------------------

HEADER_FMT = "<IHH"
HEADER_SIZE = struct.calcsize(HEADER_FMT)

SAMPLE_FMT = "<I"
SAMPLE_SIZE = struct.calcsize(SAMPLE_FMT)

EXPECTED_PAYLOAD_BYTES = (
    EXPECTED_SAMPLES_PER_PACKET * SAMPLE_SIZE
)

EXPECTED_DATAGRAM_BYTES = (
    HEADER_SIZE + EXPECTED_PAYLOAD_BYTES
)


# -------------------- Ramki aktywne --------------------

# Przechowywane są wyłącznie ramki oczekujące na dokończenie.
#
# frame_id -> {
#     "packets": {
#         packet_id: tuple(samples)
#     },
#     "complete": bool,
#     "mismatch_count": int,
#     "first_mismatch": tuple | None
# }
active_frames: dict[int, dict[str, Any]] = {}


# -------------------- Zakres testu --------------------

first_frame_id: int | None = None
target_last_frame_id: int | None = None

next_finalize_frame_id: int | None = None
max_seen_frame_id: int | None = None

highest_unique_key: tuple[int, int] | None = None


# -------------------- Statystyki pakietów --------------------

raw_datagrams = 0
foreign_datagrams = 0

ignored_before_sync = 0
after_test_range = 0

malformed_datagrams = 0

unique_packets = 0
duplicate_packets = 0
conflicting_duplicates = 0

out_of_order_packets = 0
late_packets = 0


# -------------------- Statystyki ramek --------------------

finalized_frames = 0

complete_frames = 0
valid_frames = 0

missing_whole_frames = 0
incomplete_frames = 0
missing_packets = 0

invalid_data_frames = 0
invalid_samples = 0


# -------------------- Statystyki pamięci --------------------

max_active_frames = 0
max_active_packets = 0


# -------------------- Statystyki czasu --------------------

test_start_time: float | None = None
measurement_end_time: float | None = None
last_test_packet_time: float | None = None

grace_deadline: float | None = None

stop_reason = "unknown"


# -------------------- Kontrola danych --------------------

def validate_complete_frame(
    frame: dict[str, Any],
) -> tuple[int, tuple[int, int, int] | None]:
    """
    Sprawdza wzorzec testowy:

        próbka 0    = 0
        próbka 1    = 1
        ...
        próbka 1023 = 1023

    Nie tworzy pełnej listy 1024 próbek, dzięki czemu
    ograniczamy liczbę tymczasowych obiektów w pamięci.
    """

    mismatch_count = 0
    first_mismatch = None

    packets = frame["packets"]

    for packet_id in range(EXPECTED_PACKET_COUNT):
        samples = packets[packet_id]

        base_sample_index = (
            packet_id * EXPECTED_SAMPLES_PER_PACKET
        )

        for local_index, received_value in enumerate(samples):
            expected_value = base_sample_index + local_index

            if received_value != expected_value:
                mismatch_count += 1

                if first_mismatch is None:
                    first_mismatch = (
                        expected_value,
                        expected_value,
                        received_value,
                    )

    return mismatch_count, first_mismatch


# -------------------- Wyświetlanie postępu --------------------

def print_progress() -> None:
    if test_start_time is None:
        return

    elapsed = time.monotonic() - test_start_time

    if elapsed > 0.0:
        frame_rate = complete_frames / elapsed
    else:
        frame_rate = 0.0

    print(
        f"PROGRESS: finalized={finalized_frames}/{TARGET_FRAMES}, "
        f"complete={complete_frames}, "
        f"valid={valid_frames}, "
        f"missing_frames={missing_whole_frames}, "
        f"incomplete={incomplete_frames}, "
        f"missing_packets={missing_packets}, "
        f"duplicates={duplicate_packets}, "
        f"out_of_order={out_of_order_packets}, "
        f"active={len(active_frames)}, "
        f"time={elapsed:.1f}s, "
        f"rate={frame_rate:.2f} frame/s"
    )


# -------------------- Finalizacja jednej ramki --------------------

def finalize_frame(frame_id: int) -> None:
    """
    Zamyka wskazany identyfikator ramki i usuwa jej dane
    z pamięci.

    Ramka może zostać zakwalifikowana jako:
    - całkowicie brakująca,
    - niekompletna,
    - kompletna i poprawna,
    - kompletna z błędnymi próbkami.
    """

    global finalized_frames

    global complete_frames
    global valid_frames

    global missing_whole_frames
    global incomplete_frames
    global missing_packets

    global invalid_data_frames
    global invalid_samples

    frame = active_frames.pop(frame_id, None)

    if frame is None:
        missing_whole_frames += 1
        missing_packets += EXPECTED_PACKET_COUNT

    else:
        packets = frame["packets"]
        received_packet_count = len(packets)

        if received_packet_count != EXPECTED_PACKET_COUNT:
            incomplete_frames += 1

            missing_packets += (
                EXPECTED_PACKET_COUNT
                - received_packet_count
            )

        else:
            complete_frames += 1

            mismatch_count = frame["mismatch_count"]
            first_mismatch = frame["first_mismatch"]

            if mismatch_count == 0:
                valid_frames += 1
            else:
                invalid_data_frames += 1
                invalid_samples += mismatch_count

                print(
                    f"ERROR: invalid samples in frame {frame_id}, "
                    f"mismatches={mismatch_count}, "
                    f"first_mismatch={first_mismatch}"
                )

            assert first_frame_id is not None

            relative_index = frame_id - first_frame_id

            if relative_index < VERBOSE_FRAME_COUNT:
                first_samples = list(
                    packets[0][:16]
                )

                print(
                    f"FRAME COMPLETE: frame_id={frame_id}, "
                    f"mismatches={mismatch_count}"
                )

                print(
                    "Pierwsze 16 próbek:",
                    first_samples,
                )

    finalized_frames += 1

    if (
        finalized_frames % PROGRESS_PERIOD
        == 0
    ):
        print_progress()


# -------------------- Normalne zwalnianie ramek --------------------

def retire_ready_frames() -> None:
    """
    Zwalnia kolejne ramki, gdy:

    1. ramka jest kompletna,
    2. albo nowsze ramki przekroczyły okno REORDER_WINDOW_FRAMES.

    Dzięki temu liczba przechowywanych ramek pozostaje ograniczona.
    """

    global next_finalize_frame_id

    if (
        next_finalize_frame_id is None
        or target_last_frame_id is None
    ):
        return

    while next_finalize_frame_id <= target_last_frame_id:
        frame = active_frames.get(
            next_finalize_frame_id
        )

        if frame is not None and frame["complete"]:
            finalize_frame(next_finalize_frame_id)
            next_finalize_frame_id += 1
            continue

        if (
            max_seen_frame_id is not None
            and (
                max_seen_frame_id
                - next_finalize_frame_id
            ) >= REORDER_WINDOW_FRAMES
        ):
            finalize_frame(next_finalize_frame_id)
            next_finalize_frame_id += 1
            continue

        break


# -------------------- Wymuszona finalizacja zakresu --------------------

def force_finalize_to(last_frame_id: int) -> None:
    """
    Finalizuje wszystkie pozostałe ramki do podanego ID.
    Używane na końcu zakresu lub po przerwaniu transmisji.
    """

    global next_finalize_frame_id

    if (
        next_finalize_frame_id is None
        or target_last_frame_id is None
    ):
        return

    effective_last_frame_id = min(
        last_frame_id,
        target_last_frame_id,
    )

    while (
        next_finalize_frame_id
        <= effective_last_frame_id
    ):
        finalize_frame(next_finalize_frame_id)
        next_finalize_frame_id += 1


# -------------------- Raport końcowy --------------------

def print_summary() -> None:
    if (
        first_frame_id is None
        or target_last_frame_id is None
    ):
        print("\n========== LONG TEST SUMMARY ==========")
        print("Test nie rozpoczął się.")
        print(f"Odebrane datagramy:       {raw_datagrams}")
        print(f"Powód zakończenia:        {stop_reason}")
        print("RESULT:                   FAIL")
        print("=======================================")
        return

    not_reached_frames = max(
        0,
        TARGET_FRAMES - finalized_frames,
    )

    if (
        test_start_time is not None
        and measurement_end_time is not None
    ):
        duration = (
            measurement_end_time
            - test_start_time
        )
    else:
        duration = 0.0

    if duration > 0.0:
        frame_rate = complete_frames / duration

        packet_rate = unique_packets / duration

        sample_data_rate_mbps = (
            unique_packets
            * EXPECTED_PAYLOAD_BYTES
            * 8.0
            / duration
            / 1_000_000.0
        )

        application_data_rate_mbps = (
            unique_packets
            * EXPECTED_DATAGRAM_BYTES
            * 8.0
            / duration
            / 1_000_000.0
        )
    else:
        frame_rate = 0.0
        packet_rate = 0.0
        sample_data_rate_mbps = 0.0
        application_data_rate_mbps = 0.0

    passed = (
        finalized_frames == TARGET_FRAMES
        and complete_frames == TARGET_FRAMES
        and valid_frames == TARGET_FRAMES
        and not_reached_frames == 0
        and missing_whole_frames == 0
        and incomplete_frames == 0
        and missing_packets == 0
        and malformed_datagrams == 0
        and duplicate_packets == 0
        and conflicting_duplicates == 0
        and out_of_order_packets == 0
        and late_packets == 0
        and invalid_data_frames == 0
        and invalid_samples == 0
        and stop_reason == "target range finalized"
    )

    print("\n========== LONG TEST SUMMARY ==========")

    print(
        f"Zakres ramek:             "
        f"{first_frame_id}..{target_last_frame_id}"
    )

    print(f"Planowane ramki:          {TARGET_FRAMES}")
    print(f"Sfinalizowane ramki:      {finalized_frames}")
    print(f"Nieosiągnięte ramki:      {not_reached_frames}")

    print(f"Kompletne ramki:          {complete_frames}")
    print(f"Poprawne ramki:           {valid_frames}")

    print(f"Brakujące całe ramki:     {missing_whole_frames}")
    print(f"Niekompletne ramki:       {incomplete_frames}")
    print(f"Brakujące pakiety:        {missing_packets}")

    print(f"Unikalne pakiety:         {unique_packets}")
    print(f"Duplikaty pakietów:       {duplicate_packets}")
    print(f"Sprzeczne duplikaty:      {conflicting_duplicates}")

    print(f"Pakiety poza kolejnością: {out_of_order_packets}")
    print(f"Pakiety spóźnione:        {late_packets}")

    print(f"Błędne datagramy:         {malformed_datagrams}")
    print(f"Ramki z błędnymi danymi:  {invalid_data_frames}")
    print(f"Błędne próbki:            {invalid_samples}")

    print(f"Datagramy obcego źródła:  {foreign_datagrams}")
    print(f"Pominięte przed startem:  {ignored_before_sync}")
    print(f"Poza zakresem testu:      {after_test_range}")

    print(f"Maks. aktywne ramki:      {max_active_frames}")
    print(f"Maks. aktywne pakiety:    {max_active_packets}")

    print(f"Czas pomiaru:             {duration:.3f} s")
    print(f"Prędkość ramek:           {frame_rate:.2f} frame/s")
    print(f"Prędkość pakietów:        {packet_rate:.2f} packet/s")

    print(
        f"Przepływność próbek:      "
        f"{sample_data_rate_mbps:.3f} Mbit/s"
    )

    print(
        f"Przepływność aplikacji:   "
        f"{application_data_rate_mbps:.3f} Mbit/s"
    )

    print(f"Powód zakończenia:        {stop_reason}")
    print(f"RESULT:                   {'PASS' if passed else 'FAIL'}")

    print("=======================================")


# -------------------- Inicjalizacja gniazda --------------------

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

sock.bind(
    (LISTEN_IP, LISTEN_PORT)
)

actual_receive_buffer = sock.getsockopt(
    socket.SOL_SOCKET,
    socket.SO_RCVBUF,
)

print(f"Listening on {LISTEN_IP}:{LISTEN_PORT}")
print(f"Expected source: {EXPECTED_SOURCE_IP}")
print(f"Target frames: {TARGET_FRAMES}")
print(f"Expected datagram size: {EXPECTED_DATAGRAM_BYTES} B")
print(f"Socket receive buffer: {actual_receive_buffer} B")
print(
    "Waiting for packet_id=0 "
    "to start at a frame boundary..."
)


# -------------------- Pętla odbiorcza --------------------

try:
    while True:
        now = time.monotonic()

        # Koniec okresu oczekiwania po przekroczeniu zakresu.
        if (
            grace_deadline is not None
            and now >= grace_deadline
        ):
            assert target_last_frame_id is not None

            force_finalize_to(
                target_last_frame_id
            )

            stop_reason = (
                "target range passed; grace time expired"
            )
            break

        try:
            data, addr = sock.recvfrom(2048)

        except socket.timeout:
            now = time.monotonic()

            if (
                grace_deadline is not None
                and now >= grace_deadline
            ):
                assert target_last_frame_id is not None

                force_finalize_to(
                    target_last_frame_id
                )

                stop_reason = (
                    "target range passed; grace time expired"
                )
                break

            if (
                test_start_time is not None
                and last_test_packet_time is not None
                and (
                    now - last_test_packet_time
                ) >= IDLE_TIMEOUT_S
            ):
                if max_seen_frame_id is not None:
                    force_finalize_to(
                        max_seen_frame_id
                    )

                stop_reason = (
                    f"no test packets for "
                    f"{IDLE_TIMEOUT_S:.1f} s"
                )
                break

            continue

        raw_datagrams += 1
        now = time.monotonic()

        # Ignorujemy ruch od innych urządzeń.
        if addr[0] != EXPECTED_SOURCE_IP:
            foreign_datagrams += 1
            continue

        # Pakiet musi zawierać pełny nagłówek.
        if len(data) < HEADER_SIZE:
            malformed_datagrams += 1

            print(
                f"ERROR: datagram too short "
                f"from={addr}, length={len(data)}"
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
                f"frame={frame_id}, "
                f"packet={packet_id}, "
                f"packet_count={packet_count}, "
                f"length={len(data)}"
            )
            continue

        samples = struct.unpack(
            f"<{EXPECTED_SAMPLES_PER_PACKET}I",
            payload,
        )

        # Synchronizacja początku testu.
        if first_frame_id is None:
            if packet_id != 0:
                ignored_before_sync += 1
                continue

            first_frame_id = frame_id

            target_last_frame_id = (
                first_frame_id
                + TARGET_FRAMES
                - 1
            )

            next_finalize_frame_id = first_frame_id
            max_seen_frame_id = first_frame_id

            test_start_time = now
            measurement_end_time = now
            last_test_packet_time = now

            print(
                f"Long test started: frame range "
                f"{first_frame_id}.."
                f"{target_last_frame_id}"
            )

        assert first_frame_id is not None
        assert target_last_frame_id is not None
        assert next_finalize_frame_id is not None

        # Pakiet dotyczy ramki już zamkniętej.
        if frame_id < next_finalize_frame_id:
            late_packets += 1
            continue

        # Pakiet starszy niż początek testu.
        if frame_id < first_frame_id:
            ignored_before_sync += 1
            continue

        # Nadajnik przeszedł już poza badany zakres.
        if frame_id > target_last_frame_id:
            after_test_range += 1

            if grace_deadline is None:
                grace_deadline = (
                    now + FINAL_GRACE_TIME_S
                )

                print(
                    "Target range passed. "
                    "Waiting for delayed packets..."
                )

            continue

        last_test_packet_time = now
        measurement_end_time = now

        if (
            max_seen_frame_id is None
            or frame_id > max_seen_frame_id
        ):
            max_seen_frame_id = frame_id

        frame = active_frames.setdefault(
            frame_id,
            {
                "packets": {},
                "complete": False,
                "mismatch_count": 0,
                "first_mismatch": None,
            },
        )

        packets = frame["packets"]

        # Duplikat pakietu w aktywnej ramce.
        if packet_id in packets:
            duplicate_packets += 1

            if packets[packet_id] != samples:
                conflicting_duplicates += 1

                print(
                    f"ERROR: conflicting duplicate: "
                    f"frame={frame_id}, "
                    f"packet={packet_id}"
                )

            continue

        current_key = (
            frame_id,
            packet_id,
        )

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

        # Kontrola maksymalnego wykorzystania pamięci.
        current_active_packets = sum(
            len(item["packets"])
            for item in active_frames.values()
        )

        if len(active_frames) > max_active_frames:
            max_active_frames = len(active_frames)

        if current_active_packets > max_active_packets:
            max_active_packets = current_active_packets

        # Ramka otrzymała wszystkie cztery pakiety.
        if (
            len(packets) == EXPECTED_PACKET_COUNT
            and not frame["complete"]
        ):
            mismatch_count, first_mismatch = (
                validate_complete_frame(frame)
            )

            frame["mismatch_count"] = mismatch_count
            frame["first_mismatch"] = first_mismatch
            frame["complete"] = True

        retire_ready_frames()

        # Cały wymagany zakres został już rozliczony.
        if (
            next_finalize_frame_id
            > target_last_frame_id
        ):
            stop_reason = "target range finalized"
            break

except KeyboardInterrupt:
    if max_seen_frame_id is not None:
        force_finalize_to(
            max_seen_frame_id
        )

    stop_reason = "stopped by user"

finally:
    sock.close()
    print_summary()