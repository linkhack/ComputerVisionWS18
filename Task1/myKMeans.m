function [centers,indicatorMatrix] = myKMeans(data,K,threshold)
%KMEANS Calculates k-means clustering of data with K clusters
%   data data matrix Data(i,:) is ith data point
%   K = number of clusters
%   precision = threshold-1 used for convergence check
%
%   Algorithm:
%       1. Assign random vectors as centroids
%       2. Assign each data point to its nearest center and record this in
%          a indicator Matrix
%       3. Update each centroid as mean of all data associated to it
%       4. Check for convergence of distortion. If not goto step 2

    n = size(data,1); %number of data points
    dimension = size(data,2); %dimension of one datapoints
    centers = rand(K,dimension); %initialize centers randomly
    indicatorMatrix = assignToCenter(data,centers); %assign data to the nearest center
    improvement = threshold + 1;
    
    iter=1;
    
    %distortion measure for stopping loop
    distortionOld=distortionMeasure(data,indicatorMatrix,centers);
    
    while improvement>threshold
        iter=iter+1
        
        % Calculate mean of datapoints assigned to each cluster
        centers = (indicatorMatrix'*data); % sum of data points in each cluster
        members = sum(indicatorMatrix)'; % number of data points in each cluster
        centers = centers./members; % mean of cluster = (sum of data in cluster)/(number of points in cluster)

        indicatorMatrix = assignToCenter(data,centers);
        
        distortion=distortionMeasure(data,indicatorMatrix,centers);
        
        %We want to allow that distortion can get worse -> ratio and
        %absolute value. ratio because we don't know abbsolute value or
        %typical change
        
        improvement = abs(1- distortion/distortionOld);
        distortionOld=distortion;
    end
end

