function [verdict]=iseven(candy)
verdict=zeros(size(candy));
isint=find(isint(candy)==1);
divided2=candy(isint)/2;
evens=(divided2==floor(divided2));
verdict(isint)=evens;
return;
