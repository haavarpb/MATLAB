function [] = evaluateCrack(g, g_lines, lines)
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
masked = g.*uint8(filled);
cracks = imfilter(masked, fspecial('sobel')*fspecial('sobel')');
cracks = imbinarize(cracks, 0.7); % Need to find a good threshold
% figure; imshowpair(masked, cracks, 'montage');

%% Crack evaluation
% Idea:
% - Create a matrix containing interestpoints (centroids of elements in the
% crack image and do a window search for high density areas.
% - Size of window proportional of pipe width
% - Threshold densities to get severity

search_image = zeros(size(cracks));
stats = regionprops(cracks); % Extracts centroids, area and boundingbox
centroid_coordinates = floor(reshape(extractfield(stats, 'Centroid'), 2, []))'; % [X Y]
centroid_area = extractfield(stats,'Area');
X = centroid_coordinates(:,1)';
Y = centroid_coordinates(:,2)';
idx = sub2ind(size(search_image), Y, X);
search_image(idx) = centroid_area; % Now search_image contains each centroid weighted with its pixel area it represents
boxSize = floor(pipe_width/6); % Size of searchbox relative to pipe size
if bitget(boxSize,1) %odd
else %even
    boxSize = boxSize + 1;
end
response = imboxfilt(search_image, boxSize, 'Padding', 0, 'NormalizationFactor', 1); % Sum box to get a pixel density

%% Grade crack
% Thresholding response
thresh_yellow = 5;
thresh_red = 20;

grade_yellow = response(response > thresh_yellow & response < thresh_red);
grade_red = response(response > thresh_red);

stats_yellow = regionprops(grade_yellow);
stats_red = regionprops(grade_red);

figure; imshow(g);
hold on;
for k = 1 : length(stats_yellow) % Loop through all blobs.
	% Find the bounding box of each blob.
	thisBlobsBoundingBox = stats_yellow(k).BoundingBox;  
	rectangle('Position', thisBlobsBoundingBox, 'edgecolor', 'yellow');
end

for k = 1 : length(stats_red) % Loop through all blobs.
	% Find the bounding box of each blob.
	thisBlobsBoundingBox = stats_red(k).BoundingBox;  
	rectangle('Position', thisBlobsBoundingBox, 'edgecolor', 'red');
end
hold off

% IDEA
% - Since not all boxes are connected, make a box search (size % of radius)
% - If (pixel area > thresh) -> crack detected!
end

function [filled, pipe_width] = fillPipe(pipe_edges, hough_lines)
%FILLPIPE fills a pipe given as a two element structure given by
%houghlines()

dir = [hough_lines.theta];
len = [hough_lines.rho];

farthest_index = find(len == max(len)); % Finds the index of the greatest line
shortest_index = find(len == min(len));
pipe_width = len(farthest_index) - len(shortest_index);
pipe_center_line = len(farthest_index) - pipe_width/2;

fill_location = floor([pipe_center_line*sind(dir(farthest_index)) ... % Y pos
                        pipe_center_line*cosd(dir(farthest_index)) ] + 1); % X pos (+ 1 to shift into matrix indeces
             
filled = imfill(pipe_edges, fill_location);

end


