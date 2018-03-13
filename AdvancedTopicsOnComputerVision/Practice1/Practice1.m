clc
clear all
close all

%% Basic frequency domain filtering using the Discrete Fourier Transform

cd Pictures
f = im2double(imread('lena.gif'));
cd ..

figure; imshow(f)
title('Original picture');

sz = size(f);
PQ = paddedsize(sz);
F = fft2(f ,PQ(1), PQ(2));
S = fftshift(F); % Shift the spectrum origo to middle
figure; imshow(log(abs(S) + 1), [])
title('Fourier transform shifted (showing log(abs(S)) + 1)')

H = gaussianFilter(10, 10, PQ(2), PQ(1), 0);
H = 1 - H./max(max(H)); % Normalize the filter
figure; surf(H)
title('2D gaussian filter')

G = H.*S; % Apply filter
figure; imshow(log(abs(G)) + 1, [])
title('Filter applied (showing log(abs(G)) + 1)')

f = real(ifft2(G)); 
figure; imshow(f, [])
title('Filtered image with padding')

f_cropped = f(1:sz(2), 1:sz(1));
figure; imshow(f_cropped, []);
title('Filtered image')

%% Exercise 4.1
% We modified the spectrum by applying a filter similar to the gaussian
% function. It is evident that the output is different from the input.

%% Exercise 4.2 

f_no_inv_shift = real(G); 
figure; imshow(f_no_inv_shift, [])
title('Filtered image without inverse shift')

% It is evident that the inverse shift is important to do before the
% inverse transform.

%% Exercise 4.3

[U, V] = dftuv(9, 5);

% Find distances from every element to the origin (1,1)
N = max(size(U));

y_sq = repmat(diag(0:N)*(0:N)', 1, N);
x_sq = y_sq';

d_sq = x_sq + y_sq;

d_sq = d_sq(1:size(U,2), 1:size(U,1));

% Find distances from every element to the origin (N/2, M/2)

% TODO : Use d_sq and mirror it. Extraxt then the middle according to size

% x_mean = round(N/2);
% y_mean = round(M/2);
% x_sq_mid = repmat(diag(abs((0:N)-x_mean))*abs((0:N) - x_mean)', 1, max(M,N));
% y_sq_mid = repmat(diag(abs((0:M)-y_mean))*abs((0:M) - y_mean)', 1, max(M,N));
% 
% d_sq_mid = x_sq_mid + y_sq_mid;
% d_sq_mid = d_sq_mid(1:(M-1), 1:(N-1));
