function [th,thEnhanced] = mainComplexEnhanced(iterateTimes,kMax,clusterN)
% 函数调用示例
% close all;mainComplexEnhanced(10,250,2);

% 函数参数：
% iterateTimes：控制多尺度乘积的次数，初步建议取值10以下。
% kMax：控制从多尺度乘积图像提取过渡区的参数，默认值250。
% clusterN：控制过渡区均值的聚类数量，初步建议取值2。

% 函数功能：在mainComplex的基础上，增加了一个最大平稳性判定（在新增的函数
% localThresholdingEnhanced中实现），使得k的值可以扩展到整个灰度值范围255以下，
% 而不是仅仅经验的限定在10以下。通过最大平稳性判定，将筛选出均值进一步分为两类。
% 最后根据从两类均值中选择相对更平稳的一类的均值作为分割阈值thEnhanced。

% 初步实验结果表明，当图像目标和背景的灰度分布总体为对称分布（比如正态分布
% 或近似正态分布），目标和背景的大小比例可以是平衡的，也可以是不平衡的，
% 四个值th、thEnhanced、tMaxCount和tMean中，thEnhanced总体离最优阈值最近。

% 尚待完成的工作：当目标和背景的灰度分布不对称，比如为瑞利分布、极值分布等，
% 可以利用mainComplexEnhanced(10,250,2)选择thEnhanced，然后根据如下策略1或者
% 策略2，结合对称性变换，应该可以得到灰度分布不对称性时的较为理想的过渡区阈值。
% 策略1：选择一个过渡区域，其灰度均值离thEnhanced最接近，然后对该过渡区域灰度
%        直方图进行对称性变换处理，输出最终的分割阈值。
% 策略2：选择iterateTimes个过渡区域，其灰度均值离thEnhanced最接近（或者说在
%        每次多尺度乘积图像基础上，选择过渡区灰度均值离thEnhanced最接近的一个
%        这样共有iterateTimes个过渡区域。对这iterateTimes个过渡区域的每个灰度
%        直方图进行对称性变换处理，得到iterateTimes个阈值，再求它们的均值作为
%        最终分割阈值（也可以是iterateTimes个阈值的加权均值，其中权值系数为
%        每个阈值和中心阈值的距离成反比）。
% 策略n：也可以考虑其它的策略。
% 特别提示1：如何判断过渡区内目标和背景灰度分布不对称？可以先得到thEnhanced，
%            然后以thEnhanced为轴，将小于thEnhanced和大于thEnhanced进行交换，
%            如果交换后所得过渡区灰度均值近似于thEnhanced，那么分布近似对称；
%            如果交换后所得过渡区灰度均值和thEnhanced差别较大，那么分布不对称。
% 特别提示2：对于对称性变换，可以在过渡区的灰度直方图上做，或者也可以考虑直接
%            对过渡区的灰度值进行变换，或许计算上更有效率。flip函数变换

    [fileName,pathName] = uigetfile({'*.*';'*.jpg';'*.*'},'File Selector');
    fileName = strcat(pathName,fileName);
    originalImg = imread(fileName);
    if (size(originalImg,3)==3) 
        originalImg = rgb2gray(originalImg);
    end

    imgTemp = ones(size(originalImg));
    imgfilter = subMakeFilterConv(iterateTimes,originalImg);%目前只使用了
    %水平方向的多尺度乘积，后面是否再使用垂直方向的多尺度乘积可以视需要而定
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
    
    [IDX,C] = localVisual(t,iterateTimes,kMax,clusterN);%数据可视化
    th = localThresholding(originalImg,t(:),IDX,C,clusterN);%阈值化
    
    thEnhanced = localThresholdingEnhanced(originalImg,t,clusterN);
    tMean = mean(t(:));%简单的计算所有t的均值
    disp(['所有t的均值',num2str(tMean)]);

