clearvars;
addpath('../Kalman');
addpath('../Log_handling');
datapath = '../../../Data/multi_NDI/08-02-2018/GPS';
addpath(datapath);

printfigs = false;

% datapathtypes = '.txt';
% delimiter = ',';
datafile18_44 = 'IP18_44_3.txt';
datafile44_18= 'IP44_18_3.txt';
datafile22_44 = 'IP22_44_3.txt';
datafile44_22= 'IP44_22_3.txt';

datafile18_44 = fullfile(datapath,datafile18_44);
datafile44_18 = fullfile(datapath,datafile44_18);
datafile22_44 = fullfile(datapath,datafile22_44);
datafile44_22= fullfile(datapath,datafile44_22);
% data1 = extractDelimitedFile(datapath,datapathtypes,delimiter);
% data2 = extractDelimitedFile(datapath,datapathtypes,delimiter);
data18 = extractDelimitedFile(datafile18_44);
data22 = extractDelimitedFile(datafile22_44);
data44_18 = extractDelimitedFile(datafile44_18);
data44_22 = extractDelimitedFile(datafile44_22);


header1 = data18.Properties.VariableNames;
header2 = data44_18.Properties.VariableNames;


startt = 100;
endt = 300;
delay18 = 8;
delay22= 4;

[syncdata18,syncdata44_18,tm1,tm2] = syncData(data18,data44_18,'Range','time');
[syncdata22,syncdata44_22,tm1,tm2] = syncData(data22,data44_22,'Range','time');

t18 = syncdata18{:,'time'};
t22 = syncdata22{:,'time'};

[cutdata18,cutdata44_18,newt18] = cutOutData(syncdata18,syncdata44_18,startt,endt,startt,endt,'time');
[cutdata18d,cutdata44_18d,newt18d] = cutOutData(syncdata18,syncdata44_18,startt,endt,startt-delay18,endt-delay18,'time');
[cutdata22,cutdata44_22,newt22] = cutOutData(syncdata22,syncdata44_22,startt,endt,startt,endt,'time');
[cutdata22d,cutdata44_22d,newt22d] = cutOutData(syncdata22,syncdata44_22,startt,endt,startt-delay22,endt-delay22,'time');


header1 = data18.Properties.VariableNames;
header2 = data44_18.Properties.VariableNames;


%% 18
% 
% time1 = syncdata1{:,'time'};
% time2 = syncdata2{:,'time'};
h18 = cutdata18{:,'gps_z'};
u18 = cutdata18{:,'gps_vx'};
v18 = cutdata18{:,'gps_vy'};
h2meas18 = cutdata18{:,'track_z'};
kalx44_18 = cutdata18{:,'kal_x'};
kaly44_18 = cutdata18{:,'kal_y'};
h44_18 = cutdata44_18{:,'gps_z'};
x18 = cutdata18{:,'gps_x'};
y18 = cutdata18{:,'gps_y'};
x44_18 = cutdata44_18{:,'gps_x'};
y44_18 = cutdata44_18{:,'gps_y'};
truex44_18 = x44_18-x18;
truey44_18 = y44_18-y18;
trueranges18 = sqrt(truex44_18.^2+truey44_18.^2+(h18-h2meas18).^2);




xlocerr18 = kalx44_18-truex44_18;
ylocerr18 = kaly44_18-truey44_18;
plocerr18 = sqrt(xlocerr18.^2+ylocerr18.^2);
MAEploc18 = mean(plocerr18);

xtrackerr18 = cutdata18d{:,'gps_x'}-cutdata44_18d{:,'gps_x'};
ytrackerr18 = cutdata18d{:,'gps_y'}-cutdata44_18d{:,'gps_y'}; 
ptrackerr18 = sqrt(xtrackerr18.^2+ytrackerr18.^2);
MAEptrack18 = mean(ptrackerr18);

rangeerr18 = cutdata18{:,'Range'}-trueranges18;

fprintf("MAE range 18: %f\n",mean(abs(rangeerr18)));
fprintf("MAE p rel loc 18: %f\n",MAEploc18);
fprintf("MAE p track 18: %f\n",MAEptrack18);

