function [conf_matrix, predictions] = ClassifyImages(folder,vocabulary, training, group)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    folders = dir(folder);
    vocabulary_size = size(vocabulary,2); %get number of worlds
    conf_matrix = zeros(max(group(:)));
    knn_model = fitcknn(training,group,'NumNeighbors',21,'Distance','cityblock');
    predictions = [];
    %% Extract histogram for training set
    for i = 3:length(folders)
        current_folder = strcat(folders(i).folder,'\',folders(i).name);
        disp(strcat('Classifying images of class ',folders(i).name));
        train_image_folder = dir(current_folder);
        for image_index = 3:length(train_image_folder)
            image_path = strcat(train_image_folder(image_index).folder,'\',train_image_folder(image_index).name);
            img = imread(image_path);
            if (size(img, 3) > 1) img = rgb2gray(img); end
            img = im2single(img);  
            [~, features] = vl_dsift(img,'step',2,'fast');
            word_ids = knnsearch(vocabulary',double(features'));
            word_histogram = histcounts(word_ids,vocabulary_size);
            word_histogram = word_histogram/sum(word_histogram);
            % knn_result = knnclassify(word_histogram, training, group, 3);
            knn_result = predict(knn_model, word_histogram);
            conf_matrix(i-2,knn_result) = conf_matrix(i-2,knn_result)+1;
            predictions = [predictions, knn_result];
        end
    end
    disp("Classification finished")
end

