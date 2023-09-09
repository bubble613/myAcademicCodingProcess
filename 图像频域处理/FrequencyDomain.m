%(1) 计算并画出此图像的中心化频率谱。
clear;clc;close all;
[fileName,pathName] = uigetfile({'*.*';'*.jpg';'*.*'},'File Selector');
fileName = strcat(pathName,fileName);
originalImg = imread(fileName);
if (size(originalImg,3)==3)
    originalImg = rgb2gray(originalImg);
end
temp_image = originalImg;%读文件
I = im2gray(temp_image);%将图象变为黑白
P = double(I);
M = im2double(I);%转化为归一化二维矩阵
Q = fft2(P);%转化为二维矩阵
N = fft2(M);
move1 = fftshift(N);%将频谱转到中心
move2 = fftshift(Q);
figure()
subplot(1,2,1),imshow(I);title 原图;
subplot(1,2,2),imshow(log(abs(move1)+1),[]);title 中心化频率谱;

%(2) 分别用高斯低通和高斯高通滤波器对图像进行频域处理。
[row,col] = size(move2);
d0 = 10;%截止频率为10，数值越小越平滑
row1 = fix(row / 2);
col1 = fix(col / 2);
for i = 1:row %d0为10的高斯低/高通滤波器
    for j = 1:col
        d = sqrt((i - row1)^2 + (j - col1)^2);
        hl(i,j) = exp(-d^2 / (2 * d0^2));%高斯低通滤波器
        hh(i,j) = 1 - hl(i,j);%高斯高通滤波器
        gl(i,j) = hl(i,j) * move2(i,j);%高斯低通滤波
        gh(i,j) = hh(i,j) * move2(i,j);%高斯高通滤波
    end
end
gl = ifftshift(gl);%对图像进行反FFT移动
gl = ifft2(gl);%进行二维傅立叶反变换
Kl = uint8(real(gl));
gh = ifftshift(gh);%对图像进行反FFT移动
gh = ifft2(gh);%进行二维傅立叶反变换
Kh = uint8(real(gh));
figure()
subplot(2,2,1),imshow(I);
title 原图;
subplot(2,2,3),imshow(Kl);
title 高斯低通滤波处理后图;
subplot(2,2,4),imshow(Kh);
title 高斯高通滤波处理后图;

%(3)用频域拉普拉斯算子对此图像进行锐化处理。
Lap_count = fspecial('laplacian');%lapalacefilter
image_lap1 = filter2(Lap_count,M,'same');%用lapalace滤波
image_lap = M - image_lap1;
image_adjust = imadjust(image_lap,[],[0,0.8]);
figure()
subplot(2,2,1),imshow(I);
title 原始图象;
subplot(2,2,2),imshow(image_lap1);
title 拉普拉斯锐化处理后图象;
subplot(2,2,3),imshow(image_lap1,[]);
title 标定后图象;
subplot(2,2,4),imshow(image_adjust,[]);
title 增强的结果;