%% 22
h22 = cutdata22{:,'gps_z'};
u22 = cutdata22{:,'gps_vx'};
v22 = cutdata22{:,'gps_vy'};
h2meas22 = cutdata22{:,'track_z'};
kalx44_22 = cutdata22{:,'kal_x'};
kaly44_22 = cutdata22{:,'kal_y'};
h44_22 = cutdata44_22{:,'gps_z'};
x22 = cutdata22{:,'gps_x'};
y22 = cutdata22{:,'gps_y'};
x44_22 = cutdata44_22{:,'gps_x'};
y44_22 = cutdata44_22{:,'gps_y'};
truex44_22 = x44_22-x22;
truey44_22 = y44_22-y22;
trueranges22 = sqrt(truex44_22.^2+truey44_22.^2+(h22-h2meas22).^2);




xlocerr22 = kalx44_22-truex44_22;
ylocerr22 = kaly44_22-truey44_22;
plocerr22 = sqrt(xlocerr22.^2+ylocerr22.^2);
MAEploc22 = mean(plocerr22);

xtrackerr22 = cutdata22d{:,'gps_x'}-cutdata44_22d{:,'gps_x'};
ytrackerr22 = cutdata22d{:,'gps_y'}-cutdata44_22d{:,'gps_y'}; 
ptrackerr22 = sqrt(xtrackerr22.^2+ytrackerr22.^2);
MAEptrack22 = mean(ptrackerr22);

rangeerr22 = cutdata22{:,'Range'}-trueranges22;

fprintf("MAE range 22: %f\n",mean(abs(rangeerr22)));
fprintf("MAE p rel loc 22: %f\n",MAEploc22);
fprintf("MAE p track 22: %f\n",MAEptrack22);



%% 18
% file = strcat('..\..\..\Figures\NDI_experiments\leader_follower_traj_onboard.eps');
% xmin = -4; xmax = 6; xtick=1;
% ymin = -4; ymax = 4; ytick = 1;
% fontsize = 20;
h = figure;
% set(gca,'xtick',xmin:xtick:xmax,'ytick',ymin:ytick:ymax,'FontSize',fontsize,'FontName','Times');
% if (printfigs)
%     set(h,'Visible','off');
% end
colors = get(gca,'colororder');
hold on;
grid on;
% axis([xmin xmax ymin ymax]);
plot(x44_18,y44_18,'color',colors(2,:));
plot(x18,y18,'color',colors(1,:));
xlabel('x');ylabel('y');
% xlabel('x [m]','FontUnits','points','interpreter','latex','FontSize',fontsize,'FontName','Times');
% ylabel('y [m]','FontUnits','points','interpreter','latex','FontSize',fontsize,'FontName','Times');
% legend('leader','follower');
% if (printfigs)
%     print(file,'-depsc2');
% end

% file = strcat('..\..\..\Figures\NDI_experiments\leader_follower_plocerr_onboard.eps');
% xmin = 0; xmax = 0.8; xtick=0.1;
% ymin = 0; ymax = 300; ytick = 100;
% fontsize = 20;
nbins = 50;
h = figure;
% if (printfigs)
%     set(h,'Visible','off');
% end
hold on;
grid on;
% set(gca,'xtick',xmin:xtick:xmax,'ytick',ymin:ytick:ymax,'FontSize',fontsize,'FontName','Times');
histogram(plocerr18,nbins);
% axis([xmin xmax ymin ymax]);
line([MAEploc18 MAEploc18],get(gca,'YLim'),'Color','r','linewidth',2);
xlabel('loc err');
ylabel('Instances');
% xlabel('Localization error [m]','FontUnits','points','interpreter','latex','FontSize',fontsize,'FontName','Times');
% ylabel('Instances','FontUnits','points','interpreter','latex','FontSize',fontsize,'FontName','Times');
legend('errors','mean');
% if (printfigs)
%     print(file,'-depsc2');
% end



