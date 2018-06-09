close all;
clear all;
%clc;

number_of_pipes=1; % to create a function later, so far we will work with 1 only

%% Pre-process image

I = imread('easy_pipes/pipe_5.jpg');
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
dim_light = 10;
g_lines = addHoughLines(g-dim_light, lines);

%% Isolate cracks

pipe_edges = imbinarize(g_lines, 0.99); % The lines are drawn in complete white, so we can threshold almost everything
% figure; imshowpair(g_lines, pipe_edges, 'montage');

% Now we want a mask to look at the pipes irregularities
% PLAN
% - Fill in between lines
% - Use that to mask the original image
% - Do another edge detection to get only edges on the pipe

% To fill the pipe we need to know where it is:
% Assume a pipe defined by size(hough_lines) = 2, where hough_lines is the
% struct returned by the houghlines()
[filled, pipe_width] = fillPipe(pipe_edges, lines);
% figure; imshow(filled);

% We mask out the original image
cracks = imfilter(g, fspecial('sobel')*fspecial('sobel')');
masked_pipe_cracks = cracks.*uint8(filled);

%figure; imshowpair(masked_pipe_cracks, filled, 'montage');
%% TEXTURE AND LINES EVAL

entropy(masked_pipe_cracks)
figure; imshowpair(masked_pipe_cracks, g_lines, 'montage');



%% Crack evaluation
% Idea:
% - Create a matrix containing interestpoints (centroids of elements in the
% crack image and do a window search for high density areas.
% - Size of window proportional of pipe width
% - Threshold densities to get severity

search_image = zeros(size(masked_pipe_cracks));
stats = regionprops(masked_pipe_cracks); % Extracts centroids, area and boundingbox
centroid_coordinates = floor(reshape(extractfield(stats, 'Centroid'), 2, []))'; % [X Y]
X = centroid_coordinates(:,1)';
valid = ~isnan(X);
X = X(valid);
Y = centroid_coordinates(:,2)';
Y = Y(valid);
centroid_area = extractfield(stats,'Area');
centroid_area = centroid_area(valid);
idx = sub2ind(size(search_image), Y, X);
search_image(idx) = centroid_area; % Now search_image contains each centroid weighted with its pixel area it represents
boxSize = floor(pipe_width/6); % Size of searchbox relative to pipe size
if bitget(boxSize,1) %odd
else %even
    boxSize = boxSize + 1;
end
response = imboxfilt(search_image, boxSize, 'Padding', 0, 'NormalizationFactor', 1); % Sum box to get a pixel density

% %% Grade crack
% % Thresholding response
% 
% thresh_red = 5;
% 
% grade_red = logical(zeros(size(masked_pipe_cracks)));
% grade_red(response > thresh_red) = 1;
% 
% stats_red = regionprops(grade_red);
% 
% figure; imshow(g);
% hold on;
% for k = 1 : length(stats_red) % Loop through all blobs.
% 	% Find the bounding box of each blob.
% 	thisBlobsBoundingBox = stats_red(k).BoundingBox;  
% 	rectangle('Position', thisBlobsBoundingBox, 'edgecolor', 'red');
% end
% hold off

% IDEA
% - Since not all boxes are connected, make a box search (size % of radius)
% - If (pixel area > thresh) -> crack detected!