function [power] = FFT_magnitude(fftCol, len_window)
%%%discretizes/histogram of FFT magnitudes
% fftCol: column of the FFT matrix, one 256 overlapped Hanning Window
% representing a 100 ms firing rate with 156 ms overlap

% len_window: window lengths

NFFT = 2^nextpow2(len_window); % Next power of 2 from length of y
power = 2*abs(fftCol(1:NFFT/2+1));

end

