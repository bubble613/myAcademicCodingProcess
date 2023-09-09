%% 1
close all;clear all;clc;
in_img=imread('long.jpg');
[posr,posc]=Harris1(in_img,0.04);

C = cornermetric(I,'Harris');

%% 2
close all;clear all;clc;
% 运行时间长
img=imread('door.jpg');
img=rgb2gray(img);
points=harrislaplace(img);
draw(img,points,'角点检测');



