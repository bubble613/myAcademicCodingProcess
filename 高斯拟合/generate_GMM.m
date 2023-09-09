function data=generate_GMM()
%前两列是数据，最后一列是类标签
%数据规模
N=300;
%数据维度
% dim=1;
%
%混合比例
para_pi=[0.3 0.7 0.5];
%第一类数据
mul=0; % 均值
S1=1; % 协方差
data1=mvnrnd(mul, S1, para_pi(1)*N); % 产生高斯分布数据
%第二类数据
mu2=4;
S2=2;
data2=mvnrnd(mu2,S2,para_pi(2)*N);
%第三类数据
mu3=-4;
S3=1;
data3=mvnrnd(mu3,S3,para_pi(3)*N);
data = [data1, ones(para_pi(1)*N,1); data2, 2*ones(para_pi(2)*N,1); data3, 3*ones(para_pi(3)*N,1)];
save data_gauss data