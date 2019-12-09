function [ outvalue_arr ] = saturateNorm( value_arr, max )
%SATURATENORM Summary of this function goes here
%   Detailed explanation goes here
length = norm(value_arr);
if (length<=max)
    outvalue_arr = value_arr;
else
    outvalue_arr = value_arr./length*max;
end

end

