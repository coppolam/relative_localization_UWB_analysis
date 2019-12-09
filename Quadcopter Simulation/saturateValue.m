function [ outvalue_arr ] = saturateValue( value_arr, minv, maxv)
%SATURATEVALUE Input a value arr and it will be saturated to be within min
%and max

outvalue_arr = max(minv,min(value_arr,maxv));


end

