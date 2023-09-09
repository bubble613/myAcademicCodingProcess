t=imread('a1.jpg');

%添加高斯噪声
t1=imnoise(t,'gaussian',0,0.02);
[m,n]=size(t);
t2=t;

%添加周期噪声
for i=1:m
    for j=1:n
        t2(i,j)=t(i,j)+30*sin(30*i)+30*sin(30*j);
    end
end
imshow(t1),title('加入高斯噪声后')
figure,imshow(t2),title('加入周期噪声后');

%进行高斯滤波、中值滤波
t3_1=t;
t3_1(:,:,1)=medfilt2(t1(:,:,1),[3 3]);
t3_1(:,:,2)=medfilt2(t1(:,:,2),[3 3]);
t3_1(:,:,3)=medfilt2(t1(:,:,3),[3 3]);
figure,imshow(t3_1),title('对高斯噪声进行中值滤波','fontsize',16)
h=fspecial('gaussian',5,3);%确定滤波方式为高斯滤波 5是模板大小  3是方差
t3_2=imfilter(t2,h);%滤波操作
figure,imshow(t3_2),title('对周期噪声进行高斯滤波','fontsize',16)

t3_1=t;
t3_1(:,:,1)=medfilt2(t2(:,:,1),[3 3]);
t3_1(:,:,2)=medfilt2(t2(:,:,2),[3 3]);
t3_1(:,:,3)=medfilt2(t2(:,:,3),[3 3]);
figure,imshow(t3_1),title('对高斯噪声进行中值滤波','fontsize',16)
h=fspecial('gaussian',5,3);%确定滤波方式为高斯滤波 5是模板大小  3是方差
t3_2=imfilter(t1,h);%滤波操作
figure,imshow(t3_2),title('对周期噪声进行高斯滤波','fontsize',16)


%对周期噪声傅里叶变换滤波
t_f=rgb2gray(t2); %将图像灰度化
t_f=fft2(double(t_f));%利用fft2()函数将图像从时域空间转换到频域空间
t_f=fftshift(t_f);%将零频平移到中心位置
[m,n]=size(t_f);
m_min=round(m/2);
n_min=round(n/2);
t_rf=t_f;
d_0=100;%设置阈值
for i=1:m
    for j=1:n
        d_1=sqrt((i-m_min)^2+(j-n_min)^2);
        if(d_1>d_0)
            x=0;
        else
            x=1;
        end
        t_rf(i,j)=x*t_f(i,j);
    end
end
t_rf=ifftshift(t_rf);
t_rf=uint8(real(ifft2(t_rf)));
figure,imshow(t_rf),title('对周期噪声进行傅里叶变换滤波后')

%对高斯噪声进行傅里叶变换滤波
t_f=rgb2gray(t1);
t_f=fft2(double(t_f));
t_f=fftshift(t_f);
[m,n]=size(t_f);
m_min=round(m/2);
n_min=round(n/2);
t_rf=t_f;
d_0=100;
for i=1:m
    for j=1:n
        d_1=sqrt((i-m_min)^2+(j-n_min)^2);
        if(d_1>d_0)
            x=0;
        else
            x=1;
        end
        t_rf(i,j)=x*t_f(i,j);
    end
end
t_rf=ifftshift(t_rf);
t_rf=uint8(real(ifft2(t_rf)));
figure,imshow(t_rf),title('对高斯噪声进行傅里叶变换滤波后')

%对周期噪声进行小波变换滤波
[c,s]=wavedec2(t2,2,'sym4');
a1=wrcoef2('a',c,s,'sym4');
figure,imshow(uint8(a1)); title('对周期噪声进行小波变换滤波')
%对高斯噪声进行小波变换滤波
[c,s]=wavedec2(t1,2,'sym4');
a1=wrcoef2('a',c,s,'sym4');
figure, imshow(uint8(a1)); title('对高斯噪声进行小波变换滤波')