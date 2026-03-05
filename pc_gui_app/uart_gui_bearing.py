import sys
import time
import re
from dataclasses import dataclass
from typing import Optional

import serial
from serial.tools import list_ports

from PySide6.QtCore import Qt, QThread, Signal, Slot, QTimer
from PySide6.QtWidgets import (
    QApplication, QWidget, QLabel, QPushButton, QComboBox,
    QVBoxLayout, QHBoxLayout, QPlainTextEdit, QSpinBox, QMessageBox
)


@dataclass
class DeviceStatus:
    model_on: Optional[bool] = None
    bearing_fault: Optional[bool] = None
    seq: Optional[int] = None
    raw_line: str = ""
    timestamp: float = 0.0


def parse_status_line(line: str) -> Optional[DeviceStatus]:
    """
    Akceptuje linie typu:
      - "SEQ=1 MODEL=ON BEARING=OK"
      - "SEQ=2 MODEL=OFF BEARING=FAULT"
      - "SEQ=3 MODEL=1 BEARING=0"
    """
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
        elif val in ("FAULT", "BAD", "DAMAGED", "1"):
            st.bearing_fault = True

    return st


class SerialReader(QThread):
    status_received = Signal(object)  # DeviceStatus
    line_received = Signal(str)
    error = Signal(str)

    def __init__(self, port: str, baudrate: int = 115200, parent=None):
        super().__init__(parent)
        self.port = port
        self.baudrate = baudrate
        self._stop = False
        self._ser: Optional[serial.Serial] = None

    def stop(self):
        self._stop = True

    def run(self):
        try:
            self._ser = serial.Serial(self.port, self.baudrate, timeout=0.5)
        except Exception as e:
            self.error.emit(f"Nie mogę otworzyć portu {self.port}: {e}")
            return

        while not self._stop:
            try:
                raw = self._ser.readline()
                if not raw:
                    continue
                line = raw.decode(errors="replace").strip()
                if not line:
                    continue

                self.line_received.emit(line)

                st = parse_status_line(line)
                if st is not None:
                    self.status_received.emit(st)

            except Exception as e:
                self.error.emit(f"Błąd czytania UART: {e}")
                break

        try:
            if self._ser and self._ser.is_open:
                self._ser.close()
        except Exception:
            pass


