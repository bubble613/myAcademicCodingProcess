%% 1
% 读入图像并灰度化
I = imread('test.jpg');
I = rgb2gray(I);
% 生成高斯滤波器的核
w = fspecial('gaussian',3,0.5);
size_a = size(I);
% 进行高斯滤波
g = imfilter(I,w,'conv','symmetric','same');
% 降采样
t = g(1:2:size_a(1),1:2:size_a(2));
% 显示结果
figure(1);imshow(I);
figure(2);imshow(t);


%% 2
% 金字塔分解函数实现
close all;clear all;clc;
img=imread('qingdao.jpg');
n=3;
%[ pyr ] = genPyr( img, 'gauss', n );%高斯金字塔分解
[ pyr ] = genPyr( img, 'laplace', n );%拉普拉斯金字塔分解
for i=1:n
    figure(i);
    imshow(pyr{i});
end