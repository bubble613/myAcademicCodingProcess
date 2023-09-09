function [imgfilter] = subMakeFilterConv(number,img)
[m,n] = size(img);
imgfilter = zeros(m,n,number);
for i = 1:number
    hi = subCreateFilter(2*i+1);
%     hi2 = subCreateFilter2(2*i+1);
    imgfilter(:,:,i) = imfilter(double(img),hi,'conv','replicate');
%     imgfilter(:,:,i) = imfilter(double(img),hi2,'conv','replicate');
    % figure,imshow(mat2gray(abs(imgfilter(:,:,i))));
end
imgfilter = abs(imgfilter);
