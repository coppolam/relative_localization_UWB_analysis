clearvars;
scenario = 'yawnoise';
scenario = 'yawdisturbance';
scenario = 'yawdisturbance_kp1'; % Changed error calculation to x_kp1_kp1

printfigs = true;
fontsize = 20;
linewidth=2;


filenames = {'storeresmat_type12_compahead','storeresmat_type1_compahead_yawdisturbance'};
%filenames = {'storeresmat_circle_noyaw2','storeresmat_circle_noyaw_yawnoises_acchead'};
% filenames = {'storeresmat_circle_noyaw_yawratenoises_acc','storeresmat_circle_noyaw_yawnoises_yawratenoises_acchead'};


load(strcat(filenames{1},'.mat'));
storeres2 = storeres;
storeres2 = storeres2(:,1:end-1);
load(strcat(filenames{2},'.mat'));
storeres1 = storeres;
storeres1 = storeres1(:,1:end-1);

rangenoises = [0,0.1,0.25,0.5,1,2,4];
yawnoises =   [0, 0.25, 0.5, 1, 1.5]; % not plotting and 0.1
plotindices = [1, 3, 4  ,  5 , 6 ]; % skipping  0.1 at positions 2


percentarr = zeros(size(rangenoises.*yawnoises.'));

for i = plotindices
    percentarr(i,:) = ((storeres2(2,:)-storeres1(i,:))./storeres1(i,:)) * 100;
end

%((storeres(2,:)-storeres(1,:))./storeres(1,:))*100;


file = strcat('C:\Users\Steven\Dropbox\Thesis\Figures\General\nodistplot.png');

xa = [0 4];
xt = 1;
ya = [0 1.2];
yt = 0.2;
h = figure;
if (printfigs)
    set(h,'Visible','off');
end
set(gca,'XTick',xa(1):xt:xa(2),'YTick',ya(1):yt:ya(2),'FontSize',fontsize,'FontUnits','points','FontWeight','normal','FontName','Times');
hold on;
grid on;
% for i=1:length(yawnoises)
%     plot(rangenoises,storeres1(i,:),'-o','linewidth',linewidth);
% end
plot(rangenoises,storeres1(1,:),'-o','linewidth',linewidth);
plot(rangenoises,storeres2(2,:),'-o','linewidth',linewidth);
axis([xa ya]);
xlabel('Range noise [m]','FontUnits','points','interpreter','latex','FontSize',fontsize,'FontName','Times');
ylabel('Error [m]','FontUnits','points','interpreter','latex','FontWeight','normal','FontSize',fontsize,'FontName','Times');
leg1 = legend('North','No North','location','northwest');
set(leg1,'Interpreter','latex');
set(leg1,'FontSize',fontsize);
if (printfigs)
    print(file,'-dpng');
end

xa = [0 4];
xt = 1;
ya = [0 1.2];
yt = 0.2;

file = strcat('C:\Users\Steven\Dropbox\Thesis\Figures\General\dist1plot.png');

h = figure;
if (printfigs)
    set(h,'Visible','off');
end
set(gca,'XTick',xa(1):xt:xa(2),'YTick',ya(1):yt:ya(2),'FontSize',fontsize,'FontUnits','points','FontWeight','normal','FontName','Times');
hold on;
grid on;
% for i=1:length(yawnoises)
%     plot(rangenoises,storeres1(i,:),'-o','linewidth',linewidth);
% end
plot(rangenoises,storeres1(4,:),'-o','linewidth',linewidth);
plot(rangenoises,storeres2(2,:),'-o','linewidth',linewidth);
axis([xa ya]);
xlabel('Range noise [m]','FontUnits','points','interpreter','latex','FontSize',fontsize,'FontName','Times');
ylabel('Error [m]','FontUnits','points','interpreter','latex','FontWeight','normal','FontSize',fontsize,'FontName','Times');
leg1 = legend('North','No North','location','northwest');
set(leg1,'Interpreter','latex');
set(leg1,'FontSize',fontsize);
if (printfigs)
    print(file,'-dpng');
end

xa = [0 4];
xt = 1;
ya = [0 2];
yt = 0.2;
file = strcat('C:\Users\Steven\Dropbox\Thesis\Figures\General\dist2plot.png');

h = figure;
if (printfigs)
    set(h,'Visible','off');
end
set(gca,'XTick',xa(1):xt:xa(2),'YTick',ya(1):yt:ya(2),'FontSize',fontsize,'FontUnits','points','FontWeight','normal','FontName','Times');
hold on;
grid on;
% for i=1:length(yawnoises)
%     plot(rangenoises,storeres1(i,:),'-o','linewidth',linewidth);
% end
plot(rangenoises,storeres1(6,:),'-o','linewidth',linewidth);
plot(rangenoises,storeres2(2,:),'-o','linewidth',linewidth);
axis([xa ya]);
xlabel('Range noise [m]','FontUnits','points','interpreter','latex','FontSize',fontsize,'FontName','Times');
ylabel('Error [m]','FontUnits','points','interpreter','latex','FontWeight','normal','FontSize',fontsize,'FontName','Times');
leg1 = legend('North','No North','location','northwest');
set(leg1,'Interpreter','latex');
set(leg1,'FontSize',fontsize);
if (printfigs)
    print(file,'-dpng');
end
% file = strcat('C:\Users\Steven\Dropbox\Thesis\Figures\Observability_kinematic\head_nohead_disturbance_percentage_mult.eps');
% 
% cmap = jet(8);
% h = figure('Position', [480, 430, 560, 450]);
% %     h = figure;
% ya = [-100,60];
% yt = 20;
% xa = [0,8];
% xt = 1;
% if (printfigs)
%     set(h,'Visible','off');
% end
% hold on;
% grid on;
% set(gca,'XTick',xa(1):xt:xa(2),'YTick',ya(1):yt:ya(2),'FontSize',fontsize,'FontUnits','points','FontWeight','normal','FontName','Times');
% % for i=1:length(yawnoises)
% %     plot(rangenoises,percentarr(i,:),'-o','linewidth',linewidth);
% % end
% plot(rangenoises,percentarr(1,:),'-p','linewidth',linewidth);
% %     plot(rangenoises,percentarr(2,:),'-o','linewidth',linewidth);
% plot(rangenoises,percentarr(3,:),'-o','linewidth',linewidth);
% plot(rangenoises,percentarr(4,:),'-v','linewidth',linewidth);
% plot(rangenoises,percentarr(5,:),'-s','linewidth',linewidth);
% plot(rangenoises,percentarr(6,:),'-d','linewidth',linewidth);
% %     plot(rangenoises,percentarr(7,:),'-o','linewidth',linewidth);
% % plot(rangenoises,percentarr(8,:),'-v','linewidth',linewidth,'Color',cmap(8,:));
% plot(xa,zeros(1,2),'--','Color','black');
% axis([xa ya]);
% xlabel('Range noise $\sigma_{R}$ [m]','FontUnits','points','interpreter','latex','FontSize',fontsize,'FontName','Times');
% ylabel('Localization error [\%]','FontUnits','points','interpreter','latex','FontSize',fontsize,'FontName','Times');
% legentries = cell(1,length(yawnoises));
% for i = 1:length(yawnoises)
%     legentries{i} = strcat('$A_d$=',num2str(yawnoises(i)));
% end
% leg1 = legend(legentries);
% set(leg1,'Location','SouthEast');
% set(leg1,'Interpreter','latex');
% set(leg1,'FontSize',fontsize);
% if (printfigs)
%     print(file,'-depsc2');
% end