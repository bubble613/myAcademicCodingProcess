function e = straightline(f,alpha)
% 功能：检测特定角度的边缘
% 输入：f-待检测的图像
%       alpha-检测角度
%       1表示H垂直方向
%       2表示V水平方向
%       3表示45度
%       4表示-45度
f = im2double(f);
% 构造卷积核
H = [-1 -1 -1;2 2 2;-1 -1 -1];
V = [-1 2 -1;-1 2 -1;-1 2 -1];
P45 = [-1 -1 2;-1 2 -1;2 -1 -1];
M45 = [2 -1 -1;-1 2 -1;-1 -1 2];
switch(alpha)
    case 1
        e = imfilter(f,H);
    case 2
        e = imfilter(f,V);
    case 3
        e = imfilter(f,P45);
    case 4
        e = imfilter(f,M45);
    otherwise
        e = ones(size(f));
        fprintf('请检测输入：\nalpha-检测角度\n1表示H垂直方向\n2表示V水平方向\n3表示45度\n4表示-45度\n');
end