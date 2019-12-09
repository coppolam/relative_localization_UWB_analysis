function [ P, Q, R ] = setupPQRmatrices( xvec, zvec, q, r)
%setupQRmatrices Sets up the Q and R matrices for the EKF according to the
%state vector and the measurement vector
% Input: xvec, zvec, stdev of process, stdev of measurement.
%
% Developed by Mario Coppola, November 2015

n = size(xvec,2); % Number of states
m = size(zvec,2); % Number of outputs

P = eye(n);       % Initial state covariance matrix
Q = q^2 * eye(n); % Covariance of process
R = r^2 * eye(m); % Covariance of measurement

end