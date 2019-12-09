function [ optimx, optimval ] = giveUnobservable( initstate,initinput )
%GIVEUNOBSERVABLE function returns an unobservable state input pair
%   Numerically optimizes to find unobservable condition. Inputs are the
%   initial state and input, and whether it is condition 4 or 5. Returns
%   the unobservable vector (combination of state and input).

syms x y u1 v1 u2 v2 u1d v1d u2d v2d r1 r2 gam z1 z2 z w1 w2 w1d w2d k v1x v2x v1y v2y
v1v = [u1;v1];
v2v = [u2;v2];
a1v = [u1d;v1d];
a2v = [u2d;v2d];
pv = [x;y];
Rm = [cos(gam), -sin(gam);
    sin(gam), cos(gam)];
dRm = diff(Rm,gam);

km.state = [x;y;gam;u1;v1;u2;v2];
km.input = [u1d;v1d;u2d;v2d;r1;r2];
cond = pv.'*dRm*(-a2v*v1v.'+v2v*a1v.')+2*v1v.'*dRm*(v2v*v1v.'-v2v*v2v.'*Rm.');
condmfun = matlabFunction(cond,'vars',[km.state;km.input]);
condlfun = @(x) condmfun(x(1),x(2),x(3),x(4),x(5),x(6),x(7),x(8),x(9),x(10),x(11),x(12),x(13));
crosstwod = @(x,y) x(1)*y(2)-x(2)*y(1);
optfun = @(x) abs(crosstwod(condlfun(x),[x(1),x(2)]));

x0 = [initstate;initinput];
% options = optimoptions('fsolve','Algorithm','levenberg-marquardt');
options = optimset('Display','iter');
[x,fval] = fminsearch(optfun,x0,options);


optimx = x;
optimval = fval;

end

