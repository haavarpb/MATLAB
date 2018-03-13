clc
clear all
close all

cd Pictures
I = im2double(imread('moon.jpg'));
cd ..

figure; imshow(I)
title('Original picture');

PQ = paddedsize(size(I));

F = fft2(I ,PQ(1), PQ(2));
S = fftshift(F);
figure; imshow(log(abs(S) + 1), [])
title('Fourier transform shifted log(abs(S)) + 1')

H = gaussianFilter(100, 100, PQ(2), PQ(1), 0);
figure; surf(H)
title('2D gaussian filter')

G = H.*F;
figure; imshow(log(abs(G)) + 1, [])
title('Filtered image log(abs(G)) + 1 (in freq plane)')

O = real(ifft2(G));
figure; imshow(log(abs(O)) + 1, [])