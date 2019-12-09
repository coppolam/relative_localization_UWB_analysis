function [ x_kp1_k ] = calcOneStepAheadPrediction( x_k_k, dt )
%CALCONESTEPAHEADPREDICTION Calculates the one step ahead prediction of the
%state according to the system equations
%   This function simply applies a Euler integration for a single timestep
%   using the input to the system


x_kp1_k = x_k_k + [x_k_k(3);x_k_k(4);0;0;0]*dt;

end

