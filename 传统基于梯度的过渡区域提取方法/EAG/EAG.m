clear;clc;close;

[fileName,pathName] = uigetfile({'*.*';'*.tif';'*.tiff';'.bmp';'.jpg'},...
                                'Select the original image file');
fileName = strcat(pathName,fileName);
img = imread(fileName);
if (size(img,3) == 3)% 如果是三通道图像，将其转化为单通道图像
    figure,imshow(img),title('Original Color Image');
    img = rgb2gray(img);
end
figure,imshow(img),title('Original Image');
figure,imhist(img),title('Image histogram');
image = double(img);
[m,n]=size(image);
f = image;

h = imhist(img);
h_1 = h / (m * n);

for i = 1:256
    muI(i) = (i - 1) * h_1(i);
end

gradient = zeros(m,n);
for i = 1:m-1
    for j = 1:n-1
        gx = abs(f(i+1,j) - f(i,j));
        gy = abs(f(i,j+1) - f(i,j));
        grad = gx + gy;
        gradient(i,j) = grad;
    end
end
figure('Numbertitle','off','name','gradient');
imshow(gradient, []);

TG = 0;
TP = 0;
p = zeros(m,n);
for i=1:m
    for j=1:n
        TG = TG + gradient(i,j);
        if gradient(i,j) ~= 0
            p(i, j) = 1;
            TP = TP + 1;
        end
    end
end

if TP ~= 0
    EAG_value = TG / TP;
end

%% 低端剪切
EAG_value_high = zeros(1, 256);
EAG_value_low = zeros(1, 256);
for L = 1:256
    f_low = f;
    for i = 1:m
        for j = 1:n
            if f(i, j) <= L
                f_low(i, j) = L;
            else
                f_low(i, j) = f(i,j);
            end
        end
    end
    gradient_low = zeros(m,n);
    for i = 1:m-1
        for j = 1:n-1
            gx_low(L) = abs(f_low(i+1,j) - f_low(i,j));
            gy_low(L) = abs(f_low(i,j+1) - f_low(i,j));
            grad_low(L) = gx_low(L) + gy_low(L);
            gradient_low(i,j) = grad_low(L);
        end
    end
    TG_low(L) = 0;
    TP_low(L) = 0;
    p_low = zeros(m,n);
    for i=1:m
        for j=1:n
            TG_low(L) = TG_low(L) + gradient_low(i,j);
            if gradient_low(i,j) ~= 0
                p_low(i, j) = 1;
                TP_low(L) = TP_low(L) + 1;
            end
        end
    end
    
    if TP_low(L) ~= 0
        EAG_value_low(L) = TG_low(L) / TP_low(L);
    end
    
    % 高端剪切
    f_high = f;
    for i = 1:m
        for j = 1:n
            if f(i, j) >= L
                f_high(i, j) = L;
            else
                f_high(i, j) = f(i,j);
            end
        end
    end
    gradient_high = zeros(m,n);
    for i = 1:m-1
        for j = 1:n-1
            gx_high(L) = abs(f_high(i+1,j) - f_high(i,j) );
            gy_high(L) = abs(f_high(i,j+1) - f_high(i,j) );
            grad_high(L) = gx_high(L) + gy_high(L);
            gradient_high(i,j) = grad_high(L);
        end
    end
    TG_high(L) = 0;
    TP_high(L) = 0;
    p_high = zeros(m,n);
    for i=1:m
        for j=1:n
            TG_high(L) = TG_high(L) + gradient_high(i,j);
            if gradient_high(i,j) ~= 0
                p_high(i, j) = 1;
                TP_high(L) = TP_high(L) + 1;
            end
        end
    end
    
    if TP_high(L) ~= 0
        EAG_value_high(L) = TG_high(L) / TP_high(L);
    end
end

%% 求解L_low L_high
[EAG_low, L_low] = max(EAG_value_low);
[EAG_high, L_high] = max(EAG_value_high);

h = h';
% L_low到L_high的众数
hTemp = 0;
for k = L_low : L_high
    if h(k) > hTemp
        hTemp = h(k);
        h_low_high_mode = k;
    end
end
% h_low_high = h(L_low : L_high);
% [~, h_low_high_mode] = max(h_low_high);

% L_low到L_high的均值

h_low_high_mean = mean([L_low : 1 : L_high]);

[imgbw1_mode] = subim2bw(img, h_low_high_mode);
[imgbw2_mean] = subim2bw(img, h_low_high_mean);
figure(9),
subplot(221), imshow(imgbw1_mode, []); title('图像过渡区分割EAG-众数');
subplot(222), imshow(imgbw2_mean, []); title('图像过渡区分割EAG-均值');
subplot(223), imshow(img, []); title('图像过渡区分割EAG-原图');

%% 过渡区提取
img_transition = zeros(m, n);
for i = 1:m
    for j = 1:n
        if L_low <= f(i, j) && f(i, j) <= L_high
            img_transition(i, j) = 1;
%         elseif f(i, j) > L_high
%             img_transition(i, j) = 255;
%         elseif f(i, j) < L_low
%             img_transition(i, j) = 0;
        end
    end
end
img_transition_origin = img_transition .* image;
figure(10), 
subplot(121), imshow(img_transition, []); title('图像过渡区域');
subplot(122), imshow(img_transition_origin, []); title('图像过渡区域与原图');

