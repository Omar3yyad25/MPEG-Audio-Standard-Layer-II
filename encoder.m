load('filtered_signal.mat');

fs = 24000; 

[numSamples, numSubbands] = size(filtered_signal);

spl_values = zeros(numSamples, numSubbands);

fft_result = [];
for subband = 1:numSubbands
    subband_signal = filtered_signal(:, subband);
    fft_result = [fft_result fft(subband_signal,1024)];
end

% Lk should be 512x32
SPL = [];
% convert fft to dB 
for n = 1:32
    SPL_subband = 96 + 10*log10((4/(n^2))*abs(fft_result(513:end, n)).^2*(8/3));
    SPL = [SPL SPL_subband];
end

% Lk from psyhcho 1 vector 512 element 
% multiply element wise, result 512x32
% sum each column, so result 1x32 
% send to bit_allocation , number of bits 
% send to quantizer number of bits and 12 sample from each 32 column then take the next 12 sample 

