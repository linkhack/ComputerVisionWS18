image = imread('./Images/mm.jpg');
%image = imresize(image,0.5);
useCoordinates = 1

dimensions = size(image);
if(size(dimensions,2)==2)
    dimensions=[dimensions, 1];
end
image = im2double(image);
[X,Y] = meshgrid(1:dimensions(2),1:dimensions(1));
X=X/dimensions(2);
Y=Y/dimensions(1);
coordinates = cat(3,Y,X);
image = cat(3,image,coordinates);
imageVector = reshape(image,[],size(image,3));
[centers, indicatorMatrix] = myKMeans(imageVector,5,0.001);
clusterImage = indicatorMatrix*centers;
imageReshape = reshape(imageVector(:,1:dimensions(3)),dimensions);
clusterImage = reshape(clusterImage(:,1:dimensions(3)),dimensions);
imshow(imageReshape)
imshow(clusterImage)