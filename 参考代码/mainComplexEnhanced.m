function [th,thEnhanced] = mainComplexEnhanced(iterateTimes,kMax,clusterN)
% ��������ʾ��
% close all;mainComplexEnhanced(10,250,2);

% ����������
% iterateTimes�����ƶ�߶ȳ˻��Ĵ�������������ȡֵ10���¡�
% kMax�����ƴӶ�߶ȳ˻�ͼ����ȡ�������Ĳ�����Ĭ��ֵ250��
% clusterN�����ƹ�������ֵ�ľ�����������������ȡֵ2��

% �������ܣ���mainComplex�Ļ����ϣ�������һ�����ƽ�����ж����������ĺ���
% localThresholdingEnhanced��ʵ�֣���ʹ��k��ֵ������չ�������Ҷ�ֵ��Χ255���£�
% �����ǽ���������޶���10���¡�ͨ�����ƽ�����ж�����ɸѡ����ֵ��һ����Ϊ���ࡣ
% �����ݴ������ֵ��ѡ����Ը�ƽ�ȵ�һ��ľ�ֵ��Ϊ�ָ���ֵthEnhanced��

% ����ʵ������������ͼ��Ŀ��ͱ����ĻҶȷֲ�����Ϊ�ԳƷֲ���������̬�ֲ�
% �������̬�ֲ�����Ŀ��ͱ����Ĵ�С����������ƽ��ģ�Ҳ�����ǲ�ƽ��ģ�
% �ĸ�ֵth��thEnhanced��tMaxCount��tMean�У�thEnhanced������������ֵ�����

