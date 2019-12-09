function [x,P,x_p,z_p,Q,R]=ukf(f,x,P,h,z,Q,R,beta)
% UKF   Unscented Kalman Filter for nonlinear dynamic systems
% [x, P] = ukf(f,x,P,h,z,Q,R) returns state estimate, x and state covariance, P
% for nonlinear dynamic system (for simplicity, noises are assumed as additive):
%           x_k+1 = f(x_k) + w_k
%           z_k   = h(x_k) + v_k
% where w ~ N(0,Q) meaning w is gaussian noise with covariance Q
%       v ~ N(0,R) meaning v is gaussian noise with covariance R
% Inputs:   f: function handle for f(x)
%           x: "a priori" state estimate
%           P: "a priori" estimated state covariance
%           h: fanction handle for h(x)
%           z: current measurement
%           Q: process noise covariance
%           R: measurement noise covariance
% Output:   x: "a posteriori" state estimate
%           P: "a posteriori" state covariance
%
% Reference: Julier, SJ. and Uhlmann, J.K., Unscented Filtering and
% Nonlinear Estimation, Proceedings of the IEEE, Vol. 92, No. 3,
% pp.401-422, 2004.
%
% By Yi Cao at Cranfield University, 04/01/2008
%

L=numel(x);                                 %numer of states
m=numel(z);                                 %numer of measurements

alpha=1e-3;                                 %default, tunable
ki=0;                                       %default, tunable
beta=0;                                     %default, tunable

lambda = alpha^2*(L+ki)-L;                  %scaling factor
c = L+lambda;                               %scaling factor

Wm    = [lambda/c, 0.5/c+zeros(1,2*L)];     %weights for means
Wc    = Wm;
Wc(1) = Wc(1)+(1-alpha^2+beta);             %weights for covariance

c = sqrt(c);

X = sigmas(x,P,c);                            %sigma points around x

[x_p,Xnew,Pxx,Xdiff]=ut(f,X,Wm,Wc,L); %unscented transformation of process
dp         = sqrt(x_p(1)^2 + x_p(2)^2 + x_p(9)^2);
Q(1:2,1:2) = Q(1:2,1:2) ./ dp;
Pxx = Pxx + Q;

% X1=sigmas(x1,P1,c);                       %sigma points around x1
% X2=X1-x1(:,ones(1,size(X1,2)));           %deviation of X1
[z_p,~,Pyy,Ydiff]=ut(h,Xnew,Wm,Wc,m);  %unscented transformation of measurements
Pyy = Pyy + R;

Pxy = Xdiff*diag(Wc)*Ydiff';                      %transformed cross-covariance

K = Pxy*inv(Pyy);

x = x_p + K*(z-z_p);        %state update

P = Pxx - K * Pyy * K';                      %covariance update
end

function [x_predicted,Xsigcol,P,Xdiff]=ut(f,Xsig,Wm,Wc,n)
%Unscented Transformation
%Input:
%        f: nonlinear map
%        X: sigma points
%       Wm: weights for mean
%       Wc: weights for covraiance
%        n: numer of outputs of f
%        R: additive covariance
%Output:
%        y: transformed mean
%        Y: transformed smapling points
%        P: transformed covariance
%       Y1: transformed deviations

L = size(Xsig,2);

x_predicted = zeros(n,1);
Xsigcol = zeros(n,L);

for i = 1 : L
    
    Xsigcol(:,i) = f(Xsig(:,i)); % Apply the transformation to each column
    
    x_predicted = x_predicted + Wm(i) * Xsigcol(:,i);
    
end

Xdiff = Xsigcol - x_predicted(:,ones(1,L));
P = Xdiff*diag(Wc)*Xdiff';
end


function X=sigmas(x,P,c)
%Sigma points around reference point
%Inputs:
%       x: reference point
%       P: covariance
%       c: coefficient
%Output:
%       X: Sigma points

A = c*chol(P)'; % chol is a bit like taking the square root
Y = x(:,ones(1,numel(x))); % replicate P along the other dimension
X = [x Y+A Y-A]; % size of x is L times 2L+1
end
