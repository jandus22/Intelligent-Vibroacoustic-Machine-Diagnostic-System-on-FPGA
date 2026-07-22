% --- Parametry systemu ---
Fs_sensor = 26667;      % Częstotliwość próbkowania czujnika (Hz)
T_fpga = 10e-9;         % Zegar sprzętowy FPGA (100 MHz -> 10 ns)

% --- Symulacja uszkodzenia łożyska w osi X ---
t_sensor = (0:2000)' / Fs_sensor; % Wektor czasu (ok. 75 ms nagrania)
f_impact = 50;          % Częstotliwość uderzeń kulki (Hz)
f_res = 5000;           % Częstotliwość rezonansowa oprawy (Hz)
damping = 800;          % Współczynnik tłumienia drgań

% 1. Generowanie uderzeń (impulsy co 1/50 sekundy)
impacts = zeros(size(t_sensor));
impacts(mod(t_sensor, 1/f_impact) < 1/Fs_sensor) = 1;

% 2. Odpowiedź impulsowa mechaniki (zanikająca sinusoida)
impulse_response = exp(-damping * t_sensor) .* sin(2 * pi * f_res * t_sensor);

% 3. Splot (Convolution) - właściwy sygnał rezonansowy uszkodzenia
accel_x_double = conv(impacts, impulse_response, 'same') * 1000;

% Dodajemy zwykły szum tła dla osi Y i Z
accel_y_double = randn(size(t_sensor)) * 50; 
accel_z_double = randn(size(t_sensor)) * 50; 

% Konwersja do 16-bitowych liczb całkowitych ze znakiem (format z IIS3DWB)
accel_x = int16(accel_x_double);
accel_y = int16(accel_y_double);
accel_z = int16(accel_z_double);

% --- Formatowanie TDM (Time-Division Multiplexing) ---
% Tworzymy jedną długą kolejkę: X0, Y0, Z0, X1, Y1, Z1...
num_samples = length(accel_x);
tdata_16bit = zeros(3 * num_samples, 1, 'int16');
tdata_16bit(1:3:end) = accel_x; % Kanał 0
tdata_16bit(2:3:end) = accel_y; % Kanał 1
tdata_16bit(3:3:end) = accel_z; % Kanał 2

% --- Generowanie sygnałów kontrolnych AXI4-Stream ---
total_len = length(tdata_16bit);

% TVALID: Zawsze 1, udajemy, że DMA podaje dane bez przerw (jeden ciągły burst)
tvalid = ones(total_len, 1, 'logical');

% TLAST: Impuls oznaczający koniec paczki 3 próbek (stan wysoki na próbkach Z)
tlast = zeros(total_len, 1, 'logical');
tlast(3:3:end) = 1;

% --- Przygotowanie obiektów dla Simulinka ---
% Ustalamy krok czasu na 10 ns, bo dane wychodzą z DMA na zegarze 100 MHz
time_vector = (0:total_len-1)' * T_fpga; 

sim_tdata  = timeseries(tdata_16bit, time_vector);
sim_tvalid = timeseries(tvalid, time_vector);
sim_tlast  = timeseries(tlast, time_vector);