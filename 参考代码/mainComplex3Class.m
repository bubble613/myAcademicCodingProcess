function [t] = mainComplex3Class(iterateTimes,kMax,clusterN)
% ����ʵ�������������������ֳ�3�ಢ���ȷֳ�2����ã�
% �ο�mainComplex������˵����

% ��������ʾ��
% close all;mainComplex3Class(10,250,3);
% close all;mainComplex3Class(10,10,3);

% �������ܣ���mainSimpleΪ������ͨ������k�ɵ�һȡֵ��Ϊȡ1��10��Χ��ֵ��
% �����k-means���ཫ��ͬ�������ҶȾ�ֵ��Ϊ���ࡣ
% �����ݴ������ֵ��ѡ����Ը�ƽ�ȵ�һ��ľ�ֵ��Ϊ�ָ���ֵ��

% ����ʵ������������ͼ��Ŀ��ͱ����ĻҶȷֲ�����Ϊ�ԳƷֲ���������̬�ֲ�
% �������̬�ֲ�����Ŀ��ͱ����Ĵ�С����������ƽ��ģ�Ҳ�����ǲ�ƽ��ģ�
% �������ø÷�����ý�Ϊ����Ĺ�������ֵ��
% ���д���ɵġ���Ŀ��ͱ����ĻҶȷֲ����Գƣ�����Ϊ�����ֲ�����ֵ�ֲ��ȣ��������ø÷���ѡ��
% ���ƽ�ȵ�һ�࣬Ȼ���ٸ���Ļ����ϣ���϶Գ��Ա任��Ӧ�ÿ��Եõ���Ϊ�����
% ��������ֵ��

% ����������
% iterateTimes�����ƶ�߶ȳ˻��Ĵ�������������ȡֵ10���¡�
% k�����ƴӶ�߶ȳ˻�ͼ����ȡ�������Ĳ�������������ȡֵ1��10��
% clusterN�����ƹ�������ֵ�ľ�����������������ȡֵ2��

    [fileName,pathName] = uigetfile({'*.bmp';'*.jpg';'*.*'},'File Selector');
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
    imgTemp = imgTemp.*imgfilter(:,:,i);
    imgTempNormal = im2uint8(mat2gray(imgTemp));
    for j=1:kMax
        imgTempMask = imgTempNormal>=j;
        tranRegion = originalImg(imgTempMask);
        t(i,j) = mean(tranRegion);
        %v(i,j) = std(double(tranRegion));
    end
end

    [IDX,C] = localVisual(t,iterateTimes,kMax,clusterN);%���ݿ��ӻ�
    t = localThresholding(originalImg,t(:),IDX,C,clusterN);%��ֵ��

function [IDX,C]=localVisual(t,iterateTimes,kMax,clusterN)
    figure(98),hold on;
    for i = 1:kMax
        plot(t(:,i),'k.-');
    end
    title('��ͬkֵ�µĹ������ҶȾ�ֵ����');
    hold off;
    
    [X,Y] = meshgrid(1:kMax,1:iterateTimes);                                
    figure(99),mesh(X,Y,t); %figure,surf(X,Y,t);
    
    tVector = t(:);
    [IDX,C] = kmeans(tVector,clusterN);%��ʸ������t���о��࣬��t�۳����࣬
    % Ϊ̽��ƽ������׼��������Ҳ���Կ���������ƽ���Լ�ⷽ����
    disp(C);%��ʾ�������ĵ�

    figure(100),hold on;
    for ii = 1:kMax%����ÿ��kֵ�µĹ������ҶȾ�ֵ����
        plot(t(:,ii),'k.-');
    end
    hold off;
    
    reIDX = reshape(IDX,iterateTimes,kMax);%��Ϊ��ʱ��IDXΪ1ά��Ϊ�˱��ڽ�
    %����ʶ��ע��ÿ��kֵ�µĹ������ҶȾ�ֵ���ߵĵ��ϣ���IDXת��Ϊ2ά��
    [reLocationY,reLocationX] = meshgrid(1:kMax,1:iterateTimes);%reLocationX
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

function [t]=localThresholding(originalImg,tVector,IDX,C,clusterN)
% �������ܣ����ĸ����ƽ��һЩ�����Ŀ��ͱ����ĻҶȷֲ�������ǶԳƵģ�
% ��ô����ֱ����ƽ�ȵ���һ��ľ�ֵ��Ϊ�ָ���ֵ��
% ���Ŀ��ͱ����ĻҶȷֲ������ǶԳƵģ����������ֲ����߼�ֵ�ֲ��ȣ�
% �������øöδ������ƽ�ȵ�һ�࣬Ȼ���Դ�Ϊ���������зǶԳ�����Գ��Ե�ת��
% ת�������Ժ�������ֵ��
    
    %Ŀǰ�ٶ�clusterN����2�࣬�����3����߸����࣬����Ҫ��΢�ı�
    tempData1 = tVector(IDX==1);
    stdTempData1 = std(tempData1);
    tempData2 = tVector(IDX==2);
    stdTempData2 = std(tempData2);
    tempData3 = tVector(IDX==clusterN);
    stdTempData3 = std(tempData3);
    % Ŀǰʹ�ñ�׼����Ϊƽ���ԵĶ�����������Կ��������Ķ���
    %�ĸ���׼��С���ĸ���͸�ƽ�ȡ�
    [stableC,stableIndex] = min([stdTempData1 stdTempData2 stdTempData3]);
    
    switch stableIndex
        case 1
            t=mean(tempData1);
        case 2
            t=mean(tempData2);
        case 3
            t=mean(tempData2);
    end
    disp(['����t=',num2str(t),'�ǲ���C�е�һ��ֵ:',num2str(C(:)')]);
    
    %---------------------------�ر���ʾ-----------------------------------
    % ���Ŀ��ͱ����ĻҶȷֲ������ǶԳƵģ����Ǵӱ�׼���С����һ���У�
    % ���зǶԳ���ֱ��ͼ���Գ���ֱ��ͼ�ı任��
    % ������Ҫ����������д�µĴ��롣
    %---------------------------�ر���ʾ-----------------------------------
    
    % ���Ŀ��ͱ����ĻҶȷֲ������ǶԳƵģ�ֱ����ֵ��
    binaryImg = originalImg>t;%�����ֵ��
    
    figure,imshow(originalImg);
    figure,imshow(binaryImg);
    
    
    