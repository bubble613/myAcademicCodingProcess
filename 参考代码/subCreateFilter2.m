function [h] = subCreateFilter2(size)
h = zeros(size);
row = fix(size/2);
h(1:row, :) = -1/(row * size);
h(row+1, :) = 0;
h(row+2:size, :) = 1/(row * size);