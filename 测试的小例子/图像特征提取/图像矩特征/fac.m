
%%%%%子函数%%%%%
function [factorial]=fac(n)
%功能：求n的阶乘
maxno=max(max(n));
zerosi=find(n<=0); %取n小于等于0的数
n(zerosi)=ones(size(zerosi));
factorial=n;
findex=n;
for i=maxno:-1:2
    cand=find(findex>2);
    candidates=findex(cand);
    findex(cand)=candidates-1;
    factorial(cand)=factorial(cand).*findex(cand);
end
return;
