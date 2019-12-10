function h = plot_range_err_distribution(rangeerr,fontsize,xmin,xmax,xtick,ymin,ymax,ytick,printfigs)

h = figure;
nbins = 50;
hold on
grid on
set(gca,'xtick',xmin:xtick:xmax,'ytick',ymin:ytick:ymax,'FontSize',fontsize,'FontName','Times');
histogram(rangeerr,nbins);
axis([xmin xmax ymin ymax]);
line([mean(rangeerr) mean(rangeerr)],get(gca,'YLim'),'Color','r','linewidth',2);
legend('errors','mean');
xlabel('Range error [m]','FontUnits','points','interpreter','latex','FontSize',fontsize,'FontName','Times');
ylabel('Instances [m]','FontUnits','points','interpreter','latex','FontSize',fontsize,'FontName','Times');

end

