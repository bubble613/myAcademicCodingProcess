% clc;
% clear all;
img_noise = originalImg;
% img_noise = imnoise(originalImg, 'gaussian', 0, 0.01);
subplot(2,3,1),imshow(img_noise);
title('原图像');
% 将低频移动到图像的中心，这个也很重要
s=fftshift(fft2(img_noise)); 
subplot(2,3,4),imshow(log(abs(s)),[]);
title('图像傅里叶变换取对数所得频谱');
% 求解变换后的图像的中心，我们后续的处理是依据图像上的点距离中心点的距离来进行处理
[a,b] = size(img_noise);
a0 = round(a/2);
b0 = round(b/2);
d = min(a0,b0)/2;
d = d^2;
for i=1:a
    for j=1:b
        distance = (i-a0)^2+(j-b0)^2;
        if distance<d
            h = 1;
        else
            h = 0;
        end
        low_filter(i,j) = h*s(i,j);
    end
end
% low_filter = real(ifft2(ifftshift(low_filter)));
subplot(2,3,5),imshow(log(abs(low_filter)),[])
% subplot(2,2,4),imshow(low_filter,[])
title('低通滤波频谱');
% new_img = uint8(real(ifft2(ifftshift(low_filter))));
new_img = real(ifft2(ifftshift(low_filter)));

subplot(2,3,2),imshow(new_img,[])
title('低通滤波后的图像');
subplot(233),imhist(originalImg),title('原图直方图')
subplot(236),imhist(new_img),title('滤波过后直方图')