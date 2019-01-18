clear all;
close all;
classes = {'bedroom'; 'forest'; 'kitchen'; 'livingroom';'mountain';'office';'store';'street'};
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
title('Confusion Matrix')
xlabel('Predicted class')
ylabel('True class')
% Calculate error rates
%total
correct_all = trace(conf_matrix)/sum(conf_matrix(:));
fprintf('%.3f classification rate. \n',correct_all);

%per class
results_per_group = diag(conf_matrix);

%%Same as recall as every group is equally big
figure()
bar(results_per_group);
title('Correctly per group')
[worst_result, worst_group] = min(results_per_group);
worst_class_name = string(classes(worst_group));
fprintf('Worst result was group %s with %i correctly classified',worst_class_name, worst_result);
%recall, correctly / (nr in group)
recall = results_per_group./sum(conf_matrix,2);
figure()
bar(recall)
title('Recall')
%precision correctly / (classified as group)
precision = results_per_group./sum(conf_matrix,1)';
figure();
bar(precision)
title('Precision')



%% Results so far
% Euclidean / 50 words / step 2 = 0.57
% Euclidean / 50 words / step 1 = 0.57
% Euclidean / 50 words / step 3 = 0.55
% Euclidean / 75 words / step 2 = 0.59
% Euclidean / 75 words / step 2 / NN = 5 = 0.598
% Cityblock / 75 words / step 2 / NN = 21 = 0.651
% Euclidean / 75 words / step 2 / NN = 21 = 0.601
% Cityblock / 100 words / step 2 / NN = 21 = 0.598
% Euclidean / 100 words / step 2 / NN = 21 = 0.598

%% Own images
%% Classify own test images
disp('Classify test Images')
[conf_matrix, predictions] = ClassifyImages('res/test_extra',voc,training,groups);

%% Result evaluation of own images
% Plotting Confusion matrix

h = heatmap(conf_matrix);
title('Confusion Matrix')
xlabel('Predicted class')
ylabel('True class')
% Calculate error rates
%total
correct_all = trace(conf_matrix)/sum(conf_matrix(:));
fprintf('%.3f classification rate. \n',correct_all);

%per class
used_classes = [2,3,4,5,8];
results_per_group = diag(conf_matrix);

%%Same as recall as every group is equally big
figure()
bar(results_per_group(used_classes));
title('Correctly per group')
set(gca,'xticklabel',used_classes)
[worst_result, worst_group] = min(results_per_group(used_classes));
worst_class_name = string(classes(used_classes(worst_group)));
fprintf('Worst result was group %s with %i correctly classified',worst_class_name, worst_result);
%recall, correctly / (nr in group)
recall = results_per_group./sum(conf_matrix,2);
figure()
bar(recall(used_classes))
set(gca,'xticklabel',used_classes)
title('Recall')
%precision correctly / (classified as group)
precision = results_per_group./sum(conf_matrix,1)';
figure();
bar(precision(used_classes))
set(gca,'xticklabel',used_classes)
title('Precision')

