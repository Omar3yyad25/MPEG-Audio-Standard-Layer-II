%reading the audio file 
filename = 'listen-to-the-ancient-egyptions-tv.wav';
[y,Fs] = audioread(filename);  

%figure;
%plot(y);

%reading the coeffiencents from the txt file

file = fopen('filters.txt', 'r');
lines = cell(0, 1);

while ~feof(file)
    line = fgetl(file);
    lines = [lines; {line}];
end
lines = lines';
fclose(file);

flipped_lines = flip(lines);

coeff= [lines, flipped_lines(2:end)];
coeff= str2double(coeff);

%initalize filter bank 
fb = zeros(32,512);

for i= 0:1:31
    for j= 0:1:511
        fb(i+1,j+1)= coeff(j+1) * cos((i+0.5)*(j-16)*pi/32);
    end
end

%downsample 
filter_bank = zeros(32, size(y, 1) / 32);

filtered_signal = [];
for i = 0:1:31
    % Filter the signal using the current filter
    filtered_seg = filter(fb(i+1,:), 1, y);
    downsampled_signal = downsample(filtered_seg, 32);
    filtered_signal = [filtered_signal downsampled_signal];
end

save('filtered_signal.mat', 'filtered_signal');