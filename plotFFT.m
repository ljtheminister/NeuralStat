function plotFFT(fftCol, len, Fs)
% Fs / 2 = Nyquist Frequency
NFFT = 2^nextpow2(len); % Next power of 2 from length of y
f = Fs/2*linspace(0,1,NFFT/2+1);

% Plot single-sided amplitude spectrum.
plot(f,2*abs(fftCol(1:NFFT/2+1))) 
title('Single-Sided Amplitude Spectrum of y(t)')
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')
figure;
hist(2*abs(fftCol(1:NFFT/2+1)), 1000)
