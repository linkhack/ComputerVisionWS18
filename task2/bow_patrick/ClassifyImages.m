function conf_matrix = ClassifyImages(folder,vocabulary, training, group)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    folders = dir(folder);
    vocabulary_size = size(vocabulary,2); %get number of worlds
    conf_matrix = zeros(max(group(:)));
    %% Extract histogram for training set
    for i = 3:length(folders)
        current_folder = strcat(folders(i).folder,'\',folders(i).name);
        train_image_folder = dir(current_folder);
        for image_index = 3:length(train_image_folder)
            image_path = strcat(train_image_folder(image_index).folder,'\',train_image_folder(image_index).name);
            img = im2single(imread(image_path));
            [~, features] = vl_dsift(img,'fast');
            word_ids = knnsearch(vocabulary',double(features'));
            word_histogram = histcounts(word_ids,vocabulary_size);
            word_histogram = word_histogram/norm(word_histogram);
            knn_result = knnclassify(word_histogram, training, group, 3);
        end
    end
end
