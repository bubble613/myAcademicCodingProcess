% 计算Zernike矩
% 首先确定图像函数的大小N*N，从而确定N值
% 进一步确定r和delta的范围
% 利用Zernike多项式的快速递推性质计算各阶Rnm,Cnm和Snm
% 对Cnm和Snm求模，求得	Znm
% 不变矩是一种高度浓缩的图像特征，具有平移、尺度、旋转等不变性；
% 正交矩具有绝对的独立性，没有信息冗余现象，抽样性能好，抗噪能力强，适合于图像识别。
function [A_nm,zmlist,cidx,V_nm] = zernike(img,n,m)
% 功能：计算输入图像的Zernike矩
% 输入：img-灰度图像
%       n-阶数
% 输出：V_nm-n阶的Zernike多项式，定义为在极坐标系中p，theta的函数
%       cidx-表示虚部值
%       A_nm-Zernike矩

if nargin>0
    if nargin==1
        n=0;
    end
    d=size(img);
    img=double(img);
    % 取步长
    xstep=2/(d(1)-1);
    ystep=2/(d(2)-1);
    % 画方格
    [x,y]=meshgrid(-1:xstep:1,-1:ystep:1);
    circle1= x.^2 + y.^2;
    % 提取符合circle1<=1的数
    inside=find(circle1<=1);
    % 构造size（d）*size(d)的矩阵
    mask=zeros(d);
    % 构造size(inside)*size(inside)的全为1的矩阵赋值给mask（inside）
    mask(inside)=ones(size(inside));
    % 计算图像的复数表示
    [cimg,cidx]=clipimg(img,mask);
    % 计算Z的实部和虚部
    z=clipimg(x+i*y,mask);
    % 计算复数的模，sqrt(x,y),z=x+iy
    p=0.9*abs(z);   ;
    % 计算复数z的辐角值（tanz）
    theta=angle(z);
    c=1;
    for order=1:length(n)
        n1=n(order);
        if nargin<3
            m=zpossible(n1);
        end
        for r=1:length(m)
            V_nmt=zpoly(n1,m(r),p,theta);
            % conj是求复数的共轭
            zprod=cimg.*conj(V_nmt);
            % (n1+1)/π*∑∑(zprod); 对于图像而言求和代替了求积分
            A_nm(c)=(n1+1)*sum(sum(zprod))/pi;
            zmlist(c,1:2)=[n1 m(r)];
            if nargout==4
                V_nm(:,c)=V_nmt;
            end
            c=c+1;
        end
    end
else
end
