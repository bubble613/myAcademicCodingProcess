function [t] = mainComplex3Class(iterateTimes,kMax,clusterN)
% 初步实验结果表明，将过渡区分成3类并不比分成2类更好，
% 参考mainComplex函数的说明。

% 函数调用示例
% close all;mainComplex3Class(10,250,3);
% close all;mainComplex3Class(10,10,3);

% 函数功能：以mainSimple为基础，通过更改k由单一取值变为取1到10范围的值，
% 并结合k-means聚类将不同过渡区灰度均值分为两类。
% 最后根据从两类均值中选择相对更平稳的一类的均值作为分割阈值。

% 初步实验结果表明，当图像目标和背景的灰度分布总体为对称分布（比如正态分布
% 或近似正态分布），目标和背景的大小比例可以是平衡的，也可以是不平衡的，
% 可以利用该方法获得较为理想的过渡区阈值。
% 【尚待完成的】当目标和背景的灰度分布不对称，比如为瑞利分布、极值分布等，可以利用该方法选择
% 相对平稳的一类，然后再改类的基础上，结合对称性变换，应该可以得到较为理想的
% 过渡区阈值。

% 函数参数：
% iterateTimes：控制多尺度乘积的次数，初步建议取值10以下。
% k：控制从多尺度乘积图像提取过渡区的参数，初步建议取值1到10。
% clusterN：控制过渡区均值的聚类数量，初步建议取值2。

    [fileName,pathName] = uigetfile({'*.bmp';'*.jpg';'*.*'},'File Selector');
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
    t = localThresholding(originalImg,t(:),IDX,C,clusterN);%阈值化

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
    disp(C);%显示聚类中心点

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

function [t]=localThresholding(originalImg,tVector,IDX,C,clusterN)
% 函数功能：看哪个类更平稳一些，如果目标和背景的灰度分布本身就是对称的，
% 那么可以直接以平稳的哪一类的均值作为分割阈值。
% 如果目标和背景的灰度分布本身不是对称的，比如瑞利分布或者极值分布等，
% 可以利用该段代码估计平稳的一类，然后以此为基础，进行非对称性像对称性的转换
% 转换完了以后，再求阈值。
    
    %目前假定clusterN就是2类，如果是3类或者更多类，代码要略微改变
    tempData1 = tVector(IDX==1);
    stdTempData1 = std(tempData1);
    tempData2 = tVector(IDX==2);
    stdTempData2 = std(tempData2);
    tempData3 = tVector(IDX==clusterN);
    stdTempData3 = std(tempData3);
    % 目前使用标准差作为平稳性的度量，后面可以考虑其它的度量
    %哪个标准差小，哪个类就更平稳。
    [stableC,stableIndex] = min([stdTempData1 stdTempData2 stdTempData3]);
    
    switch stableIndex
        case 1
            t=mean(tempData1);
        case 2
            t=mean(tempData2);
        case 3
            t=mean(tempData2);
    end
    disp(['看看t=',num2str(t),'是不是C中的一个值:',num2str(C(:)')]);
    
    %---------------------------特别提示-----------------------------------
    % 如果目标和背景的灰度分布本身不是对称的，考虑从标准差更小的那一类中，
    % 进行非对称性直方图到对称性直方图的变换。
    % 可能需要跳出本函数写新的代码。
    %---------------------------特别提示-----------------------------------
    
    % 如果目标和背景的灰度分布本身是对称的，直接阈值化
    binaryImg = originalImg>t;%完成阈值化
    
    figure,imshow(originalImg);
    figure,imshow(binaryImg);
    
    
    