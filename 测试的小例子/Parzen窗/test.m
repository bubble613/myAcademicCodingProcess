N=[2^4,2^8,2^16]';
x=-4:0.01:4;
% y=1/sqrt(2*pi)*exp(-0.5*x.^2);
y=1/(sqrt(2*pi)*0.3)*exp(-0.5*x.^2/0.09);
h1=[0.5,1,4];
h=h1./sqrt(N);
figure
for Ni=1:length(N) %按照指定样本数序列进行仿真
    X=normrnd(0,0.3,1,N(Ni));%生成指定数目特定分布的样本
    for hi=1:length(h1)  %取指定的h值
        subplot(length(N),length(h1),(Ni-1)*length(h1)+hi)
        p=zeros(1,length(x));%一维概率密度矩阵
        for xi=1:length(x) %概率密度网格遍历
            %根据parezen窗的叠函数求取概率密度
            Xi=x(xi)*ones(1,N(Ni));%Xi中心向量
%             p(xi)=1/(sqrt(2*pi)*h(Ni,hi)*N(Ni))*sum(exp(-0.5*((X-Xi)/h(Ni,hi)).^2));
            p(xi)=1/(sqrt(2*pi)*h(Ni,hi)*N(Ni))*sum(exp(-0.5*((X-Xi)/h(Ni,hi)).^2));
%             p(xi)=1/(sqrt(2*pi*N(Ni))*h(Ni,hi))*sum(exp(-0.5*((X-Xi).^2)/h(Ni,hi)));

        end
        plot(x,p,'k-')   %估计的概率密度
        hold on 
        plot(x,y,'r--')  %真实的概率密度
        title(['N=',num2str(N(Ni)),'  h1=',num2str(h1(hi))])
    end
end
