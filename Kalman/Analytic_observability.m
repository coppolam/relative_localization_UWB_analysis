%%
% clearvars;

% type = "noacc";5
type = "acc";
% type = "northacc";
% type = "accheight";

km = {};
syms x y u1 v1 u2 v2 u1d v1d u2d v2d r1 r2 gam z1 z2 z w1 w2 w1d w2d
if(type=="acc")
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

%     statein = [  x  ;  y  ; gam ; u1 ; v1 ; u2 ; v2 ];
%     statein =   [ 1  ; 1   ; 0   ; 1  ; 2  ; 3.1  ; 4  ];
statein = [-4.8217
    6.6911
    2.8019
   -2.9395
   -0.9431
   -1.7847
    0.6255];
%     inputin = [ u1d   ; v1d    ; u2d ; v2d ;  r1  ; r2 ];
%     inputin =   [  1    ;  1     ;  1  ;  1  ; 0    ; 0  ];
inputin = [-1.5192
    3.4000
   -1.4443
    2.8449
    0.3039
   -2.1969];

    km.h = [0.5*(x^2 + y^2);
    u1;
    v1;
    u2;
    v2;];
elseif(type=="accheight")
    km.state = [x;y;z;gam;u1;v1;w1;u2;v2;w2];
    km.input = [u1d;v1d;u2d;v2d;r1;r2];
    km.n = length(km.state);
    km.fsym = [cos(gam)*u2 - sin(gam)*v2 - u1  + r1*y;
        sin(gam)*u2 + cos(gam)*v2 - v1 - r1*x;
        w2 - w1;
        r2 - r1;
        u1d + r1 * v1;
        v1d - r1 * u1;
        w1d;
        u2d + r2 * v2;
        v2d - r2 * u2;
        w2d;];

    % statein = [  x  ;  y  ; z ; gam ; u1 ; v1 ; w1 ; u2 ; v2 ; w2];
    statein =   [ 0   ; 0   ; 9.8 ;   1 ; 0  ; 0  ; 0  ; 0  ; 0  ;  0];
    % inputin = [ u1d   ; v1d    ; u2d ; v2d ;  r1  ; r2 ];
    inputin =   [  1    ;  2     ;  3  ;  4  ; 1    ; 0  ];
    km.h = [0.5*(x^2 + y^2+z^2);
        z;
    u1;
    v1;
    w1;
    u2;
    v2;
    w2;];
elseif(type=="northacc")
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

    % statein = [  x  ;  y  ; gam ; u1 ; v1 ; u2 ; v2 ];
    statein =   [ 1   ; 1 ; 0   ; 2  ; 2  ; 0  ; 0  ];
    % inputin = [ u1d   ; v1d    ; u2d ; v2d ;  r1  ; r2 ];
    inputin =   [  0    ;  0     ;  0  ;  0  ; 0    ; 0  ];
    km.h = [0.5*(x^2 + y^2);
        gam
        u1;
        v1;
        u2;
        v2;];
elseif (type=="noacc")
    km.h = [0.5*(x^2 + y^2);]; 

    km.state = [x;y;gam];
    km.input = [u1;v1;u2;v2;r1;r2];
    km.n = length(km.state);
    km.fsym = [cos(gam)*u2 - sin(gam)*v2 - u1  + r1*y;
        sin(gam)*u2 + cos(gam)*v2 - v1 - r1*x;
        r2 - r1;];

    % statein = [  x  ;  y  ; gam];
    statein =   [ 0.7 ; 1.2 ; 0];
    % inputin = [ ; u1 ; v1 ; u2 ; v2 ;  r1  ; r2 ];
    inputin =   [  1  ;  0  ;  2  ;  0  ; 1  ; 0  ];
end

    


km.Hxsym = jacobian(km.h,km.state);
if(exist('Hxxf','var')~=1 || exist('Hxxxff','var') ~= 1 || exist('H4x3f','var') ~= 1)
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
    
end


intot = [statein;inputin];


