function [ condval ] = checkFullCond( statein,inputin )
%CHECKFULLCOND Checks if the full condition for no heading system is
%violated. If condval is (near) zero, the condition is violated.



pv = [statein(1);statein(2)];
gam = statein(3);
v1v = [statein(4);statein(5)];
v2v = [statein(6);statein(7)];

a1v = [inputin(1);inputin(2)];
a2v = [inputin(3);inputin(4)];
% r1 = inputin(5);
% r2 = inputin(6);

Rm = [cos(gam), -sin(gam);
    sin(gam), cos(gam)];

dRm = [-sin(gam), -cos(gam);
    cos(gam), -sin(gam)];



cond = pv.'*dRm*(-a2v*v1v.'+v2v*a1v.')+2*v1v.'*dRm*(v2v*v1v.'-v2v*v2v.'*Rm.');
condval = cond(1)*pv(2)-cond(2)*pv(1);


end

