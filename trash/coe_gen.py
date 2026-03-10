import numpy as np
import scipy.signal as signal
import matplotlib.pyplot as plt

# --- PARAMETRY ---
fs = 26670.0        # Czestotliwosc probkowania IIS3DWB (Hz)
f_low = 2000.0      # Dolna granica pasma (Hz)
f_high = 6000.0     # Gorna granica pasma (Hz)
numtaps = 127       # Liczba wspolczynnikow (musi byc nieparzysta dla Typu I)
bit_depth = 16      # Rozdzielczosc wspolczynnikow na FPGA

# 1. Projektowanie filtra (Metoda okien - Hamming)
# pass_zero=False oznacza, ze chcemy filtr pasmowy (wycina 0 Hz)
coeffs = signal.firwin(numtaps, [f_low, f_high], pass_zero=False, fs=fs, window='hamming')

# 2. Skalowanie do Fixed-Point (Signed 16-bit)
# Szukamy najwiekszej wartosci, aby maksymalnie wykorzystac zakres dynamiki
max_val = (2**(bit_depth-1)) - 1
coeffs_scaled = np.int16(coeffs / np.max(np.abs(coeffs)) * max_val)

# 3. Generowanie tresci pliku .coe
coe_header = "memory_initialization_radix = 10;\nmemory_initialization_vector =\n"
coe_body = ", ".join(map(str, coeffs_scaled)) + ";"

with open("filter_coeffs.coe", "w") as f:
    f.write(coe_header + coe_body)

print("Plik filter_coeffs.coe zostal wygenerowany!")

# --- WIZUALIZACJA ---
# Obliczanie odpowiedzi czestotliwosciowej
w, h = signal.freqz(coeffs)
x_hz = w * fs / (2 * np.pi)

plt.figure(figsize=(12, 8))

# Wykres 1: Odpowiedz impulsowa (Wspolczynniki)
plt.subplot(2, 1, 1)
plt.stem(coeffs_scaled)
plt.title(f"Wspolczynniki Filtra FIR (16-bit Integer)\nPasmo: {f_low}-{f_high} Hz, Fs={fs} Hz")
plt.grid(True)
plt.ylabel("Amplituda (Integer)")

# Wykres 2: Charakterystyka amplitudowa (Magnituda)
plt.subplot(2, 1, 2)
plt.plot(x_hz, 20 * np.log10(np.abs(h)))
plt.axvspan(f_low, f_high, color='green', alpha=0.3, label='Pasmo przepustowe')
plt.title("Charakterystyka Amplitudowa filtra")
plt.xlabel("Czestotliwosc [Hz]")
plt.ylabel("Amplituda [dB]")
plt.ylim([-80, 5])
plt.grid(True)
plt.legend()

plt.tight_layout()
plt.show()