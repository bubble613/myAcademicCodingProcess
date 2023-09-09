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
% imgpad = padarray(image, [1 1], 'replicate', 'both'); % 扩展图像
imgpad = padarray(image, [3 3], 'symmetric', 'both'); % 扩展图像 镜像复制

% 7x7 窗口
w = 3;
imgLocalEntropy = zeros(M, N);
% imgpadLocalEntropy = zeros(M+3, N+3);
for i = 1+3 : M+3
    for j = 1+3 : N+3
        Histogram = imhist(imgpad(i-w : i+w, j-w : j+w));
        Histogram = Histogram / (7*7);
        TempEntropy = Histogram .* log(Histogram);
        TempEntropy(isinf(TempEntropy)) = 0;
        TempEntropy(isnan(TempEntropy)) = 0;

        imgLocalEntropy(i-3, j-3) = -sum(TempEntropy);
        % imgLocalEntropy(i-3, j-3) = shannonEntropyThresholding(Histogram);
    end
end

alpha1 = 0.8; % 值不一定 0.8-0.9  0.6-1.0
ET1 = alpha1 * max(imgLocalEntropy(:));
alpha2 = 0.9;
ET2 = alpha2 * max(imgLocalEntropy(:));

%% example
% I = imread('eight.tif');
% figure, imshow(I)
% J = imnoise(I,'salt & pepper',0.02);
% K = medfilt2(J);
% imshowpair(J,K,'montage')

%% 续
imgbw = zeros(M,N);
for i = 1:M
    for j = 1:N
        if imgLocalEntropy(i, j) >= ET1
            imgbw(i, j) = 1;
        end
    end
end
imgd = double(image);
imgbw1 = imgbw .* imgd;
threshold1 = sum(imgbw1(:)) / nnz(imgbw1);
% imgbw2 = imgbw .* double(image);
[counts, ~] = imhist(uint8(imgbw1));

[~, threshold2] = max(counts(2:256));

imgbw3 = subim2bw(imgd, threshold1);
imgbw4 = subim2bw(imgd, threshold2);
imgbw5 = medfilt2(imgbw3);
figure(4),
subplot(221), imshow(imgbw), title('过渡区提取');
subplot(222), imshow(imgbw1), title('过渡区在原图上的位置');
subplot(223), imshow(imgbw3), title('过渡区灰度值-均值阈值');
subplot(224), imshow(imgbw4), title('过渡区灰度值-众数阈值');


figure(100), imshow(imgbw5), title('中值滤波处理后的结果图像');