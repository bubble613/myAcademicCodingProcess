function [th] = mainComplex(iterateTimes,kMax,clusterN)
% ��������ʾ��
% close all;mainComplex(10,10,2);
% close all;mainComplex(10,250,2);%kMax����250ʱ��������ֵth����kMax����10

% ����������
% iterateTimes�����ƶ�߶ȳ˻��Ĵ�������������ȡֵ10���¡�
% kMax�����ƴӶ�߶ȳ˻�ͼ����ȡ�������Ĳ�������������ȡֵ1��10��
% clusterN�����ƹ�������ֵ�ľ�����������������ȡֵ2��

% �������ܣ���mainSimpleΪ������ͨ������k�ɵ�һȡֵ��Ϊȡ1��10��Χ��ֵ��
% �����k-means���ཫ��ͬ�������ҶȾ�ֵ��Ϊ���ࡣ
% �����ݴ������ֵ��ѡ����Ը�ƽ�ȵ�һ��ľ�ֵ��Ϊ�ָ���ֵ��

% ����ʵ������������ͼ��Ŀ��ͱ����ĻҶȷֲ�����Ϊ�ԳƷֲ���������̬�ֲ�
% �������̬�ֲ�����Ŀ��ͱ����Ĵ�С����������ƽ��ģ�Ҳ�����ǲ�ƽ��ģ�
% �������ø÷���mainComplex(10,10,2)��ý�Ϊ����Ĺ�������ֵth��
% ����ʵ���������������������Է�Ϊ2��Ч���ȷֳ�3�໹��һЩ��
% �����2���е�һ���ǹ���������̫�౳�����أ���һ���Ǹ�����࣬
% �������������϶౳�����أ���϶�Ŀ�����أ���Ŀ��ͱ������ز�ࡣ

% �÷����Ĳ���֮�����ڣ���Ҫ�޶�kMaxֵ�ڽ�С��ֵ������30���¡�Ŀǰ����ʱ��
% һ������ֵ����Ȼ���ԴӶ�߶ȳ˻�ͼ��Ľ��������ΪʲôҪ��10����30���½Ϻá�
% ��һ������չ��mainComplexEnhanced������

[fileName,pathName] = uigetfile({'*.*';'*.jpg';'*.*'},'File Selector');
fileName = strcat(pathName,fileName);
originalImg = imread(fileName);
if (size(originalImg,3)==3)
    originalImg = rgb2gray(originalImg);
end

imgTemp = ones(size(originalImg));
imgfilter = subMakeFilterConv(iterateTimes,originalImg);%Ŀǰֻʹ����
%ˮƽ����Ķ�߶ȳ˻��������Ƿ���ʹ�ô�ֱ����Ķ�߶ȳ˻���������Ҫ����
t=zeros(iterateTimes,kMax);
%v=zeros(iterateTimes,kMax);

for i = 1:iterateTimes
    imgTemp = imgTemp .* imgfilter(:,:,i);
    imgTempNormal = im2uint8(mat2gray(imgTemp));
    for j=1:kMax
        imgTempMask = imgTempNormal>=j;
        tranRegion = originalImg(imgTempMask);
        t(i,j) = mean(tranRegion);
        %v(i,j) = std(double(tranRegion));
    end
end

[IDX, C] = localVisual(t,iterateTimes, kMax, clusterN);%���ݿ��ӻ�
th = localThresholding(originalImg, t(:), IDX, C, clusterN);%��ֵ��

function [IDX, C]=localVisual(t, iterateTimes, kMax, clusterN)
figure(98), hold on;
for i = 1:kMax
    plot(t(:,i),'k.-');
end
title('��ͬkֵ�µĹ������ҶȾ�ֵ����');
hold off;

[X,Y] = meshgrid(1:kMax,1:iterateTimes);
figure(99), mesh(X, Y, t); %figure,surf(X,Y,t);

tVector = t(:);
[IDX,C] = kmeans(tVector, clusterN);%��ʸ������t���о��࣬��t�۳����࣬
% Ϊ̽��ƽ������׼��������Ҳ���Կ���������ƽ���Լ�ⷽ����
disp(C);%��ʾ�������ĵ�

figure(100),hold on;
for ii = 1:kMax % ����ÿ��kֵ�µĹ������ҶȾ�ֵ����
    plot(t(:,ii),'k.-');
end
hold off;

reIDX = reshape(IDX, iterateTimes, kMax);%��Ϊ��ʱ��IDXΪ1ά��Ϊ�˱��ڽ�
%����ʶ��ע��ÿ��kֵ�µĹ������ҶȾ�ֵ���ߵĵ��ϣ���IDXת��Ϊ2ά��
[reLocationY,reLocationX] = meshgrid(1:kMax,1:iterateTimes);
%     [reLocationY,mreLocationX] = meshgrid(1:kMax,1:iterateTimes);
%reLocationX
%���ڻ��ƺ����X��ֵ
figure(100),hold on;
for ii = 1:clusterN
    switch ii
        case 1
            plot(reLocationX(reIDX==ii),t(reIDX==ii),'ro');
        case 2
            plot(reLocationX(reIDX==ii),t(reIDX==ii),'bs');
        case 3
            plot(reLocationX(reIDX==ii),t(reIDX==ii),'kx');
    end
    plot([1 iterateTimes],[C(ii) C(ii)],'b--');
    text(1,C(ii),num2str(C(ii)),'Color','r','FontSize',18);
end
title('�������ע��Ĳ�ͬkֵ�µĹ������ҶȾ�ֵ����');
hold off;

function [th]=localThresholding(originalImg,tVector,IDX,C,clusterN)
% �������ܣ����ĸ����ƽ��һЩ�����Ŀ��ͱ����ĻҶȷֲ�������ǶԳƵģ�
% ��ô����ֱ����ƽ�ȵ���һ��ľ�ֵ��Ϊ�ָ���ֵ��
% ���Ŀ��ͱ����ĻҶȷֲ������ǶԳƵģ����������ֲ����߼�ֵ�ֲ��ȣ�
% �������øöδ������ƽ�ȵ�һ�࣬Ȼ���Դ�Ϊ���������зǶԳ�����Գ��Ե�ת��
% ת�������Ժ�������ֵ��

%Ŀǰ�ٶ�clusterN����2�࣬�����3����߸����࣬����Ҫ��΢�ı�
tempData1 = tVector(IDX==1);
stdTempData1 = std(tempData1);
tempData2 = tVector(IDX==clusterN);
stdTempData2 = std(tempData2);

% Ŀǰʹ�� ��׼�� ��Ϊƽ���ԵĶ�����������Կ��� �����Ķ���
if (stdTempData1 < stdTempData2)%�ĸ���׼��С���ĸ���͸�ƽ�ȡ�
    th = mean(tempData1);
else
    th = mean(tempData2);
end
disp(['���� th=',num2str(th),' �ǲ���C�е�һ��ֵ:',num2str(C(:)')]);

%---------------------------�ر���ʾ-----------------------------------
% ���Ŀ��ͱ����ĻҶȷֲ������ǶԳƵģ����Ǵӱ�׼���С����һ���У�
% ���зǶԳ���ֱ��ͼ���Գ���ֱ��ͼ�ı任��
% ������Ҫ����������д�µĴ��롣
%---------------------------�ر���ʾ-----------------------------------

% ���Ŀ��ͱ����ĻҶȷֲ������ǶԳƵģ�ֱ����ֵ��
binaryImg = originalImg > th;%�����ֵ��

figure, imshow(originalImg);
figure, imshow(binaryImg);


