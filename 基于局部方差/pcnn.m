function [Edge,Numberofaera]=pcnn(X)
% 功能：采用PCNN算法进行边缘检测
% 输入：X—输入的灰度图像
% 输出：Edge—检测到的       Numberofaera—表明了在各次迭代时激活的块区域
% [Edge,Numberofaera]=pcnn(image);

figure(1);
imshow(X);
X=double(X);
% 设定权值
Weight=[0.07 0.1 0.07;0.1 0 0.1;0.07 0.1 0.07];
WeightLI2=[-0.03 -0.03 -0.03;-0.03 0 -0.03;-0.03 -0.03 -0.03];
d=1/(1+sum(sum(WeightLI2)));
%%%%%%测试权值%%%%%%
WeightLI=[-0.03 -0.03 -0.03;-0.03 0.5 -0.03;-0.03 -0.03 -0.03];
d1=1/(sum(sum(WeightLI)));
%%%%%%%%%%%%%%%%%%
Beta=0.4;
Yuzhi=245;
%衰减系数
Decay=0.3;
[a,b]=size(X);
V_T=0.2;
%门限值
Threshold=zeros(a,b);
S=zeros(a+2,b+2);
Y=zeros(a,b);
%点火频率
Firate=zeros(a,b);
n=1;
%统计循环次数
count=0;
Tempu1=zeros(a,b);
Tempu2=zeros(a+2,b+2);
%%%%%%图像增强部分%%%%%%
Out=zeros(a,b);
Out=uint8(Out);
for i=1:a
    for j=1:b
        if(i==1|j==1|i==a|j==b)
            Out(i,j)=X(i,j);
        else
            H=[X(i-1,j-1)  X(i-1,j) X(i-1,j+1);
                X(i,j-1)   X(i,j)   X(i,j+1);
                X(i+1,j-1) X(i+1,j) X(i+1,j+1)];
            temp=d1*sum(sum(H.*WeightLI));
            Out(i,j)=temp;
        end
    end
end
figure(2);
imshow(Out);
%%%%%%%%%%%%%%%%%%%
for count=1:30
    for i0=2:a+1
        for i1=2:b+1
            V=[S(i0-1,i1-1)  S(i0-1,i1) S(i0-1,i1+1);
                S(i0,i1-1)   S(i0,i1)   S(i0,i1+1);
                S(i0+1,i1-1) S(i0+1,i1) S(i0+1,i1+1)];
            L=sum(sum(V.*Weight));
            V2=[Tempu2(i0-1,i1-1)  Tempu2(i0-1,i1) Tempu2(i0-1,i1+1);
                Tempu2(i0,i1-1)   Tempu2(i0,i1)   Tempu2(i0,i1+1);
                Tempu2(i0+1,i1-1) Tempu2(i0+1,i1) Tempu2(i0+1,i1+1)];        F=X(i0-1,i1-1)+sum(sum(V2.*WeightLI2));
            %保证侧抑制图像无能量损失
            F=d*F;
            U=double(F)*(1+Beta*double(L));
            Tempu1(i0-1,i1-1)=U;
            if U>=Threshold(i0-1,i1-1)|Threshold(i0-1,i1-1)<60
                T(i0-1,i1-1)=1;
                Threshold(i0-1,i1-1)=Yuzhi;
                %点火后一直置为1
                Y(i0-1,i1-1)=1;
            else
                T(i0-1,i1-1)=0;
                Y(i0-1,i1-1)=0;
            end
        end
    end
    Threshold=exp(-Decay)*Threshold+V_T*Y;
    %被激活过的像素不再参与迭代过程
    if n==1
        S=zeros(a+2,b+2);
    else
        S=Bianhuan(T);
    end
    n=n+1;
    count=count+1;
    Firate=Firate+Y;
    figure(3);
    imshow(Y);
    Tempu2=Bianhuan(Tempu1);
end
Firate(find(Firate<10))=0;
Firate(find(Firate>=10))=10;
figure(4);
imshow(Firate);
%%%%%%子函数 %%%%%%%
function Y=Jiabian(X)
[m,n]=size(X);
Y=zeros(m+2,n+2);
for i=1:m+2
    for j=1:n+2
        if i==1&j~=1&j~=n+2
            Y(i,j)=X(1,j-1);
        elseif j==1&i~=1&i~=m+2
            Y(i,j)=X(i-1,1);
        elseif i~=1&j==n+2&i~=m+2
            Y(i,j)=X(i-1,n);
        elseif i==m+2&j~=1&j~=n+2
            Y(i,j)=X(m,j-1);
        elseif i==1&j==1
            Y(i,j)=X(i,j);
        elseif i==1&j==n+2
            Y(i,j)=X(1,n);
        elseif i==(m+2)&j==1
            Y(i,j)=X(m,1);
        elseif i==m+2&j==n+2
            Y(i,j)=X(m,n);
        else
            Y(i,j)=X(i-1,j-1);
        end
    end
end
%%%%%%子函数%%%%%%
function Y=Bianhuan(X)
[m,n]=size(X);
Y=zeros(m+2,n+2);
for i=1:m+2
    for j=1:n+2
        if i==1|j==1|i==m+2|j==n+2
            Y(i,j)=0;
        else
            Y(i,j)=X(i-1,j-1);
        end
    end
end
%%%%%%子函数%%%%%%
function Y=judge_edge(X,n)
%X:每次迭代后PCNN输出的二值图像，如何准确判断边界点是关键
[a,b]=size(X);
T=Jiabian(X);
Y=zeros(a,b);
W=zeros(a,b);
for i=2:a+1
    for j=2:b+1
        if (T(i,j)==1)&((T(i-1,j)==0&T(i+1,j)==0)|(T(i,j-1)==0&T(i,j+1)==0)|(T(i-1,j-1)==0&T(i+1,j+1)==0)|(T(i+1,j-1)==0&T(i-1,j+1)==0))
            Y(i-1,j-1)=-n;
        end
    end
end
