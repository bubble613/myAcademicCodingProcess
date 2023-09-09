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
