function [h] = subCreateFilter(size)
h = zeros(size);
col = fix(size/2);
h(:, 1:col) = -1/(col * size);
h(:, col + 1) = 0;
h(:, col+2:size) = 1/(col * size);

