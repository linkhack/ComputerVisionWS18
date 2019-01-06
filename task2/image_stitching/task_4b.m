clear all; close all;

filename1 = 'res/officeview3.jpg'; filename2 = 'res/officeview4.jpg'; 
%filename1 = 'res/campus2.jpg';     filename2 = 'res/campus3.jpg';

%disable "Image is too big" warning temporarily
warning('off', 'images:initSize:adjustingMag');

I1 = im2single(rgb2gray(imread(filename1))); % read img.; grayscale
I2 = im2single(rgb2gray(imread(filename2)));

homography(I1, I2, true);

warning('on', 'images:initSize:adjustingMag'); % re-enable warning


