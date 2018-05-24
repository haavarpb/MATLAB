close all;
clear all;
%clc;

number_of_pipes=1; % to create a function later, so far we will work with 1 only

%% Pre-process image

I = imread('easy_pipes\pipe_5.jpg');
% I = imread('easy_pipes\pipe_1.jpg');
% IF YOU GET WARNING ABOUT IMAGE IS TO BIG THIS ALGO WONT WORK
% IF YOU TRY NEW IMAGES AND THINGS CRASH CHECK THE FOLLOWING:
% - CHECK THAT THE HOUGH LINE PLOTTER DRAWS THE LINE ALL THE WAY TO EDGE
% - CHECK ALSO THAT THE CROP IN HOUGHLINES PLOTTER DOESN'T FUCK UP THE CROP
g = imresize(rgb2gray(I), 0.1);

%% Edge detection

edges = edge(g,'Sobel', 'nothinning');
%figure; imshowpair(g, edges, 'montage');

%% Hough transform

[H,theta,rho] = hough(edges,'RhoResolution',0.5,'Theta',-90:0.5:89.50);
number_of_lines= number_of_pipes*2;
peaks  = houghpeaks(H,number_of_lines,'threshold',ceil(0.3*max(H(:))));  % play with the number of peaks
lines = houghlines(edges,theta,rho,peaks,'FillGap',200,'MinLength',200); % play with the FillGap and MinLenght parameters

g_lines = addHoughLines(g, lines);

% POTENTIAL ADDITION IF TIME:
% CONFIRM THAT ITS A PIPE AND NOT TWO RANDOMLY PARALLELL LINES

%% Isolate cracks

pipe_edges = imbinarize(g_lines, 0.99); % The lines are drawn in complete white, so we can threshold almost everything
figure; imshowpair(g_lines, pipe_edges, 'montage');

% Now we want a mask to look at the pipes irregularities
% PLAN
% - Fill in between lines
% - Use that to mask the original image
% - Do another edge detection to get only edges on the pipe

% To fill the pipe we need to know where it is:
% Assume a pipe defined by size(hough_lines) = 2, where hough_lines is the
% struct returned by the houghlines()
filled = fillPipe(pipe_edges, lines);
% figure; imshow(filled);

% We mask out the original image
masked = g.*uint8(filled);
cracks = imfilter(masked, fspecial('sobel')*fspecial('sobel')');
cracks = imbinarize(cracks, 0.6); % Need to find a good threshold
% figure; imshowpair(masked, cracks, 'montage');

%% Crack evaluation
stats = regionprops(cracks);
% figure; imshow(g);
hold on;
for k = 1 : length(stats) % Loop through all blobs.
	% Find the bounding box of each blob.
	thisBlobsBoundingBox = stats(k).BoundingBox;  
	rectangle('Position', thisBlobsBoundingBox, 'edgecolor', 'red');
end

% IDEA
% - Since not all boxes are connected, make a box search (size % of radius)
% - If (pixel area > thresh) -> crack detected!

% figure; imshow(cracks);
% mask = boundarymask(cracks);
% imshow(mask)
% regions = splitmerge(g, 4, @predicate)
% imshow(regions);