% file = strcat('..\..\..\Figures\NDI_experiments\leader_follower_ptrackerr_onboard.eps');
% xmin = 0; xmax = 1.5; xtick=0.2;
% ymin = 0; ymax = 350; ytick = 50;
% fontsize = 20;
nbins = 50;
h = figure;
% if (printfigs)
%     set(h,'Visible','off');
% end
hold on;
grid on;
% set(gca,'xtick',xmin:xtick:xmax,'ytick',ymin:ytick:ymax,'FontSize',fontsize,'FontName','Times');
histogram(ptrackerr18,nbins);
% axis([xmin xmax ymin ymax]);
line([MAEptrack18 MAEptrack18],get(gca,'YLim'),'Color','r','linewidth',2);
xlabel('track err');
ylabel('Instances');
% xlabel('Tracking error [m]','FontUnits','points','interpreter','latex','FontSize',fontsize,'FontName','Times');
% ylabel('Instances','FontUnits','points','interpreter','latex','FontSize',fontsize,'FontName','Times');
legend('errors','mean');
% if (printfigs)
%     print(file,'-depsc2');
% end




% file = strcat('..\..\..\Figures\NDI_experiments\leader_follower_rangeerr_onboard.eps');
% xmin = -0.6; xmax = 1; xtick=0.2;
% ymin = 0; ymax = 1000; ytick = 200;
% fontsize = 20;
nbins = 50;
h = figure;
% if (printfigs)
%     set(h,'Visible','off');
% end
hold on;
grid on;
% set(gca,'xtick',xmin:xtick:xmax,'ytick',ymin:ytick:ymax,'FontSize',fontsize,'FontName','Times');
histogram(rangeerr18(rangeerr18>-10),nbins);
% axis([xmin xmax ymin ymax]);
line([mean(rangeerr18) mean(rangeerr18)],get(gca,'YLim'),'Color','r','linewidth',2);
xlabel('range err');
ylabel('Instances');
% xlabel('Range errror [m]','FontUnits','points','interpreter','latex','FontSize',fontsize,'FontName','Times');
% ylabel('Instances','FontUnits','points','interpreter','latex','FontSize',fontsize,'FontName','Times');
legend('errors','mean');
% if (printfigs)
%     print(file,'-depsc2');
% end

%% 22
% file = strcat('..\..\..\Figures\NDI_experiments\leader_follower_traj_onboard.eps');
% xmin = -4; xmax = 6; xtick=1;
% ymin = -4; ymax = 4; ytick = 1;
% fontsize = 20;
h = figure;
% set(gca,'xtick',xmin:xtick:xmax,'ytick',ymin:ytick:ymax,'FontSize',fontsize,'FontName','Times');
% if (printfigs)
%     set(h,'Visible','off');
% end
colors = get(gca,'colororder');
hold on;
grid on;
% axis([xmin xmax ymin ymax]);
plot(x44_22,y44_22,'color',colors(2,:));
plot(x22,y22,'color',colors(1,:));
xlabel('x');ylabel('y');
% xlabel('x [m]','FontUnits','points','interpreter','latex','FontSize',fontsize,'FontName','Times');
% ylabel('y [m]','FontUnits','points','interpreter','latex','FontSize',fontsize,'FontName','Times');
% legend('leader','follower');
% if (printfigs)
%     print(file,'-depsc2');
% end

% file = strcat('..\..\..\Figures\NDI_experiments\leader_follower_plocerr_onboard.eps');
% xmin = 0; xmax = 0.8; xtick=0.1;
% ymin = 0; ymax = 300; ytick = 100;
% fontsize = 20;
nbins = 50;
h = figure;
% if (printfigs)
%     set(h,'Visible','off');
% end
hold on;
grid on;
% set(gca,'xtick',xmin:xtick:xmax,'ytick',ymin:ytick:ymax,'FontSize',fontsize,'FontName','Times');
histogram(plocerr22,nbins);
% axis([xmin xmax ymin ymax]);
line([MAEploc22 MAEploc22],get(gca,'YLim'),'Color','r','linewidth',2);
xlabel('loc err');
ylabel('Instances');
% xlabel('Localization error [m]','FontUnits','points','interpreter','latex','FontSize',fontsize,'FontName','Times');
% ylabel('Instances','FontUnits','points','interpreter','latex','FontSize',fontsize,'FontName','Times');
legend('errors','mean');
% if (printfigs)
%     print(file,'-depsc2');
% end



