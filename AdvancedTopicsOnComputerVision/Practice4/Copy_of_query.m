%% Test the classifier with the dataset

figure;
fig_number = 1;

for person=1:12
    for j = 1:test(person).Count
        query_image = read(test(person),j);
        query_features = hist_feat(query_image);
        object_label = predict(object_classifier,query_features);
        index_bol = strcmp(object_label, object_index);
        index_int = find(index_bol);
        
        subplot(2,2,fig_number);
        imshow(imresize(query_image,3));
        
        title('Input Image');
        subplot(2,2,fig_number;
        imshow(imresize(read(training(index_int),1),3));
        title('Matched Image');
        
        fig_number = fig_number+2;
        
    end
    figure;
    fig_number = 1;

end