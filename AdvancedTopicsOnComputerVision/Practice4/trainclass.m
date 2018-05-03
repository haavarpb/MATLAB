close all;
clear all;
clc;

%% Load database of images
object_database = imageSet('mydatabase','recursive');

%% Split database into training and test sets
[training, test] = partition(object_database,[0.75 0.25]);

%% Extract WHT features for training set 
training_features = zeros(size(training,2)*training(1).Count,768);
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
object_classifier = fitcecoc(training_features,training_label);