class MainWindow(QWidget):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("Monitor łożyska (UART)")

        # --- Controls (top row)
        self.port_combo = QComboBox()
        self.port_combo.setEditable(True)
        self.port_combo.setInsertPolicy(QComboBox.NoInsert)
        self.refresh_btn = QPushButton("Odśwież porty")

        self.baud_spin = QSpinBox()
        self.baud_spin.setRange(1200, 2000000)
        self.baud_spin.setValue(115200)

        self.btn_connect = QPushButton("Połącz")
        self.btn_disconnect = QPushButton("Rozłącz")
        self.btn_disconnect.setEnabled(False)

        # --- Status labels
        self.label_conn = QLabel("Połączenie: rozłączone")
        self.label_conn.setAlignment(Qt.AlignCenter)
        self.label_conn.setStyleSheet("font-size: 14px;")

        # System status row
        self.label_uart = QLabel("UART: DISCONNECTED")
        self.label_uart.setAlignment(Qt.AlignCenter)
        self.label_uart.setStyleSheet(
            "font-size: 14px; font-weight: 700; color: white; background-color: dimgray; padding: 6px;"
        )

        self.label_model_state = QLabel("MODEL: STOPPED")
        self.label_model_state.setAlignment(Qt.AlignCenter)
        self.label_model_state.setStyleSheet(
            "font-size: 14px; font-weight: 700; color: white; background-color: dimgray; padding: 6px;"
        )

        # Compact metrics row (SEQ / rate / last)
        self.label_seq = QLabel("SEQ: -")
        self.label_seq.setAlignment(Qt.AlignCenter)
        self.label_seq.setStyleSheet("font-size: 14px;")

        self.label_rate = QLabel("DATA RATE: - Hz")
        self.label_rate.setAlignment(Qt.AlignCenter)
        self.label_rate.setStyleSheet("font-size: 14px;")

        self.label_last = QLabel("LAST FRAME: - s ago")
        self.label_last.setAlignment(Qt.AlignCenter)
        self.label_last.setStyleSheet("font-size: 14px;")

        # Big panels
        self.label_model = QLabel("MODEL: ?")
        self.label_model.setAlignment(Qt.AlignCenter)
        self.label_model.setStyleSheet(
            "font-size: 22px; font-weight: 800; color: white; background-color: gray; padding: 10px;"
        )

        self.label_bearing = QLabel("ŁOŻYSKO: ?")
        self.label_bearing.setAlignment(Qt.AlignCenter)
        self.label_bearing.setStyleSheet(
            "font-size: 28px; font-weight: 900; color: white; background-color: gray; padding: 14px;"
        )

        # UART log (smaller)
        self.log = QPlainTextEdit()
        self.log.setReadOnly(True)
        self.log.setMaximumBlockCount(500)
        self.log.setFixedHeight(160)

        # --- Layout
        top = QHBoxLayout()
        top.addWidget(QLabel("Port:"))
        top.addWidget(self.port_combo, 2)
        top.addWidget(self.refresh_btn)
        top.addWidget(QLabel("Baud:"))
        top.addWidget(self.baud_spin)
        top.addWidget(self.btn_connect)
        top.addWidget(self.btn_disconnect)

        system_row = QHBoxLayout()
        system_row.addWidget(self.label_uart)
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
        layout.addWidget(QLabel("Log UART:"))
        layout.addWidget(self.log)
        self.setLayout(layout)

        # --- Runtime state
        self.reader: Optional[SerialReader] = None
        self.last_frame_time = time.time()

        self._rate_window_start = time.time()
        self._rate_window_count = 0
        self._rate_hz = 0.0

        # --- Signals
        self.refresh_btn.clicked.connect(self.refresh_ports)
        self.btn_connect.clicked.connect(self.connect_serial)
        self.btn_disconnect.clicked.connect(self.disconnect_serial)

        # --- Init
        self.refresh_ports()

        self.watchdog_timer = QTimer()
        self.watchdog_timer.timeout.connect(self.check_data_timeout)
        self.watchdog_timer.start(500)

    def refresh_ports(self):
        self.port_combo.clear()
        ports = list(list_ports.comports())
        auto_port = None

        for p in ports:
            self.port_combo.addItem(p.device)

            if "ttyUSB" in p.device or "ttyACM" in p.device:
                auto_port = p.device

        if auto_port:
            self.port_combo.setCurrentText(auto_port)

        if not ports:
            self.port_combo.addItem("Brak portów")

    @Slot()
    def connect_serial(self):
        port = (self.port_combo.currentText() or "").strip()
        if not port or port == "Brak portów":
            QMessageBox.warning(self, "Brak portu", "Nie wybrano poprawnego portu.")
            return

        baud = int(self.baud_spin.value())

        self.reader = SerialReader(port, baud)
        self.reader.line_received.connect(self.on_line)
        self.reader.status_received.connect(self.on_status)
        self.reader.error.connect(self.on_error)
        self.reader.start()

        self.label_conn.setText(f"Połączenie: {port} @ {baud}")

        self.label_uart.setText("UART: CONNECTED")
        self.label_uart.setStyleSheet(
            "font-size: 14px; font-weight: 700; color: white; background-color: green; padding: 6px;"
        )

        self.btn_connect.setEnabled(False)
        self.btn_disconnect.setEnabled(True)
        self.refresh_btn.setEnabled(False)
        self.port_combo.setEnabled(False)
        self.baud_spin.setEnabled(False)

    @Slot()
    def disconnect_serial(self):
        if self.reader:
            self.reader.stop()
            self.reader.wait(1500)
            self.reader = None

        self.label_conn.setText("Połączenie: rozłączone")

        self.label_uart.setText("UART: DISCONNECTED")
        self.label_uart.setStyleSheet(
            "font-size: 14px; font-weight: 700; color: white; background-color: dimgray; padding: 6px;"
        )

        self.label_model_state.setText("MODEL: STOPPED")
        self.label_model_state.setStyleSheet(
            "font-size: 14px; font-weight: 700; color: white; background-color: dimgray; padding: 6px;"
        )

        self.btn_connect.setEnabled(True)
        self.btn_disconnect.setEnabled(False)
        self.refresh_btn.setEnabled(True)
        self.port_combo.setEnabled(True)
        self.baud_spin.setEnabled(True)

    def check_data_timeout(self):
        age = time.time() - self.last_frame_time
        self.label_last.setText(f"LAST FRAME: {age:.2f} s ago")

        if age > 2:
            self.label_bearing.setText("⚠ BRAK DANYCH")
            self.label_bearing.setStyleSheet(
                "font-size: 28px; font-weight: 900; color: white; background-color: orange; padding: 14px;"
            )

    @Slot(str)
    def on_line(self, line: str):
        self.log.appendPlainText(line)

    @Slot(object)
    def on_status(self, st: DeviceStatus):
        now = time.time()
        self.last_frame_time = now

        # SEQ
        if st.seq is not None:
            self.label_seq.setText(f"SEQ: {st.seq}")

        # Data rate (średnia z okna 2 sekund)
        self._rate_window_count += 1
        dt = now - self._rate_window_start
        if dt >= 2.0:
            self._rate_hz = self._rate_window_count / dt
            self._rate_window_start = now
            self._rate_window_count = 0
        self.label_rate.setText(f"DATA RATE: {self._rate_hz:.1f} Hz")

        # MODEL panels + system state
        if st.model_on is True:
            self.label_model_state.setText("MODEL: RUNNING")
            self.label_model_state.setStyleSheet(
                "font-size: 14px; font-weight: 700; color: white; background-color: green; padding: 6px;"
            )

            self.label_model.setText("MODEL: ON")
            self.label_model.setStyleSheet(
                "font-size: 22px; font-weight: 800; color: white; background-color: green; padding: 10px;"
            )

        elif st.model_on is False:
            self.label_model_state.setText("MODEL: STOPPED")
            self.label_model_state.setStyleSheet(
                "font-size: 14px; font-weight: 700; color: white; background-color: dimgray; padding: 6px;"
            )

            self.label_model.setText("MODEL: OFF")
            self.label_model.setStyleSheet(
                "font-size: 22px; font-weight: 800; color: white; background-color: dimgray; padding: 10px;"
            )

        # Bearing panel
        if st.bearing_fault is True:
            self.label_bearing.setText("ŁOŻYSKO: USZKODZONE")
            self.label_bearing.setStyleSheet(
                "font-size: 28px; font-weight: 900; color: white; background-color: red; padding: 14px;"
            )

        elif st.bearing_fault is False:
            self.label_bearing.setText("ŁOŻYSKO: OK")
            self.label_bearing.setStyleSheet(
                "font-size: 28px; font-weight: 900; color: white; background-color: green; padding: 14px;"
            )

    @Slot(str)
    def on_error(self, msg: str):
        QMessageBox.critical(self, "Błąd", msg)
        self.disconnect_serial()

    def closeEvent(self, event):
        self.disconnect_serial()
        event.accept()


def main():
    app = QApplication(sys.argv)
    w = MainWindow()
    w.resize(900, 650)
    w.show()
    sys.exit(app.exec())


if __name__ == "__main__":
    main()