function [similarity] = similarityCorrelation(image_left, image_right, point, k, interval)
%% PARAMETERS
% image_left: Left image of stereo pair
% image_right: Right image of stereo pair
% point (type: Origin pixel from image_left to be searched for in image_right
% window_size: Size of the evaluation window
% interval: Interval area of where to search for the point in the
% image_right

%% Assumptions
% - image_left and image_right have epipolar horizontal lines

r = point(1);
c = point(2);
Ii = interval(1);
If = interval(2);

% Find windows
minr = max(1,r-k);
maxr = min(size(image_left,1),r+k); 
minc_l = max(1,c-k);
maxc_l = min(size(image_left,2),c+k);
minc_r = max(1,c-If-k);
maxc_r = min(size(image_right,2),c-Ii+k);
template = double(image_left(minr:maxr,minc_l:maxc_l));
search_window = double(image_right(minr:maxr,minc_r:maxc_r));

% Compute correlation
similarity = imfilter(search_window,template);

% Extract epipolar line
c0 = k+1;
c1 = size(similarity,2) - k;

% General border handling
if (c-If < k+1) 
    c0 = max(1,c-If);
elseif (c-Ii > size(image_left,2)-k)
    c1 = c1 + min(k,c-Ii-(size(image_left,2)-k));
end
r0 = k+1;
if (r < k+1)
    r0 = r;
elseif (r > size(image_left,1)-k)
    r0 = k+1 - (r-(size(image_left,1)-k));
end
similarity = similarity(r0,c0:c1);

% Normalize, change to minimum and flip
similarity = 1 - similarity./sum(sum(template));
similarity = fliplr(similarity);
end