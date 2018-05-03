query_image = read(test(6),1);
figure;
imshow(imresize(query_image,3));
query_features = histogram_feat(query_image);
query_features_n = query_features./max(max(training_features));
object_label = predict(object_classifier,query_features_n)
index_bol = strcmp(object_label, object_index);
index_int = find(index_bol);

subplot(1,2,1);
imshow(imresize(query_image,3));
title('Input Image');

subplot(1,2,2);
imshow(imresize(read(training(index_int),1),3));
title('Matched Image');