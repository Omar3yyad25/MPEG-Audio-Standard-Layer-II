load('filtered_signal.mat');
load('reshaped_SPL.mat')
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

reshaped_SPL = reshaped_SPL';
% 
% % Lk from psyhcho 1 vector 512 element 
% multiply element wise, result 512x32
x = [];
for i = 1:32
   x_value= reshaped_SPL.*SPL(:,i);
   x = [x x_value];
end
% 
% sum each column, so result 1x32 
sum_spl = sum(x,1);
% send to bit_allocation , number of bits 
subband_bits = zeros(1,32);
count = 0;
BPS_signal= 16;
if BPS_signal<=16
    BPS = BPS_signal;
else
    BPS = 16;
end

b = BPS;

for i=1:1:32
    [smax,index] = max(sum_spl);
    index;

    if count < 4
        b = BPS;
    elseif count<8
        if BPS - 10 >= 2 
            b = BPS - 10;
        else
            b = 2;
        end
    elseif count<12
        if BPS - 14 >= 2
            b = BPS - 14;
        else
            b = 2;
        end
    elseif count<16
        if BPS - 14 >= 2
            b = BPS - 14;
        else
            b = 2;
        end
    elseif count<20
       if BPS - 14 >= 2
            b = BPS - 14;
        else
            b = 2;
       end
    elseif count<24
        if BPS - 15 >= 1
            b = BPS - 15;
        else
            b = 2;
        end
    elseif count<28
        if BPS - 15 >= 1
            b = BPS - 15;
        else
            b = 1;
        end
    else
        if BPS - 15 >= 1
            b = BPS - 15;
        else
            b = 1;
        end
    end
    subband_bits(index) = b;
    count = count + 1;
    sum_spl(index) = -inf;
end

% send to quantizer number of bits and 12 sample from each 32 column then take the next 12 sample

quatized = zeros(7500,32);
maxi=zeros(625,32);
mini=zeros(625,32);
for j = 1 : 12 : 7500
    for i = 1 : 32
        [maxi((j-1)/12+1,i), mini((j-1)/12+1,i), quatized(j:j+11,i)]=Quan(filtered_signal(j:j+11,i), subband_bits(i));
    end
end

save('maxi.mat', 'maxi');
save('mini.mat', 'mini');
save('quatized.mat', 'quatized')
save('subband_bits.mat', "subband_bits")







