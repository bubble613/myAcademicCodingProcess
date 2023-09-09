%% 1
clc; clear; close all; % clc清除命令行，clear清除存在内存里的数据，close关闭打开了的文件，

I = imread('coins.png');
imshow(I);
I = im2double(I);
threshold = graythresh(I);
[m, n] = size(I);
imgbw1 = imbinarize(I, threshold);
figure(2),
subplot(331), imshow(imgbw1); title('Otsu阈值化的二值图像');

se = strel('square',3);
I2 = imopen(imgbw1, se);
subplot(332), imshow(I2); title('开操作后的二值图像');

I_bg = imdilate(I2, se);
I_fg = imerode(I2, se);

unknown1 = zeros(m, n);
% unknown = setxor(I_bg, I_fg);
unknown1((I_bg & ~I_fg) | (~I_bg & I_fg)) = 1;

subplot(3, 3, 3), imshow(I_bg); title('膨胀操作后的背景二值图像');
subplot(3, 3, 4), imshow(I_fg); title('腐蚀操作后的前景二值图像');
subplot(3 ,3, 5), imshow(unknown1, []); title('相减后的二值未知区域图像');

%% 距离变换图像
% D = bwdistgeodesic(BW,C,R);
D = bwdist(~I2);
imshow(D);
D = -D;
subplot(336)
imshow(D,[])
title('Complement of Distance Transform')
sure_fg = imbinarize(D, 0.5);
sure_bg = im2double(I_bg);
unknown2 = zeros(m, n);
unknown2((sure_bg & ~sure_fg) | (~sure_bg & sure_fg)) = 1;
subplot(337), imshow(sure_bg); title('背景二值图像');
subplot(338), imshow(sure_fg, []); title('前景二值图像');
subplot(339), imshow(unknown2); title('相减后的二值未知区域图像');