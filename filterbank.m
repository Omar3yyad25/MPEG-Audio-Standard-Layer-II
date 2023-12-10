%reading the audio file 
filename = 'listen-to-the-ancient-egyptions-tv.wav';
[y,Fs] = audioread(filename);  

%figure;
%plot(y);

%reading the coeffiencents from the txt file

fileID = fopen('filters.txt', 'r');
lines = cell(0, 1);

while ~feof(fileID)
    line = fgetl(fileID);
    lines = [lines; {line}];
end
lines = lines';
fclose(fileID);

flipped_lines = flip(lines);

coeff= [lines, flipped_lines(2:end)];
coeff= str2double(coeff);

%initalize filter bank 
fb = zeros(32,512);

for i= 1:32
    for j= 1:512
        fb(i,j)= coeff(j) * cos((i+0.5)*(j-16)*pi/32);
    end
end

%downsample 
filter_bank = zeros(32, size(y, 1) / 32);

for i = 1:32
    % Filter the signal using the current filter
    filtered_signal = filter(coeff, 1, y);
    downsampled_signal = downsample(filtered_signal, 32);
    filter_bank(i, :) = downsampled_signal;
end