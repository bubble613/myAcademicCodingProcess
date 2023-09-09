%% 清理命令
% 使用二维直方图在每一维上分别求s和t 
clear;
close all;
clc;

%% 引入图片
[fileName, pathName] = uigetfile({'*.*'; '*.bmp'; '*.jpg'}, 'Select the  original image file');
fileName = strcat(pathName, fileName);
image = imread(fileName);

if size(image, 3) == 3
    figure(1), imshow(image), title('Original Color Image');
    image = rgb2gray(image);
end

[M, N] = size(image);
figure(2),
imshow(image),
title('原始灰度图像');

%% 向图片添加噪声
% J = imnoise(I,'gaussian',m,var_gauss) 添加高斯白噪声，均值为 m，方差为 var_gauss。
% imgNg = imnoise(image,'gaussian');
% imgNs = imnoise(image, 'salt & pepper', 0.1);
%% 扩展图像边缘
% imgpad = padarray(image, [1 1], 'replicate', 'both'); 
% 扩展图像
imgpad = padarray(image, [1 1], 'symmetric', 'both'); % 扩展图像 镜像复制

% 7x7 窗口
m = 1;
% 局部方差矩阵
LV = zeros(M, N);

for i = 1+1 : M+1
    for j = 1+1 : N+1
        Temp = 0;
        Temp = sum(sum(power(imgpad(i-w : i+w, j-w : j+w) - mean(mean(imgpad(i-w : i+w, j-w : j+w))), 2)));
        LV(i-1, j-1) = Temp / (m * m - 1);
        
    end
end

% 全局阈值Tg
Tg = 0;
% for i = 1 : M
%     for j = 1 : N
%         image(i, j)
%     end
% end
Tg = sum(sum(image)) / M*N;
imgbw = zeros(M, N);
for i = 1 : M
    for j = 1 : N
        if LV(i, j) >= Tg
            imgbw(i, j) = 1;
        end
    end
end

%% 图像边缘细化



%% 图像边缘滤波



%% 图像边缘链接
% clear all;clc;
L=magic(128); L(2:26,43:68)=1; L(55:67,42:59)=1;
c4=chaincode4(L); %4连通边界链码
c8=chaincode8(L); %8连通边界链码  

%% 图像填充与目标区域滤波


