function [output_img, info_count] = svd_compress(img, threshold)
%SVD_COMPRESS Summary of this function goes here
%   Detailed explanation goes here
img = double(img);

j = round((threshold/100)*size(img,1));

[U, S, V] = svd(img, 'vector');
compressed_U = U(:,1:j);
compressed_S = S(1:j);
compressed_V = V(:,1:j);

output_img = uint8(compressed_U * diag(compressed_S) * compressed_V');
info_count = (numel(compressed_U) + numel(compressed_S) + numel(compressed_V))/(numel(U)+numel(S)+numel(V));
end