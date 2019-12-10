%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% noise_heading_disturbance_plot.m
%
% This code plots the heading disturbance that was used in the noise analysis, as seen in Figure 13.
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

printfigs = false;
tstart = 2;
tend = 8;
tmid = 5;
dt = 0.01;
tarr = tstart:dt:tend;
linewidth = 2;

Ad = 1;
eps = 1;

d = Ad*exp(-(eps*(tarr-tmid)).^2);

%% Plot
file = strcat('figures\General\HeadingDisturbance.eps');
xmin = tstart; xmax = tend; xtick=1;
ymin = 0; ymax = 1; ytick = 0.2;
fontsize = 20;
h = figure;
set(gca,'xtick',xmin:xtick:xmax,'ytick',ymin:ytick:ymax,'FontSize',fontsize,'FontName','Times');
colors = get(gca,'colororder');
hold on;
grid on;
axis([xmin xmax ymin ymax]);
plot(tarr,d,'linewidth',linewidth);
xlabel('Time [s]','FontUnits','points','interpreter','latex','FontSize',fontsize,'FontName','Times');
ylabel('$d(t)$ [rad]','FontUnits','points','interpreter','latex','FontSize',fontsize,'FontName','Times');
if printfigs
    print(file,'-depsc2');
end