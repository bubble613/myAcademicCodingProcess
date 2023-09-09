function PSNR = psnr1(f1, f2)
%计算两幅图像的峰值信噪比
k = 8;
%k为图像是表示地个像素点所用的二进制位数，即位深。
fmax = 2.^k - 1;
a = fmax.^2;
MSE =(double(im2uint8(f1)) -double( im2uint8(f2))).^2;
b = mean(mean(MSE));
PSNR = 10*log10(a/b);

% 对图像进行4:1的压缩
t=imread('a6.jpg');
t=rgb2gray(t);%灰度化
[k,p]=size(t);
t=double(t)/255;%归一化 便于计算
%显示原图
imshow(t),title('原图','fontsize',16);
%利用blkproc 进行分块 并对每一块进行fft操作
t_fft=blkproc(t,[8 8],'fft2(x)');
%利用im2col进行优化操作 便于计算
t_block=im2col(t_fft,[8 8],'distinct');
[t_change,ix]=sort(t_block);%对每一块图像进行排序
[m,n]=size(t_block);
nums=48;
%对后48位系数清零
for i=1:n
    t_block(ix(1:nums),i)=0;
end
t_rchange=col2im(t_block,[8 8],[k p],'distinct');
t_ifft=blkproc(t_rchange,[8 8],'ifft2(x)');%对每一块进行傅里叶反变换
figure,
imshow(t_ifft),title('4:1压缩后','fontsize',16);