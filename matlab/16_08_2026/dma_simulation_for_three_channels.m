% --- 1. Parametry podstawowe ---
N_fft = 4096;         % Długość jednego okna FFT na kanał
liczba_ramek = 5;     % Ile ramek chcemy przepuścić przez układ
L_kanal = N_fft * liczba_ramek; % Całkowita liczba próbek dla jednej osi

% --- 2. Generowanie ciągłego sygnału (cykliczne bicie + rezonans) ---
czyste_bicie = zeros(L_kanal, 1);
tlumienie = 0.02;    
czestotliwosc = 0.3; 

% Generujemy miejsca uderzeń (np. co 1500 próbek na całej długości sygnału)
odstep_uderzen = 1500;
indeksy_uderzen = 200 : odstep_uderzen : (L_kanal - 500);

% Pętla nakładająca gasnące sinusoidy w miejscach uderzeń
for k = 1:length(indeksy_uderzen)
    idx = indeksy_uderzen(k);
    zakres = idx:L_kanal; % Od uderzenia do końca sygnału
    
    % Wektor czasu lokalnego dla pojedynczego uderzenia
    czas_lokalny = (0:(length(zakres)-1))'; 
    
    % Dodajemy uderzenie do głównego sygnału
    czyste_bicie(zakres) = czyste_bicie(zakres) + 900 * exp(-tlumienie*czas_lokalny) .* sin(czestotliwosc*czas_lokalny);
end

% --- 3. Dodawanie niezależnego szumu do każdego z 3 kanałów ---
accel_x = int16(czyste_bicie + 50 * randn(L_kanal, 1));
accel_y = int16(czyste_bicie + 50 * randn(L_kanal, 1));
accel_z = int16(czyste_bicie + 50 * randn(L_kanal, 1));

% --- 4. Multipleksowanie sygnałów w jedną szynę TDM ---
total_len = 3 * L_kanal; % Całkowita długość strumienia po złączeniu (61 440 próbek)
tdata_16bit = zeros(total_len, 1, 'int16');

tdata_16bit(1:3:end) = accel_x; 
tdata_16bit(2:3:end) = accel_y; 
tdata_16bit(3:3:end) = accel_z; 

% --- 5. Sygnały sterujące (TVALID i TLAST) ---
tvalid = ones(total_len, 1, 'logical');

tlast = zeros(total_len, 1, 'logical');
% TLAST musi wystąpić na końcu KROTKOTRWAŁEJ RAMKI FFT, a nie tylko na końcu symulacji!
% 1 ramka TDM to 4096 * 3 = 12288 próbek. Co tyle próbek dajemy impuls wysokiego stanu.
tlast(12288:12288:end) = 1; 

% --- 6. Przygotowanie wektorów dla Simulinka ---
% Zegar symulacji (FPGA clock) to 100 MHz, czyli okres = 10 ns
t_sim = (0:total_len-1)' * 10e-9;

tdata_sim = timeseries(tdata_16bit, t_sim);
tvalid_sim = timeseries(tvalid, t_sim);
tlast_sim = timeseries(tlast, t_sim);