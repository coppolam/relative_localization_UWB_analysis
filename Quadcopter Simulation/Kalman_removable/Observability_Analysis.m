% clearvars;
km = KalmanClass("Kalman_no_heading3");
%km = KalmanClass("Kalman_mario");

% km = {};
% syms theta phi rho w2 w1 v2 v1 theta1 x1 y1
% km.state = [rho;phi;theta];
% km.fsym = [v1*cos(theta1);
%     v1*sin(theta1);
%     w1;
%     v2*cos(theta-phi)-v1*cos(phi);
%     (v2/rho)*sin(theta-phi)-(v1/rho)*sin(phi);
%     w2-w1];
% km.fsym = [v2*cos(theta-phi)-v1*cos(phi);
%     (v2/rho)*sin(theta-phi)-(v1/rho)*sin(phi);
%     w2-w1];

% km.h = rho;
% km.Hxsym = jacobian(km.h,km.state);
if(exist('Hxxf','var')~=1 || exist('Hxxxff','var') ~= 1 || exist('H4x3f','var') ~= 1)
    Hxf = km.Hxsym*km.fsym;
    Hxxf = simplify(jacobian(Hxf,km.state));
    Hxxff = Hxxf * km.fsym;
    Hxxxff = simplify(jacobian(Hxxff, km.state));
    H3x3f = Hxxxff * km.fsym;
    H4x3f = simplify(jacobian(H3x3f,km.state));
end

% state:   [x12; y12 ; z1 ; z2 ; u1 ; v1 ; u2 ; v2 ; gam ];
statein = [ 0.7; 1.3 ; 1  ; 0  ; 225.3  ; 225.3*1.44  ; 1  ; 1.44  ; 0  ];
% input:   [u1dm;v1dm; u2dm ;v2dm;r1m;r2m];
inputin = [ 2  ; 2.88; 0  ;  0 ; 0 ; 0 ];

% assumptions = [km.state(1:4)];
% subsvals    = [1;1;1;1];
% 
% %state:  [x_rel;y_rel;ownvx;ownvy;othvx;othvy;z_rel];
% statein = [ 1  ;  1  ;  0  ;   0 ;  0  ;   0 ;  0  ];
% inputin = [];
% assumptions = [];
% subsvals = [];

Ox = km.Hxsym;
Oxsub = eval(subs(Ox,[km.state;km.input],[statein;inputin]));
Ox2 = [km.Hxsym;Hxxf];
Ox2sub = eval(subs(Ox2,[km.state;km.input],[statein;inputin]));
Ox3 = [km.Hxsym;Hxxf;Hxxxff];
Ox3sub = eval(subs(Ox3,[km.state;km.input],[statein;inputin]));
Ox4 = [km.Hxsym;Hxxf;Hxxxff;H4x3f];
Ox4sub = eval(subs(Ox4,[km.state;km.input],[statein;inputin]));


fprintf('Rank observability is %i/%i\n',rank(Ox4sub),km.n);

%Ox3simplified = subs(Ox3,assumptions,subsvals);
%digits(4);
%Ox3simplifieddec = vpa(Ox3simplified);
% filenamesym = "symobsmat.txt";
% symbolic_mat_print(filenamesym,Ox3);
% 
% filenamesymsimplified = "symobsmatsimplified.txt";
% symbolic_mat_print(filenamesymsimplified,Ox3simplified);
% 
% filenamesymdec = "symobsmatdec.txt";
% symbolic_mat_print(filenamesymdec,Ox3simplifieddec);
% 
% fprintf('Rank observability is %i/%i\n',rank(Ox3sub),km.n);
% 
% importmat = [Ox3(1,1:2),Ox3(1,9);
%     Ox3(8,1:2),Ox3(8,9);
%     Ox3(15,1:2),Ox3(15,9)];
% 
% filenameimp = "importantmat.txt";
% symbolic_mat_print(filenameimp,importmat);
% 
% simpledet = simplify(det(importmat));
% 
% filenamedet = "determinant.txt";
% symbolic_mat_print(filenamedet,simpledet);