fs = 27000;   % Hz
N = length(out.complex);

Y = fft(out.complex);

P2 = abs(Y/N);                  % widmo dwustronne
P1 = P2(1:N/2+1);               % widmo jednostronne
P1(2:end-1) = 2*P1(2:end-1);

f = fs*(0:(N/2))/N;

plot(f, 20*log10(P1))
xlabel('Częstotliwość [Hz]')
ylabel('Amplituda [dB]')
grid on
xlim([0 fs/2])