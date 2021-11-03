
%% Training images

original = imshow('Trainimages/rose/40.jpg');
RGB = imread('Trainimages/rose/40.jpg');

%% segmentation using grabcut method
L = superpixels(RGB,500);
h1 = drawpolygon(gca,'Color','r');

roiPoints = h1.Position;
roi = poly2mask(roiPoints(:,1),roiPoints(:,2),size(L,1),size(L,2));

BW = grabcut(RGB,L,roi);
figure
imshow(BW)


maskedImage = RGB;
maskedImage(repmat(~BW,[1 1 3])) = 0;
figure;
imshow(maskedImage)


%% perform Erosion
s=strel('disk',2,0);
F=imerode(BW,s);
imshow(BW-F);


%% Creating bounding box around boundary image
stats = regionprops(BW-F, 'BoundingBox');
crop_region = stats.BoundingBox; 

%% Crop image around boundary
j = imcrop(BW-F, crop_region);
imshow(j)

%% Resize boundary extracted image
f = imresize(j, [64 64]);
imshow(f);



