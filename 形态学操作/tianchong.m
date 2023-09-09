clc; clear; close all;
%区域填充测试图像
I=im2double(imread('eight.tif'));
%获得图像大小
[M,N]=size(I);
 
%----------------------------形态学区域填充--------------------------------
%===============================边界提取===================================
%结构元素
n=3;
B=ones(n,n);
n_B=length(find(B==1));
%这里需要B对其原点进行翻转，因为B是对称的，所以翻转后的结果与其本身相同
n_l=floor(n/2);
%腐蚀操作
%存放腐蚀后的图像
J=zeros(M,N);
I_pad=padarray(I,[n_l,n_l],'symmetric');
for x=1:M
    for y=1:N
        %从扩展图像中取出子图像
         Block=I_pad(x:x+2*n_l,y:y+2*n_l);
         %将结构元素与子图像点乘,即逻辑“与”操作
         c=B.*Block;
         %比较结构元素与c中的1的数量，如果一样多，则该点的值为1
         ind=find(c==1);
         if length(ind)==n_B
             J(x,y)=1;
         end
    end
end
Beta=I-J;
imshow(Beta,[]);
% imwrite(Beta,'D:\Gray Files\9-14-BoundaryExtration.tif','tif');

%================用8连通找出边界对象，并对符合条件的对象进行填充===========
%保存所有连通对象集
Objs={};
%对边界图进行扩充，四周各加0，目的是为了处理边界点
Beta_pad=padarray(Beta,[n_l,n_l]);
%找到所有1（白色）点
[rows,cols]=find(Beta_pad==1);
%将行列（x,y）组合成一个下标矩阵
ind=cat(2,rows,cols);
set(0,'RecursionLimit',700);
%递归寻找连通对象
while 1
    %取出下标矩阵中的第一个值
    if isempty(ind)
        break;
    end
    %取出下标矩阵中的第一个对象
    p=ind(1,:);
    A=FindConnectedPoint(p,Beta_pad,ind,n_l);
    %取出边界线对象
    Obj=A{1,1};
    %找出x,y的最大最小值
    x_max=max(Obj(:,1));
    x_min=min(Obj(:,1));
    y_max=max(Obj(:,2));
    y_min=min(Obj(:,2));
    %从原图中取出该对象区域,这里调整了坐标，因为上面对边界图进行了扩充
    Block=I(x_min-n_l:x_max-n_l,y_min-n_l:y_max-n_l);
    [m,n]=size(Block);
    %获得对象区域中1的数量
    num=length(find(Block)==1);
    if num/(m*n)<0.5   
        %将对象区域内填充
        I(x_min-n_l:x_max-n_l,y_min-n_l:y_max-n_l)=1;
        Objs=cat(1,Objs,A{1,1});
    end
    ind=A{1,2}; 
    Beta_pad=A{1,3};  
end
figure(10),
imshow(I)