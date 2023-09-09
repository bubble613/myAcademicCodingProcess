load data_gauss
data=data(:,1);
K=3;
% GMM聚类算法  https://www.cnblogs.com/kailugaji/p/10759419.html
gmm=fitgmdist(data, K);
% 自定义参数
% RegularizationValue=0.001;   %正则化系数，协方差矩阵求逆
% MaxIter=1000;   %最大迭代次数
% TolFun=1e-8;   %终止条件
% gmm=fitgmdist(data, K, 'RegularizationValue', RegularizationValue, 'CovarianceType', 'diagonal', 'Start', 'plus', 'Options', statset('Display', 'final', 'MaxIter', MaxIter, 'TolFun', TolFun));
[N, D]=size(data);
mu=gmm.mu;  %均值
Sigma=gmm.Sigma;   %协方差矩阵
ComponentProportion=gmm.ComponentProportion;  %混合比例
Y=zeros(N, K);
for k=1:K
    Y(:,k)=ComponentProportion(k).*normpdf(data, mu(k), Sigma(:,:,k));
end
YY=sum(Y, 2);
plot(data,YY,'r.')