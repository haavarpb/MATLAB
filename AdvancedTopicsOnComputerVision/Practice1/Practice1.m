clc
clear all
close all

cd Pictures
I = im2double(imread('lena.gif'));
cd ..

figure; imshow(I)
title('Original picture');
sz = size(I);
PQ = paddedsize(sz);

F = fft2(I ,PQ(1), PQ(2));
S = fftshift(F);
figure; imshow(log(abs(S) + 1), [])
title('Fourier transform shifted log(abs(S)) + 1')

%H = gaussianFilter(10, 10, PQ(2), PQ(1), 0);
sig = 10;
H = 1 - Gaussian(PQ(1), PQ(2), sig);
figure; surf(H)
title('2D gaussian filter')

G = H.*S;
figure; imshow(log(abs(G)) + 1, [])
title('Filtered image log(abs(G)) + 1 (in freq plane)')

O = abs(ifft2(G));
figure; imshow(O, [])

I_filtered = O(1:sz(2), 1:sz(1));
figure; imshow(I_filtered, []);

function f = Gaussian(M, N, sig)
if(mod(M,2) == 0)
    cM = floor(M/2) + 0.5;
else
    cM = floor(M/2) + 1;
end;
if(mod(N,2) == 0)
    cN = floor(N/2) + 0.5;
else
    cN = floor(N/2) + 1;
end;
f = zeros(M,N);
for i = 1:M
    for j = 1:N
        dis = (i - cM)^2 + (j - cN)^2;
        f(i,j) = exp(-dis/2/sig^2);
    end;
end;
end