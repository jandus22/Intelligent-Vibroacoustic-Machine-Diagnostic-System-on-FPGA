import sys
import time
import re
import socket
from dataclasses import dataclass
from typing import Optional

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

UDP_PORT = 5000

SAMPLING_RATE = 26700
FFT_SIZE = 1024
FFT_AVG_ALPHA = 0.2

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
# DATA STRUCTURE
# ==============================

@dataclass
class DeviceStatus:
    model_on: Optional[bool] = None
    bearing_fault: Optional[bool] = None
    seq: Optional[int] = None
    raw_line: str = ""
    timestamp: float = 0.0


# ==============================
# PARSER
# ==============================

def parse_status_line(line: str) -> Optional[DeviceStatus]:
    s = line.strip()
    if not s:
        return None

    seq_match = re.search(r"\bSEQ\s*=\s*(\d+)\b", s, re.IGNORECASE)
    m = re.search(r"\bMODEL\s*=\s*([A-Za-z0-9]+)\b", s, re.IGNORECASE)
    b = re.search(r"\bBEARING\s*=\s*([A-Za-z0-9]+)\b", s, re.IGNORECASE)

    if not m and not b and not seq_match:
        return None

    st = DeviceStatus(raw_line=s, timestamp=time.time())

    if seq_match:
        st.seq = int(seq_match.group(1))

    if m:
        val = m.group(1).upper()
        if val in ("ON", "1", "TRUE", "T"):
            st.model_on = True
        elif val in ("OFF", "0", "FALSE", "F"):
            st.model_on = False

    if b:
        val = b.group(1).upper()
        if val in ("OK", "GOOD", "0"):
            st.bearing_fault = False
        elif val in ("DAMAGED", "BAD", "1"):
            st.bearing_fault = True

    return st


# ==============================
# UDP READER
# ==============================

