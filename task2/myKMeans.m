function [centers,indicatorMatrix] = myKMeans(data,K,threshold)
%KMEANS Summary of this function goes here
%   Detailed explanation goes here

    n = size(data,1);
    dimension = size(data,2);
    centers = rand(K,dimension);
    indicatorMatrix = assignToCenter(data,centers);
    improvement = threshold + 1;
    iter=1;
    distortionOld=distortionMeasure(data,indicatorMatrix,centers);
    while improvement>threshold
        iter=iter+1
        centers = (indicatorMatrix'*data);
        members = sum(indicatorMatrix)';
        centers = centers./members;

        indicatorMatrix = assignToCenter(data,centers);
        distortion=distortionMeasure(data,indicatorMatrix,centers);
        improvement = abs(1- distortionOld/distortion);
        distortionOld=distortion;
    end
end

