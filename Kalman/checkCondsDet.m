function [ cond4val, cond5val, detval ] = checkCondsDet( statein, inputin )
%CHECKCONDSDET check if a state is unobservable

syms x y u1 v1 u2 v2 u1d v1d u2d v2d r1 r2 gam z1 z2 z w1 w2 w1d w2d
v1v = [u1;v1];
v2v = [u2;v2];
a1v = [u1d;v1d];
a2v = [u2d;v2d];
pv = [x;y];
Rm = [cos(gam), -sin(gam);
    sin(gam), cos(gam)];
dRm = diff(Rm,gam);
A=[0 -1;
    1 0];


km.state = [x;y;gam;u1;v1;u2;v2];
km.input = [u1d;v1d;u2d;v2d;r1;r2];
cond = pv.'*dRm*(-a2v*v1v.'+v2v*a1v.')+2*v1v.'*dRm*(v2v*v1v.'-v2v*v2v.'*Rm.');
condmfun = matlabFunction(cond,'vars',[km.state;km.input]);
optfun = @(x) condmfun(x(1),x(2),x(3),x(4),x(5),x(6),x(7),x(8),x(9),x(10),x(11),x(12),x(13));



detf = (pv.'*dRm*(-a2v*v1v.'+v2v*a1v.')+2*v1v.'*dRm*(v2v*v1v.'-v2v*v2v.'*Rm.'))*A*pv;
detmfun = matlabFunction(detf,'vars',[km.state;km.input]);

pvin = [statein(1);statein(2)];
twodcross = @(x,y) x(1)*y(2) - x(2)*y(1);

optfunnorm4 = @(x) norm(optfun(x));
optfunnorm5 = @(x) twodcross(optfun(x),pvin);
optfundet = @(x) detmfun(x(1),x(2),x(3),x(4),x(5),x(6),x(7),x(8),x(9),x(10),x(11),x(12),x(13));


xin = [statein;inputin];

cond4val = optfunnorm4(xin);
cond5val = optfunnorm5(xin);
detval = optfundet(xin);


% detv4 = (pv.'*dRm*(-a2v*v1v.'+v2v*a1v.')+2*v1v.'*dRm*(v2v*v1v.'-v2v*v2v.'*Rm.'))*A*pv;
% 
% detval = eval(subs(detv4,[km.state;km.input],x));

end

