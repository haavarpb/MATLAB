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

H = gaussianFilter(100, 100, PQ(2), PQ(1), 0);
H = H./max(max(H)); % Normalize the filter
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

y_sq = repmat(diag(1:N)*(1:N)', 1, N);
x_sq = y_sq';

d_sq = x_sq + y_sq;

d_sq = d_sq(1:size(U,2), 1:size(U,1));

% Find distances from every element to the origin (N/2, M/2)

N = size(U, 1);
M = size(U, 2);

lower_left = fliplr(d_sq);
upper_left = flipud(lower_left);
upper_right = fliplr(upper_left);
lower_right = d_sq;

d_non_cropped = [upper_left, upper_right;
                lower_left, lower_right];
sz = size(d_non_cropped);
% Now we extract the core

d_sq_mid = d_non_cropped((round(sz(1)/2) - round(M/2)):(round(sz(1)/2) + round(M/2)), ...
                         (round(sz(2)/2) - round(N/2)):(round(sz(2)/2) + round(N/2)));
                     
%% Exercise 4.4
% See lpfilter.m

H = lpfilter('gauss', size(S,1), size(S,2), 100);
figure; surf(fftshift(H));
filtered_s = fftshift(H).*S;
filtered = fftshift(filtered_s);
f_spatial = abs(ifft2(filtered));
figure; imshow(f_spatial, []);
figure; imshow(f_spatial(1:size(f_spatial,1)/2, 1:size(f_spatial,2)/2), [])

title('Filtered');

%% Exercise 4.5

cd 'Pictures'
moon = imread('moon.jpg');
cd ..

moon_fft = fft2(moon);

moon_dim = size(moon);

size_f = 100;

% Create all the filters
gauss_f = fftshift(lpfilter('gauss', moon_dim(1), moon_dim(2), size_f));
btw_f2 = fftshift(lpfilter('btw', moon_dim(1), moon_dim(2), size_f, 2));
btw_f4 = fftshift(lpfilter('btw', moon_dim(1), moon_dim(2), size_f, 4));
ideal_f = fftshift(lpfilter('ideal', moon_dim(1), moon_dim(2), size_f));

% Apply filter and inverse transform
moon_g = real(ifft2(moon_fft.*gauss_f));
moon_b2 = real(ifft2(moon_fft.*btw_f2));
moon_b4 = real(ifft2(moon_fft.*btw_f4));
moon_i = real(ifft2(moon_fft.*ideal_f));

% Plot gaussian

figure
subplot(1,3,1);
imshow(moon, []);
subplot(1,3,2);
imshow(moon_g, []);
title('Original, filtered and the gaussian filter');
subplot(1,3,3);
surf(gauss_f);
shading interp

% Plot btw 2

figure
subplot(1,3,1);
imshow(moon, []);
subplot(1,3,2);
imshow(moon_b2, []);
title('Original, filtered and the 2nd order Butterworth filter');
subplot(1,3,3);
surf(btw_f2);
shading interp

% Plot btw 4

figure
subplot(1,3,1);
imshow(moon, []);
subplot(1,3,2);
imshow(moon_b4, []);
title('Original, filtered and the 4th order Butterworth filter');
subplot(1,3,3);
surf(btw_f4);
shading interp

% Plot ideal

figure
subplot(1,3,1);
imshow(moon, []);
subplot(1,3,2);
imshow(moon_i, []);
title('Original, filtered and the ideal low pass filter');
subplot(1,3,3);
surf(ideal_f);
shading interp


%% Exercise 4.6
% See hpfilter 

size_f = 50;

% Create all the filters
gauss_f = fftshift(hpfilter('gauss', moon_dim(1), moon_dim(2), size_f));
btw_f2 = fftshift(hpfilter('btw', moon_dim(1), moon_dim(2), size_f, 2));
btw_f4 = fftshift(hpfilter('btw', moon_dim(1), moon_dim(2), size_f, 4));
ideal_f = fftshift(hpfilter('ideal', moon_dim(1), moon_dim(2), size_f));

% Apply filter and inverse transform
moon_g = real(ifft2(moon_fft.*gauss_f));
moon_b2 = real(ifft2(moon_fft.*btw_f2));
moon_b4 = real(ifft2(moon_fft.*btw_f4));
moon_i = real(ifft2(moon_fft.*ideal_f));

% Plot gaussian

figure
subplot(1,3,1);
imshow(moon, []);
subplot(1,3,2);
imshow(moon_g, []);
title('Original, filtered and the gaussian filter');
subplot(1,3,3);
surf(gauss_f);
shading interp

% Plot btw 2

figure
subplot(1,3,1);
imshow(moon, []);
subplot(1,3,2);
imshow(moon_b2, []);
title('Original, filtered and the 2nd order Butterworth filter');
subplot(1,3,3);
surf(btw_f2);
shading interp

% Plot btw 4

figure
subplot(1,3,1);
imshow(moon, []);
subplot(1,3,2);
imshow(moon_b4, []);
title('Original, filtered and the 4th order Butterworth filter');
subplot(1,3,3);
surf(btw_f4);
shading interp

% Plot ideal

figure
subplot(1,3,1);
imshow(moon, []);
subplot(1,3,2);
imshow(moon_i, []);
title('Original, filtered and the ideal high pass filter');
subplot(1,3,3);
surf(ideal_f);
shading interp

%% Exercise 4.7
a = 0.5;
b = 2.0;

filter_e = fftshift(hpfilterEmphasis('ideal', moon_dim(1), moon_dim(2), size_f, a, b));

moon_e = real(ifft2(moon_fft.*filter_e));

figure
subplot(1,3,1);
imshow(moon, []);
subplot(1,3,2);
imshow(moon_e, []);
title('Original, filtered and the ideal emphasis filter');
subplot(1,3,3);
surf(filter_e);
shading interp

%% Problem 1

cd 'C:\Users\Håvard\Documents\MATLAB\AdvancedTopicsOnComputerVision\Practice1\Pictures'
moon = imread('moon.jpg');
cd ..

moon_fft = fft2(moon);

moon_dim = size(moon);

close all;
A_max = 256/2;
A = A_max*0.3;
w = 1;
d = 0;
n = createSineNoise(moon_dim(1), moon_dim(2), A, w, d);

moon_N = moon + uint8(n);

% Show moon with added noise
figure; imshow(moon_N);

% Show noise
figure; imshow(uint8(n), []);

moon_NF = fft2(moon_N);
moon_NFS = abs(fftshift(moon_NF));

% Spectrum
figure; imshow(log(moon_NFS) + 1, []);
figure; surf(log(moon_NFS) + 1);
hold on

% Finding peaks
avg = mean(mean(moon_NFS));

moon_col = im2col(moon_NFS, [moon_dim(1) moon_dim(2)], 'distinct');
[pks loc] = findpeaks(moon_col, 'MinPeakDistance', 50, 'MinPeakHeight', 1/100*max(moon_col));
surf(log(1/100*max(moon_col)*ones(size(moon_NFS))) + 1);




