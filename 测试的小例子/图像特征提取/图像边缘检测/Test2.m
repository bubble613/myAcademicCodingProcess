%% 1 二维FIR的特定角度边缘检测
% 输入图像，并将其转化成灰度图像
I=imread('coins.png');
I=rgb2gray(I);

% 构造卷积核
% 提取右侧上方边缘
F1=[-1 0 0 -1 -1
     1 1 1 0 0];
% 进行卷积运算
A1=conv2(double(I),double(F1));
% 转换成8位无符号整型并显示
A1=uint8(A1);
figure(1);imshow(A1);

% 构造卷积核
% 提取左侧上方边缘
F2=[-1 -1 0 0 -1
     0 0 1 1 1];
% 进行卷积运算
A2=conv2(double(I),double(F2));
% 转换成8位无符号整型并显示
A2=uint8(A2);
figure(2);imshow(A2);

%% 2
close all;clear all;clc;
f=imread('qipan.jpg');
f=rgb2gray(f);
% 输入：f-待检测的图像
% alpha-检测角度
% 1表示H垂直方向
% 2表示V水平方向
% 3表示45度
% 4表示-45度
e1 = straightline(f,1);
e2 = straightline(f,2);
e3 = straightline(f,3);
e4 = straightline(f,4);
figure(1);imshow(f);
figure(2);imshow(e1);
figure(3);imshow(e2);
figure(4);imshow(e3);
figure(5);imshow(e4);