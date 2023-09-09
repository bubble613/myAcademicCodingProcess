function [] = mainSimple(iterateTimes,k)
% ��������ʾ��
% `
% close all;mainSimple(10,1);

% �������ܣ��۲���ȡ�Ĺ������򼰹������Ҷ�ֱ��ͼ��״

% ����������
% iterateTimes�����ƶ�߶ȳ˻��Ĵ���,������10���£�
% k�����ƴӶ�߶ȳ˻�ͼ����ȡ�������Ĳ�������������ȡֵ1��10��
% ��߶ȳ˱任���ͼ��ȷ�������������ܵ���ȡ��

iterateTimes = 10;
k = 2;

[fileName,pathName] = uigetfile({'*.*';'*.jpg';'*.*'},'File Selector');
fileName = strcat(pathName,fileName);
originalImg = imread(fileName);
if (size(originalImg,3)==3) 
    originalImg = rgb2gray(originalImg);
end

% ����ͼƬ
imgTemp = ones(size(originalImg));
% Ŀǰֻʹ����ˮƽ����Ķ�߶ȳ˻���
imgfilter = subMakeFilterConv(iterateTimes,originalImg);
% �����Ƿ���ʹ�ô�ֱ����Ķ�߶ȳ˻���������Ҫ����

t = zeros(iterateTimes,1);

for i = 1:iterateTimes
    imgTemp = imgTemp .* imgfilter(:,:,i);
    imgTempNormal = im2uint8(mat2gray(imgTemp));%�淶����߶ȳ˻�ͼ��
    figure(199),subplot(2,iterateTimes/2,i),imshow(imgTempNormal);
    
    imgTempMask = imgTempNormal>=k;
    figure(200),subplot(2,iterateTimes/2,i),imshow(imgTempMask);
    
    tranRegion = originalImg(imgTempMask);
    t(i) = mean(tranRegion);
    
    figure,histogram(double(tranRegion),256);
end
figure,plot(t,'r.-');
disp(t);

[IDX, C] = kmeans(t,2) 
%��t�۳����࣬Ϊ̽��ƽ������׼��������Ҳ���Կ���������
% ƽ���Լ�ⷽ����
% �ҵ���������ֵ�ȶ���һ�࣬������д���

    