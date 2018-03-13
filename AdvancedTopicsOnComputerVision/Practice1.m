clc
clear all
close all

I = im2double(imread('moon.jpg'));

figure; imshow(I)

PQ = paddedsize(size(I));

F = fft2(I ,PQ(1), PQ(2));
S = fftshift(log(abs(F) + 1));
figure; imshow(S, [])

H = imgaussfilt(