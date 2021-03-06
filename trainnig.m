
%% Training images

original = imshow('Trainimages/rose/54.jpg');
RGB = imread('Trainimages/rose/54.jpg')

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

%f=im2bw(maskedImage);
%imshow(f)

%% perform Erosion
s=strel('disk',2,0);
F=imerode(BW,s);
%imshow(BW-F);

%disp(mean2(BW-F));

%% Creating bounding box around boundary image
stats = regionprops(BW-F, 'BoundingBox');
crop_region = stats.BoundingBox; 

%% Crop image around boundary
j = imcrop(BW-F, crop_region);

%% Resize boundary extracted image
f = imresize(j, [64 64]);
%imshow(f);

%% sample subplot

%subplot(2,2,1);
%imshow(RGB)
%title('Original image')

%subplot(2,2,2);
%imshow(BW)
%title('Segmented Binary image')

%subplot(2,2,3);
%imshow(BW-F)
%title('Boundary Extracted image')

%subplot(2,2,4);
%imshow(f)
%title('resized image 64x64')

c=input('Enter the Class(Number from 1-2)');

%% Feature Extraction
F=FeatureStatistical(f);
try 
    load db;
    F=[F c];
    db=[db; F];
    save db.mat db 
catch 
    db=[F c]; % 10 12 1
    save db.mat db 
end




