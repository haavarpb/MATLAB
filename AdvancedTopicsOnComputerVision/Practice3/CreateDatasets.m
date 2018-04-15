%% Create a trainingset for texture analysis
clc
clear all
close all

%% PS: The pictures have to be atleast as big as size below
imageSize = 350;

%% Trainingset

cd C:\Users\Håvard\Documents\MATLAB\AdvancedTopicsOnComputerVision\Practice3\Bricks
directory = dir;
cd ..

dataSet = struct('bricks', struct(), 'concrete', struct(), 'bricksValidation', struct(), 'concreteValidation', []);

% Load images to struct
for image = 1:length(directory)
    if strcmp(directory(image).name,'.') || strcmp(directory(image).name,'..')
        continue;
    end
    fullFileName = strcat(strcat(directory(image).folder, '\'), directory(image).name);
    i = imread(fullFileName);
    dataSet.bricks(image - 2).image = rgb2gray(i(1:imageSize, 1:imageSize, :));
end

cd C:\Users\Håvard\Documents\MATLAB\AdvancedTopicsOnComputerVision\Practice3\Concrete
directory = dir;
cd ..

% Load images to struct
for image = 1:length(directory)
    if strcmp(directory(image).name,'.') || strcmp(directory(image).name,'..')
        continue;
    end
    fullFileName = strcat(strcat(directory(image).folder, '\'), directory(image).name);
    i = imread(fullFileName);
    dataSet.concrete(image - 2).image = rgb2gray(i(1:imageSize, 1:imageSize, :));
end



%% Validation sets

cd C:\Users\Håvard\Documents\MATLAB\AdvancedTopicsOnComputerVision\Practice3\BricksValidation
directory = dir;
cd ..

% Load images to struct
for image = 1:length(directory)
    if strcmp(directory(image).name,'.') || strcmp(directory(image).name,'..')
        continue;
    end
    fullFileName = strcat(strcat(directory(image).folder, '\'), directory(image).name);
    i = imread(fullFileName);
    dataSet.bricksValidation(image - 2).image = rgb2gray(i(1:imageSize, 1:imageSize, :));
end

cd C:\Users\Håvard\Documents\MATLAB\AdvancedTopicsOnComputerVision\Practice3\ConcreteValidation
directory = dir;
cd ..

% Load images to struct
for image = 1:length(directory)
    if strcmp(directory(image).name,'.') || strcmp(directory(image).name,'..')
        continue;
    end
    fullFileName = strcat(strcat(directory(image).folder, '\'), directory(image).name);
    i = imread(fullFileName);
    dataSet.concreteValidation(image - 2).image = rgb2gray(i(1:imageSize, 1:imageSize, :));
end

save dataSet
