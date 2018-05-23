close all;
clear all;
clc;

number_of_pipes=1; % to create a function later, so far we will work with 1 only

% Adaptative binarization

%% Pre-process image

I = imread('easy_pipes\pipe_4.jpg');
figure; imshow(I); title('Original image');
g = imresize(rgb2gray(I), 0.1);
% [M, N] = size(g);
% med = medfilt2(g, [5 5]);
% rotI = imrotate(med,33,'crop');
% b = imbinarize(gr);

% Try different preprocessing methods/more (bilateral filter?)
%% Edge detection
edges = edge(g,'Sobel');
figure; imshow(edges); title('Image after Sobel edges');

% Try different edge detectors
%% Hough transform
[H,theta,rho] = hough(edges,'RhoResolution',0.5,'Theta',-90:0.5:89.5);
if number_of_pipes==1
    n=2;
elseif number_of_pipes==2
    n=4
end
peaks  = houghpeaks(H,n,'threshold',ceil(0.3*max(H(:))));  % play with the number of peaks
lines = houghlines(edges,theta,rho,peaks,'FillGap',200,'MinLength',200); % play with the FillGap and MinLenght parameters

%% Plot Hough lines cuts with the axis
figure, imshow(edges), hold on;

% Calculate the cuts of the line with the 4 axis
for k = 1:length(lines)
    rho = lines(k).rho;
    theta = lines(k).theta;
    xup = rho/cosd(theta);
    xdown = (rho - size(g, 2)*sind(theta))/cosd(theta);
    yleft = rho/sind(theta);
    yright = (rho - size(g,1)*cosd(theta))/sind(theta);
    
    % Check if the cut points are valid (different from Inf and -Inf)
    % and plot the line between them
    xy = zeros(2,2);
    j = 1;
    
        if (xup ~= Inf) && (xup ~= -Inf)
            xy(j,:) = [xup, 0];
            j = j+1;
            if j==3
                plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','white');
                    continue
                end
        end
        if (xdown ~= Inf) && (xdown ~= -Inf)
            xy(j,:) = [xdown, size(g,2)];
            j = j+1;
                if j==3
                    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','white');
                    continue
                end
        end
        if (yleft ~= Inf) && (yleft ~= -Inf)
            xy(j,:) = [0, yleft];
            j = j+1;
                if j==3
                    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','white');
                    continue
                end
        end
        if (yright ~= Inf) && (yright ~= -Inf)
            xy(j,:) = [size(g,2), yright];
            j = j+1;
                if j==3
                    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','white');
                    continue
                end
        end
end

hold off;
F = getframe(gcf); % Captures the image with the Hough lines plotted
[X, Map] = frame2im(F); % Converts it into the variable X
H = imcrop(X, [87, 30, 399, 299]); % Cut it to size 300 x 400
gray_hough = rgb2gray(H); 
figure; imshow(gray_hough);

%% Morphologic operations

se_opening = strel('square',2);
opening = imopen(gray_hough, se_opening); % opening to eliminate everything but the pipe
figure; imshow(opening);

se_closing = strel('square',50); % fill the pipe with white pixels
closing = imclose(opening, se_closing);
figure; imshow(closing); title('Image after morphologic operations');

segmentation = closing.*gray_hough; % apply the closing mask on the edges image + the hough lines
figure; imshow(segmentation); title('Segmented pipe');

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