clear all;
close all;
clc;

% Read the images
im_l = imread('Images/barn2/im0.ppm');
im_r = imread('Images/barn2/im4.ppm');

figure
imshowpair(im_l, im_r, 'montage');
title('Original Images');

% Transform into grayscale
im_r = rgb2gray(im_r);
im_l = rgb2gray(im_l);

% Calculate the edges
im_r_edges = double(edge(im_r, 'Canny'));
im_l_edges = double(edge(im_l, 'Canny'));

%% Shirai
% Parameters
k_i = 4;
k_f = 10;
I_i = 0;
I_f = 30;
d1 = 0.5;
d2 = 0.8;
d3 = 1.0;

% Initialize the disparity map
dispmap = zeros(size(im_l_edges,1),size(im_l_edges,2));

% Loop
[rows, cols] = size(im_l);
% For every pixel on the left image
for i=1:rows
    for j=1:cols
        % If (i,j) is an edge pixel then:
        if(im_l_edges(i,j))
            % Initialize the window parameter k and the search interval
            % [I_i, I_f]
            I_i = 0;
            I_f = 30;
            k = k_i;
            finish = false;
            while finish == false
                % Calculate the similarity measure
                similarity = similarityCorrelation(im_l_edges,im_r_edges,[i j], k, [I_i,I_f]);
                [min_value, disp] = min(similarity); % Minimun value and its index
                % If there is a unique minimun smaller that d1
                if min_value < d1
                    disp = disp + I_i;
                    dispmap(i,j) = disp; % Set the disparity value for point (i,j) in the disparity map
                    finish = true; % Exit the loop
                    
                % Else if all similarity values are larger than d2
                elseif sum(similarity>d2) == numel(similarity)
                    finish = true; % Exit the loop
                    
                % Else if the window has already maximun size
                elseif k == k_f
                    finish = true; % Exit the loop
                % Else reduce the size of the interval
                else
                    while similarity(1) >= d3 % Reduce from the start
                        similarity = similarity(2:end);
                        I_i = I_i + 1; % Update the initial index
                        if numel(similarity) == 0
                            finish = true;
                        end
                        break
                    end
                    % If we still have elements in similarity
                    if numel(similarity) > 0 
                        while similarity(end) >= d3 % Reduce from the end
                            similarity = similarity(1:end-1);
                            I_f = I_f - 1; % Update the final index
                            if (numel(similarity) == 0)
                                finish = true;
                            end
                            break
                        end
                    end
                    k = k + 1; % Increase the windows size
                end 
            end
        end
    end
end

% Plot results
figure; 
subplot(2,2,1);
imshow(im_l);
subplot(2,2,2);
imshow(dispmap, [0 30]);            
colormap(gca,jet) 
colorbar

filled = fill_disparity(dispmap);
filled2 = imrotate(fill_disparity(imrotate(dispmap, 90)), -90);
filled3 = imrotate(fill_disparity(imrotate(dispmap, 180)), -180);
filled4 = imrotate(fill_disparity(imrotate(dispmap, 270)), -270);

tot = (filled + filled2 + filled3 + filled4);
tot = tot./4;

% figure;imshow(filled, [0 30])
% title(['k_i=', num2str(k_i), ' k_f=', num2str(k_f), ' I_i=', num2str(I_i), ' I_f=', num2str(I_f), ' d1=', num2str(d1), ' d2=', num2str(d2), ' d3=', num2str(d3)]);
% colormap(gca,jet) 
% colorbar

subplot(2,2,3);
imshow(imgaussfilt(tot, 4), [0 30]);
% title(['k_i=', num2str(k_i), ' k_f=', num2str(k_f), ' I_i=', num2str(I_i), ' I_f=', num2str(I_f), ' d1=', num2str(d1), ' d2=', num2str(d2), ' d3=', num2str(d3)]);
colormap(gca,jet) 
colorbar

subplot(2,2,4);
disparityMap = disparity(im_l,im_r);
imshow(disparityMap, [0 30]);
colormap(gca,jet) 
colorbar