% �д���ɵĹ�������Ŀ��ͱ����ĻҶȷֲ����Գƣ�����Ϊ�����ֲ�����ֵ�ֲ��ȣ�
% ��������mainComplexEnhanced(10,250,2)ѡ��thEnhanced��Ȼ��������²���1����
% ����2����϶Գ��Ա任��Ӧ�ÿ��Եõ��Ҷȷֲ����Գ���ʱ�Ľ�Ϊ����Ĺ�������ֵ��
% ����1��ѡ��һ������������ҶȾ�ֵ��thEnhanced��ӽ���Ȼ��Ըù�������Ҷ�
%        ֱ��ͼ���жԳ��Ա任����������յķָ���ֵ��
% ����2��ѡ��iterateTimes������������ҶȾ�ֵ��thEnhanced��ӽ�������˵��
%        ÿ�ζ�߶ȳ˻�ͼ������ϣ�ѡ��������ҶȾ�ֵ��thEnhanced��ӽ���һ��
%        ��������iterateTimes���������򡣶���iterateTimes�����������ÿ���Ҷ�
%        ֱ��ͼ���жԳ��Ա任�����õ�iterateTimes����ֵ���������ǵľ�ֵ��Ϊ
%        ���շָ���ֵ��Ҳ������iterateTimes����ֵ�ļ�Ȩ��ֵ������Ȩֵϵ��Ϊ
%        ÿ����ֵ��������ֵ�ľ���ɷ��ȣ���
% ����n��Ҳ���Կ��������Ĳ��ԡ�
% �ر���ʾ1������жϹ�������Ŀ��ͱ����Ҷȷֲ����Գƣ������ȵõ�thEnhanced��
%            Ȼ����thEnhancedΪ�ᣬ��С��thEnhanced�ʹ���thEnhanced���н�����
%            ������������ù������ҶȾ�ֵ������thEnhanced����ô�ֲ����ƶԳƣ�
%            ������������ù������ҶȾ�ֵ��thEnhanced���ϴ���ô�ֲ����Գơ�
% �ر���ʾ2�����ڶԳ��Ա任�������ڹ������ĻҶ�ֱ��ͼ����������Ҳ���Կ���ֱ��
%            �Թ������ĻҶ�ֵ���б任����������ϸ���Ч�ʡ�flip�����任

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
    th = localThresholding(originalImg,t(:),IDX,C,clusterN);%��ֵ��
    
    thEnhanced = localThresholdingEnhanced(originalImg,t,clusterN);
    tMean = mean(t(:));%�򵥵ļ�������t�ľ�ֵ
    disp(['����t�ľ�ֵ',num2str(tMean)]);

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
    %disp(C);%��ʾ�������ĵ�

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
    
    % Ŀǰʹ�ñ�׼����Ϊƽ���ԵĶ�����������Կ��������Ķ���
    if (stdTempData1<stdTempData2)%�ĸ���׼��С���ĸ���͸�ƽ�ȡ�
        th=mean(tempData1);
    else
        th=mean(tempData2);
    end
    disp(['����th=',num2str(th),'�ǲ���C�е�һ��ֵ:',num2str(C(:)')]);
    
    %---------------------------�ر���ʾ-----------------------------------
    % ���Ŀ��ͱ����ĻҶȷֲ������ǶԳƵģ����Ǵӱ�׼���С����һ���У�
    % ���зǶԳ���ֱ��ͼ���Գ���ֱ��ͼ�ı任��
    % ������Ҫ����������д�µĴ��롣
    %---------------------------�ر���ʾ-----------------------------------
    
    % ���Ŀ��ͱ����ĻҶȷֲ������ǶԳƵģ�ֱ����ֵ��
    binaryImg = originalImg>th;%�����ֵ��
    
    figure,imshow(originalImg);
    figure,imshow(binaryImg);
    
function [thEnhanced]=localThresholdingEnhanced(originalImg,t,clusterN)
    tmin = min(t(:));
    tmax = max(t(:));
    nbins = round(tmax-tmin+1);
    [ntmp,xout] = hist(t(:),nbins);
    figure,bar(xout,ntmp);
    [xtmp,itmp] = max(ntmp);
    tMaxCount = tmin+itmp-1;
    disp(['��ƽ����ֵλ��',num2str(tMaxCount)]);
    ttmp = t(t<tMaxCount);
    % ע�����Ŀ���������������ǲ���tС�ڵķ�ʽ��
    % ����Ŀ�갵�������������ǲ���t���ڵķ�ʽ��
    % ����ж���Ŀ�������Ǳ�����������ͨ��mainComplex(10,2,2);���ߵ�������
    % �жϣ��ȵͺ����Ŀ��������֮��������������Ժ������������ơ�
    
    [IDX,C] = kmeans(ttmp,clusterN);
    
    %Ŀǰ�ٶ�clusterN����2�࣬�����3����߸����࣬����Ҫ��΢�ı�
    tempData1 = ttmp(IDX==1);
    stdTempData1 = std(tempData1);
    tempData2 = ttmp(IDX==2);
    stdTempData2 = std(tempData2);
    
    % Ŀǰʹ�ñ�׼����Ϊƽ���ԵĶ�����������Կ��������Ķ���
    if (stdTempData1<stdTempData2)%�ĸ���׼��С���ĸ���͸�ƽ�ȡ�
        thEnhanced=mean(tempData1);
    else
        thEnhanced=mean(tempData2);
    end
    disp(['����thEnhanced=',num2str(thEnhanced),'�ǲ���C�е�һ��ֵ:',num2str(C(:)')]);
    
    %---------------------------�ر���ʾ-----------------------------------
    % ���Ŀ��ͱ����ĻҶȷֲ������ǶԳƵģ����Ǵӱ�׼���С����һ���У�
    % ���зǶԳ���ֱ��ͼ���Գ���ֱ��ͼ�ı任��
    % ������Ҫ����������д�µĴ��롣
    %---------------------------�ر���ʾ-----------------------------------
    
    % ���Ŀ��ͱ����ĻҶȷֲ������ǶԳƵģ�ֱ����ֵ��
    binaryImg = originalImg>thEnhanced;%�����ֵ��
    
    figure,imshow(originalImg);
    figure,imshow(binaryImg);

    