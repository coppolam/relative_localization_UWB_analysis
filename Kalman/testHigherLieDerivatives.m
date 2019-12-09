km = {};
syms x y u1 v1 u2 v2 u1d v1d u2d v2d r1 r2 gam z1 z2 z w1 w2 w1d w2d

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

statein = [x;y;gam;0;0;u2;v2];
inputin=[0;0;u2d;v2d;r1;r2];
state = [x;y;gam;u1;v1;0;0];
input = [u1d;v1d;0;0;r1;r2];

intot = [statein;inputin];

km.h = [0.5*(x^2 + y^2);
    u1;
    v1;
    u2;
    v2;];

km.Hxsym = jacobian(km.h,km.state);

Hxf = km.Hxsym*km.fsym;
Hxxf = simplify(jacobian(Hxf,km.state));
Hxxff = Hxxf * km.fsym;
Hxxxff = simplify(jacobian(Hxxff, km.state));
H3x3f = Hxxxff * km.fsym;
H4x3f = simplify(jacobian(H3x3f,km.state));
H4x4f = H4x3f*km.fsym;
H5x4f = simplify(jacobian(H4x4f,km.state));
H5x5f = H5x4f*km.fsym;
H6x5f = simplify(jacobian(H5x5f,km.state));



Ox = km.Hxsym;
Oxsub = eval(subs(Ox,[km.state;km.input],[statein;inputin]));
Ox2 = [km.Hxsym;Hxxf];
Ox2sub = eval(subs(Ox2,[km.state;km.input],[statein;inputin]));
Ox3 = [km.Hxsym;Hxxf;Hxxxff];
Ox3sub = eval(subs(Ox3,[km.state;km.input],intot));
Ox4 = [km.Hxsym;Hxxf;Hxxxff;H4x3f];
Ox4sub = eval(subs(Ox4,[km.state;km.input],intot));
Ox5 = [Ox4;H5x4f];
Ox5sub = eval(subs(Ox5,[km.state;km.input],intot));
Ox6 = [Ox5;H6x5f];
Ox6sub = eval(subs(Ox6,[km.state;km.input],intot));

cutoutrows = [1,6,11];
cutoutcols = [1,2,3];

Ox33 = getSymCutout(Ox6,cutoutrows,cutoutcols);
Ox33sub = getSymCutout(Ox6sub,cutoutrows,cutoutcols);
Ox44 = getSymCutout(Ox6,[cutoutrows,16],cutoutcols);
Ox44sub = getSymCutout(Ox6sub,[cutoutrows,16],cutoutcols);
Ox55 = getSymCutout(Ox6,[cutoutrows,16,21],cutoutcols);
Ox55sub = getSymCutout(Ox6sub,[cutoutrows,16,21],cutoutcols);
Ox66 = getSymCutout(Ox6,[cutoutrows,16,21,26],cutoutcols);
Ox66sub = getSymCutout(Ox6sub,[cutoutrows,16,21,26],cutoutcols);
