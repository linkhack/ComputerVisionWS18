function [segmented_image, centers, indicator_matrix] = image_segmentation(image_path,K,threshold,use_coordinates,distinct_colors)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    if nargin<2
        throw MException("image_segmentation:NotEnoughParameters","Some Parameters are missing")
    end
    switch nargin
        case 2
            threshold = 0.001;
            use_coordinates = true;
            distinct_colors = false;
        case 3
            use_coordinates = true;
            distinct_colors = false;
        case 4
            distinct_colors = false
    end
    
    %load image
    image = imread(image_path);
    image = im2double(image);

    %calculating dimensions for reshape
    dimensions = size(image);
    if(size(dimensions,2)==2)
        dimensions=[dimensions, 1];
    end

    %calculating coordinates and scaling them to [0 1]
    [X,Y] = meshgrid(1:dimensions(2),1:dimensions(1)); %first dimension is y, second is x
    X=X/dimensions(2);
    Y=Y/dimensions(1);
    coordinates = cat(3,Y,X);
    if use_coordinates
        image = cat(3,image,coordinates);
    end

    %vectorize image
    imageVector = reshape(image,[],size(image,3));
    
    %calculating k-means. Gets centers and indicator matrix
    [centers, indicator_matrix] = myKMeans(imageVector,K,threshold);
    
    %plotting stuff
    %color pixel with color of center
    %ktest3 = eye(3,5); %use this for 3 clusters, gives red,green or blue for respective segment
    if distinct_colors
        segmented_image = indicator_matrix*distinguishable_colors(K);
    else
        segmented_image = indicator_matrix*centers;
    end
    segmented_image = reshape(segmented_image(:,1:dimensions(3)),dimensions); %color is at position 1,2,3
end

