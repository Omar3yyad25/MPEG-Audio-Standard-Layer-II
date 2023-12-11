load("maxi.mat")
load("mini.mat")
load("quatized.mat")
load("subband_bits.mat")
load("coeff.mat")

filename = 'listen-to-the-ancient-egyptions-tv.wav';
[y,Fs] = audioread(filename); 

restored_signal = zeros(240000, 32);
upsampled_subband = zeros(240000, 1);
fb = zeros (32,513);
dequatized_signal = zeros(7500, 32);

for i= 0:1:31
    for j= 0:1:512
        fb(i+1,j+1)= 32* coeff(j+1) * cos((i+0.5)*(j+16)*pi/32);
    end
end

fb = fb';

for j = 1 : 12 : 7500
    for i = 1 : 32
        [dequatized_signal(j:j+11, i)]=DeQuan(maxi((j-1)/12+1,i), mini((j-1)/12+1,i), subband_bits(i), quatized(j:j+11,i));
    end
end

for i= 1:32
    upsampled_subband= upsample(dequatized_signal(:, i), 32);
    restored_signal(:,i) = filter(fb(:,i), 1, upsampled_subband);
end

reconstructed = sum(restored_signal, 2);
reconstructed = reconstructed';

plot([1:240000],reconstructed, [1:240000], y);
title("Comparession between the original and reconstructed signals")
audiowrite("reconstructed.wav",reconstructed,Fs);


plot(abs(fftshift(fft(reconstructed))));

inputSignalSize = numel(y)*16;
encodedSignalSize = 0;

for i =1:32
    encodedSignalSize = encodedSignalSize + numel(quatized(:,i)*subband_bits(i));
end

compression_ratio = inputSignalSize / encodedSignalSize;