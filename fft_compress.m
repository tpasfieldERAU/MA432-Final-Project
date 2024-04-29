function [output_img, nonzero_count] = fft_compress(img,threshold)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    img = double(img);
    freq = fftshift(fft2(img));
    fabs = abs(freq);
    fLog = log(fabs);


    count = (threshold/100) * numel(fLog);
    [~, indices] = maxk(fLog(:), round(count));
    plc = zeros(numel(fLog),1);
    plc(indices) = 1;
    plc = reshape(plc,size(fLog));

    %filter = (fLog > ((100-threshold)/100)*max(fLog(:)));
    %output_img = abs(ifft2(freq.*filter));
    
    output_img = uint8(abs(ifft2(freq.*plc)));
    nonzero_count = threshold/100;
end