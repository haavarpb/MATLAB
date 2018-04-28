close all
clear all

cd C:\Users\Håvard\Documents\MATLAB\AdvancedTopicsOnComputerVision\Practice4Color\colorimages

bg = imread('back.png');
sprayflask = imread('VC (5).png');

cd ..

figure; imshow(bg);
figure; imshow(sprayflask);

diff = bg - sprayflask;
diff2 = sprayflask - bg;

figure; imshow(diff);
% figure; imshow(diff2);

% Extract the three channels
diff_r = diff(:,:,1);
diff_g = diff(:,:,2);
diff_b = diff(:,:,3);

% Create normalized histogram
bins = 256; % The use of bins might sacrifice detail for visibility! 
hist_r = imhist(diff_r, bins)/max(max(imhist(diff_r)));
hist_g = imhist(diff_g, bins)/max(max(imhist(diff_g)));
hist_b = imhist(diff_b, bins)/max(max(imhist(diff_b)));

% Display
figure; bh = bar([hist_r hist_g hist_b]);
bh(1).FaceColor = 'r';
bh(2).FaceColor = 'g';
bh(3).FaceColor = 'b';
axis tight

%% Thresholding

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% METHOD 1 SUCKS
% Try to threshold based on index halfway between the highest peaks
thresh_r = indexBetweenTwoHighestPeaks(hist_r)
thresh_g = indexBetweenTwoHighestPeaks(hist_g)
thresh_b = indexBetweenTwoHighestPeaks(hist_b)

diff_r(diff_r < thresh_r) = 0;
diff_g(diff_g < thresh_g) = 0;
diff_b(diff_b < thresh_b) = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% COG-METHOD
cog_r = dot(hist_r, 0:255)/sum(hist_r);
cog_g = dot(hist_g, 0:255)/sum(hist_g);
cog_b = dot(hist_b, 0:255)/sum(hist_b);

diff_r(diff_r < cog_r) = 0;
diff_g(diff_g < cog_g) = 0;
diff_b(diff_b < cog_b) = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure; imshow(diff_r);
figure; imshow(diff_g);
figure; imshow(diff_b);

% Put back together to color
r = cat(3, diff_r*255, diff_g*255, diff_b*255);
figure; imshow(r);

function i = indexBetweenTwoHighestPeaks(histogram)
[pks, loc] = findpeaks(histogram, 'SortStr', 'descend');
i = min(loc(1),loc(2)) + abs(loc(1) - loc(2))/2;
end

