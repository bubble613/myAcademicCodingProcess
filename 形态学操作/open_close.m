% 开启和闭合操作 用 MATLAB实现开启和闭合操作
clc;clear;close; % clc清除命令行，clear清除存在内存里的数据，close关闭打开了的文件，

I=imread('cameraman.tif');  % 载入图像
figure(1),
subplot(2,2,1), imshow(I); title('原始图像');
axis on;                    % 显示坐标系
I1 = im2gray(I);
subplot(2,2,2), imshow(I1); title('灰度图像');
axis on;                    %显示坐标系
% se = strel('square',4);     %采用半径为4的矩形作为结构元素
se = strel('square',6);     %采用半径为6的矩形作为结构元素
I2 = imopen(I1,se);         %开启操作
I3 = imclose(I1,se);        %闭合操作
subplot(2,2,3), imshow(I2); title('开启运算后图像');
axis on;                    %显示坐标系
subplot(2,2,4), imshow(I3); title('闭合运算后图像');
axis on;                    %显示坐标系

%% 2 imerode()  imdilate()
% 腐蚀运算是一种消除边界点，使边界点向内部收缩的过程。
% 因此，腐蚀运算常用来消除图像中一些小且无意义的物体；
% 使用腐蚀运算消除图像的背景部分，也可以产生滤波器的效果。
figure(2),
J_erode = imerode(I, se); % 使用结构元素 SE 腐蚀灰度、二值或压缩二值图像 I
subplot(121), imshow(J_erode); title('腐蚀图像');

% 膨胀运算是将与物体接触的所有背景合并到该物体中，使边界向外扩张的过程。
% 因此，膨胀运算可以用来填补物体中的空洞及消除目标物体中的小颗粒噪声。
% 在处理上面一张字迹不清的图片时，用膨胀运算填补字迹的空洞，从而使字迹更加清晰。
J_dilate = imdilate(I, se); % 使用结构元素 SE 膨胀灰度、二值或压缩二值图像 I
subplot(122), imshow(J_dilate); title('膨胀图像');

% 开运算对图像先腐蚀后膨胀。开运算去除了白点，能够除去孤立的小点，
% 毛刺和粘连，而总的位置和形状不变。开运算是一个基于几何运算的滤波器。
% 结构元素大小的不同将导致滤波效果的不同。
% 不同的结构元素的选择导致了不同的分割，即提取出不同的特征。
% 闭运算对图像先膨胀后腐蚀。闭运算去除了黑点，能够填平目标物中的小孔，弥合小裂缝，
% 而总的位置和形状不变。闭运算是通过填充图像的暗块来滤波图像的。
% 结构元素大小的不同将导致滤波效果的不同。不同结构元素的选择导致了不同的弥合

%% bwareopen()  imclose()  imfill()
I01=rgb2gray(RGB01);
threshold=graythresh(I01);
bw01=im2bw(I01,threshold);%阈值分割二值化
subplot(222);
imshow(bw01);title('二值图像');

bw02=bwareaopen(bw01,30);%形态学开运算去除像素小于30的目标
subplot(223);
imshow(bw02);title('开运算去除噪声');

sse=strel('disk',2);
bw03=imclose(bw02,sse);%对图像进行填充缝隙和孔洞
subplot(224);
imshow(bw03);title('填充后的图像');