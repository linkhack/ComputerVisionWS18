%% Vocab building
disp('Building Vocabulary')
tic
voc = BuildVocabulary('res/train',75);
toc
%% KNN building
tic
disp('Building KNN')
[training, groups] = BuildKNN('res/train',voc);
toc

%% Classify test images
tic
disp('Classify test Images')
[conf_matrix, predictions] = ClassifyImages('res/test',voc,training,groups);
toc