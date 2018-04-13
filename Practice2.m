clc
clear all
close all

I = im2double(imread('att_faces\s7\7.pgm'));
figure; imshow(I);

% Pre-processing 
[major, minor] = size(I);
f = I(1:minor,1:minor);
figure; imshow(f);

% fitcecoc
% I2 = imresize(I, [48, 48])
% figure; imshow(croppedImage);

%% Divide the image in 8x8 blocks, each containing 50% of its neighbour

k = 1;
for i = 1:4:(minor-4)
    for j = 1:4:(minor-4)
        blocks(:,:,k)= f(i:(i+7),j:(j+7));
        k = k+1;
    end
end

%% Fast Walsh-Hadamard transform and coefficients mean for each block

[~,N,n] = size(blocks);
sum_coef = zeros(1,n);
for k = 1:n
    C(:,:,k) = fwht(blocks(:,:,k));
    for i = 1:N
        for j = 1:N
            if i==1 && j==1
                break
            else
               sum_coef(k) = sum_coef(k) + C(i,j,k);
               mean(k) = sum_coef(k)/(N^2-1);
            end
        end
    end
end

%% Calculate the coefficients
S1 = zeros(1,n);
S2 = zeros(1,n);
S3 = zeros(1,n);
S4 = zeros(1,n);
S5 = zeros(1,n);

S3_sum = zeros(1,n);
S4_sum = zeros(1,n);
S5_sum = zeros(1,n);

for k = 1:n
    for i = 1:N
        for j = 1:N
            if i==1 && j==1
                break
            else
                S1(k) = (C(i,j,k))^2;
                S2(k) = (abs(C(i,j,k)) - abs(mean(k)));
                S3_sum(k) = S3_sum(k) + ((C(i,j,k)) - mean(k))^2;
                S4_sum(k) = S4_sum(k) + abs(C(i,j,k));
                S5_sum(k) = S5_sum(k) + abs(C(i,j,k) - mean(k));
            end
        end
    end
    S3(k) = S3_sum(k) / (N^2-1);
    S4(k) = S4_sum(k) / (N^2-1);
    S5(k) = S5_sum(k) / (N^2-1);
end

