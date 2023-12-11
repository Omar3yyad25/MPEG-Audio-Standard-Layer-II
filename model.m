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

% % quit A
A = [];
for i = 1:N/2
   A_subband= (3.64*(F(:, i)/1000).^(-0.8))-(6.5 *exp((-0.6)*(F(:, i)/1000 -3.3).^2))+(10^(-3)*(F(:, i)/1000).^4);
   A = [A A_subband];
end

SPL(A > SPL) = 0;
plot(SPL);


% divide into 32 sub frame 
% get global max and min using findpeaks 
maxs = [];
for i = 1:16:512
    [value, index] = findpeaks(SPL(:,i:i+15));
    local = [value , index+i-1];
    maxs = [maxs local];
end

globalmax = max(maxs);


%84 masked range 