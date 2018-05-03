close all;
clear all;
clc;

%% Load database of images
object_database = imageSet('mydatabase_2','recursive');

%% Split database into training and test sets
[training, test] = partition(object_database,[0.8 0.2]);

%% Extract color features for training set 
training_features = zeros(size(training,2)*training(1).Count,12);
counter = 1;

for i=1:size(training,2)
    for j = 1:training(i).Count
        training_features(counter,:) = histogram_feat(read(training(i),j));
        training_label{counter} = training(i).Description;    
        counter = counter + 1;
    end
    object_index{i} = training(i).Description;
end

%% Create classifier
training_features_n = training_features./max(max(training_features));
object_classifier = fitcecoc(training_features_n,training_label);

