clc, clear, close all;

[fileName,pathName] = uigetfile({'*.*';'*.tif';'*.tiff';'.bmp';'.jpg'},...
                                'Select the original image file');
fileName = strcat(pathName,fileName);
img = imread(fileName);
if (size(img,3) == 3)%如果是三通道图像，将其转化为单通道图像
    figure,imshow(img),title('Original Color Image');
    img = rgb2gray(img);
end
figure,imshow(img),title('Original Image');
figure,imhist(img),title('Image histogram');
image = im2double(img);
[m, n]=size(image);

p = imhist(img);
p = p / (m * n);

%% 1
[gx, gy] = imgradientxy(image, 'sobel');
subplot(221), imshow(gx);
subplot(222), imshow((gx + 4)/8);
subplot(223), imshow((gy + 4)/8);
subplot(224), imshow(gy);

[gmag, gdir] = imgradient(gx, gy);
figure(4),
% gmag = sqrt(gx^2+gy^2), so:[0, (4*sqrt(2))]
subplot(121), imshow(gmag / (4 * sqrt(2)));
% angle in degrees [-180 , 180]
subplot(122), imshow((gdir + 180.0) / 360.0); 

my_grad = select_gdir(gmag, gdir, 1, -15, 15); % ~0 deg
figure(5),
imshow(my_grad);

%% 梯度图
gradient = zeros(m,n);
for i = 1:m-1
    for j = 1:n-1
        gx = abs(image(i+1,j) - image(i,j) );
        gy = abs(image(i,j+1) - image(i,j) );
        grad = gx + gy;
        gradient(i,j) = grad;
    end
end
figure('Numbertitle','off','name','gradient');
imshow(gradient);

%合成
compose = image + gradient;
compose = im2uint8(compose);
figure('Numbertitle','off','name','合成');
imshow(compose);

