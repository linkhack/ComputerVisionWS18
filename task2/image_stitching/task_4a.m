clear all; close all;

filename = 'res/campus4.jpg';

I = im2single(rgb2gray(imread(filename))); % read img., convert to grayscale
F = vl_sift(I); % extract SIFT keypoints (frames) [x;y;scale;orient.]
figure('Name','SIFT keypoint frames');
imshow(I);
vl_plotframe(F); % overlay plot of keypoints
% circle radius = scale of keypoints
% lines indicate orientation of keypoints
