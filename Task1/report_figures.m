%% Comparison of coordinates an no coordinates

K=3;
precision = 0.0000001;

figure()

image1 = image_segmentation('./res/future.jpg', K, precision, false, false);
subplot(2,2,1)
imshow(image1)
title("K=3, no coordinates used")

image2 = image_segmentation('./res/future.jpg', K, precision, true, false);
subplot(2,2,2)
imshow(image2)
title("K=3, coordinates used")

K=5;
image1 = image_segmentation('./res/future.jpg', K, precision, false, false);
subplot(2,2,3)
imshow(image1)
title("K=5, no coordinates used")

image2 = image_segmentation('./res/future.jpg', K, precision, true, false);
subplot(2,2,4)
imshow(image2)
title("K=5, coordinates used")

%%
K=3;
figure()
image1 = image_segmentation('./res/mm.jpg', K, precision, false, false);
subplot(2,2,1)
imshow(image1)
title("K=3, no coordinates used")

image2 = image_segmentation('./res/mm.jpg', K, precision, true, false);
subplot(2,2,2)
imshow(image2)
title("K=3, coordinates used")


K=5;
image1 = image_segmentation('./res/mm.jpg', K, precision, false, false);
subplot(2,2,3)
imshow(image1)
title("K=5, no coordinates used")

image2 = image_segmentation('./res/mm.jpg', K, precision, true, false);
subplot(2,2,4)
imshow(image2)
title("K=5, coordinates used")

%%
figure()
K=3;
image1 = image_segmentation('./res/simple.PNG', K, precision, false, false);
subplot(2,2,1)
imshow(image1)
title("K=3, no coordinates used")

image2 = image_segmentation('./res/simple.PNG', K, precision, true, false);
subplot(2,2,2)
imshow(image2)
title("K=3, coordinates used")

K=5;
image1 = image_segmentation('./res/simple.PNG', K, precision, false, false);
subplot(2,2,3)
imshow(image1)
title("K=5, no coordinates used")

image2 = image_segmentation('./res/simple.PNG', K, precision, true, false);
subplot(2,2,4)
imshow(image2)
title("K=5, coordinates used")

%%
%%Hard to see stuff, so do K=5 image = mm.jpg with distinct colors
figure()
K=3;
image1 = image_segmentation('./res/mm.jpg', K, precision, false, true);
subplot(1,2,1)
imshow(image1)
title("K=5, no coordinates used")

image2 = image_segmentation('./res/mm.jpg', K, precision, true, true);
subplot(1,2,2)
imshow(image2)
title("K=5, coordinates used")

%%
% Change number of clusters. As we don't see results very good. Use
% distinct colors

Karray = [3,5,7,10,25,50];

%without coordinates
figure()
for i = 1:6
    seg_image = image_segmentation('./res/mm.jpg',Karray(i),precision,false,true);
    subplot(3,2,i)
    imshow(seg_image)
    title("K= " + Karray(i) + ", no coordinates used")
end
%%
figure()
for i = 1:6
    seg_image = image_segmentation('./res/mm.jpg',Karray(i),precision,true,true);
    subplot(3,2,i)
    imshow(seg_image)
    title("K= " + Karray(i) + ", coordinates used")
end

%%
%Bad initialization. Run the segmentation 20 times and shpw result
for i=1:20
    figure()
    seg_image = image_segmentation('./res/simple.PNG',3,precision,false,true);
    imshow(seg_image)
    title("Bad initialization")
end

