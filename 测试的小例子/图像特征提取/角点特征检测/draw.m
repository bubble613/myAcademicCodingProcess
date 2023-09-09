% function [row,col,max_local] = findLocalMaximum(val,radius)
% % 功能：查找邻域极大值
% % 输入：
% % val -NxM 矩阵；
% % radius –邻域半径；
% % 输出：
% % row –邻域极大值的行坐标；
% % col – 邻域极大值的列坐标；
% % max_local-邻域极大值。
% 
% mask  = fspecial('disk',radius)>0;
% nb    = sum(mask(:));
% highest          = ordfilt2(val, nb, mask);
% second_highest   = ordfilt2(val, nb-1, mask);
% index            = highest==val & highest~=second_highest;
% max_local        = zeros(size(val));
% max_local(index) = val(index);
% [row,col]        = find(index==1);
% 
% end
function draw(img,pt,str)
% 功能：在图像中绘制出特征点
% 输入：
%      img –输入的图像
%       pt-检测出的特征点的坐标
%       str-在图上显示的名称

figure('Name',str);
imshow(img);
hold on;
axis off;
switch size(pt,2)
    case 2
        s = 2;
        for i=1:size(pt,1)
            rectangle('Position',[pt(i,2)-s,pt(i,1)-s,2*s,2*s],'Curvature',[0 0],'EdgeColor','b','LineWidth',2);
        end
    case 3
        for i=1:size(pt,1)
            rectangle('Position',[pt(i,2)-pt(i,3),pt(i,1)-pt(i,3),2*pt(i,3),2*pt(i,3)],'Curvature',[1,1],'EdgeColor','w','LineWidth',2);
        end
end
end