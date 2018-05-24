close all;
clear all;
clc;

I = imread('Easy_pipes\pipe_2.jpg');
g  = imresize(rgb2gray(I), 0.1);

f = fspecial('sobel');

s = imfilter(g, f);

figure;imshowpair(g, s, 'montage');