Ox = km.Hxsym;
% Oxsub = eval(subs(Ox,[km.state;km.input],[statein;inputin]));
Ox2 = [km.Hxsym;Hxxf];
% Ox2sub = eval(subs(Ox2,[km.state;km.input],[statein;inputin]));
Ox3 = [km.Hxsym;Hxxf;Hxxxff];
Ox3sub = eval(subs(Ox3,[km.state;km.input],intot));
Ox4 = [km.Hxsym;Hxxf;Hxxxff;H4x3f];
Ox4sub = eval(subs(Ox4,[km.state;km.input],intot));
Ox5 = [Ox4;H5x4f];
Ox5sub = eval(subs(Ox5,[km.state;km.input],intot));
Ox6 = [Ox5;H6x5f];
Ox6sub = eval(subs(Ox6,[km.state;km.input],intot));

fprintf('Rank Ox3 is %i/%i\n',rank(Ox3sub),km.n);
fprintf('Rank Ox4 is %i/%i\n',rank(Ox4sub),km.n);
fprintf('Rank Ox5 is %i/%i\n',rank(Ox5sub),km.n);
fprintf('Rank Ox6 is %i/%i\n',rank(Ox6sub),km.n);
fprintf('\n');

cutoutrows = [1,6,11];
cutoutcols = [1,2,3];

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

if (type=="acc" && length(km.h)>1)
Ox33 = getSymCutout(Ox6,cutoutrows,cutoutcols);
Ox44 = getSymCutout(Ox6,[cutoutrows,16],cutoutcols);
Ox55 = getSymCutout(Ox6,[cutoutrows,16,21],cutoutcols);
Ox66 = getSymCutout(Ox6,[cutoutrows,16,21,26],cutoutcols);

Ox33sub= getCutout(Ox6sub,cutoutrows,cutoutcols);
Ox44sub = getCutout(Ox6sub,[cutoutrows,16],cutoutcols);
Ox55sub = getCutout(Ox6sub,[cutoutrows,16,21],cutoutcols);
Ox66sub = getCutout(Ox6sub,[cutoutrows,16,21,26],cutoutcols);

% detn = det(Ox33);

