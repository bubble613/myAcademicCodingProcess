%%%%%子函数%%%%%
function [cimg,cindex,dim]=clipimg(img,mask)
%功能：计算复数的实部和虚部
dim=size(img);
cindex=find(mask~=0);
cimg=img(cindex);
return;