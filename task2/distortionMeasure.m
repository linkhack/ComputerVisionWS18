function distortion = distortionMeasure(data,indicator,centroids)
%DISTORTIONMEASURE Calculates the distortion measure as defined in
%assignment
%   Detailed explanation goes here
    meanOfPixel = indicator*centroids; %Gives centorid of cluster associated to cluster of specific pixel
    difference = data - meanOfPixel; %diff from pixel to centroid
    norms = sum(difference.^2,2); %norm squared is faster
    distortion = sum(norms(:)); 
end

