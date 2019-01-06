function [tform] = homography(I1, I2, plotResults )
%HOMOGRAPHY Find homography between two images
%   Calculate a homography to transform I1 to I2
%   Both I1 and I2 are grayscale images in single precision
%   PlotResults (optional): if true, outputs interim/final results
%
%   Returns [tform] the calculated transform

if nargin < 3; plotResults = false; end;

[F1,D1] = vl_sift(I1); % extract SIFT features and descriptors
[F2,D2] = vl_sift(I2);
M = vl_ubcmatch(D1,D2); % match the descriptors

% M has the indices of the matched keypoints; get x,y coordinates from F:
% F has [X,Y,scale,orientation] in each column
P1 = F1(1:2, M(1,:))';   % feature coordinates from image 1
P2 = F2(1:2, M(2,:))';   % and image 2

[tform,idx] = ransac(P1,P2,1000,5); % run RANSAC on the matches

if plotResults
    match_plot(I1,I2,P1,P2); % plot initial matches
    fig = gcf; fig.Name = sprintf('Initial matches (%d)', size(P1,1));

    match_plot(I1,I2,P1(idx,:),P2(idx,:)); % plot the RANSAC matches
    fig = gcf; fig.Name = sprintf('Final matches (%d)', size(idx,1));

    I1warped = imwarp(I1, tform, 'FillValues', 0, 'OutputView', imref2d(size(I2)));
    % TODO: can we make the FillValues transparent?
    figure('Name','Overlayed images');
    imshowpair(I1warped, I2, 'blend', 'Scaling', 'joint');

    % show absolute differences
    figure('Name','Image differences');
    imshowpair(I1warped, I2, 'diff');
end

end