% detval = eval(subs(detn,[km.state;km.input],intot))
% 
a = pv.'*dRm*(-a2v*v1v.'+v2v*a1v.')+2*v1v.'*dRm*(v2v*v1v.'-v2v*v2v.'*Rm.');
b = eval(subs(a,[km.state;km.input],[statein;inputin]));
%c = b./statein(1:2).'
fun = @(x,y,gam,u1,v1,u2,v2,u1d,v1d,u2d,v2d,r1,r2) eval(subs(a,[km.state;km.input],[x;y;gam;u1;v1;u2;v2;u1d;v1d;u2d;v2d;r1;r2])).';
fun2 = @(x) fun(x(1),x(2),x(3),x(4),x(5),x(6),x(7),x(8),x(9),x(10),x(11),x(12),x(13));
fun3 = @(x,y,gam,u1,v1,u2,v2,u1d,v1d,u2d,v2d,r1,r2,c) eval(subs(a-c*pv.',[km.state;km.input],[x;y;gam;u1;v1;u2;v2;u1d;v1d;u2d;v2d;r1;r2])).';
fun4 = @(x) fun3(x(1),x(2),x(3),x(4),x(5),x(6),x(7),x(8),x(9),x(10),x(11),x(12),x(13),x(14));

% x0 = [statein;inputin];
% options = optimoptions('fsolve','Algorithm','levenberg-marquardt');
% [xd,fval] = fsolve(fun2,x0,options);
% xd.';
% fval.';
% [x2d,fval2] = fsolve(fun4,[x0;1],options);
% x2d.';
% fval2.';

% cutout = [Ox3(1,1:3);Ox3(6,1:3);Ox3(11,1:3)];
% 
% detcutout = simplify(det(cutout));
% 

end

Oxcut = [Ox3(1,1:2); Ox3(7,1:2)];
detn = det(Oxcut);
A = [0 1;-1 0];
detv = pv.'*A*(-v1v+Rm*v2v);

Hxxfv = [-v1v.'+v2v.'*Rm.', pv.'*dRm*v2v, -pv.', pv.'*Rm];

Lf2hbas = (-v1v.'+v2v.'*Rm.')*(-v1v+Rm*v2v-S1m*pv)+pv.'*dRm*v2v*(r2-r1)+...
    pv.'*(-a1v+S1m*v1v+Rm*a2v-Rm*S2m*v2v);

Lf2h = simplify(v1v.'*v1v - v1v.'*Rm*v2v + v1v.'*S1m*pv - v2v.'*Rm.'*v1v + v2v.'*v2v-...
    v2v.'*Rm.'*S1m*pv + pv.'*dRm*v2v*(r2-r1) + pv.'*(-a1v+S1m*v1v+Rm*a2v-Rm*S2m*v2v));

Lf2hsimp = v1v.'*v1v - 2*v1v.'*Rm*v2v +v2v.'*v2v + pv.'*dRm*v2v*r2+...
    -pv.'*a1v+pv.'*Rm*a2v-pv.'*Rm*S2m*v2v;

Hxxxffv = [r2*v2v.'*dRm.'-a1v.'+a2v.'*Rm.'-v2v.'*S2m.'*Rm.',...
    -2*v1v.'*dRm*v2v+pv.'*ddRm*v2v*r2+pv.'*dRm*a2v-pv.'*dRm*S2m*v2v,...
    2*v1v.'-2*v2v.'*Rm.', -2*v1v.'*Rm + 2*v2v.' + r2*pv.'*dRm - pv.'*Rm*S2m];

Hxxxffvsimp = [-a1v.' + a2v.' * Rm.', -2 * v1v.' * dRm * v2v + pv.' * dRm * a2v,...
    2*v1v.' - 2*v2v.' * Rm.', -2*v1v.'*Rm + 2*v2v.'];

Oxpartn = Ox3(1:3,1:3);
Oxpart =  [pv.', 0; -v1v.' + v2v.'*Rm.', pv.'*dRm*v2v;-a1v.'+a2v.'*Rm.', -2*v1v.'*dRm*v2v+pv.'*dRm*a2v];

detv = det([-v1v.'+v2v.'*Rm.';
    -a1v.'+a2v.'*Rm.']);
detv = detv - det([-v1v.'+v2v.'*Rm.';-a1v.'+a2v.'*Rm.'] + [pv.'*dRm*v2v;
    -2*v1v.'*dRm*v2v+pv.'*dRm*a2v]*pv.');
detv = simplify(detv);

A = [0 -1;1 0];

detv2 = (pv.'*dRm*a2v-2*v1v.'*dRm*v2v)*(-v1v.'+v2v.'*Rm.')*A*pv - pv.'*dRm*v2v*(-a1v.'+a2v.'*Rm.')*A*pv;
% 
detv3 = (pv.'*dRm*(-a2v*v1v.'+a2v*v2v.'*Rm.'+v2v*a1v.'-v2v*a2v.'*Rm.')+2*v1v.'*dRm*(v2v*v1v.'-v2v*v2v.'*Rm.'))*A*pv;
% 
detv4 = (pv.'*dRm*(-a2v*v1v.'+v2v*a1v.')+2*v1v.'*dRm*(v2v*v1v.'-v2v*v2v.'*Rm.'))*A*pv;



Ox3simplified = subs(Ox3,assumptions,subsvals);
digits(4);
Ox3simplifieddec = vpa(Ox3simplified);
filenamesym = "symobsmat.txt";
symbolic_mat_print(filenamesym,Ox3);

filenamesymsimplified = "symobsmatsimplified.txt";
symbolic_mat_print(filenamesymsimplified,Ox3simplified);

filenamesymdec = "symobsmatdec.txt";
symbolic_mat_print(filenamesymdec,Ox3simplifieddec);

fprintf('Rank observability is %i/%i\n',rank(Ox3sub),km.n);

importmat = [Ox3(1,1:2),Ox3(1,9);
    Ox3(8,1:2),Ox3(8,9);
    Ox3(15,1:2),Ox3(15,9)];

filenameimp = "importantmat.txt";
symbolic_mat_print(filenameimp,importmat);

simpledet = simplify(det(importmat));

filenamedet = "determinant.txt";
symbolic_mat_print(filenamedet,simpledet);