function distortion = distortionMeasure(data,indicator,means)
%DISTORTIONMEASURE Summary of this function goes here
%   Detailed explanation goes here
    meanOfPixel = indicator*means; %Gives mean of cluster associated to cluster of specific pixel
    difference = data - meanOfPixel; %diff from pixel to mean
    %norms = vecnorm(difference,2,2); %norm of data of each pixel, along second dimension
    norms = sum(difference.^2,2);
    distortion = sum(norms(:)); 
end

