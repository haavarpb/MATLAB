close all;
clear all;
clc;

number_of_pipes=1; % to create a function later, so far we will work with 1 only

%% Pre-process image

I = imread('Easy_pipes\pipe_2.jpg');
g = imresize(rgb2gray(I), 0.5);

%% Edge detection

edges = edge(g,'Sobel', [], 'both', 'nothinning');
%edges = edge(g, 'log');
figure; imshowpair(g, edges, 'montage'); title('Image after Sobel edges');

%% Hough transform

[H,theta,rho] = hough(edges,'RhoResolution',0.5,'Theta',-90:1:89);
number_of_lines= number_of_pipes*2;
peaks  = houghpeaks(H,number_of_lines,'threshold',ceil(0.3*max(H(:))));  % play with the number of peaks
%peaks  = houghpeaks(H,number_of_lines);
lines = houghlines(edges,theta,rho,peaks,'FillGap',200,'MinLength',200); % play with the FillGap and MinLenght parameters
%lines = houghlines(edges,theta,rho,peaks);
%% Plot Hough lines cuts with the axis

bw = addHoughLines(g, lines);
figure;imshow(bw);

%% Morphologic operations

se_opening = strel('square',3);
opening = imopen(bw, se_opening); % opening to eliminate everything but the pipe
figure; imshow(opening);

se_closing = strel('square',50); % fill the pipe with white pixels
closing = imclose(opening, se_closing);
figure; imshow(closing); title('Image after morphologic operations');

segmentation = closing.*bw; % apply the closing mask on the edges image + the hough lines
figure; imshow(segmentation); title('Segmented pipe');

figure; imshow(segmentation - imopen(segmentation, ones(3)))

%% Crack evaluation
stats = regionprops(segmentation);
% figure; imshow(g);
% hold on;
% for k = 1 : length(stats) % Loop through all blobs.
% 	% Find the bounding box of each blob.
% 	thisBlobsBoundingBox = stats(k).BoundingBox;  
% 	rectangle('Position', thisBlobsBoundingBox);
% end

% figure; imshow(BW);
% mask = boundarymask(BW);
% imshow(mask)
% regions = splitmerge(g, 4, @predicate)
% imshow(regions);