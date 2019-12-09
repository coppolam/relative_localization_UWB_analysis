h = figure;
set(gca,'xtick',xmin:xtick:xmax,'ytick',ymin:ytick:ymax,'FontSize',fontsize,'FontName','Times');
if printfigs
    set(h,'Visible','off');
end
colors = get(gca,'colororder');
hold on;
grid on;
axis([xmin xmax ymin ymax]);
plot(x44_22,y44_22,'color',colors(2,:));
plot(x22,   y22,   'color',colors(1,:));
plot(x18,   y18,   'color',colors(5,:));
xlabel('x');ylabel('y');
xlabel('x [m]','FontUnits','points','interpreter','latex','FontSize',fontsize,'FontName','Times');
ylabel('y [m]','FontUnits','points','interpreter','latex','FontSize',fontsize,'FontName','Times');
legend('leader','follower 1','follower 2','location','southeast');