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