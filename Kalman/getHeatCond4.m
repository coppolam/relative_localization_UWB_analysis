function [ X,Y, zarr4, zarrcrit4 ] = getHeatCond4( state0, input0, xrange, yrange, threshold)
%PLOTHEATCOND4 

syms x y u1 v1 u2 v2 u1d v1d u2d v2d r1 r2 gam z1 z2 z w1 w2 w1d w2d k
v1v = [u1;v1];
v2v = [u2;v2];
a1v = [u1d;v1d];
a2v = [u2d;v2d];
pv = [x;y];
Rm = [cos(gam), -sin(gam);
    sin(gam), cos(gam)];
dRm = diff(Rm,gam);

km = {};
km.state = [x;y;gam;u1;v1;u2;v2];
km.input = [u1d;v1d;u2d;v2d;r1;r2];
km.n = length(km.state);

cond4 = pv.'*dRm*(-a2v*v1v.'+v2v*a1v.')+2*v1v.'*dRm*(v2v*v1v.'-v2v*v2v.'*Rm.');

%% Assumptions:
Ax = state0(1); Ay=state0(2);Agam = state0(3); Au1 = state0(4); Av1 = state0(5); Au2 = state0(6); 
Av2 = state0(7); Au1d = input0(1); Av1d= input0(2); Au2d =input0(3);
Av2d =input0(4); Ar1 = input0(5); Ar2 =input0(6);


cond4mfun = matlabFunction(cond4,'vars',[km.state;km.input]);
funcond4 = @(x,y) cond4mfun(x,y,Agam,Au1,Av1,Au2,Av2,Au1d,Av1d,Au2d,Av2d,Ar1,Ar2);
funcond42 = @(u1,v1) cond4mfun(Ax,Ay,Agam,u1,v1,Au2,Av2,Au1d,Av1d,Au2d,Av2d,Ar1,Ar2);




dx = 0.05;
dy = 0.05;
xarr = xrange;%
yarr = yrange;%


curfun = funcond4;
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


[X,Y]=meshgrid(xarr,yarr);




end

