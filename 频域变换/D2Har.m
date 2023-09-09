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