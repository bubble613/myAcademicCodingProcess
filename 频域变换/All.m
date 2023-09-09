%实现一维Haar变换
function [h]=D1Haar(f,N)
J=log2(N);
Y=zeros(J,N);
f1=zeros(1,N);
H=zeros(1,N);
q=f';

%调用倒序函数
f1=Reverse(q,N);
for A=1:N
    Y(1,A)=f1(A);
end

%第一层的迭代
for C=1:N/2
    Y(2,C)=Y(1,C)+Y(1,C+N/2);
    Y(2,C+N/2)=Y(1,C)-Y(1,C+N/2);
end

%余下层的迭代
M=0;
for B=2:J
    K=2*N/(2^B);
    F=zeros(1,K);
    for C=1:K/2
        Y(B+1,C)=Y(B,C)+Y(B,C+K/2);
        Y(B+1,C+K/2)=Y(B,C)-Y(B,C+K/2);
    end
    for C=K+1:2*K
        F(1,C-K)=Y(B,C);
    end
    Z=Reverse(F,K);
    for D=1:K
        Y(B+1,D+K)=Z(D);
    end
    for C=2*K+1:N
        Y(B+1,C)=Y(B,C);
    end
end

%系数修正
H(1,1)=(1/N)*Y(J+1,1);
H(1,2)=(1/N)*Y(J+1,2);
for a=2:J
    b=2^(a-1);
    c=b^(1/2);
    for d=b+1:2*b
        H(1,d)=(c/N)*Y(J+1,d);
    end
end
h=H';

%二维哈尔函数的正变换
function [y]=D2Haar(x,M,N)
%先进行按列变换
for i=1:N
    z=zeros(M,1);
    for c=1:M
        z(c,1)=x(c,i);
    end
    z1=D1Haar(z,M);%调用一维哈尔变换函数D1Haar
    for c=1:M
        x1(c,i)=z1(c,1);
    end
end

%再进行按行变换
x2=x1';%将变换好的矩阵进行转置
for j=1:M
    z=zeros(N,1);
    for c=1:N
        z(c,1)=x2(c,j);
    end
    z1=D1Haar(z,N);%调用一维哈尔变换函数D1Haar
    for c=1:N
        y1(c,j)=z1(c,1);
    end
end
y=y1';%再最后将变换好的矩阵作转置


%对矩阵作一次哈尔变换
function [y]=D2Har(x,M,N)
for i=1:N
    z=zeros(M,1);
    for c=1:M
        z(c,1)=x(c,i);
    end
    z1=D1Haar(z,M);
    for c=1:M
        x1(c,i)=z1(c,1);
    end
end
y=x1;

%哈尔函数的逆变换
function [y]=ID2Haar(X,M,N)
har1=zeros(M);
I1=eye(M);%产生M维单位阵
har1=D2Har(I1,M,M);%调用D2Har产生M维哈尔矩阵
har2=M*har1';
I2=eye(N);%产生N维单位阵
har3=zeros(N);
har3=D2Har(I2,N,N);%调用D2Har产生M维哈尔矩阵
har4=N*har3;
y=har2*X*har4;%哈尔逆变换

%求倒叙函数
function [F]=Reverse(F,M)
N=log10(M)/log10(2);
Y=zeros(1,M);
for  x=0:M-1
    A=dec2bin(x,N);%十进制转二进制
    B=fliplr(A);%二进制倒叙
    C=bin2dec(B);%二进制转十进制
    Y(x+1)=F(C+1);
end
for x=0:M-1
    F(x+1)=Y(x+1);
end

%对图片进行哈尔正变化，并对其进行恢复
clear;
M=256;
N=256;

%读取图象
X=imread('C:\Users\LiCongliang\Desktop\数字图像处理\数字图像处理第七次作业\tea.jpg');
subplot(2,2,1);
imshow(X);
title('原图像');

%缩放原图象
x=imresize(X,[M,N]);%将原图象缩放成分辨率为256*256的图象
subplot(2,2,2);
imshow(x);
title('缩放图象');

%对缩放图象进行Haar变换
y=D2Haar(x,M,N);
subplot(2,2,3);
imshow(y);
title('变换图象');

%对变换后的图象进行Harr逆变换，恢复原图象
z=ID2Haar(y,M,N);
%Z=imresize(z,[480,360]);
subplot(2,2,4);
imshow(z,[0,255]);
title('恢复图象');

% 小波变换进行图像压缩
X=imread('a5.jpg');
X=rgb2gray(X);
subplot(221); imshow(X);
title('原始图像');
%对图像用小波进行层小波分解
[c,s]=wavedec2(X,2,'haar');
%提取小波分解结构中的一层的低频系数和高频系数
cal=appcoef2(c,s,'haar',1);
ch1=detcoef2('h',c,s,1);      %水平方向
cv1=detcoef2('v',c,s,1);      %垂直方向
cd1=detcoef2('d',c,s,1);      %斜线方向
%各频率成份重构
a1=wrcoef2('a',c,s,'haar',1);
h1=wrcoef2('h',c,s,'haar',1);
v1=wrcoef2('v',c,s,'haar',1);
d1=wrcoef2('d',c,s,'haar',1);
c1=[a1,h1;v1,d1];
subplot(222),imshow(c1,[]);
title ('分解后低频和高频信息');
%进行图像压缩
%保留小波分解第一层低频信息
%首先对第一层信息进行量化编码
ca1=appcoef2(c,s,'haar',1);
ca1=wcodemat(ca1,440,'mat',0);
%改变图像高度并显示
ca1=0.5*ca1;
subplot(223);imshow(cal,[]);
title('第一次压缩图像');
%保留小波分解第二层低频信息进行压缩
ca2=appcoef2(c,s,'haar',2);
%首先对第二层信息进行量化编码
ca2=wcodemat(ca2,440,'mat',0);
%改变图像高度并显示
ca2=0.25*ca2;
subplot(224);imshow(ca2,[]);
title('第二次压缩图像');

