%% Plot the circular trajectory as stylized in Fig. 11

init

scenario = 'circles';

printfigs = true;
fontsize = 13;
linewidth = 1.2;
arrowlength = 30;
arrowtipangle = 20;

if (strcmpi(scenario,'circles'))
    windowsize = [-5 5 -5 5];
    xticks = 1;
    yticks = 1;
    radianarr = 0:0.01:1.9*pi;
    rho2 = 4;
    rho1 = rho2-1;
    traj1 = [-rho1*sin(-radianarr);
        rho1*cos(-radianarr)];
    lenarrows = 5;
    numarrows1 = 5;
    traj2 = [rho2*cos(radianarr);
        rho2*sin(radianarr)];    
    numarrows2 = 5;
    
    arrowint1 = length(traj1)/numarrows1;
    arrowint2 = length(traj2)/numarrows2;
    h = figure('position',[400 400 500 500]);
    if (printfigs)
        set(h,'Visible','off');
    end
    set(gca,'XTick',windowsize(1):xticks:windowsize(2),...
        'YTick',windowsize(3):yticks:windowsize(4),...
        'FontSize',fontsize,...
        'FontUnits','points','FontWeight','normal','FontName','Times');
    hold on;
    grid on;
    plot(traj1(1,:),traj1(2,:),'linewidth',linewidth);
    plot(traj2(1,:),traj2(2,:),'linewidth',linewidth);
    defcolors = get(gca,'ColorOrder');
    arrow(traj1(:,1),traj1(:,round(arrowlength/2)),'FaceColor',defcolors(1,:),'EdgeColor',defcolors(1,:),'Length',arrowlength,'TipAngle',arrowtipangle);
    curarrowind = length(traj1);
    for i=1:numarrows1        
        arrow(traj1(:,curarrowind-round(arrowlength/2)),traj1(:,curarrowind),'FaceColor',defcolors(1,:),'EdgeColor',defcolors(1,:),'Length',arrowlength,'TipAngle',arrowtipangle);
        curarrowind = round(curarrowind-arrowint1);
    end
    arrow(traj2(:,1),traj2(:,5),'FaceColor',defcolors(2,:),'EdgeColor',defcolors(2,:),'Length',arrowlength,'TipAngle',arrowtipangle);
    curarrowind = length(traj2);
    for i=1:numarrows1
        arrow(traj2(:,curarrowind-round(arrowlength/2)),traj2(:,curarrowind),'FaceColor',defcolors(2,:),'EdgeColor',defcolors(2,:),'Length',arrowlength,'TipAngle',arrowtipangle);
        curarrowind = round(curarrowind-arrowint2);
    end
    arrow(traj2(:,end-5),traj2(:,end),'FaceColor',defcolors(2,:),'EdgeColor',defcolors(2,:),'Length',arrowlength,'TipAngle',arrowtipangle);
    axis([-5 5 -5 5]);
    axis square
    xlabel('x [m]','FontUnits','points','interpreter','latex','FontSize',fontsize,'FontName','Times');
    ylabel('y [m]','FontUnits','points','interpreter','latex','FontWeight','normal','FontSize',fontsize,'FontName','Times');
    leg1 = legend('drone 1','drone 2','location','bestoutside');
    set(leg1,'Interpreter','latex');
    set(leg1,'FontSize',fontsize);
    
    file = strcat('figures/trajectory_arrows_',scenario);
    if (printfigs)
        print(file,'-depsc2');
    end
    
end

 
