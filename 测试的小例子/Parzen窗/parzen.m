clear all;
clc;
n=100;
% 生成一些正态分布的随机数
x=normrnd(0,1,1,n);
minx = min(x);
maxx = max(x);
dx = (maxx-minx)/n;
x1 = minx:dx:maxx-dx;
h=0.5;
f=zeros(1,n);
for j = 1:n
    for i=1:n
        f(j)=f(j)+exp(-(x1(j)-x(i))^2/2/h^2)/sqrt(2*pi);
    end
    f(j)=f(j)/n/h;
end
plot(x1,f);

%用系统函数计算比较
[f2,x2] = ksdensity(x);
hold on;
plot(x2,f2,'r'); %红色为参考