function [IDX,C]=localVisual(t,iterateTimes,kMax,clusterN)
    figure(98),hold on;
    for i = 1:kMax
        plot(t(:,i),'k.-');
    end
    title('不同k值下的过渡区灰度均值曲线');
    hold off;
    
    [X,Y] = meshgrid(1:kMax,1:iterateTimes);                                
    figure(99),mesh(X,Y,t); %figure,surf(X,Y,t);
    
    tVector = t(:);
    [IDX,C] = kmeans(tVector,clusterN);%对矢量化的t进行聚类，将t聚成两类，
    % 为探测平稳性做准备。后面也可以考虑其它的平稳性检测方法。
    %disp(C);%显示聚类中心点

    figure(100),hold on;
    for ii = 1:kMax%绘制每个k值下的过渡区灰度均值曲线
        plot(t(:,ii),'k.-');
    end
    hold off;
    
    reIDX = reshape(IDX,iterateTimes,kMax);%因为此时的IDX为1维，为了便于将
    %类别标识标注到每个k值下的过渡区灰度均值曲线的点上，将IDX转换为2维。
    [reLocationY,reLocationX] = meshgrid(1:kMax,1:iterateTimes);%reLocationX
    %用于绘制后面的X轴值
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
    title('带分类标注点的不同k值下的过渡区灰度均值曲线');
    hold off;

function [th]=localThresholding(originalImg,tVector,IDX,C,clusterN)
% 函数功能：看哪个类更平稳一些，如果目标和背景的灰度分布本身就是对称的，
% 那么可以直接以平稳的哪一类的均值作为分割阈值。
% 如果目标和背景的灰度分布本身不是对称的，比如瑞利分布或者极值分布等，
% 可以利用该段代码估计平稳的一类，然后以此为基础，进行非对称性像对称性的转换
% 转换完了以后，再求阈值。
    
    %目前假定clusterN就是2类，如果是3类或者更多类，代码要略微改变
    tempData1 = tVector(IDX==1);
    stdTempData1 = std(tempData1);
    tempData2 = tVector(IDX==clusterN);
    stdTempData2 = std(tempData2);
    
    % 目前使用标准差作为平稳性的度量，后面可以考虑其它的度量
    if (stdTempData1<stdTempData2)%哪个标准差小，哪个类就更平稳。
        th=mean(tempData1);
    else
        th=mean(tempData2);
    end
    disp(['看看th=',num2str(th),'是不是C中的一个值:',num2str(C(:)')]);
    
    %---------------------------特别提示-----------------------------------
    % 如果目标和背景的灰度分布本身不是对称的，考虑从标准差更小的那一类中，
    % 进行非对称性直方图到对称性直方图的变换。
    % 可能需要跳出本函数写新的代码。
    %---------------------------特别提示-----------------------------------
    
    % 如果目标和背景的灰度分布本身是对称的，直接阈值化
    binaryImg = originalImg>th;%完成阈值化
    
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
    disp(['最平稳阈值位于',num2str(tMaxCount)]);
    ttmp = t(t<tMaxCount);
    % 注意对于目标亮，而背景暗是采用t小于的方式，
    % 对于目标暗，而背景亮则是采用t大于的方式。
    % 如何判断是目标亮还是背景亮，容易通过mainComplex(10,2,2);曲线的走势来
    % 判断：先低后高是目标亮，反之背景亮。这个可以后面来编码完善。
    
    [IDX,C] = kmeans(ttmp,clusterN);
    
    %目前假定clusterN就是2类，如果是3类或者更多类，代码要略微改变
    tempData1 = ttmp(IDX==1);
    stdTempData1 = std(tempData1);
    tempData2 = ttmp(IDX==2);
    stdTempData2 = std(tempData2);
    
    % 目前使用标准差作为平稳性的度量，后面可以考虑其它的度量
    if (stdTempData1<stdTempData2)%哪个标准差小，哪个类就更平稳。
        thEnhanced=mean(tempData1);
    else
        thEnhanced=mean(tempData2);
    end
    disp(['看看thEnhanced=',num2str(thEnhanced),'是不是C中的一个值:',num2str(C(:)')]);
    
    %---------------------------特别提示-----------------------------------
    % 如果目标和背景的灰度分布本身不是对称的，考虑从标准差更小的那一类中，
    % 进行非对称性直方图到对称性直方图的变换。
    % 可能需要跳出本函数写新的代码。
    %---------------------------特别提示-----------------------------------
    
    % 如果目标和背景的灰度分布本身是对称的，直接阈值化
    binaryImg = originalImg>thEnhanced;%完成阈值化
    
    figure,imshow(originalImg);
    figure,imshow(binaryImg);

    