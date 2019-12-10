% Plots the disturbance given in Fig 13

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