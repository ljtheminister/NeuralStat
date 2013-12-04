function fft_mat= fftLFP(rawLFP, len, overlap)
%% This function uses a hanning window multiplier and then performs a FFT 
% rawLFP - raw LFP data, should be a double
% length - the number of elements in the raw LFP per window (256 ms windows in the paper)
% overlap - the nubmer of elements to overlap per LFP window (156 ms of overlap in the paper)
hannMultiplier = hann(len, 'periodic');
lfp_length = length(rawLFP);
start_idx = 1;
jump = len-overlap;
numCol = 0;
while (lfp_length - start_idx > len)
    numCol = numCol + 1;
    start_idx = start_idx + jump;
end
%make data matrix
fft_mat = zeros(len, numCol);
start_idx = 1;
col_idx = 1;
while (lfp_length - start_idx > len)
   fft_mat(:, col_idx) = fft(hannMultiplier.*rawLFP(start_idx: (start_idx + len -1 )), len)/len;
   col_idx = col_idx + 1;
   start_idx = start_idx + jump;
end
end

