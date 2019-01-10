%% Vocab building
tic
voc = BuildVocabulary('res/train',50)
toc
%% KNN building
tic
[training, groups] = BuildKNN('res/train',voc);
toc