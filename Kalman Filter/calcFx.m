function [ Fx ] = calcFx()
%CALCFX Function that evaluates Fx at a certain state and input. It will
%always be a constant matrix for this system
% x - state ([x_db; y_db; vx_db; vy_db;B])


Fx = zeros(5,5);
Fx(1,3)=1;
Fx(2,4)=1;

end

