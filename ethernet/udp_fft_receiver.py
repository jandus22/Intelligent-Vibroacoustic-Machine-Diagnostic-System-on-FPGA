import socket
import struct

LISTEN_IP = "0.0.0.0"
LISTEN_PORT = 5001

HEADER_FMT = "<IHH"   # frame_id(uint32), packet_id(uint16), packet_count(uint16)
HEADER_SIZE = struct.calcsize(HEADER_FMT)
SAMPLE_FMT = "<I"     # uint32
SAMPLE_SIZE = struct.calcsize(SAMPLE_FMT)

# frame_id -> {"packet_count": int, "packets": {packet_id: [samples]}}
frames = {}

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
sock.bind((LISTEN_IP, LISTEN_PORT))

print(f"Listening on {LISTEN_IP}:{LISTEN_PORT}")

while True:
    data, addr = sock.recvfrom(2048)

    if len(data) < HEADER_SIZE:
        print(f"Za krótki pakiet od {addr}, len={len(data)}")
        continue

    frame_id, packet_id, packet_count = struct.unpack(HEADER_FMT, data[:HEADER_SIZE])
    payload = data[HEADER_SIZE:]

    if len(payload) % SAMPLE_SIZE != 0:
        print(f"Zły payload size dla frame {frame_id}, packet {packet_id}")
        continue

    sample_count = len(payload) // SAMPLE_SIZE
    samples = list(struct.unpack(f"<{sample_count}I", payload))

    if frame_id not in frames:
        frames[frame_id] = {
            "packet_count": packet_count,
            "packets": {}
        }

    frames[frame_id]["packets"][packet_id] = samples

    current = frames[frame_id]
    got = len(current["packets"])

    print(
        f"RX frame={frame_id} packet={packet_id}/{packet_count - 1} "
        f"samples={sample_count} from={addr}"
    )

    if got == current["packet_count"]:
        full_fft = []
        for pid in range(current["packet_count"]):
            if pid not in current["packets"]:
                print(f"Brak packet {pid} w frame {frame_id}")
                break
            full_fft.extend(current["packets"][pid])
        else:
            print(f"FRAME COMPLETE: frame_id={frame_id}, total_samples={len(full_fft)}")
            print("Pierwsze 16 próbek:", full_fft[:16])

        del frames[frame_id]

    