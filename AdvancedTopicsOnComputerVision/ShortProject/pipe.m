close all;
clear all;
%clc;

number_of_pipes=1; % to create a function later, so far we will work with 1 only

%% Pre-process image

I = imread('easy_pipes/pipe_1.jpg');
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

for line = 1:length(lines)
    if lines(line).rho < 0
        lines(line).rho = abs(lines(line).rho);
        lines(line).theta = lines(line).theta + 180;
    end
end

g_lines = addHoughLines(g, lines);

%% Isolate pipe

pipe_edges = imbinarize(g_lines, 0.99); % The lines are drawn in complete white, so we can threshold almost everything
% figure; imshowpair(g_lines, pipe_edges, 'montage');
[filled, pipe_width] = fillPipe(pipe_edges, lines);

% We mask out the original image
masked = g.*uint8(filled);
figure; imshow(rangefilt(masked));
cracks = imfilter(masked, fspecial('sobel')*fspecial('sobel')');
%cracks = imbinarize(cracks, 0.05); % Need to find a good threshold
figure; imshowpair(imbinarize(imgaussfilt(double(cracks), 15)), cracks, 'montage');

boxSize = floor(pipe_width/6); % Size of searchbox relative to pipe size
if bitget(boxSize,1) %odd
else %even
    boxSize = boxSize + 1;
end
response = imboxfilt(double(cracks), boxSize, 'Padding', 'symmetric', 'NormalizationFactor', 1); % Sum box to get a pixel density
masked_res = uint8(response.*filled);
segmented = imbinarize(masked_res);
% figure; imshowpair(cracks, masked_res, 'montage');
% figure; imshow(g_lines)

