function [ z_kp1_k ] = calcZk(Zsymf,x)
%CALCZK Function that evaluates the Kalman output equation at a certain state and input
%   Zsymf - symbolic representation of Kalman output equation
%   x - state ([x_db; y_db; vx_db; vy_db; B])

x_db = x(1);
y_db = x(2);
vx_db = x(3);
vy_db = x(4);
B = x(5);

z_kp1_k = Zsymf(x_db,y_db,vx_db,vy_db,B);

end

