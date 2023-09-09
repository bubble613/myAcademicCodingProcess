%%%%%子函数%%%%%
function [V_nm,mag,phase]=zpoly(n,m,p,theta)
%功能：计算Zernike矩多项式
R_nm=zeros(size(p)); % 产生size(p)*size(p)的零矩阵赋给R_nm
a=(n+abs(m))/2;
b=(n-abs(m))/2;
total=b;
for s=0:total
    num=((-1)^s)*fac(n-s)*(p.^(n-2*s)); % (-1).-1*(n-s)!r.^(n-2*s)
    den=fac(s)*fac(a-s)*fac(b-s); % s!*(a-s)!*(b-s)!
    R_nm=R_nm + num/den; % R_nm是一个实数值的径向多项式
end
mag=R_nm; % 赋值
phase=m*theta;
V_nm=mag.*exp(i*phase); % V_nm为n阶的Zernike多项式，定义为在极坐标系中p，theta的函数
return;
