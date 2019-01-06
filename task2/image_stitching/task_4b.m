clear all; close all;

filename1 = 'res/officeview3.jpg'; filename2 = 'res/officeview4.jpg'; 
%filename1 = 'res/campus2.jpg';     filename2 = 'res/campus3.jpg';

do_rot_scale = false; % rotate/scale 2nd image? (subtask for report)

%disable "Image is too big" warning temporarily
warning('off', 'images:initSize:adjustingMag');

I1 = im2single(rgb2gray(imread(filename1))); % read img.; grayscale
I2 = im2single(rgb2gray(imread(filename2)));

if do_rot_scale
    I2 = imresize(imrotate(I2,30), .75);
end

homography(I1, I2, true);

warning('on', 'images:initSize:adjustingMag'); % re-enable warning


