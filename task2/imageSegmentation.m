%constants
image_path = './Images/mm.jpg';
K = 2;
use_coordinates = true;
precision = 0.001;


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
[centers, indicatorMatrix] = myKMeans(imageVector,K,precision);


%ktest3 = eye(3,5); %use this for 3 clusters, gives red,green or blue for respective segment

%plotting stuff
%color pixel with color of center
%ktest3 = eye(3,5); %use this for 3 clusters, gives red,green or blue for respective segment
clusterImage = indicatorMatrix*centers;
imageReshape = reshape(imageVector(:,1:dimensions(3)),dimensions); %color info of center is in 1,2,3
clusterImage = reshape(clusterImage(:,1:dimensions(3)),dimensions);
figure()
imshow(imageReshape)
figure()
imshow(clusterImage)