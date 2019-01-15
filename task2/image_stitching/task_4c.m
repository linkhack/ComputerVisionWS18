clear all; close all;

% image params: dir, basename, extension, first image #, last image #

imageinfo = {'res/','campus',    '.jpg',1,5};
%imageinfo = {'res/','officeview','.jpg',1,5};
%imageinfo = {'../../../testimg/lores/','zimmer_','.jpg',5,7};
%imageinfo = {'../../../testimg/lores/','wiese_','.jpg',1,5};

% save output files? -> task_4c_unblended.png, task4c_feathered.png
saveresults = true;


directory    = imageinfo{1};
baseFileName = imageinfo{2};
extension    = imageinfo{3};
firstNumber  = imageinfo{4};
lastNumber   = imageinfo{5};
numImages    = lastNumber - firstNumber + 1;

% load images
I_orig = cell(numImages,1);
I = cell(numImages,1);
for i = 1:numImages
    filename = sprintf('%s%s%d%s', directory, baseFileName, i + firstNumber - 1, extension);
    I_orig{i} = im2single(imread(filename));
    I{i} = im2single(rgb2gray(I_orig{i}));
end
    
% (1) find homographies between adjacent pairs
H_adj = cell(numImages-1,1); % H_adj{x}: Homography from I{x} to I{x+1}
for i = 1:(numImages-1)
    H_adj{i} = homography(I{i}, I{i+1});
end

% (2) calculate homographies from each image to the reference image
ref = floor((numImages+1) / 2); % reference image #
H_ref = cell(numImages,1); % H_ref{x}: Homography from I{x} to I{ref}
H_ref{ref} = projective2d; % identity transform
for i=(ref-1):-1:1
    % to get from i to ref:
    % get from i to i+1 (H_adj{i}) and then from i+1 to ref (H_ref{i+1})
    H_ref{i} = projective2d(H_ref{i+1}.T * H_adj{i}.T);
end
% e.g., for 5 images with ref=3, the above loop calcs:
%       H_2_3 = H_3_3 * H_2_3; H_1_3 = H_2_3 * H_1_2
for i=(ref+1):numImages
    % to get from i to ref:
    % get from i to i-1 (inv(H_adj{i-1})) and then from i-1 to ref (H_ref{i-1})
    H_ref{i} = projective2d(H_ref{i-1}.T * inv(H_adj{i-1}.T));
end
% e.g., for 5 images with ref=3, the second loop calcs:
%       H_4_3 = H_3_3 * (H_3_4^-1); H_5_3 = H_4_3 * (H_4_5^-1)

% (3) calculate panorama size: transform the corners of each image
xMin = 1; yMin = 1; [yMax, xMax] = size(I{ref});
for i=1:numImages
    [h,w] = size(I{i});
    corners = [1 1; 1 h; w 1; w h];
    t = transformPointsForward(H_ref{i}, corners);
    xMin = floor(min(xMin, min(t(:,1))));
    yMin = floor(min(yMin, min(t(:,2))));
    xMax = ceil (max(xMax, max(t(:,1))));
    yMax = ceil (max(yMax, max(t(:,2))));
end
panoSize = [yMax-yMin xMax-xMin];

% (4) transform all images to target plane
outref = imref2d(panoSize, [xMin xMax], [yMin yMax]);
Iw = cell(numImages,1);
Ibm = cell(numImages,1); % binary mask
Ifm = cell(numImages,1); % feather mask
dbg = cell(numImages,1); % debug
for i = 1:numImages
    Iw{i} = imwarp(I_orig{i}, H_ref{i}, 'OutputView', outref);
    % also warp a binary mask for each image
    [h,w] = size(I{i});
    Ibm{i} = imwarp(true(h,w), H_ref{i}, 'OutputView', outref);
    % feather mask:
    bw = zeros(h,w); bw(1,:)=1; bw(:,1)=1; bw(h,:)=1; bw(:,w)=1;
    mask = im2single(mat2gray(bwdist(bw)));
    Ifm{i} = imwarp(mask, H_ref{i}, 'OutputView', outref);
end

% (5) combine them all together and show results
% TODO - Recheck if feathering is ok!

%disable "Image is too big" warning temporarily
warning('off', 'images:initSize:adjustingMag');

% manually, without vision.AlphaBlender
pano = zeros([panoSize(1) panoSize(2) 3], 'like', I{1});
for i = 1:numImages
    % pano = old * (1-alpha) + new * alpha (alpha = binary mask):
    pano = pano .* (1-Ibm{i}) + Iw{i} .* Ibm{i};
end
figure('Name','Panorama with binary mask'); imshow(pano);
if saveresults; imwrite(pano, 'task_4c_unblended.png'); end

pano = zeros([panoSize(1) panoSize(2) 3], 'like', I{1});
sumA = zeros([panoSize(1) panoSize(2)]);
for i = 1:numImages
    pano = pano + Iw{i} .* Ifm{i};  % just add up all (feathered) images
    sumA = sumA + Ifm{i};           % and add up the alpha values
end
sumA(sumA==0) = 1; % avoid division by zero and preserve black background for saving
pano = pano ./ sumA; % final color = Sum((R,G,B)*alpha)/Sum(alpha)
figure('Name','Panorama feathered'); imshow(pano);
if saveresults; imwrite(pano, 'task_4c_feathered.png'); end

% blender = vision.AlphaBlender('Operation','Binary mask','MaskSource','Input port');
% pano = zeros([panoSize(1) panoSize(2) 3], 'like', I{1});
% for i = 1:numImages
%     pano = step(blender, pano, Iw{i}, Ibm{i});
% end
% figure('Name','Panorama with binary mask'); imshow(pano);
% 

warning('on', 'images:initSize:adjustingMag'); % re-enable warning

