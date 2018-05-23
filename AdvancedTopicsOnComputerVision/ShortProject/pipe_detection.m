close all;
clear all;
clc;

%% Pre-process image (madian filter, greyscale)
I = imread('Easy_pipes\pipe_3.jpg');
g  = imresize(rgb2gray(I), 0.1);

%% Edge detection
BW = edge(g,'Sobel');
figure; imshowpair(BW, g);

%% Hough transform
[H,theta,rho] = hough(BW,'RhoResolution',1,'Theta',-90:1:89);
peaks  = houghpeaks(H,8,'threshold',ceil(0.3*max(H(:))));  % play with the number of peaks
lines = houghlines(BW,theta,rho,peaks,'FillGap',500,'MinLength',200); % play with the FillGap and MinLenght parameters

%% Give parallell lines the same color
thetaRange = 90; % Houghlines theta range
resBin = 2; % Degrees resolution for each bin. Tunable
numBins = thetaRange/resBin;
offset = 90;

numLines = zeros(numBins, 1);
for k = 1:length(lines)
    lines(k).bin = ceil( (abs(lines(k).theta) + 1) / (thetaRange + 1) * numBins);
    lines(k).bin
    numLines(lines(k).bin) = numLines(lines(k).bin) + 1;
end
colours = ['r' 'g' 'b'];
distinctColours = find(numLines);
for k = 1:length(lines)
    if lines(k).bin == distinctColours(1)
        lines(k).colour = colours(1);
    elseif lines(k).bin == distinctColours(2)
        lines(k).colour = colours(2);
    else
        lines(k).colour = colours(3);
    end
end

%% Plot Hough Lines
figure, imshow(g), hold on
for k = 1:length(lines)
    p = [];
    temp = [];
    r = lines(k).rho;
    t = lines(k).theta;
    ybot = r/sind(t); % [xminboundary ybot]
    temp = [temp; 0 ybot];
    ytop = (r - size(g,2)*cosd(t))/sind(t); % [xmaxboundary ytop]
    temp = [temp; size(g,2) ytop];
    xbot = r/cosd(t); % [xbot yminboundary]
    temp = [temp; xbot 0];
    xtop = (r - size(g,1)*sind(t))/cosd(t); % [xtop ymaxboundary]
    temp = [temp; xtop size(g,1)];
    
    for point = 1:length(temp)
        if  min(temp(point, :) <= [size(g, 2) size(g,1)]) && min(temp(point, :) >= [0 0])
            p = [p; temp(point,:)];
        end
    end
    plot(p(:,1), p(:,2), 'linewidth', 2, 'color', lines(k).colour);
end




