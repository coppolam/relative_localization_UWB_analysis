

printfigs = true;
tstart = 2;
tend = 8;
tmid = 5;
dt = 0.01;
tarr = tstart:dt:tend;
linewidth = 2;

Ad = 28.65;
eps = 1;

d = Ad*exp(-(eps*(tarr-tmid)).^2);

file = strcat('..\..\..\Figures\General\HeadingDisturbancePres30.png');
xmin = tstart; xmax = tend; xtick=1;
ymin = 0; ymax = 30; ytick = 5;
fontsize = 20;
h = figure;
set(gca,'xtick',xmin:xtick:xmax,'ytick',ymin:ytick:ymax,'FontSize',fontsize,'FontName','Times');
if (printfigs)
    set(h,'Visible','off');
end
colors = get(gca,'colororder');
hold on;
grid on;
axis([xmin xmax ymin ymax]);
plot(tarr,d,'linewidth',linewidth);
xlabel('Time [s]','FontUnits','points','interpreter','latex','FontSize',fontsize,'FontName','Times');
ylabel('Disturbance [deg]','FontUnits','points','interpreter','latex','FontSize',fontsize,'FontName','Times');
if (printfigs)
    print(file,'-dpng');
end