% file = strcat('..\..\..\Figures\NDI_experiments\leader_follower_ptrackerr_onboard.eps');
% xmin = 0; xmax = 1.5; xtick=0.2;
% ymin = 0; ymax = 350; ytick = 50;
% fontsize = 20;
nbins = 50;
h = figure;
% if (printfigs)
%     set(h,'Visible','off');
% end
hold on;
grid on;
% set(gca,'xtick',xmin:xtick:xmax,'ytick',ymin:ytick:ymax,'FontSize',fontsize,'FontName','Times');
histogram(ptrackerr22,nbins);
% axis([xmin xmax ymin ymax]);
line([MAEptrack22 MAEptrack22],get(gca,'YLim'),'Color','r','linewidth',2);
xlabel('track err');
ylabel('Instances');
% xlabel('Tracking error [m]','FontUnits','points','interpreter','latex','FontSize',fontsize,'FontName','Times');
% ylabel('Instances','FontUnits','points','interpreter','latex','FontSize',fontsize,'FontName','Times');
legend('errors','mean');
% if (printfigs)
%     print(file,'-depsc2');
% end




% file = strcat('..\..\..\Figures\NDI_experiments\leader_follower_rangeerr_onboard.eps');
% xmin = -0.6; xmax = 1; xtick=0.2;
% ymin = 0; ymax = 1000; ytick = 200;
% fontsize = 20;
nbins = 50;
h = figure;
% if (printfigs)
%     set(h,'Visible','off');
% end
hold on;
grid on;
% set(gca,'xtick',xmin:xtick:xmax,'ytick',ymin:ytick:ymax,'FontSize',fontsize,'FontName','Times');
histogram(rangeerr22(rangeerr22>-10),nbins);
% axis([xmin xmax ymin ymax]);
line([mean(rangeerr22) mean(rangeerr22)],get(gca,'YLim'),'Color','r','linewidth',2);
xlabel('range err');
ylabel('Instances');
% xlabel('Range errror [m]','FontUnits','points','interpreter','latex','FontSize',fontsize,'FontName','Times');
% ylabel('Instances','FontUnits','points','interpreter','latex','FontSize',fontsize,'FontName','Times');
legend('errors','mean');
% if (printfigs)
%     print(file,'-depsc2');
% end

%% Both together

% file = strcat('..\..\..\Figures\NDI_experiments\leader_follower_traj_onboard.eps');
% xmin = -4; xmax = 6; xtick=1;
% ymin = -4; ymax = 4; ytick = 1;
% fontsize = 20;
h = figure;
% set(gca,'xtick',xmin:xtick:xmax,'ytick',ymin:ytick:ymax,'FontSize',fontsize,'FontName','Times');
% if (printfigs)
%     set(h,'Visible','off');
% end
colors = get(gca,'colororder');
hold on;
grid on;
% axis([xmin xmax ymin ymax]);
plot(x44_22,y44_22,'color',colors(2,:));
plot(x22,y22,'color',colors(1,:));
plot(x18,y18,'color',colors(5,:));
xlabel('x');ylabel('y');
% xlabel('x [m]','FontUnits','points','interpreter','latex','FontSize',fontsize,'FontName','Times');
% ylabel('y [m]','FontUnits','points','interpreter','latex','FontSize',fontsize,'FontName','Times');
% legend('leader','follower');
% if (printfigs)
%     print(file,'-depsc2');
% end


% figure;
% hold on;
% plot(newtd,cutdata1d{:,'gps_x'});
% plot(newtd,cutdata2d{:,'gps_x'},'--');
% xlabel('time [s]');
% ylabel('x [m]');
% legend('follower','delayed leader');
% 
% figure;
% hold on;
% plot(newtd,cutdata1d{:,'gps_y'});
% plot(newtd,cutdata2d{:,'gps_y'},'--');
% xlabel('time [s]');
% ylabel('y [m]');
% legend('follower','delayed leader');
% % 
% figure;
% hold on;
% plot(newt,plocerr);
% plot(newtd,ptrackerr);
% xlabel('time [s]');
% ylabel('|p| error');
% legend('localization','tracking');
% % % 
% %
% figure;
% hold on;
% plot(newt,cutdata1{:,'gps_z'});
% plot(newt,cutdata1{:,'state_z'});
% xlabel('time');
% ylabel('z');
% legend('gps','state');
% 
% figure;
% hold on;
% plot(newt,rangeerr);
% 
% figure;
% hold on;
% plot(newt,trueranges);


% 
% 


