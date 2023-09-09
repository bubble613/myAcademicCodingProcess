%%%%%子函数%%%%%
function  [m]=zpossible(n)
% 功能：判断n是偶数还是奇数，是偶数时，m取0,2,4,6等,否则取奇数赋值m
if iseven(n)
    m=0:2:n;
else
    m=1:2:n;
end
return;
