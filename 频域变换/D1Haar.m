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
