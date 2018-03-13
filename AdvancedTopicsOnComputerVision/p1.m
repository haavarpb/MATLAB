clc
clear all
close all

Image = imread('elephant.jpg');

BW_Image = rgb2gray(Image);

figure
imshow(BW_Image)

PQ = paddedsize(size(BW_Image));

F = fft2(BW_Image ,PQ(1), PQ(2));
S = abs(F);

figure
imshow(S, [])
