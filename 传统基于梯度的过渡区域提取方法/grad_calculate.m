clc;clear;close all;
x=32;
I = imread('coins.png');
I = imresize(I,[x x]);
I = double(I(:,:,1));
tic
[dx, dy] = gradient(I);
toc
tic
[m,n]=size(I);
A = [I(:,2:end) zeros(m,1)];
B = [zeros(m,1) I(:,1:end-1)];
dx1 = [I(:,2)-I(:,1) (A(:,2:end-1)-B(:,2:end-1))./2 I(:,end)-I(:,end-1)];
A = [I(2:end,:) ; zeros(1,n)];
B = [zeros(1,n) ; I(1:end-1,:)];
dy1 = [I(2,:)-I(1,:) ; (A(2:end-1,:)-B(2:end-1,:))./2 ; I(end,:)-I(end-1,:)];
toc
nnz(dx-dx1)
nnz(dy-dy1)
% 我的基本想法是：渐变平均2个相邻位置(左和右或顶部和底部),除了它取值和相邻位置之间的差异的边缘.
% 然后,我用matlab梯度函数(dx,dy)生成的矩阵检查了我生成的矩阵(dx1,dy1).