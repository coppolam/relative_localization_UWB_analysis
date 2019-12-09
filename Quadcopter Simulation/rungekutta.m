function [ x_kp1 ] = rungekutta( fsymf,x_k,dt )
%RKSOLUTION Summary of this function goes here
%   Detailed explanation goes here
localsymf = fsymf;

y = x_k;


k1 = localsymf(y);
k2 = localsymf(y+dt/2*k1);
k3 = localsymf(y+dt/2*k2);
k4 = localsymf(y+dt*k3);

x_kp1 = x_k + dt/6*(k1+2*k2+2*k3+k4);




end

