function [output_img, nonzero_count] = dct_compress(img, Q)
%DCT_COMPRESS Performs DCT-based image compression upon an input matrix.
%   Detailed explanation goes here

    I = img - 128;
    T = dctmtx(8);
    dct = @(block) T * block.data * T';
    B = blockproc(I, [8,8], dct);

    % Q_base = [16 11 10 16 24 40 51 61;
    %           12 12 14 19 26 58 60 55;
    %           14 13 16 24 40 57 69 56;
    %           14 17 22 29 51 87 80 62;
    %           18 22 37 56 68 109 103 77;
    %           24 35 55 64 81 104 113 92;
    %           49 64 78 87 103 121 120 101;
    %           72 92 95 98 112 100 103 99];
    % 
    % if Q < 50
    %     S = 5000/Q;
    % else
    %     S = 200 - 2*Q;
    % end

    % Q_matrix = floor((S*Q_base + 50) / 100);
    % Q_matrix(Q_matrix == 0) = 1;  % Avoid divide by zero

    % quantize = @(block) round(block.data ./ Q_matrix);
    % B2 = blockproc(B,[8 8], quantize);
    % B2 = int16(B2);

    Q_matrix = [ 1  2  5  9 14 20 27 35;
                 3  4  7 12 18 25 33 42;
                 6  8 11 16 23 31 40 48;
                10 13 17 22 29 39 46 53;
                15 19 24 30 37 44 51 57;
                21 26 32 38 45 50 55 60;
                28 34 41 47 52 56 59 62;
                36 43 49 54 58 61 63 64];

    Q_matrix = Q_matrix <= (Q/100)*64;
    B2 = B;

    invdct = @(block_struct) T' * (Q_matrix .* block_struct.data) * T;
    I2 = blockproc(double(B2),[8 8],invdct);
    I2 = uint8(I2 + 128);

output_img = I2;
nonzero_count = sum(Q_matrix(:))/64;
end