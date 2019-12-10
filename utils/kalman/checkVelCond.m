function [ condval ] = checkVelCond( statein )
%CHECKVELCOND Summary of this function goes here
%   Detailed explanation goes here

v1v = [statein(4);statein(5)];
v2v = [statein(6);statein(7)];
condval = v1v(1)*v2v(2)-v1v(2)*v2v(1);

end

