import sys
import time
import socket
import struct
from dataclasses import dataclass, field
from typing import Dict, Optional

import numpy as np
import pyqtgraph as pg

from PySide6.QtCore import Qt, QThread, Signal, Slot, QTimer
from PySide6.QtWidgets import (
    QApplication, QWidget, QLabel, QPushButton,
    QVBoxLayout, QHBoxLayout, QPlainTextEdit, QMessageBox, QDoubleSpinBox
)

# ==============================
# CONSTANTS
# ==============================

APP_TITLE = "Vibration Diagnostic Monitor"

# Port używany obecnie przez aplikację Vitis na KR260.
UDP_PORT = 5001

SAMPLING_RATE = 26700
FFT_SIZE = 4096
FFT_AVG_ALPHA = 0.2

FRAME_ASSEMBLY_TIMEOUT_S = 1.0
CONNECTION_TIMEOUT_S = 2.5
MAX_PENDING_FRAMES = 64
MAX_UDP_DATAGRAM = 2048

# Acquisition may run at ~90 frames/s, but a GUI should not redraw at that rate.
FFT_UI_PERIOD_S = 0.10          # plot refresh: max 10 Hz
CLASS_UI_PERIOD_S = 1.00        # bearing panel refresh: max 1 Hz
SYNC_LOG_PERIOD_S = 1.00        # one aggregated log entry per second
ACTIVITY_SIGNAL_PERIOD_S = 0.25 # ETH indicator refresh: max 4 Hz

# Set True only while diagnosing individual datagrams.
RAW_PACKET_LOG = False

TEXT_CONNECTION_DISCONNECTED = "Connection: disconnected"
TEXT_CONNECTION_LISTENING = f"Listening UDP :{UDP_PORT}"

TEXT_ETH_CONNECTED = "ETH: CONNECTED"
TEXT_ETH_DISCONNECTED = "ETH: DISCONNECTED"

TEXT_MODEL_RUNNING = "MODEL: RUNNING"
TEXT_MODEL_STOPPED = "MODEL: STOPPED"

TEXT_MODEL_ON = "MODEL: ON"
TEXT_MODEL_OFF = "MODEL: OFF"
TEXT_MODEL_UNKNOWN = "MODEL: ?"

TEXT_BEARING_OK = "BEARING: OK"
TEXT_BEARING_DAMAGED = "BEARING: DAMAGED"
TEXT_BEARING_UNKNOWN = "BEARING: ?"
TEXT_NO_DATA = "⚠ NO DATA"

TEXT_LOG = "ETH Log:"

# ==============================
# VIBR UDP PROTOCOL V1
# ==============================

VIBR_MAGIC = b"VIBR"
VIBR_VERSION = 1

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
MEASUREMENT_META_STRUCT = struct.Struct("!BBBBHH")
CLASSIFICATION_STRUCT = struct.Struct("!BBHHHHHII")
BOARD_STATUS_STRUCT = struct.Struct("!BBBBIIII")

HEADER_SIZE = HEADER_STRUCT.size

CLASS_NAMES = {
    CLASS_HEALTHY: "HEALTHY",
    CLASS_INNER_FAULT: "INNER_RING_FAULT",
    CLASS_OUTER_FAULT: "OUTER_RING_FAULT",
    CLASS_UNKNOWN: "UNKNOWN",
}

STATE_NAMES = {
    STATE_BOOTING: "BOOTING",
    STATE_READY: "READY",
    STATE_RUNNING: "RUNNING",
    STATE_ERROR: "ERROR",
}


# ==============================
# DATA STRUCTURES
# ==============================

@dataclass(frozen=True)
class VibrHeader:
    message_type: int
    flags: int
    frame_id: int
    packet_id: int
    packet_count: int
    payload_length: int
    timestamp_us: int


@dataclass(frozen=True)
class MeasurementPacket:
    header: VibrHeader
    data_kind: int
    element_format: int
    channel: int
    first_index: int
    element_count: int
    values: np.ndarray


@dataclass(frozen=True)
class ClassificationResult:
    header: VibrHeader
    class_id: int
    class_count: int
    confidence_permille: int
    score_healthy: int
    score_inner: int
    score_outer: int
    inference_time_us: int
    model_version: int


@dataclass(frozen=True)
class BoardStatus:
    header: VibrHeader
    board_state: int
    dma_state: int
    model_state: int
    ethernet_state: int
    last_frame_id: int
    dropped_frames: int
    uptime_ms: int
    last_error: int


@dataclass
class PendingFrame:
    frame_id: int
    created_monotonic: float = field(default_factory=time.monotonic)
    packet_count: Optional[int] = None
    data_kind: Optional[int] = None
    element_format: Optional[int] = None
    channel: Optional[int] = None
    packets: Dict[int, MeasurementPacket] = field(default_factory=dict)
    values: Optional[np.ndarray] = None
    classification: Optional[ClassificationResult] = None
    measurement_emitted: bool = False
    classification_emitted: bool = False


# ==============================
# VIBR PARSER
# ==============================

