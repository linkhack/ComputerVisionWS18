%% Vocab building
disp('Building Vocabulary')
voc = BuildVocabulary('res/train',75);

%% KNN building
disp('Building KNN')
[training, groups] = BuildKNN('res/train',voc);

%% Classify test images
disp('Classify test Images')
[conf_matrix, predictions] = ClassifyImages('res/test',voc,training,groups);

%% Result evaluation
% Plotting Confusion matrix
h = heatmap(conf_matrix);
% Calculate error rates
%total
correct_all = trace(conf_matrix)/sum(conf_matrix(:));
fprintf('%.3f classification rate. \n',correct_all)
%per class



%% Results so far
% Euclidean / 50 words / step 2 = 0.57
% Euclidean / 50 words / step 1 = 0.57
% Euclidean / 50 words / step 3 = 0.55
% Euclidean / 75 words / step 2 = 0.59
% Euclidean / 75 words / step 2 / NN = 5 = 0.598
