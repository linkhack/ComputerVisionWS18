function distortion = distortionMeasure(data,indicator,means)
%DISTORTIONMEASURE Calculates the distortion measure as defined in
%assignment
%   Detailed explanation goes here
    meanOfPixel = indicator*means; %Gives mean of cluster associated to cluster of specific pixel
    difference = data - meanOfPixel; %diff from pixel to mean
    norms = sum(difference.^2,2); %norm squared is faster
    distortion = sum(norms(:)); 
end

