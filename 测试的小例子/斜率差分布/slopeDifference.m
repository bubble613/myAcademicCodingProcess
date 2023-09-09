clc;clear;
% close all；
% originalImg = imread("");
[fileName,pathName] = uigetfile({'*.*';'*.jpg';'*.*'},'File Selector');
fileName = strcat(pathName,fileName);
originalImg = imread(fileName);
if (size(originalImg,3)==3)
    originalImg = rgb2gray(originalImg);
end

% 归一化
% h是像素沿图像的垂直方向的索引，j是像素沿着图像的水平方向的索引。
[h, j] = size(originalImg);
originalImg = im2double(originalImg);
maxI = max(originalImg(:));
minI = min(originalImg(:));
ImgNormal = zeros(h, j);
% 将图像归一化到[0,255]内
for m = 1:h
    for n = 1:j
        ImgNormal(m, n) = 255 * (originalImg(m, n) - minI) / maxI;
    end
end

ImgNormal = mat2gray(ImgNormal);
[counts,binLocations] = imhist(ImgNormal);
P = zeros(256, 1);
% counts = double(counts);
for i = 1:256
    P(i, 1) = counts(i) / sum(counts(:));
end
% 归一化直方图分布
% [ntmp,xout] = hist(ImgNormal);
% tmin = min(t(:));
% tmax = max(t(:));
% nbins = round(tmax-tmin+1);
% [ntmp,xout] = hist(t(:),nbins);
% figure(50),
% bar(xout,ntmp);
% [xtmp,itmp] = max(ntmp);
% tMaxCount = tmin+itmp-1;

% 加窗操作 错误
% P_parzen = parzenwin(225);
% PParzen = counts(1:225,1).*P_parzen;
% for i = 3 : 256-3
%     PParzen(i-2 : i+2) = PParzen(i-2 : i+2) .* P_parzen;
% end

% 应用离散傅里叶变换滤波
F = fft(P, 256);
% F = fftshift(F);
FF = F;
W = 10; % 初始化为10 根据不同图像种类不同
for i = W + 1 : length(F) - W
    FF(i) = 0;
end

% PP1 = uint8(real(ifft(ifftshift(FF))));
PP = real(ifft(FF, 256));

subplot(121),plot(1:256,P),title("原图直方图");
subplot(122),plot(1:256,PP),title("通过低通DFT后的平滑直方图");

% 求解斜率 斜率差
N = 15;
P_pad = padarray(PP,[N,1],'symmetric');
P_pad = P_pad(:,1);
% P_pad = P_pad(2:length(P_pad)-1,1);

BLeft = zeros(N,2);
BLeft(:,2) = ones(N,1);
BRight = zeros(N,2);
BRight(:,2) = ones(N,1);
binB = [15:-1:1,2:256,255:-1:242];
binB = binB';
resultsR = zeros(2,256);
resultsL = zeros(2,256);
for i = N:256+N-1
    BLeft(:,1) = binB(i-N+1 : i);
    BRight(:,1) = binB(i : i+N-1);
    
%     YLeft = (P_pad(i-N+1 : i))';
%     YRight = (P_pad(i : i+N-1))';

    YLeft = (P_pad(i-N+1 : i));
    YRight = (P_pad(i : i+N-1));
    resultsR(:,i-N+1) = inv((BRight')*BRight)*(BRight')*YRight;
    resultsL(:,i-N+1) = inv((BLeft')*BLeft)*(BLeft')*YLeft;
%     num = num+1;
end

% B1(:,1) = 1:N;
% B2(:,1) = 1:N;
% Y1 = (-N:-1)';
% Y2 = (1:N)';
% resultsR = inv((B1')*B1)*(B1')*Y2;
% resultsL = inv((B1')*B1)*(B1')*Y1;
% resultsR与resultsL分别为右侧与左侧的[a,b]值 y = a*x + b
aRight = resultsR(1,:);
aLeft = resultsL(1,:);
s = aRight - aLeft;
sDiff = diff(s);
sZeros = find(sDiff == 0)
% binaryImg = originalImg>115;

plot(s)
hold on, plot(sDiff)
plot(1:length(s),zeros(length(s),1), 'k');
% 阈值选择
NClasses = 2;



