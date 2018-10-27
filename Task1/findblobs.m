clear all
close all

I = im2double(imread('res/butterfly.jpg'));
%I = im2double(imread('res/future.jpg'));
%I = im2double(imread('res/mytest.png'));

% convert color images to grayscale
if ndims(I) > 2
    I = rgb2gray(I);
end

%I = imresize(I,0.15);

DEBUG=false;
DRAW_SEPARATE=true;

% parameters
sigma0 = 2;    % initial sigma
k      = 1.25; % k - factor to increase sigma by each level
levels = 10;   % number of levels to process
thresh = 0.15;    % threshold for local maxima % TODO

% --- Create scale space matrix ------------------------------------------
[height,width] = size(I);
scale_space = zeros(height,width,levels);

sigma = sigma0;
for i = 1:levels
    % create a LoG filter of appropriate size and scale it by sigma^2
    hsize = 2 * floor(3 * sigma) + 1;
    log = sigma*sigma*fspecial('log', hsize, sigma);

    % convolve with the image and store absolute values in the scalespace
    scale_space(:,:,i) = abs(imfilter(I, log, 'replicate', 'same'));

    % increase sigma
    sigma = sigma * k;
end
if DEBUG, debug_montage('Scale space', scale_space), end;


% --- Non-maximum-suppression -------------------------------------------

% for each level: set maxima to the value of the maximal neighbour
%                 inside this level
levelmax = zeros(height,width,levels);
for i = 1:levels
% wayyyyy too slow...
%   maxfunc=@(x) max(x(:));
%   max_space(:,:,i) = nlfilter(scale_space(:,:,i), [3 3], maxfunc);

% much faster:
    levelmax(:,:,i) = colfilt(scale_space(:,:,i), [3 3], 'sliding', @max);
end
if DEBUG, debug_montage('Maxima per level', levelmax), end;

% calculate maxima between level-neighbourhoods.
% - we already have set the maxima IN each level
% - now perform a max operation along the 3rd dimension between neighbouring levels
% ATTN: we need to use a separate matrix for the results, because we need
%       the original values to calc other levels
% TODO: actually we only need to buffer 3 levels... optimize mem usage!
totalmax = zeros(height,width,levels);
for i = 1:levels
    prev = i - 1; % previous level
    next = i + 1; % next level
    if (prev < 1);      prev = 1;      end;
    if (next > levels); next = levels; end;
    levels_of_interest = levelmax(:,:,prev:next);
    totalmax(:,:,i) = max(levels_of_interest, [], 3);
end
if DEBUG, debug_montage('Combined maxima', totalmax), end;

% TODO: is there some function like colfilt for 3D, so we can calc the
% total maxima in one go?

% now we have the 3D-neighbourhood-maxima in totalmax
% delete all pixels from scale space that do not equal these maxima
% also delete pixels that are lower than threshold
scale_space(scale_space ~= totalmax) = 0;
scale_space(scale_space < thresh) = 0;
if DEBUG, debug_montage('Final maxima', scale_space), end;


cx = []; cy = []; rad = [];
for i = 1:levels
    sigma = sigma0 * k^(i-1);
    radius = sqrt(2) * sigma;
    [cy_,cx_] = find(scale_space(:,:,i))
    rad_ = zeros(size(cx_));
    rad_(:) = radius;
    if DRAW_SEPARATE
        if size(cx_) > 0
            figure('Name',sprintf('Level %d',i));
            show_all_circles(I,cx_,cy_,rad_);
        end
    else
        cx  = [cx;cx_];
        cy  = [cy;cy_];
        rad = [rad;rad_];
    end
end
if ~DRAW_SEPARATE
    figure
    show_all_circles(I,cx,cy,rad);
end


% debug output
function [] = debug_montage(label, space)
    [height,width,levels] = size(space);
    tmp = zeros(height,width,1,levels);
    for i=1:levels; tmp(:,:,:,i)=space(:,:,i); end;
    figure('Name', label);
    montage(tmp);
end

