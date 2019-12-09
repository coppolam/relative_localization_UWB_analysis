syms px py phi v1 v2 w1 w2
state = [px;py;phi];
input = [v1;v2;w1;w2];
n = length(state);
fsym = [-v1+cos(phi)*v2+py*w1;
    sin(phi)*v2-px*w1;
    w2 - w1];
h = 0.5*(px^2+py^2);
% h = [0.5*(px^2+py^2);
%     v1;
%     v2;
%     w1;
%     w2];
%state =  [ px ; py ; phi ];
statein = [0 ;0 ;2    ];
%input =  [ v1 ; v2 ; w1 ; w2 ];
inputin = [ 1  ; 3  ; 0   ;0   ];


Hxsym = jacobian(h,state);

Hxf = Hxsym*fsym;
Hxxf = simplify(jacobian(Hxf,state));
Hxxff = Hxxf * fsym;
Hxxxff = simplify(jacobian(Hxxff, state));
H3x3f = Hxxxff * fsym;
H4x3f = simplify(jacobian(H3x3f,state));
H4x4f = H4x3f*fsym;
H5x4f = simplify(jacobian(H4x4f,state));
H5x5f = H5x4f*fsym;
H6x5f = simplify(jacobian(H5x5f,state));

Ox = Hxsym;
Ox2 = [Hxsym;Hxxf];
Ox3 = [Hxsym;Hxxf;Hxxxff];
Ox4 = [Hxsym;Hxxf;Hxxxff;H4x3f];
Ox5 = [Ox4;H5x4f];
Ox6 = [Ox5;H6x5f];

Ox6sub = eval(subs(Ox6,[state;input],[statein;inputin]));
fprintf('Rank Ox6 is %i/%i\n',rank(Ox6sub),n);