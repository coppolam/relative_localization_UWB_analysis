syms x y u1 v1 u2 v2 u1d v1d u2d v2d gam r1 r2

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


eq11 = -v2v.'*Rm.'*S1m
eq12 = -a1v.'+v1v.'*S1m.'
eq13 = a2v.'*R.'
eq14 = -v2v.'*S2m.'*R.'
eq15 = v2v.'*dRm.'*(r2-r1)
eq1 = simplify(eq11 + eq12 + eq13 + eq14+ eq15);