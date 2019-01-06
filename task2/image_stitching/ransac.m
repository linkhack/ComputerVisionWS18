function [tform,inlierIdx] = ransac(P1,P2, NumRounds,Threshold)
%RANSAC Random Sample Concensus on two sets of 2D points
%   P1 set of 2D-points [x1 y1; x2 y2; ... ] to transform
%   P2 set of 2D-points (target positions)
%   NumRounds (optional) number of RANSAC rounds (default 1000)
%   Threshold (optional) threshold for inliers   (default 5)
%
%   Returns [tform,inlierIdx]

if nargin > 2
    N = NumRounds;
else
    N = 1000; % default #rounds
end;
if nargin > 3
    T = Threshold;
else
    T = 5; % default threshold
end;

T_squared = T.^2; % we compare with T^2 for performance reasons
bestInliers = 0;  % number of best inliers

% temporarily disable "Matrix is close to singular..." warning
old_warnings = warning('off', 'MATLAB:nearlySingularMatrix');

for i = 1:N
    ok = false;
    while ~ok  % might need to retry when picking bad points
        idx = randsample(1:size(P1,1), 4); % pick 4 random matched points
        Ps1 = P1(idx,:); % sample coordinates from image 1
        Ps2 = P2(idx,:); % and image 2
        try
            tform = fitgeotrans(Ps1, Ps2, 'projective'); % calc transformation
            ok = true;
        catch
        end
    end

    P1trans = transformPointsForward(tform, P1); % transform ALL P1
    d2 = sum((P2 - P1trans).^2, 2); % squared distances between P1trans/P2
    
    inliers = sum(d2 < T_squared); % inliers lie closer than distance T
    if inliers > bestInliers
        bestInliers = inliers; % remember how many inliers
        bestInlierIdx = find(d2 < T_squared); % and which points
    end
end

% now calculate the final transform ONLY from the inliers of the best
% transform found so far
Ps1 = P1(bestInlierIdx,:);
Ps2 = P2(bestInlierIdx,:);
tform = fitgeotrans(Ps1, Ps2, 'projective'); % the final transformation

% and calc the final inlier indices (like in the loop)
P1trans = transformPointsForward(tform, P1);
d2 = sum((P2 - P1trans).^2, 2);
inlierIdx = find(d2 < T_squared); % the final inliers

warning(old_warnings); % restore warnings
end

