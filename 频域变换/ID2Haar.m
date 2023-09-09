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