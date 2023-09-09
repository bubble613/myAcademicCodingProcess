%% 1 LoG斑点(高斯拉普拉斯算子)
close all;clear all;clc;
% 运行时间较长
img=imread('sunflower.jpg');
imshow(img)
pt=log_Blob(rgb2gray(img));
draw(img,pt,'LoG Lindeberg');

%% 2 Gilles斑点
points = gilles(im,o_radius);


%% 3 