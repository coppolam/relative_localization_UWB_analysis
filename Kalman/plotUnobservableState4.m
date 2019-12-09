printfigs = false;

%% State
% statein = [  x  ;  y  ; gam ; u1 ; v1 ; u2 ; v2 ];
statein =   [ 2.2 ; 1   ; 0   ; 2  ; 1  ; 0  ; 1  ];
% inputin = [ u1d   ; v1d    ; u2d ; v2d ;  r1  ; r2 ];
inputin =   [  1    ;  0     ;  0  ;  0  ; 0    ; 0  ];

%% Symbolic definition
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

a = pv.'*dRm*(-a2v*v1v.'+v2v*a1v.')+2*v1v.'*dRm*(v2v*v1v.'-v2v*v2v.'*Rm.');
cond5 = pv.'*dRm*(-a2v*v1v.'+v2v*a1v.')+2*v1v.'*dRm*(v2v*v1v.'-v2v*v2v.'*Rm.')-k*pv.';
cond4 = pv.'*dRm*(-a2v*v1v.'+v2v*a1v.')+2*v1v.'*dRm*(v2v*v1v.'-v2v*v2v.'*Rm.');

%% Assumptions:
Agam = 0; Au1 = 0; Av1 = 0; Au2 = 1; Av2 = 1; Au1d = 0; Av1d= 0; Au2d =0;
Av2d =0; Ar1 = 0; Ar2 = 0; Ak = 1;
Ax = 1; Ay = 0;

cond4mfun = matlabFunction(cond4,'vars',[km.state;km.input]);
funcond4 = @(x,y) cond4mfun(x,y,Agam,Au1,Av1,Au2,Av2,Au1d,Av1d,Au2d,Av2d,Ar1,Ar2);
funcond42 = @(u1,v1) cond4mfun(Ax,Ay,Agam,u1,v1,Au2,Av2,Au1d,Av1d,Au2d,Av2d,Ar1,Ar2);

cond5mfun = matlabFunction(cond5,'vars',[km.state;km.input;k]);
funcond5 = @(x,y) cond5mfun(x,y,Agam,Au1,Av1,Au2,Av2,Au1d,Av1d,Au2d,Av2d,Ar1,Ar2,Ak);
funcond52 = @(u1,v1) cond5mfun(Ax,Ay,Agam,u1,v1,Au2,Av2,Au1d,Av1d,Au2d,Av2d,Ar1,Ar2,Ak);
funcond53 = @(x,y,k) cond5mfun(x,y,Agam,Au1,Av1,Au2,Av2,Au1d,Av1d,Au2d,Av2d,Ar1,Ar2,k);

yrange = 5;
xrange = 5;
threshold = 1;

dx = 0.05;
dy = 0.05;
xarr = -xrange:dx:xrange; 
yarr = -yrange:dy:yrange;
zarr = zeros(length(yarr),length(xarr));
zarrcrit = zeros(length(yarr),length(xarr));

curfun = funcond42;
zarr4 = zeros(length(yarr),length(xarr));
zarrcrit4 = zeros(length(yarr),length(xarr));
for xind = 1:length(xarr)
    for yind = 1:length(yarr)
        curans = curfun(xarr(xind),yarr(yind));
        curval = sqrt(curans(1).^2 + curans(2).^2);
        zarr4(yind,xind) = curval;
        if(curval<threshold)
            zarrcrit4(yind,xind) = 1;
        else
            zarrcrit4(yind,xind)=0;
        end
    end
end

file = strcat('C:\Users\Steven\Dropbox\Thesis\Figures\Observability\cond4_obs_noacc.eps');

fontsize = 20;
dxplot = 1;
dyplot = 1;
[X,Y]=meshgrid(xarr,yarr);
h = figure('Renderer','painters');
if (printfigs)
    set(h,'Visible','off');
end
set(gca,'XTick',-xrange:dxplot:xrange,...
    'YTick',-yrange:dyplot:yrange,...
    'FontSize',fontsize,...
    'FontUnits','points','FontWeight','normal','FontName','Times');
hold on;
axis([-xrange xrange -yrange yrange]);
surf(X,Y,zarr4,'EdgeColor','None');
view(2)
cb = colorbar;
hcrit = surf(X,Y,zarrcrit4,'EdgeColor','None','FaceColor','red');
t=get(cb,'Limits');
set(cb,'Ticks',round(linspace(t(1),t(2),5),2));
legend(hcrit,'unobservable','location','northwest');
xlabel('u1 [m/s]','FontUnits','points','interpreter','latex','FontSize',fontsize,'FontName','Times');
ylabel('v1 [m/s]','FontUnits','points','interpreter','latex','FontSize',fontsize,'FontName','Times');
if (printfigs)
    print(file,'-depsc2','-opengl');
end
