function [] = mainSimple(iterateTimes,k)
% 函数调用示例
% `
% close all;mainSimple(10,1);

% 函数功能：观察提取的过渡区域及过渡区灰度直方图形状

% 函数参数：
% iterateTimes：控制多尺度乘积的次数,建议在10以下；
% k：控制从多尺度乘积图像提取过渡区的参数，初步建议取值1到10。
% 多尺度乘变换后的图像精确过渡区被尽可能的提取，

iterateTimes = 10;
k = 2;

[fileName,pathName] = uigetfile({'*.*';'*.jpg';'*.*'},'File Selector');
fileName = strcat(pathName,fileName);
originalImg = imread(fileName);
if (size(originalImg,3)==3) 
    originalImg = rgb2gray(originalImg);
end

% 缓存图片
imgTemp = ones(size(originalImg));
% 目前只使用了水平方向的多尺度乘积，
imgfilter = subMakeFilterConv(iterateTimes,originalImg);
% 后面是否再使用垂直方向的多尺度乘积可以视需要而定

t = zeros(iterateTimes,1);

for i = 1:iterateTimes
    imgTemp = imgTemp .* imgfilter(:,:,i);
    imgTempNormal = im2uint8(mat2gray(imgTemp));%规范化多尺度乘积图像，
    figure(199),subplot(2,iterateTimes/2,i),imshow(imgTempNormal);
    
    imgTempMask = imgTempNormal>=k;
    figure(200),subplot(2,iterateTimes/2,i),imshow(imgTempMask);
    
    tranRegion = originalImg(imgTempMask);
    t(i) = mean(tranRegion);
    
    figure,histogram(double(tranRegion),256);
end
figure,plot(t,'r.-');
disp(t);

[IDX, C] = kmeans(t,2) 
%将t聚成两类，为探测平稳性做准备。后面也可以考虑其它的
% 平稳性检测方法。
% 找到过渡区均值稳定的一类，对其进行处理

    