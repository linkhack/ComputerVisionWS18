function vocabulary = BuildVocabulary(folder,num_clusters)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    folders = dir(folder);
    sift_features = [];

    %% Extract Sift Features
    for i = 3:length(folders)
        current_folder = strcat(folders(i).folder,'\',folders(i).name);
        train_image_folder = dir(current_folder);
        for image_index = 3:length(train_image_folder)
            image_path = strcat(train_image_folder(image_index).folder,'\',train_image_folder(image_index).name);
            img = im2single(imread(image_path));
            pixels = numel(img);
            step = floor(sqrt(pixels/100)); % area/(step^2) = number of descriptors
            [~, d] = vl_dsift(img,'step',step,'fast');
            sift_features = [sift_features, d];
        end
    end

    %% Calculate Vocabulary by k-means
    vocabulary = vl_kmeans(double(sift_features), num_clusters);

end

