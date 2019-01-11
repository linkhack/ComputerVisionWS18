%% Vocab building
disp('Building Vocabulary')
tic
voc = BuildVocabulary('res/train',50);
toc
%% KNN building
tic
disp('Building KNN')
[training, groups] = BuildKNN('res/train',voc);
toc

%% Classify test images
tic
disp('Classify test Images')
conf_matrix = ClassifyImages('res/test',voc,training,groups);
toc