class UdpReader(QThread):
    status_received = Signal(object)
    line_received = Signal(str)
    error = Signal(str)

    def __init__(self, port=UDP_PORT, parent=None):
        super().__init__(parent)
        self.port = port
        self._stop = False

    def stop(self):
        self._stop = True

    def run(self):
        sock = None
        try:
            sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
            sock.bind(("0.0.0.0", self.port))
            sock.settimeout(0.2)
        except Exception as e:
            self.error.emit(f"Cannot open UDP socket: {e}")
            return

        while not self._stop:
            try:
                data, _ = sock.recvfrom(8192)
                if not data:
                    continue

                line = data.decode(errors="replace").strip()
                if not line:
                    continue

                self.line_received.emit(line)

                st = parse_status_line(line)
                if st is not None:
                    self.status_received.emit(st)

            except socket.timeout:
                continue
            except Exception as e:
                self.error.emit(f"UDP read error: {e}")
                break

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
        self.plot.enableAutoRange(axis='y', enable=False)
        self.plot.setYRange(0, 500)

        self.curve = self.plot.plot(pen=pg.mkPen("y", width=1))
        self.max_marker = self.plot.plot([], [], pen=None, symbol='o',
                                 symbolBrush='r', symbolSize=10)
        self.min_marker = self.plot.plot([], [], pen=None, symbol='o',
                                 symbolBrush='b', symbolSize=10)

        self.v_line = pg.InfiniteLine(angle=90, pen=pg.mkPen("r", width=1))
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
            slot=self.mouse_moved
        )
    def toggle_averaging(self, checked):
        self.use_averaging = checked
        self.btn_avg.setText("Averaging: ON" if checked else "Averaging: OFF")

    def toggle_marker(self, checked):
        self.btn_marker.setText("Marker: ON" if checked else "Marker: OFF")
        self.v_line.setVisible(checked)

        if not checked:
            self.label_cursor.setText("")
    def apply_y_range(self):
        y_min = self.y_min_spin.value()
        y_max = self.y_max_spin.value()

        if y_min >= y_max:
            return

        self.plot.setYRange(y_min, y_max)
    def update_fft(self, fft_data):

        if self.btn_freeze.isChecked():
            return

        self.current_fft = fft_data

        if self.current_fft_avg is None:
            self.current_fft_avg = fft_data
        else:
            self.current_fft_avg = FFT_AVG_ALPHA * fft_data + (1 - FFT_AVG_ALPHA) * self.current_fft_avg

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
            f"Frequency: {self.freq_axis[idx]:.1f} Hz | Amplitude: {amp:.3f}"
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
            "font-size: 14px; font-weight: 700; color: white; background-color: dimgray; padding: 6px;"
        )

        self.label_model_state = QLabel(TEXT_MODEL_STOPPED)
        self.label_model_state.setAlignment(Qt.AlignCenter)
        self.label_model_state.setStyleSheet(
            "font-size: 14px; font-weight: 700; color: white; background-color: dimgray; padding: 6px;"
        )

        # --- Metrics
        self.label_seq = QLabel("SEQ: -")
        self.label_seq.setAlignment(Qt.AlignCenter)
        self.label_seq.setStyleSheet("font-size: 14px;")

        self.label_rate = QLabel("DATA RATE: - Hz")
        self.label_rate.setAlignment(Qt.AlignCenter)
        self.label_rate.setStyleSheet("font-size: 14px;")

        self.label_last = QLabel("LAST FRAME: - s ago")
        self.label_last.setAlignment(Qt.AlignCenter)
        self.label_last.setStyleSheet("font-size: 14px;")

        # --- Big panels
        self.label_model = QLabel(TEXT_MODEL_UNKNOWN)
        self.label_model.setAlignment(Qt.AlignCenter)
        self.label_model.setStyleSheet(
            "font-size: 22px; font-weight: 800; color: white; background-color: gray; padding: 10px;"
        )

        self.label_bearing = QLabel(TEXT_BEARING_UNKNOWN)
        self.label_bearing.setAlignment(Qt.AlignCenter)
        self.label_bearing.setStyleSheet(
            "font-size: 28px; font-weight: 900; color: white; background-color: gray; padding: 14px;"
        )

        # --- Peak label
        self.label_peak = QLabel("Peak: - Hz | Amplitude: -")
        self.label_peak.setAlignment(Qt.AlignCenter)
        self.label_peak.setStyleSheet("font-size: 16px; font-weight: 700;")

        # --- Averaged FFT plot
        self.fft_plot = pg.PlotWidget(title="FFT Spectrum")
        self.fft_plot.setBackground("k")
        self.fft_plot.setLabel("left", "Amplitude")
        self.fft_plot.setLabel("bottom", "Frequency (Hz)")
        self.fft_plot.showGrid(x=True, y=True, alpha=0.2)

        self.fft_curve = self.fft_plot.plot(pen=pg.mkPen("y", width=1))
        self.peak_marker = self.fft_plot.plot(
            [], [], pen=None, symbol='o', symbolBrush='r', symbolPen='w', symbolSize=8
        )

        self.freq_axis = np.fft.rfftfreq(FFT_SIZE, d=1 / SAMPLING_RATE)
        self.fft_avg = None

        # --- Log
        self.log = QPlainTextEdit()
        self.log.setReadOnly(True)
        self.log.setMaximumBlockCount(500)
        self.log.setFixedHeight(120)

        # --- Layout
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
        layout.addWidget(QLabel(TEXT_LOG))
        layout.addWidget(self.log)
        self.setLayout(layout)

        # --- Runtime state
        self.reader: Optional[UdpReader] = None
        self.live_window: Optional[LiveFFTWindow] = None
        self.last_frame_time = time.time()

        self._rate_window_start = time.time()
        self._rate_window_count = 0
        self._rate_hz = 0.0

        # --- Signals
        self.btn_connect.clicked.connect(self.start_udp)
        self.btn_disconnect.clicked.connect(self.stop_udp)
        self.btn_open_live.clicked.connect(self.open_live_fft)

        # --- Timers
        self.watchdog_timer = QTimer()
        self.watchdog_timer.timeout.connect(self.check_data_timeout)
        self.watchdog_timer.start(500)

        # Test FFT generator
        self.test_timer = QTimer()
        self.test_timer.timeout.connect(self.generate_fake_fft)
        self.test_timer.start(100)

    # ==============================

    def start_udp(self):
        if self.reader is not None:
            return

        self.reader = UdpReader()

        self.reader.line_received.connect(self.on_line)
        self.reader.status_received.connect(self.on_status)
        self.reader.error.connect(self.on_error)
        self.reader.start()

        self.label_conn.setText(TEXT_CONNECTION_LISTENING)

        self.label_eth.setText(TEXT_ETH_CONNECTED)
        self.label_eth.setStyleSheet(
            "font-size: 14px; font-weight: 700; color: white; background-color: green; padding: 6px;"
        )

        self.btn_connect.setEnabled(False)
        self.btn_disconnect.setEnabled(True)

    # ==============================

    def stop_udp(self):
        if self.reader:
            self.reader.stop()
            self.reader.wait(1500)
            self.reader = None

        self.label_conn.setText(TEXT_CONNECTION_DISCONNECTED)

        self.label_eth.setText(TEXT_ETH_DISCONNECTED)
        self.label_eth.setStyleSheet(
            "font-size: 14px; font-weight: 700; color: white; background-color: dimgray; padding: 6px;"
        )

        self.label_model_state.setText(TEXT_MODEL_STOPPED)
        self.label_model_state.setStyleSheet(
            "font-size: 14px; font-weight: 700; color: white; background-color: dimgray; padding: 6px;"
        )

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

    def check_data_timeout(self):
        age = time.time() - self.last_frame_time
        self.label_last.setText(f"LAST FRAME: {age:.2f} s ago")

        if age > 2:
            self.label_bearing.setText(TEXT_NO_DATA)
            self.label_bearing.setStyleSheet(
                "font-size: 28px; font-weight: 900; color: white; background-color: orange; padding: 14px;"
            )

    # ==============================

    def update_fft(self, fft_data):
        if self.fft_avg is None:
            self.fft_avg = fft_data
        else:
            self.fft_avg = FFT_AVG_ALPHA * fft_data + (1 - FFT_AVG_ALPHA) * self.fft_avg

        self.fft_curve.setData(self.freq_axis, self.fft_avg)

        peak_idx = int(np.argmax(self.fft_avg))
        peak_freq = self.freq_axis[peak_idx]
        peak_amp = self.fft_avg[peak_idx]

        self.peak_marker.setData([peak_freq], [peak_amp])
        self.label_peak.setText(f"Peak: {peak_freq:.1f} Hz | Amplitude: {peak_amp:.2f}")

        if self.live_window is not None:
            self.live_window.update_fft(fft_data)

    # ==============================

    def generate_fake_fft(self):
        t = np.arange(FFT_SIZE)

        freq = 2000 + np.random.randn() * 80
        amp = 1.0 + np.random.randn() * 0.15

        signal = amp * np.sin(2 * np.pi * freq * t / SAMPLING_RATE)
        noise = 0.3 * np.random.randn(FFT_SIZE)

        fft = np.abs(np.fft.rfft(signal + noise))
        self.update_fft(fft)

    # ==============================

    @Slot(str)
    def on_line(self, line: str):
        self.log.appendPlainText(line)

    # ==============================

    @Slot(object)
    def on_status(self, st: DeviceStatus):
        now = time.time()
        self.last_frame_time = now

        if st.seq is not None:
            self.label_seq.setText(f"SEQ: {st.seq}")

        self._rate_window_count += 1
        dt = now - self._rate_window_start
        if dt >= 2.0:
            self._rate_hz = self._rate_window_count / dt
            self._rate_window_start = now
            self._rate_window_count = 0

        self.label_rate.setText(f"DATA RATE: {self._rate_hz:.1f} Hz")

        if st.model_on is True:
            self.label_model_state.setText(TEXT_MODEL_RUNNING)
            self.label_model_state.setStyleSheet(
                "font-size: 14px; font-weight: 700; color: white; background-color: green; padding: 6px;"
            )

            self.label_model.setText(TEXT_MODEL_ON)
            self.label_model.setStyleSheet(
                "font-size: 22px; font-weight: 800; color: white; background-color: green; padding: 10px;"
            )

        elif st.model_on is False:
            self.label_model_state.setText(TEXT_MODEL_STOPPED)
            self.label_model_state.setStyleSheet(
                "font-size: 14px; font-weight: 700; color: white; background-color: dimgray; padding: 6px;"
            )

            self.label_model.setText(TEXT_MODEL_OFF)
            self.label_model.setStyleSheet(
                "font-size: 22px; font-weight: 800; color: white; background-color: dimgray; padding: 10px;"
            )

        if st.bearing_fault is True:
            self.label_bearing.setText(TEXT_BEARING_DAMAGED)
            self.label_bearing.setStyleSheet(
                "font-size: 28px; font-weight: 900; color: white; background-color: red; padding: 14px;"
            )

        elif st.bearing_fault is False:
            self.label_bearing.setText(TEXT_BEARING_OK)
            self.label_bearing.setStyleSheet(
                "font-size: 28px; font-weight: 900; color: white; background-color: green; padding: 14px;"
            )

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
    w = MainWindow()
    w.resize(950, 520)
    w.show()
    sys.exit(app.exec())


if __name__ == "__main__":
    main()