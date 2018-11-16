clear all
close all

DOHALFSIZE=true;        % process half sized image in addition?
DEBUG=false;
DRAW_SEPARATE=false;    % draw circles for each scale in separate image?
%FILENAME='res/butterfly.jpg';
FILENAME='res/dalmatian.png';
%FILENAME='res/mytest.png';

% parameters
sigma0 = 2;    % initial sigma
k      = 1.25; % k - factor to increase sigma by each level
levels = 10;   % number of levels to process
thresh = 0.20; %0.15;    % threshold for local maxima % TODO

% threshold butterfly: 0.15 < t < 0.25 -> 0.20 looks good
% threshold dalmatian: 0.15 < t < 0.25 -> 0.20 looks good

% read image
I = im2double(imread(FILENAME));

% convert color images to grayscale
if ndims(I) > 2
    I = rgb2gray(I);
end

for halfsizeloop = 1:2
    % pass = 1: do full size image
    % pass = 2: do half size image

    % resize to half
    if halfsizeloop == 2
        if DOHALFSIZE
            I = imresize(I, 0.5);
        else
            break;
        end
    end


    % --- Create scale space matrix ------------------------------------------
    [height,width] = size(I);
    scale_space = zeros(height,width,levels);

    sigma = sigma0;
    for i = 1:levels
        % create a LoG filter of appropriate size and scale it by sigma^2
        hsize = 2 * floor(3 * sigma) + 1;
        log = sigma*sigma*fspecial('log', hsize, sigma);

        % convolve with the image and store values in the scalespace
        scale_space(:,:,i) = imfilter(I, log, 'replicate', 'same');

        % increase sigma
        sigma = sigma * k;
    end
    orig_scale_space = scale_space; % keep the original response for later

    % work with the absolute response values
    scale_space = abs(scale_space);

    if DEBUG, debug_montage('Scale space', scale_space), end;


    % --- Non-maximum-suppression -------------------------------------------

    % for each level: set maxima to the value of the maximal neighbour
    %                 inside this level
    levelmax = zeros(height,width,levels);
    for i = 1:levels
        % wayyyyy too slow...
        % maxfunc=@(x) max(x(:));
        % max_space(:,:,i) = nlfilter(scale_space(:,:,i), [3 3], maxfunc);

        % much faster:
        levelmax(:,:,i) = colfilt(scale_space(:,:,i), [3 3], 'sliding', @max);
    end
    if DEBUG, debug_montage('Maxima per level', levelmax), end;

    % calculate maxima between level-neighbourhoods.
    % - we already have set the maxima IN each level
    % - now perform a max operation along the 3rd dimension between neighbouring levels
    % ATTN: we need to use a separate matrix for the results, because we still need
    %       the original values to calc other levels
    %       (actually we only need to buffer 3 levels - could optimize mem)
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

    % draw a circle for each detected blob, with radius proportional to
    % sigma => circle should cover the actual blob
    cx = []; cy = []; rad = []; lev = [];
    for i = 1:levels
        sigma = sigma0 * k^(i-1);
        radius = sqrt(2) * sigma;
        [cy_,cx_] = find(scale_space(:,:,i));
        rad_ = zeros(size(cx_));
        rad_(:) = radius;
        lev_ = zeros(size(cx_));
        lev_(:) = i;
        if DRAW_SEPARATE
            if size(cx_) > 0
                figure('Name',sprintf('Level %d',i));
                show_all_circles(I,cx_,cy_,rad_);
            end
        else
            cx  = [cx;cx_];
            cy  = [cy;cy_];
            rad = [rad;rad_];
            lev = [lev;lev_];
        end
    end
    if ~DRAW_SEPARATE
        figure
        show_all_circles(I,cx,cy,rad);


        % let the user pick keypoints to analyze further
        disp('Select blobs to analyze, double-click or press Enter to finish.');
        [xs,ys] = getpts;

        % find the closest blob centers to the clicked coordinates
        ixs = zeros(size(xs,1),1);
        for i=1:size(xs)
            d = (cx - xs(i)).^2 + (cy - ys(i)).^2;
            [~,ix] = min(d);
            ixs(i) = ix;
        end

        for i=1:size(ixs)
            ix = ixs(i);
            if halfsizeloop==1;
                shalf = '(Full)';
            else
                shalf = '(Half)';
            end

            % show a separate image with selected blobs marked only
            % figure; show_all_circles(I,[cx(ix)],[cy(ix)],[rad(ix)]);

            % plot LoG response for selected keypoint
            info = sprintf('%s Blob %d: x=%d y=%d level %d (\\sigma=%f)', ...
                    shalf, i, cx(ix), cy(ix), lev(ix), sigma0 * k^(lev(ix)-1));
            plot_log_response(info, cx(ix), cy(ix), orig_scale_space, sigma0, k);
        end
    end

end % halfsizeloop

% plot the LoG response for given coordinates
% function plot_log_response(info,x,y,scalespc,sigma0,k)
%     disp(info);
% 
%     levels = size(scalespc,3);
%     vals = reshape(scalespc(y,x,:), [levels 1])
%     sigs = (sigma0 * k.^((1:levels)-1))'
%     
%     figure('Name', 'LoG response');
%     plot(sigs,vals);
%     title(info);
%     xlabel('\sigma');
%     ylabel('LoG response');
% end

function plot_log_response(info,x,y,scalespc,sigma0,k)
    disp(info);

    levels = size(scalespc,3);
    vals = reshape(scalespc(y,x,:), [levels 1]);
    lvls = 1:levels; % 0:(levels-1);
    sigs = (sigma0 * k.^((1:levels)-1))';
    
    figure('Name', 'LoG response');
    plot(lvls,vals);
    grid on;

    % second x-axis for sigma - how ?
    
    title(info);
    xlabel('Scale level');
    ylabel('LoG response');
    
end

% debug output
function [] = debug_montage(label, space)
    [height,width,levels] = size(space);
    tmp = zeros(height,width,1,levels);
    for i=1:levels; tmp(:,:,:,i)=space(:,:,i); end;
    figure('Name', label);
    montage(tmp);
end