def parse_vibr_header(data: bytes) -> VibrHeader:
    if len(data) < HEADER_SIZE:
        raise ValueError(
            f"datagram too short: {len(data)} B, expected at least {HEADER_SIZE} B"
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

    if magic != VIBR_MAGIC:
        raise ValueError(f"invalid magic {magic!r}")

    if version != VIBR_VERSION:
        raise ValueError(
            f"unsupported protocol version {version}, expected {VIBR_VERSION}"
        )

    if packet_count == 0:
        raise ValueError("packet_count cannot be zero")

    if packet_id >= packet_count:
        raise ValueError(
            f"packet_id={packet_id} outside packet_count={packet_count}"
        )

    expected_length = HEADER_SIZE + payload_length
    if len(data) != expected_length:
        raise ValueError(
            f"invalid length {len(data)} B, header declares {expected_length} B"
        )

    return VibrHeader(
        message_type=message_type,
        flags=flags,
        frame_id=frame_id,
        packet_id=packet_id,
        packet_count=packet_count,
        payload_length=payload_length,
        timestamp_us=timestamp_us,
    )


def parse_measurement_packet(
    header: VibrHeader,
    payload: bytes,
) -> MeasurementPacket:
    if len(payload) < MEASUREMENT_META_STRUCT.size:
        raise ValueError("measurement payload is too short")

    (
        data_kind,
        element_format,
        channel,
        _reserved,
        first_index,
        element_count,
    ) = MEASUREMENT_META_STRUCT.unpack_from(payload)

    encoded_values = payload[MEASUREMENT_META_STRUCT.size:]

    format_map = {
        FORMAT_INT32: (np.dtype(">i4"), 4),
        FORMAT_FLOAT32: (np.dtype(">f4"), 4),
        FORMAT_INT16: (np.dtype(">i2"), 2),
    }

    try:
        dtype, element_size = format_map[element_format]
    except KeyError as exc:
        raise ValueError(
            f"unsupported element format {element_format}"
        ) from exc

    expected_size = element_count * element_size
    if len(encoded_values) != expected_size:
        raise ValueError(
            f"measurement has {len(encoded_values)} data bytes, "
            f"expected {expected_size}"
        )

    # Kopia odłącza tablicę NumPy od bufora datagramu.
    values = np.frombuffer(
        encoded_values,
        dtype=dtype,
        count=element_count,
    ).astype(np.float64, copy=True)

    return MeasurementPacket(
        header=header,
        data_kind=data_kind,
        element_format=element_format,
        channel=channel,
        first_index=first_index,
        element_count=element_count,
        values=values,
    )


def parse_classification(
    header: VibrHeader,
    payload: bytes,
) -> ClassificationResult:
    if len(payload) != CLASSIFICATION_STRUCT.size:
        raise ValueError(
            f"classification payload must have "
            f"{CLASSIFICATION_STRUCT.size} B"
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
    ) = CLASSIFICATION_STRUCT.unpack(payload)

    return ClassificationResult(
        header=header,
        class_id=class_id,
        class_count=class_count,
        confidence_permille=confidence_permille,
        score_healthy=score_healthy,
        score_inner=score_inner,
        score_outer=score_outer,
        inference_time_us=inference_time_us,
        model_version=model_version,
    )


def parse_board_status(
    header: VibrHeader,
    payload: bytes,
) -> BoardStatus:
    if len(payload) != BOARD_STATUS_STRUCT.size:
        raise ValueError(
            f"board status payload must have "
            f"{BOARD_STATUS_STRUCT.size} B"
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
    ) = BOARD_STATUS_STRUCT.unpack(payload)

    return BoardStatus(
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


# ==============================
# UDP READER
# ==============================

class UdpReader(QThread):
    measurement_received = Signal(int, object, int, int)
    classification_received = Signal(object)
    board_status_received = Signal(object)
    synchronized_received = Signal(int, object)
    protocol_activity = Signal()
    line_received = Signal(str)
    error = Signal(str)

    def __init__(self, port=UDP_PORT, parent=None):
        super().__init__(parent)
        self.port = port
        self._stop = False
        self.pending_frames: Dict[int, PendingFrame] = {}
        self._last_activity_emit = 0.0

    def stop(self):
        self._stop = True

    def _get_pending_frame(self, frame_id: int) -> PendingFrame:
        frame = self.pending_frames.get(frame_id)

        if frame is not None:
            return frame

        if len(self.pending_frames) >= MAX_PENDING_FRAMES:
            oldest_id = min(
                self.pending_frames,
                key=lambda current_id:
                    self.pending_frames[current_id].created_monotonic,
            )
            del self.pending_frames[oldest_id]
            self.line_received.emit(
                f"DROP: frame={oldest_id}, reason=assembler_capacity"
            )

        frame = PendingFrame(frame_id=frame_id)
        self.pending_frames[frame_id] = frame
        return frame

    def _handle_measurement(
        self,
        header: VibrHeader,
        payload: bytes,
    ) -> None:
        packet = parse_measurement_packet(header, payload)
        frame = self._get_pending_frame(header.frame_id)

        if frame.packet_count is None:
            frame.packet_count = header.packet_count
            frame.data_kind = packet.data_kind
            frame.element_format = packet.element_format
            frame.channel = packet.channel
        else:
            if frame.packet_count != header.packet_count:
                raise ValueError(
                    f"frame {header.frame_id}: inconsistent packet_count"
                )

            if (
                frame.data_kind != packet.data_kind
                or frame.element_format != packet.element_format
                or frame.channel != packet.channel
            ):
                raise ValueError(
                    f"frame {header.frame_id}: inconsistent measurement metadata"
                )

        if header.packet_id in frame.packets:
            self.line_received.emit(
                f"DUPLICATE: frame={header.frame_id}, packet={header.packet_id}"
            )
            return

        frame.packets[header.packet_id] = packet

        if len(frame.packets) != frame.packet_count:
            return

        ordered_packets = sorted(
            frame.packets.values(),
            key=lambda current_packet: current_packet.first_index,
        )

        expected_index = 0
        value_parts = []

        for current_packet in ordered_packets:
            if current_packet.first_index != expected_index:
                raise ValueError(
                    f"frame {header.frame_id}: index gap, "
                    f"expected {expected_index}, "
                    f"received {current_packet.first_index}"
                )

            value_parts.append(current_packet.values)
            expected_index += current_packet.element_count

        frame.values = np.concatenate(value_parts)

        if not frame.measurement_emitted:
            frame.measurement_emitted = True
            self.measurement_received.emit(
                header.frame_id,
                frame.values,
                frame.data_kind,
                frame.channel,
            )
            if RAW_PACKET_LOG:
                self.line_received.emit(
                    f"RX DATA: frame={header.frame_id}, "
                    f"elements={len(frame.values)}, "
                    f"channel={frame.channel}"
                )

        self._emit_sync_if_ready(frame)

    def _handle_classification(
        self,
        header: VibrHeader,
        payload: bytes,
    ) -> None:
        result = parse_classification(header, payload)
        frame = self._get_pending_frame(header.frame_id)
        frame.classification = result

        if not frame.classification_emitted:
            frame.classification_emitted = True
            self.classification_received.emit(result)

            class_name = CLASS_NAMES.get(
                result.class_id,
                f"CLASS_{result.class_id}",
            )
            if RAW_PACKET_LOG:
                self.line_received.emit(
                    f"RX MODEL: frame={header.frame_id}, "
                    f"class={class_name}, "
                    f"confidence="
                    f"{result.confidence_permille / 10:.1f}%, "
                    f"inference={result.inference_time_us} us"
                )

        self._emit_sync_if_ready(frame)

    def _emit_sync_if_ready(self, frame: PendingFrame) -> None:
        if frame.values is None or frame.classification is None:
            return

        self.synchronized_received.emit(
            frame.frame_id,
            frame.classification,
        )
        self.pending_frames.pop(frame.frame_id, None)

    def _handle_board_status(
        self,
        header: VibrHeader,
        payload: bytes,
    ) -> None:
        status = parse_board_status(header, payload)
        self.board_status_received.emit(status)

        if (
            RAW_PACKET_LOG
            or status.dropped_frames != 0
            or status.last_error != 0
        ):
            self.line_received.emit(
                "RX STATUS: "
                f"board="
                f"{STATE_NAMES.get(status.board_state, status.board_state)}, "
                f"dma="
                f"{STATE_NAMES.get(status.dma_state, status.dma_state)}, "
                f"model="
                f"{STATE_NAMES.get(status.model_state, status.model_state)}, "
                f"ethernet="
                f"{STATE_NAMES.get(status.ethernet_state, status.ethernet_state)}, "
                f"last_frame={status.last_frame_id}, "
                f"dropped={status.dropped_frames}, "
                f"last_error={status.last_error}"
            )

    def _cleanup_expired_frames(self) -> None:
        now = time.monotonic()
        expired_ids = [
            frame_id
            for frame_id, frame in self.pending_frames.items()
            if now - frame.created_monotonic > FRAME_ASSEMBLY_TIMEOUT_S
        ]

        for frame_id in expired_ids:
            frame = self.pending_frames.pop(frame_id)

            self.line_received.emit(
                f"TIMEOUT: frame={frame_id}, "
                f"missing_data={frame.values is None}, "
                f"missing_model={frame.classification is None}, "
                f"packets={len(frame.packets)}/"
                f"{frame.packet_count if frame.packet_count is not None else '?'}"
            )

    def run(self):
        sock = None

        try:
            sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
            sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
            sock.bind(("0.0.0.0", self.port))
            sock.settimeout(0.2)
        except Exception as exc:
            self.error.emit(f"Cannot open UDP socket: {exc}")
            return

        self.line_received.emit(
            f"Listening for VIBR UDP protocol v{VIBR_VERSION} "
            f"on 0.0.0.0:{self.port}"
        )

        while not self._stop:
            try:
                data, source = sock.recvfrom(MAX_UDP_DATAGRAM)

                if not data:
                    continue

                header = parse_vibr_header(data)
                payload = data[HEADER_SIZE:]

                now = time.monotonic()
                if (
                    now - self._last_activity_emit
                    >= ACTIVITY_SIGNAL_PERIOD_S
                ):
                    self._last_activity_emit = now
                    self.protocol_activity.emit()

                if header.message_type == MSG_MEASUREMENT:
                    self._handle_measurement(header, payload)
                elif header.message_type == MSG_CLASSIFICATION:
                    self._handle_classification(header, payload)
                elif header.message_type == MSG_BOARD_STATUS:
                    self._handle_board_status(header, payload)
                else:
                    raise ValueError(
                        f"unsupported message type "
                        f"0x{header.message_type:02X}"
                    )

            except socket.timeout:
                self._cleanup_expired_frames()
                continue
            except ValueError as exc:
                self.line_received.emit(
                    f"INVALID PACKET from {source}: {exc}"
                )
            except Exception as exc:
                self.error.emit(f"UDP read error: {exc}")
                break

            self._cleanup_expired_frames()

        try:
            if sock is not None:
                sock.close()
        except Exception:
            pass


# ==============================
# LIVE FFT WINDOW
# ==============================

class LiveFFTWindow(QWidget):
    def __init__(self, freq_axis):
        super().__init__()

        self.setWindowTitle("Live FFT Analyzer")
        self.resize(950, 700)
        self.freq_axis = freq_axis
        self.current_fft = None
        self.current_fft_avg = None
        self.use_averaging = False

        self.btn_freeze = QPushButton("Freeze")
        self.btn_freeze.setCheckable(True)

        self.btn_avg = QPushButton("Averaging: OFF")
        self.btn_avg.setCheckable(True)
        self.btn_avg.toggled.connect(self.toggle_averaging)

        self.btn_marker = QPushButton("Marker: ON")
        self.btn_marker.setCheckable(True)
        self.btn_marker.setChecked(True)
        self.btn_marker.toggled.connect(self.toggle_marker)

        self.btn_peaks = QPushButton("Detect Peaks")
        self.btn_peaks.clicked.connect(self.detect_peaks)

        self.label_cursor = QLabel("Frequency: - Hz | Amplitude: -")
        self.label_cursor.setAlignment(Qt.AlignLeft)

        self.y_min_spin = QDoubleSpinBox()
        self.y_min_spin.setRange(-1e6, 1e6)
        self.y_min_spin.setValue(0.0)
        self.y_min_spin.setDecimals(2)

        self.y_max_spin = QDoubleSpinBox()
        self.y_max_spin.setRange(-1e6, 1e6)
        self.y_max_spin.setValue(500.0)
        self.y_max_spin.setDecimals(2)

        self.btn_apply_y = QPushButton("Apply Y Range")
        self.btn_apply_y.clicked.connect(self.apply_y_range)

        self.plot = pg.PlotWidget(title="Live FFT Spectrum")
        self.plot.setBackground("k")
        self.plot.setLabel("bottom", "Frequency (Hz)")
        self.plot.setLabel("left", "Amplitude")
        self.plot.showGrid(x=True, y=True, alpha=0.2)
        self.plot.enableAutoRange(axis="x", enable=False)
        self.plot.setXRange(0.0, float(self.freq_axis[-1]), padding=0.0)
        self.plot.enableAutoRange(axis="y", enable=True)

        self.curve = self.plot.plot(pen=pg.mkPen("y", width=1))
        self.max_marker = self.plot.plot(
            [], [], pen=None, symbol="o",
            symbolBrush="r", symbolSize=10
        )
        self.min_marker = self.plot.plot(
            [], [], pen=None, symbol="o",
            symbolBrush="b", symbolSize=10
        )

        self.v_line = pg.InfiniteLine(
            angle=90,
            pen=pg.mkPen("r", width=1),
        )
        self.plot.addItem(self.v_line)

        top = QHBoxLayout()
        top.addWidget(self.btn_freeze)
        top.addWidget(self.btn_avg)
        top.addWidget(self.btn_marker)
        top.addWidget(self.btn_peaks)
        top.addWidget(QLabel("Y min:"))
        top.addWidget(self.y_min_spin)
        top.addWidget(QLabel("Y max:"))
        top.addWidget(self.y_max_spin)
        top.addWidget(self.btn_apply_y)
        top.addWidget(self.label_cursor, 1)

        layout = QVBoxLayout()
        layout.addLayout(top)
        layout.addWidget(self.plot)
        self.setLayout(layout)

        self.proxy = pg.SignalProxy(
            self.plot.scene().sigMouseMoved,
            rateLimit=60,
            slot=self.mouse_moved,
        )

    def toggle_averaging(self, checked):
        self.use_averaging = checked
        self.btn_avg.setText(
            "Averaging: ON" if checked else "Averaging: OFF"
        )

    def toggle_marker(self, checked):
        self.btn_marker.setText(
            "Marker: ON" if checked else "Marker: OFF"
        )
        self.v_line.setVisible(checked)

        if not checked:
            self.label_cursor.setText("")

    def apply_y_range(self):
        y_min = self.y_min_spin.value()
        y_max = self.y_max_spin.value()

        if y_min >= y_max:
            return

        self.plot.enableAutoRange(axis="y", enable=False)
        self.plot.setYRange(y_min, y_max)

    def update_fft(self, fft_data):
        if self.btn_freeze.isChecked():
            return

        self.current_fft = fft_data

        if self.current_fft_avg is None:
            self.current_fft_avg = fft_data.copy()
        else:
            self.current_fft_avg = (
                FFT_AVG_ALPHA * fft_data
                + (1 - FFT_AVG_ALPHA) * self.current_fft_avg
            )

        if self.use_averaging:
            fft_to_plot = self.current_fft_avg
        else:
            fft_to_plot = self.current_fft

        self.curve.setData(self.freq_axis, fft_to_plot)

    def detect_peaks(self):
        if self.use_averaging:
            data = self.current_fft_avg
        else:
            data = self.current_fft

        if data is None:
            return

        max_idx = np.argmax(data)
        min_idx = np.argmin(data)

        max_freq = self.freq_axis[max_idx]
        max_amp = data[max_idx]

        min_freq = self.freq_axis[min_idx]
        min_amp = data[min_idx]

        self.max_marker.setData([max_freq], [max_amp])
        self.min_marker.setData([min_freq], [min_amp])

        self.label_cursor.setText(
            f"MAX: {max_freq:.1f} Hz | Amplitude: {max_amp:.2f}  ||  "
            f"MIN: {min_freq:.1f} Hz | Amplitude: {min_amp:.2f}"
        )

    def mouse_moved(self, evt):
        pos = evt[0]

        if not self.btn_marker.isChecked():
            return

        if not self.plot.sceneBoundingRect().contains(pos):
            return

        mouse_point = self.plot.getPlotItem().vb.mapSceneToView(pos)
        freq = mouse_point.x()
        self.v_line.setPos(freq)

        if self.current_fft is None:
            return

        idx = int(np.argmin(np.abs(self.freq_axis - freq)))
        amp = self.current_fft[idx]

        self.label_cursor.setText(
            f"Frequency: {self.freq_axis[idx]:.1f} Hz | "
            f"Amplitude: {amp:.3f}"
        )


# ==============================
# MAIN GUI
# ==============================

class MainWindow(QWidget):
    def __init__(self):
        super().__init__()
        self.setWindowTitle(APP_TITLE)

        # --- Top controls
        self.btn_connect = QPushButton("Start listening")
        self.btn_disconnect = QPushButton("Stop")
        self.btn_open_live = QPushButton("Open Live FFT")
        self.btn_disconnect.setEnabled(False)

        # --- Connection label
        self.label_conn = QLabel(TEXT_CONNECTION_DISCONNECTED)
        self.label_conn.setAlignment(Qt.AlignCenter)
        self.label_conn.setStyleSheet("font-size: 14px;")

        # --- System status row
        self.label_eth = QLabel(TEXT_ETH_DISCONNECTED)
        self.label_eth.setAlignment(Qt.AlignCenter)
        self.label_eth.setStyleSheet(
            "font-size: 14px; font-weight: 700; color: white; "
            "background-color: dimgray; padding: 6px;"
        )

        self.label_model_state = QLabel(TEXT_MODEL_STOPPED)
        self.label_model_state.setAlignment(Qt.AlignCenter)
        self.label_model_state.setStyleSheet(
            "font-size: 14px; font-weight: 700; color: white; "
            "background-color: dimgray; padding: 6px;"
        )

        # --- Metrics
        self.label_seq = QLabel("SEQ: -")
        self.label_seq.setAlignment(Qt.AlignCenter)
        self.label_seq.setStyleSheet("font-size: 14px;")

        self.label_rate = QLabel("FRAME RATE: - fps")
        self.label_rate.setAlignment(Qt.AlignCenter)
        self.label_rate.setStyleSheet("font-size: 14px;")

        self.label_last = QLabel("LAST FRAME: - s ago")
        self.label_last.setAlignment(Qt.AlignCenter)
        self.label_last.setStyleSheet("font-size: 14px;")

        # --- Big panels
        self.label_model = QLabel(TEXT_MODEL_UNKNOWN)
        self.label_model.setAlignment(Qt.AlignCenter)
        self.label_model.setStyleSheet(
            "font-size: 22px; font-weight: 800; color: white; "
            "background-color: gray; padding: 10px;"
        )

        self.label_bearing = QLabel(TEXT_BEARING_UNKNOWN)
        self.label_bearing.setAlignment(Qt.AlignCenter)
        self.label_bearing.setStyleSheet(
            "font-size: 28px; font-weight: 900; color: white; "
            "background-color: gray; padding: 14px;"
        )

        # --- Peak label
        self.label_peak = QLabel("Peak: - Hz | Amplitude: -")
        self.label_peak.setAlignment(Qt.AlignCenter)
        self.label_peak.setStyleSheet(
            "font-size: 16px; font-weight: 700;"
        )

        # --- Averaged FFT plot
        self.fft_plot = pg.PlotWidget(title="FFT Spectrum")
        self.fft_plot.setBackground("k")
        self.fft_plot.setLabel("left", "Amplitude")
        self.fft_plot.setLabel("bottom", "Frequency (Hz)")
        self.fft_plot.showGrid(x=True, y=True, alpha=0.2)

        self.fft_curve = self.fft_plot.plot(
            pen=pg.mkPen("y", width=1)
        )
        self.peak_marker = self.fft_plot.plot(
            [], [], pen=None, symbol="o",
            symbolBrush="r", symbolPen="w", symbolSize=8
        )

        self.freq_axis = np.fft.rfftfreq(
            FFT_SIZE,
            d=1 / SAMPLING_RATE,
        )
        self.fft_avg = None

        # --- Log
        self.log = QPlainTextEdit()
        self.log.setReadOnly(True)
        self.log.setMaximumBlockCount(500)
        self.log.setFixedHeight(120)

        # --- Layout — zachowany z istniejącej aplikacji.
        top = QHBoxLayout()
        top.addWidget(self.btn_connect)
        top.addWidget(self.btn_disconnect)
        top.addWidget(self.btn_open_live)

        system_row = QHBoxLayout()
        system_row.addWidget(self.label_eth)
        system_row.addWidget(self.label_model_state)

        metrics_row = QHBoxLayout()
        metrics_row.addWidget(self.label_seq)
        metrics_row.addWidget(self.label_rate)
        metrics_row.addWidget(self.label_last)

        layout = QVBoxLayout()
        layout.addLayout(top)
        layout.addWidget(self.label_conn)
        layout.addLayout(system_row)
        layout.addLayout(metrics_row)
        layout.addWidget(self.label_model)
        layout.addWidget(self.label_bearing)
        layout.addWidget(self.label_peak)
        layout.addWidget(self.fft_plot, 1)
        layout.addWidget(QLabel(TEXT_LOG))
        layout.addWidget(self.log)
        self.setLayout(layout)

        # --- Runtime state
        self.reader: Optional[UdpReader] = None
        self.live_window: Optional[LiveFFTWindow] = None

        self.last_packet_time: Optional[float] = None
        self.last_frame_time: Optional[float] = None
        self.last_data_frame_id: Optional[int] = None
        self.last_model_frame_id: Optional[int] = None

        self._rate_window_start = time.monotonic()
        self._rate_window_count = 0
        self._rate_hz = 0.0

        self._last_fft_ui_update = 0.0
        self._last_class_ui_update = 0.0
        self._last_sync_log = 0.0
        self._sync_count_since_log = 0
        self._latest_sync_frame: Optional[int] = None
        self._latest_sync_result: Optional[ClassificationResult] = None

        # --- Signals
        self.btn_connect.clicked.connect(self.start_udp)
        self.btn_disconnect.clicked.connect(self.stop_udp)
        self.btn_open_live.clicked.connect(self.open_live_fft)

        # --- Timers
        self.watchdog_timer = QTimer()
        self.watchdog_timer.timeout.connect(self.check_data_timeout)
        self.watchdog_timer.start(500)

        # Poprzedni generator sztucznego FFT został wyłączony.
        # Wykres jest teraz aktualizowany wyłącznie danymi z KR260.

    # ==============================

    def start_udp(self):
        if self.reader is not None:
            return

        self.last_packet_time = None
        self.last_frame_time = None
        self.last_data_frame_id = None
        self.last_model_frame_id = None

        self._rate_window_start = time.monotonic()
        self._rate_window_count = 0
        self._rate_hz = 0.0

        self._last_fft_ui_update = 0.0
        self._last_class_ui_update = 0.0
        self._last_sync_log = time.monotonic()
        self._sync_count_since_log = 0
        self._latest_sync_frame = None
        self._latest_sync_result = None

        self.reader = UdpReader()

        self.reader.protocol_activity.connect(self.on_protocol_activity)
        self.reader.measurement_received.connect(self.on_measurement)
        self.reader.classification_received.connect(
            self.on_classification
        )
        self.reader.board_status_received.connect(
            self.on_board_status
        )
        self.reader.synchronized_received.connect(
            self.on_synchronized
        )
        self.reader.line_received.connect(self.on_line)
        self.reader.error.connect(self.on_error)
        self.reader.start()

        self.label_conn.setText(TEXT_CONNECTION_LISTENING)

        self.label_eth.setText(TEXT_ETH_DISCONNECTED)
        self.label_eth.setStyleSheet(
            "font-size: 14px; font-weight: 700; color: white; "
            "background-color: dimgray; padding: 6px;"
        )

        self.btn_connect.setEnabled(False)
        self.btn_disconnect.setEnabled(True)

    # ==============================

    def stop_udp(self):
        if self.reader:
            self.reader.stop()
            self.reader.wait(1500)
            self.reader = None

        self.last_packet_time = None
        self.last_frame_time = None

        self.label_conn.setText(TEXT_CONNECTION_DISCONNECTED)

        self.label_eth.setText(TEXT_ETH_DISCONNECTED)
        self.label_eth.setStyleSheet(
            "font-size: 14px; font-weight: 700; color: white; "
            "background-color: dimgray; padding: 6px;"
        )

        self.label_model_state.setText(TEXT_MODEL_STOPPED)
        self.label_model_state.setStyleSheet(
            "font-size: 14px; font-weight: 700; color: white; "
            "background-color: dimgray; padding: 6px;"
        )

        self.label_model.setText(TEXT_MODEL_UNKNOWN)
        self.label_model.setStyleSheet(
            "font-size: 22px; font-weight: 800; color: white; "
            "background-color: gray; padding: 10px;"
        )

        self.label_bearing.setText(TEXT_BEARING_UNKNOWN)
        self.label_bearing.setStyleSheet(
            "font-size: 28px; font-weight: 900; color: white; "
            "background-color: gray; padding: 14px;"
        )

        self.label_last.setText("LAST FRAME: - s ago")

        self.btn_connect.setEnabled(True)
        self.btn_disconnect.setEnabled(False)

    # ==============================

    def open_live_fft(self):
        if self.live_window is None:
            self.live_window = LiveFFTWindow(self.freq_axis)

        self.live_window.show()
        self.live_window.raise_()
        self.live_window.activateWindow()

    # ==============================

    @Slot()
    def on_protocol_activity(self):
        self.last_packet_time = time.monotonic()

        self.label_eth.setText(TEXT_ETH_CONNECTED)
        self.label_eth.setStyleSheet(
            "font-size: 14px; font-weight: 700; color: white; "
            "background-color: green; padding: 6px;"
        )

    # ==============================

    def check_data_timeout(self):
        if self.reader is None:
            return

        now = time.monotonic()

        if self.last_frame_time is None:
            self.label_last.setText("LAST FRAME: waiting")
        else:
            age = now - self.last_frame_time
            self.label_last.setText(
                f"LAST FRAME: {age:.2f} s ago"
            )

            if age > 2.0:
                self.label_bearing.setText(TEXT_NO_DATA)
                self.label_bearing.setStyleSheet(
                    "font-size: 28px; font-weight: 900; color: white; "
                    "background-color: orange; padding: 14px;"
                )

        if (
            self.last_packet_time is not None
            and now - self.last_packet_time > CONNECTION_TIMEOUT_S
        ):
            self.label_eth.setText(TEXT_ETH_DISCONNECTED)
            self.label_eth.setStyleSheet(
                "font-size: 14px; font-weight: 700; color: white; "
                "background-color: dimgray; padding: 6px;"
            )

            self.label_model_state.setText(TEXT_MODEL_STOPPED)
            self.label_model_state.setStyleSheet(
                "font-size: 14px; font-weight: 700; color: white; "
                "background-color: dimgray; padding: 6px;"
            )

    # ==============================

    def update_fft(self, fft_data):
        fft_data = np.asarray(fft_data, dtype=np.float64)

        if fft_data.shape != self.freq_axis.shape:
            self.log.appendPlainText(
                f"FFT length mismatch: received {len(fft_data)}, "
                f"expected {len(self.freq_axis)}"
            )
            return

        if self.fft_avg is None:
            self.fft_avg = fft_data.copy()
        else:
            self.fft_avg = (
                FFT_AVG_ALPHA * fft_data
                + (1 - FFT_AVG_ALPHA) * self.fft_avg
            )

        self.fft_curve.setData(self.freq_axis, self.fft_avg)

        peak_idx = int(np.argmax(self.fft_avg))
        peak_freq = self.freq_axis[peak_idx]
        peak_amp = self.fft_avg[peak_idx]

        self.peak_marker.setData([peak_freq], [peak_amp])
        self.label_peak.setText(
            f"Peak: {peak_freq:.1f} Hz | "
            f"Amplitude: {peak_amp:.2f}"
        )

        if self.live_window is not None:
            self.live_window.update_fft(fft_data)

    # ==============================

    def prepare_fft(
        self,
        values: np.ndarray,
        data_kind: int,
    ) -> Optional[np.ndarray]:
        values = np.asarray(values, dtype=np.float64)

        if data_kind == DATA_TIME_SAMPLES:
            if len(values) != FFT_SIZE:
                self.log.appendPlainText(
                    f"Cannot calculate FFT: frame has {len(values)} "
                    f"samples, expected {FFT_SIZE}"
                )
                return None

            # Standardowe przygotowanie widma:
            # 1) usunięcie składowej stałej,
            # 2) okno Hanna ograniczające przeciek widma,
            # 3) jednowymiarowe widmo amplitudowe.
            centered = values - np.mean(values)
            window = np.hanning(len(centered))
            window_sum = float(np.sum(window))

            if window_sum <= 0.0:
                return None

            spectrum = np.fft.rfft(centered * window)
            magnitude = 2.0 * np.abs(spectrum) / window_sum

            # Składowa DC i ewentualny bin Nyquista nie są podwajane.
            magnitude[0] *= 0.5
            if len(centered) % 2 == 0:
                magnitude[-1] *= 0.5

            return magnitude

        if data_kind == DATA_FFT_MAGNITUDE:
            expected_bins = FFT_SIZE // 2 + 1

            if len(values) == expected_bins:
                return values

            if len(values) >= expected_bins:
                # Dla pełnego widma 1024-punktowego pokazujemy dodatnią połowę.
                return values[:expected_bins]

            self.log.appendPlainText(
                f"FFT magnitude frame has {len(values)} bins, "
                f"expected at least {expected_bins}"
            )
            return None

        if data_kind == DATA_FFT_COMPLEX:
            if len(values) % 2 != 0:
                self.log.appendPlainText(
                    "Complex FFT payload must contain real/imaginary pairs"
                )
                return None

            complex_values = (
                values[0::2] + 1j * values[1::2]
            )
            magnitude = np.abs(complex_values)
            expected_bins = FFT_SIZE // 2 + 1

            if len(magnitude) >= expected_bins:
                return magnitude[:expected_bins]

            self.log.appendPlainText(
                f"Complex FFT frame has {len(magnitude)} bins, "
                f"expected at least {expected_bins}"
            )
            return None

        self.log.appendPlainText(
            f"Unsupported measurement data kind: {data_kind}"
        )
        return None

    # ==============================

    @Slot(int, object, int, int)
    def on_measurement(
        self,
        frame_id: int,
        values: np.ndarray,
        data_kind: int,
        channel: int,
    ):
        del channel

        now = time.monotonic()
        self.last_frame_time = now
        self.last_data_frame_id = frame_id

        self._rate_window_count += 1
        dt = now - self._rate_window_start

        if dt >= 2.0:
            self._rate_hz = self._rate_window_count / dt
            self._rate_window_start = now
            self._rate_window_count = 0

        # Odbieramy każdą ramkę, lecz odrysowujemy maksymalnie 10 razy/s.
        if now - self._last_fft_ui_update < FFT_UI_PERIOD_S:
            return

        self._last_fft_ui_update = now
        self.label_seq.setText(f"SEQ: {frame_id}")
        sample_rate_ksps = (
            self._rate_hz * FFT_SIZE / 1000.0
        )
        self.label_rate.setText(
            f"FRAME RATE: {self._rate_hz:.1f} fps | "
            f"{sample_rate_ksps:.1f} kS/s"
        )

        fft_data = self.prepare_fft(values, data_kind)

        if fft_data is not None:
            self.update_fft(fft_data)

    # ==============================

    @Slot(object)
    def on_classification(
        self,
        result: ClassificationResult,
    ):
        self.last_model_frame_id = result.header.frame_id

        now = time.monotonic()

        # Model nadal jest odbierany dla każdej ramki, ale panel diagnozy
        # zmienia się najwyżej raz na sekundę. Eliminuje to migotanie GUI.
        if (
            self._last_class_ui_update != 0.0
            and now - self._last_class_ui_update < CLASS_UI_PERIOD_S
        ):
            return

        self._last_class_ui_update = now

        self.label_model_state.setText(TEXT_MODEL_RUNNING)
        self.label_model_state.setStyleSheet(
            "font-size: 14px; font-weight: 700; color: white; "
            "background-color: green; padding: 6px;"
        )

        self.label_model.setText(TEXT_MODEL_ON)
        self.label_model.setStyleSheet(
            "font-size: 22px; font-weight: 800; color: white; "
            "background-color: green; padding: 10px;"
        )

        if result.class_id == CLASS_HEALTHY:
            self.label_bearing.setText(TEXT_BEARING_OK)
            self.label_bearing.setStyleSheet(
                "font-size: 28px; font-weight: 900; color: white; "
                "background-color: green; padding: 14px;"
            )

        elif result.class_id in (
            CLASS_INNER_FAULT,
            CLASS_OUTER_FAULT,
        ):
            self.label_bearing.setText(TEXT_BEARING_DAMAGED)
            self.label_bearing.setStyleSheet(
                "font-size: 28px; font-weight: 900; color: white; "
                "background-color: red; padding: 14px;"
            )

        else:
            self.label_bearing.setText(TEXT_BEARING_UNKNOWN)
            self.label_bearing.setStyleSheet(
                "font-size: 28px; font-weight: 900; color: white; "
                "background-color: gray; padding: 14px;"
            )

    # ==============================

    @Slot(object)
    def on_board_status(self, status: BoardStatus):
        ethernet_running = status.ethernet_state == STATE_RUNNING
        model_running = status.model_state == STATE_RUNNING

        if ethernet_running:
            self.label_eth.setText(TEXT_ETH_CONNECTED)
            self.label_eth.setStyleSheet(
                "font-size: 14px; font-weight: 700; color: white; "
                "background-color: green; padding: 6px;"
            )
        else:
            self.label_eth.setText(TEXT_ETH_DISCONNECTED)
            self.label_eth.setStyleSheet(
                "font-size: 14px; font-weight: 700; color: white; "
                "background-color: dimgray; padding: 6px;"
            )

        if model_running:
            self.label_model_state.setText(TEXT_MODEL_RUNNING)
            self.label_model_state.setStyleSheet(
                "font-size: 14px; font-weight: 700; color: white; "
                "background-color: green; padding: 6px;"
            )

            self.label_model.setText(TEXT_MODEL_ON)
            self.label_model.setStyleSheet(
                "font-size: 22px; font-weight: 800; color: white; "
                "background-color: green; padding: 10px;"
            )
        else:
            self.label_model_state.setText(TEXT_MODEL_STOPPED)
            self.label_model_state.setStyleSheet(
                "font-size: 14px; font-weight: 700; color: white; "
                "background-color: dimgray; padding: 6px;"
            )

            self.label_model.setText(TEXT_MODEL_OFF)
            self.label_model.setStyleSheet(
                "font-size: 22px; font-weight: 800; color: white; "
                "background-color: dimgray; padding: 10px;"
            )

        # Szczegóły błędów i dropów są logowane przez UdpReader
        # tylko wtedy, gdy wartości są niezerowe.

    # ==============================

    @Slot(int, object)
    def on_synchronized(
        self,
        frame_id: int,
        result: ClassificationResult,
    ):
        self._sync_count_since_log += 1
        self._latest_sync_frame = frame_id
        self._latest_sync_result = result

        now = time.monotonic()

        if now - self._last_sync_log < SYNC_LOG_PERIOD_S:
            return

        class_name = CLASS_NAMES.get(
            result.class_id,
            f"CLASS_{result.class_id}",
        )

        self.log.appendPlainText(
            f"RX SUMMARY: frame={frame_id}, "
            f"synced={self._sync_count_since_log}, "
            f"rate={self._rate_hz:.1f} fps, "
            f"class={class_name}, "
            f"confidence={result.confidence_permille / 10:.1f}%"
        )

        self._sync_count_since_log = 0
        self._last_sync_log = now

    # ==============================

    @Slot(str)
    def on_line(self, line: str):
        self.log.appendPlainText(line)

    # ==============================

    @Slot(str)
    def on_error(self, msg: str):
        QMessageBox.critical(self, "Error", msg)
        self.stop_udp()

    # ==============================

    def closeEvent(self, event):
        self.stop_udp()

        if self.live_window is not None:
            self.live_window.close()

        event.accept()


# ==============================
# MAIN
# ==============================

def main():
    app = QApplication(sys.argv)
    window = MainWindow()
    window.resize(950, 520)
    window.show()
    sys.exit(app.exec())


if __name__ == "__main__":
    main()
