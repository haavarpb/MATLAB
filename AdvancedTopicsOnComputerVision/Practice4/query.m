%% Test the classifier with the dataset

for object=1:6
    for j = 1:test(object).Count
        query_image = read(test(object),j);
        query_features = histogram_feat(query_image);
        object_label = predict(object_classifier,query_features);
        index_bol = strcmp(object_label, object_index);
        index_int = find(index_bol);
        
        subplot(1,2,1);
        imshow(imresize(query_image,3));
        title('Input Image');
        
        subplot(1,2,2);
        imshow(imresize(read(training(index_int),1),3));
        title('Matched Image');
        
    end


end