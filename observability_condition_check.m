%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% observability_condition_check.m
%
% This code symbolically verifies the derived observability condition in the paper (Condition Eq. 36). 
% The analyirical derivation can be found in Appendix A of the paper.
%
% The code was used in the paper:
%
% "On-board range-based relative localization for micro air vehicles in indoor leader–follower flight". 
% 
% Steven van der Helm, Mario Coppola, Kimberly N. McGuire, Guido C. H. E. de Croon.
% Autonomous Robots, March 2019, pp 1-27.
% The paper is available open-access at this link: https://link.springer.com/article/10.1007/s10514-019-09843-6
% Or use the following link for a PDF: https://link.springer.com/content/pdf/10.1007%2Fs10514-019-09843-6.pdf
% 
% Code written by Steven van der Helm and edited by Mario Coppola
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Initialize
init;

%% Empirical check for derived observability condition
syms s u1 v1 u2 v2 gam

v1v = [u1;v1];
v2v = [u2;v2];

Rm = [cos(gam), -sin(gam);
    sin(gam), cos(gam)];
dRm = diff(Rm,gam);

% So in the paper the second part of equation 33 is:
% 2*v1^T*dRm*(v2v*v1v^T-v2v*v2v^T*Rm^T)
% if we consider no accelerations, then we simply need to show that
% this part somehow is equal to 0 for v1v = s*R*v2v to show unobservability
% (note that we should actually show it is equal to k*pv^T, but choose k=0 here
% since we are free to choose k)
% so let's split it in two parts
% First handle the 2*v1v^T*dRm part, and substitute v1v = s*Rm*v2v
a = 2*(s*Rm*v2v).'*dRm;

% Then do the (v2v*v1v^T-v2v*v2v^T*Rm^T) part with v1v = s*Rm*v2v
b = v2v*(s*Rm*v2v)'-v2v*v2v.'*Rm';

% Then in the end we want to know if a*b = 0, so let matlab do the
% simplification, and output will be equal to [0,0], thus showing it is
% indeed unobservable
output = simplify(a*b)
