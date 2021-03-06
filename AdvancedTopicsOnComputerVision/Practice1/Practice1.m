clc
clear all
close all

%% Basic frequency domain filtering using the Discrete Fourier Transform

cd C:\Users\H�vard\Documents\MATLAB\AdvancedTopicsOnComputerVision\Practice1\Pictures
f = im2double(imread('lena.gif'));
cd ..

showImage(f, 'Original picture');

size_f = size(f);
PQ = paddedsize(size_f);
F = fft2(f ,PQ(1), PQ(2));
S = fftshift(F); % Shift the spectrum origo to middle

showSpectrum(S, 'Fourier transform shifted (showing log(abs(S) + 1)');

H = gaussianFilter(100, 100, PQ(2), PQ(1), 0);
H = H./max(max(H)); % Normalize the filter

showSurf(H, '2D Gaussian filter')

G = H.*S; % Apply filter

showSpectrum(G, '2D Gaussian filter applied');

f = real(ifft2(ifftshift(G))); 

showImage(f, 'Filtered image with padding');

showImage(f(1:size_f(1), 1:size_f(2)), 'Filtered image cropped');

%% Exercise 4.1
% We modified the spectrum by applying a filter similar to the gaussian
% function. It is evident that the output is different from the input.

%% Exercise 4.2 

f_no_inv_shift = real(ifft2(G));
showImage(f_no_inv_shift, 'No inverse shift applied');

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
showSurf(fftshift(H), 'Gaussian filter');
filtered_s = fftshift(H).*S;
filtered = fftshift(filtered_s);
f_spatial = real(ifft2(filtered));
showImage(f_spatial, 'High passed image');
showImage(f_spatial(1:sz(1), 1:sz(2)), 'High passed image cropped');

%% Exercise 4.5

cd C:\Users\H�vard\Documents\MATLAB\AdvancedTopicsOnComputerVision\Practice1\Pictures
moon = imread('moon.jpg');
cd ..

orgSize = size(moon);
PQ = paddedsize(orgSize);
moon_fft = fftshift(fft2(moon, PQ(1), PQ(2)));
moon_dim = PQ;

% Filter size (Depends on the type)
size_f = 100;

% Create all the filters
gauss_f = fftshift(lpfilter('gauss', moon_dim(1), moon_dim(2), size_f));
btw_f2 = fftshift(lpfilter('btw', moon_dim(1), moon_dim(2), size_f, 2));
btw_f4 = fftshift(lpfilter('btw', moon_dim(1), moon_dim(2), size_f, 4));
ideal_f = fftshift(lpfilter('ideal', moon_dim(1), moon_dim(2), size_f));

% Apply filter and inverse transform
moon_g = real(ifft2(ifftshift(moon_fft.*gauss_f)));
moon_b2 = real(ifft2(ifftshift(moon_fft.*btw_f2)));
moon_b4 = real(ifft2(ifftshift(moon_fft.*btw_f4)));
moon_i = real(ifft2(ifftshift(moon_fft.*ideal_f)));

% Plot gaussian

figure
subplot(1,3,1);
imshow(moon, []);
subplot(1,3,2);
imshow(moon_g(1:orgSize(1), 1:orgSize(2)), []);
title('Original, filtered and the gaussian filter');
subplot(1,3,3);
surf(gauss_f);
shading interp

% Plot btw 2

figure
subplot(1,3,1);
imshow(moon, []);
subplot(1,3,2);
imshow(moon_b2(1:orgSize(1), 1:orgSize(2)), []);
title('Original, filtered and the 2nd order Butterworth filter');
subplot(1,3,3);
surf(btw_f2);
shading interp

% Plot btw 4

figure
subplot(1,3,1);
imshow(moon, []);
subplot(1,3,2);
imshow(moon_b4(1:orgSize(1), 1:orgSize(2)), []);
title('Original, filtered and the 4th order Butterworth filter');
subplot(1,3,3);
surf(btw_f4);
shading interp

% Plot ideal

figure
subplot(1,3,1);
imshow(moon, []);
subplot(1,3,2);
imshow(moon_i(1:orgSize(1), 1:orgSize(2)), []);
title('Original, filtered and the ideal low pass filter');
subplot(1,3,3);
surf(ideal_f);
shading interp


%% Exercise 4.6
% See hpfilter 

orgSize = size(moon);
PQ = paddedsize(orgSize);
moon_fft = fftshift(fft2(moon, PQ(1), PQ(2)));
moon_dim = PQ;

size_f = 100;

% Create all the filters
gauss_f = fftshift(hpfilter('gauss', moon_dim(1), moon_dim(2), size_f));
btw_f2 = fftshift(hpfilter('btw', moon_dim(1), moon_dim(2), size_f, 2));
btw_f4 = fftshift(hpfilter('btw', moon_dim(1), moon_dim(2), size_f, 4));
ideal_f = fftshift(hpfilter('ideal', moon_dim(1), moon_dim(2), size_f));

