load('Signal_Spectrum.mat');
[x, y] = size(Signal_Spectrum);

Signal_Spectrum = Signal_Spectrum(:,513:end);
Fs = 24000;

F = linspace(-Fs/2, Fs/2, 1024);
F = F(:, 513:end);

SPL = [];
N = 1024;
for n = 1:N/2
    SPL_subband = 96 + 10*log10((4/(N^2))*abs(Signal_Spectrum(:, n)).^2*(8/3));
    SPL = [SPL SPL_subband];
end

% plot (F, SPL);
% title("Spectral view of input signal");
% xlabel("Frequency (Hz)")
% ylabel("SPL (dB)");


% % quit A
A = [];
for i = 1:N/2
   A_subband= (3.64*(F(:, i)/1000).^(-0.8))-(6.5 *exp((-0.6)*(F(:, i)/1000 -3.3).^2))+(10^(-3)*(F(:, i)/1000).^4);
   A = [A A_subband];
end

SPL(A > SPL) = 0;

% divide into 32 sub frame 
% get global max and min using findpeaks 
maxs = [];
reshaped_SPL = [];
for i = 1:16:512
    [value, index] = findpeaks(SPL(:,i:i+15));
    local = [value ; index+i-1];
    maxs = [maxs local];
    reshaped_SPL = [reshaped_SPL ; SPL(:,i:i+15)];
end

[maxLength, maxSize] = size(maxs);

masked_ranges = [];
spl_values = [];
thresholds = [];
for i= 1:maxSize
    mask_range = masking_threshold(maxs(1,i), F(maxs(2,i)));
    spl_value = (3.64*(mask_range/1000).^(-0.8))-(6.5 *exp((-0.6)*(mask_range/1000 -3.3).^2))+(10^(-3)*(mask_range/1000).^4);
    masked_ranges = [masked_ranges mask_range];
    spl_values = [spl_values spl_value];
    line = polyfit([mask_range,maxs(1,i)],[spl_value,F(maxs(2,i))] ,1);
    line = line *1.5;
    %plot(polyval(line, 0:15));
    thresholds = [thresholds; polyval(line, 0:15)];
    subband = (fix(maxs(2,i)/16) +1);
    for j = rem(maxs(2,i),16)+1:16
        x = polyval(line, 0:15);
        if x(:, j) > reshaped_SPL(subband, j)
            reshaped_SPL(subband, j) = 0;
        end
    end
end

reshaped_SPL = reshape(reshaped_SPL.', 1,[]);

plot(F, reshaped_SPL);
title("Spectral after psychoacoustic model")
xlabel("Freq (Hz)");
ylabel("SPL (dB)")

save('reshaped_SPL.mat', 'reshaped_SPL');
