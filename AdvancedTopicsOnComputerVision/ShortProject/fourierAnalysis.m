%% Fourier analysis of pipe images
%
% IDEA: Since edge detector is distorted by background, use fourier to
% suppress background noise.

% Load
cd Easy_pipes
I = imread('pipe_5.jpg');
cd ..
g = imresize(rgb2gray(I), 0.1); % Scale to 10% of original size
figure; imshow(g);

% Fourier
F = fft2(g, size(g,1)*2, size(g,2)*2);
S = fftshift(F);

figure;
surf(log(abs(S) + 1));
shading interp