% Apply filter and inverse transform
moon_g = real(ifft2(ifftshift(moon_fft.*gauss_f)));
moon_b2 = real(ifft2(ifftshift(moon_fft.*btw_f2)));
moon_b4 = real(ifft2(ifftshift(moon_fft.*btw_f4)));
moon_i = real(ifft2(ifftshift(moon_fft.*ideal_f)));

% Plot gaussian

figure
subplot(1,3,1);
imshow(moon, []);
subplot(1,3,2);
imshow(moon_g(1:orgSize(1), 1:orgSize(2)), []);
title('Original, filtered and the gaussian filter');
subplot(1,3,3);
surf(gauss_f);
shading interp

% Plot btw 2

figure
subplot(1,3,1);
imshow(moon, []);
subplot(1,3,2);
imshow(moon_b2(1:orgSize(1), 1:orgSize(2)), []);
title('Original, filtered and the 2nd order Butterworth filter');
subplot(1,3,3);
surf(btw_f2);
shading interp

% Plot btw 4

figure
subplot(1,3,1);
imshow(moon, []);
subplot(1,3,2);
imshow(moon_b4(1:orgSize(1), 1:orgSize(2)), []);
title('Original, filtered and the 4th order Butterworth filter');
subplot(1,3,3);
surf(btw_f4);
shading interp

% Plot ideal

figure
subplot(1,3,1);
imshow(moon, []);
subplot(1,3,2);
imshow(moon_i(1:orgSize(1), 1:orgSize(2)), []);
title('Original, filtered and the ideal high pass filter');
subplot(1,3,3);
surf(ideal_f);
shading interp

%% Exercise 4.7
a = 0.5;
b = 2.0;

filter_e = fftshift(hpfilterEmphasis('ideal', moon_dim(1), moon_dim(2), size_f, a, b));

moon_e = real(ifft2(ifftshift(moon_fft.*filter_e)));

figure
subplot(1,3,1);
imshow(moon, []);
subplot(1,3,2);
imshow(moon_e(1:orgSize(1), 1:orgSize(2)), []);
title('Original, filtered and the ideal emphasis filter');
subplot(1,3,3);
surf(filter_e);
shading interp

%% Problem 1

cd 'C:\Users\H�vard\Documents\MATLAB\AdvancedTopicsOnComputerVision\Practice1\Pictures'
moon = imread('moon.jpg');
cd ..

orgSize = size(moon);

close all;
A_max = 256/2;
A = A_max*0.5;
w = 0.5;
d = 0;
n = createSineNoise(orgSize(1), orgSize(2), A, w, d);

moon_N = moon + uint8(n);

% Show moon with added noise
showImage(moon_N, 'Moon with added noise');

% Show noise
showImage(uint8(n), 'Noise');

PQ = paddedsize(orgSize);
moon_NF = fft2(moon_N, PQ(1), PQ(2));
moon_NFS = fftshift(moon_NF);

% Spectrum
showSpectrum(moon_NFS, '');
showSurf(log(abs(moon_NFS) + 1), '');
hold on

% Finding peaks
avg = mean(mean(moon_NFS));

moon_col = im2col(abs(moon_NFS), [moon_dim(1) moon_dim(2)], 'distinct');
[pks, loc, widths, proms] = findpeaks(moon_col, 'MinPeakDistance', 20, 'MinPeakHeight', 1/100*max(moon_col));
surf(log(1/100*max(moon_col)*ones(size(moon_NFS)) + 1));
shading interp

% Remove peaks from low frequenzy areas which we want to keep. I.E. we
% assume noise to be high frequency

toBeKept = zeros(length(pks), 1);
center = moon_dim./2;
distance = 50;
for peak = 1:length(pks)
    [pY, pX] = ind2sub(moon_dim,loc(peak)); 
    location = [pY, pX];
    distanceFromCenterSquared = (location - center).^2;
    distCenterSqrt = sqrt(distanceFromCenterSquared);
    distCenter = distCenterSqrt(1) + distCenterSqrt(2);
    if  distCenter >= distance
        toBeKept(peak) = 1;
    end
end

indeces = find(toBeKept);
pks = pks(indeces); loc = loc(indeces); widths = widths(indeces); proms = proms(indeces);

[i, j] = ind2sub(size(moon_NFS), loc');
plot3(j, i, log(pks + 1), '.r', 'markersize', 10);

% Construct filter

radius = 5; % Tunable
ideal_filter = ones(moon_dim);
for peak = 1:length(pks)
    H = hpfilter('ideal', moon_dim(1), moon_dim(2), radius);
    [shiftY, shiftX] = ind2sub(moon_dim, loc(peak));
    H = circshift(H, [shiftY, shiftX]);
    ideal_filter = H.*ideal_filter;
end

showSurf(ideal_filter, 'The created filter');

filtered_F = moon_NFS.*ideal_filter;

showSpectrum(filtered_F, '');

filtered_f = real(ifft2(ifftshift(filtered_F)));

figure; imshow(filtered_f(1:orgSize(1), 1:orgSize(2)), []);


