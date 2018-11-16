function [centers,indicatorMatrix] = myKMeans(data,K,threshold)
%KMEANS Calculates k-means clustering of data with K clusters
%   

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
        
        improvement = abs(1- distortionOld/distortion);
        distortionOld=distortion;
    end
end

