function [ x_kp1 ] = rksolution( fsymf,x_k,inp,dt )
%RKSOLUTION Summary of this function goes here
%   Detailed explanation goes here
localsymf = @(y) fsymf(y(1),y(2),y(3),y(4),y(5),y(6),y(7),...
                y(8),inp(1),inp(2),inp(3),inp(4),inp(5),inp(6),inp(7),inp(8),inp(9));
y = x_k;

k1 = localsymf(y);
k2 = localsymf(y+dt/2*k1);
k3 = localsymf(y+dt/2*k2);
k4 = localsymf(dt*k3);

x_kp1 = x_k + dt/6*(k1+2*k2+2*k3+k4);

end

