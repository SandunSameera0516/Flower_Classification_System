%% Test Image
clc;
clear all;
close all;
original = imshow('testimages/3.jpg');
RGB = imread('testimages/3.jpg')
%disp(RGB);


%% segmentation using grabcut method
L = superpixels(RGB,500);
h1 = drawpolygon(gca,'Color','r');

roiPoints = h1.Position;
roi = poly2mask(roiPoints(:,1),roiPoints(:,2),size(L,1),size(L,2));
BW = grabcut(RGB,L,roi);
%figure
%imshow(BW)

maskedImage = RGB;
maskedImage(repmat(~BW,[1 1 3])) = 0;
%figure;
%imshow(maskedImage)

%% perform Erosion
s=strel('disk',2,0);
F=imerode(BW,s);
imshow(BW-F);


%% Creating bounding box around boundary image
stats = regionprops(BW-F,'BoundingBox');
crop_region = stats.BoundingBox;

%% Crop image around boundary
j = imcrop(BW-F, crop_region);

%% Resize boundary extracted image
f = imresize(j, [64 64]);


%% Find the class the test image belongs
Ftest=FeatureStatistical(f);
%disp(Ftest)



%% Compare with the feature of training image in the database
load db.mat
Ftrain=db(:,1:2);
Ctrain=db(:,3);

for (i=1:size(Ftrain,1));
    %disp(strcat('this',Ftrain(i,:)));
    dist(i,:)=sum(abs(Ftrain(i,:)-Ftest));
    %disp(dist(i,:))
end   

m=find(dist==min(dist),1);
det_class=Ctrain(m);

%% detecting flower according to the class
flower="";

switch det_class
    case 1
        flower="daisy";
    case 2
       flower="rose";
end


%% final output

subplot(2,3,1);
imshow(RGB)
title('Original image')

subplot(2,3,2);
imshow(maskedImage)
title('Segmented image')

subplot(2,3,3);
imshow(BW-F)
title('Boundary Extracted image')

subplot(2,3,4);
imshow(f)
title('resized image 64x64')

subplot(2,3,5);
imshow(RGB)
title(strcat('Detected Flower is :',flower))

