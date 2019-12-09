function [ Hxeval ] = calcHx( Hxsymf,x)
%CALCHX Function that evaluates Hx at a certain state and input
%   Hxsymf - symbolic representation of Hx
%   x - state ([x_db; y_db; vx_db; vy_db; B])

x_db = x(1);
y_db = x(2);
vx_db = x(3);
vy_db = x(4);
B = x(5);

Hxeval = Hxsymf(x_db,y_db,vx_db,vy_db,B);


end

