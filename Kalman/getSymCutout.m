function [ cutout ] = getSymCutout( Oxmat,rows,cols )
%GETCUTOUT Summary of this function goes here
%   Detailed explanation goes here

m = length(rows);
n = length(cols);
cutout = sym(zeros(m,n));

for i = 1:m
    for j = 1:n
        cutout(i,j) = Oxmat(rows(i),cols(j));
    end
end


end

