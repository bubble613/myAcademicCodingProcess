
%% x方向导数
I = imread( 'coins.png' ); figure; imshow(I);
Id = mipforwarddiff(I, 'dx' ); figure, imshow(Id);

%% 1）gradient：梯度计算
% 2）quiver：以箭头形状绘制梯度。注意放大下面最右侧图可看到箭头，
%   由于这里计算横竖两个方向的梯度，因此箭头方向都是水平或垂直的。
I =  double (imread( 'coins.png' ));
[dx,dy]=gradient(I);
magnitudeI=sqrt(dx.^2+dy.^2);
figure;imagesc(magnitudeI);colormap(gray);%梯度幅值
hold on;quiver(dx,dy);%叠加梯度方向

%% 两种拉普拉斯算子函数
% 1）del2
% 2）fspecial：图像处理中一般利用Matlab函数fspecial


