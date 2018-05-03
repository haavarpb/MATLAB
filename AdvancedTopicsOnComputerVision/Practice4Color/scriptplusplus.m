close all
clear all

cd C:\Users\Håvard\Documents\MATLAB\AdvancedTopicsOnComputerVision\Practice4Color\colorimages

bg = imread('back.png');
i = imread('VC (8).png');

cd ..

figure; imshow(bg);
figure; imshow(i);

diff = bg - i;

figure; imshow(diff);

g = rgb2gray(diff);
bw = imbinarize(g);
figure; imshow(bw);
bwf = imfill(bw, 'holes');
bwf = imopen(bwf, ones(50));
figure; imshow(bwf);
roi = regionprops(bwf, 'BoundingBox');
figure; imshow(i); hold on;
rectangle('Position',roi(1).BoundingBox);
row_s = roi(1).BoundingBox(2);
row_e = row_s + roi(1).BoundingBox(4);
col_s = roi(1).BoundingBox(1);
col_e = col_s + roi(1).BoundingBox(3);
diff = i(row_s:row_e, col_s:col_e, :);

figure; imshow(diff);

% Extract the three channels
diff_r = diff(:,:,1);
diff_g = diff(:,:,2);
diff_b = diff(:,:,3);

% Create histogram
bins = 256; % The use of bins might sacrifice detail for visibility! 
hist_r = imhist(diff_r, bins);
hist_g = imhist(diff_g, bins);
hist_b = imhist(diff_b, bins);
% 
% % Display
figure; subplot(1,2,1); bh = bar([hist_r hist_g hist_b]);
title('Histogram for RGB Values')
xlabel('RGB Value')
ylabel('Count')
bh(1).FaceColor = 'r';
bh(2).FaceColor = 'g';
bh(3).FaceColor = 'b';
axis tight
subplot(1,2,2); imshow(diff);