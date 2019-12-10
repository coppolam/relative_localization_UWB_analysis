syms x y u1 v1 u2 v2 u1d v1d u2d v2d r1 r2 gam z1 z2 z w1 w2 w1d w2d k
v1v = [u1;v1];
v2v = [u2;v2];
a1v = [u1d;v1d];
a2v = [u2d;v2d];
pv = [x;y];
Rm = [cos(gam), -sin(gam);
    sin(gam), cos(gam)];
dRm = diff(Rm,gam);
ddRm = diff(dRm,gam);
S1m = [0, -r1;
    r1, 0];
S2m = [0, -r2;
    r2, 0];
Am = [0 -1;1 0];

km = {};
km.state = [x;y;gam;u1;v1;u2;v2];
km.input = [u1d;v1d;u2d;v2d;r1;r2];
km.n = length(km.state);
km.fsym = [cos(gam)*u2 - sin(gam)*v2 - u1  + r1*y;
    sin(gam)*u2 + cos(gam)*v2 - v1 - r1*x;
    r2 - r1;
    u1d + r1 * v1;
    v1d - r1 * u1;
    u2d + r2 * v2;
    v2d - r2 * u2;];

km.h = [0.5*(x^2 + y^2);
    u1;
    v1;
    u2;
    v2;];

% statein = [  x  ;  y  ; gam ; u1 ; v1 ; u2 ; v2 ];
statein =   [ 2.2 ; 1   ; 0   ; 2  ; 1  ; 0  ; 1  ];
% inputin = [ u1d   ; v1d    ; u2d ; v2d ;  r1  ; r2 ];
inputin =   [  1    ;  0     ;  0  ;  0  ; 0    ; 0  ];

a = pv.'*dRm*(-a2v*v1v.'+v2v*a1v.')+2*v1v.'*dRm*(v2v*v1v.'-v2v*v2v.'*Rm.');
% b = eval(subs(a,[km.state;km.input],[statein;inputin]));
cond5 = pv.'*dRm*(-a2v*v1v.'+v2v*a1v.')+2*v1v.'*dRm*(v2v*v1v.'-v2v*v2v.'*Rm.')-k*pv.';
cond4 = pv.'*dRm*(-a2v*v1v.'+v2v*a1v.')+2*v1v.'*dRm*(v2v*v1v.'-v2v*v2v.'*Rm.');

%% Assumptions:
Agam = 0; Au1 = 0; Av1 = 0; Au2 = 1; Av2 = 1; Au1d = 0; Av1d= 0; Au2d =0;
Av2d =0; Ar1 = 0; Ar2 = 0; Ak = 1;
Ax = 1; Ay = 0;

cond4mfun = matlabFunction(cond4,'vars',[km.state;km.input]);
optfun4 = @(x) cond4mfun(x(1),x(2),x(3),x(4),x(5),x(6),x(7),x(8),x(9),x(10),x(11),x(12),x(13));

cond5mfun = matlabFunction(cond5,'vars',[km.state;km.input;k]);
optfun5 = @(x) cond5mfun(x(1),x(2),x(3),x(4),x(5),x(6),x(7),x(8),x(9),x(10),x(11),x(12),x(13),x(14));
