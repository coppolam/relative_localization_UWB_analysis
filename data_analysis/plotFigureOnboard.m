clearvars;
addpath('../Kalman');
addpath('../Log_handling');
datapath = '../../../Data/NDI/01-02-2018/onboard';
addpath(datapath);


printfigs = false;
% datapathtypes = '.txt';
% delimiter = ',';
datafile1 = 'IP22_8.txt';
datafile2 = 'IP44_8.txt';
datafile1 = fullfile(datapath,datafile1);
datafile2 = fullfile(datapath,datafile2);
% data1 = extractDelimitedFile(datapath,datapathtypes,delimiter);
% data2 = extractDelimitedFile(datapath,datapathtypes,delimiter);
data1 = extractDelimitedFile(datafile1);
data2 = extractDelimitedFile(datafile2);

header1 = data1.Properties.VariableNames;
header2 = data2.Properties.VariableNames;


startt = 200;
endt = 240;
delay = 5;

[syncdata1,syncdata2,tm1,tm2] = syncData(data1,data2,'Range','time');


[cutdata1,cutdata2,newt1,newt2] = cutOutData(syncdata1,syncdata2,startt,endt,startt,endt,'time');
[cutdata1d,cutdata2d,newt1d,newt2d] = cutOutData(syncdata1,syncdata2,startt,endt,startt-delay,endt-delay,'time');



header1 = data1.Properties.VariableNames;
header2 = data2.Properties.VariableNames;



% 
% time1 = syncdata1{:,'time'};
% time2 = syncdata2{:,'time'};
h1 = cutdata1{:,'gps_z'};
u1 = cutdata1{:,'gps_vx'};
v1 = cutdata1{:,'gps_vy'};
h2meas = cutdata1{:,'track_z'};
kalx21 = cutdata1{:,'kal_x'};
kaly21 = cutdata1{:,'kal_y'};
h2 = cutdata2{:,'gps_z'};
x1 = cutdata1{:,'gps_x'};
y1 = cutdata1{:,'gps_y'};
x2 = cutdata2{:,'gps_x'};
y2 = cutdata2{:,'gps_y'};
truex21 = x2-x1;
truey21 = y2-y1;
trueranges = sqrt(truex21.^2+truey21.^2+(h1-h2meas).^2);

dtarr = cutdata1{:,'dt'};
dtm = dtarr>0.05;



xlocerr = kalx21-truex21;
ylocerr = kaly21-truey21;
plocerr = sqrt(xlocerr.^2+ylocerr.^2);
MAEploc = mean(plocerr);

xtrackerr = cutdata1d{:,'gps_x'}-cutdata2d{:,'gps_x'};
ytrackerr = cutdata1d{:,'gps_y'}-cutdata2d{:,'gps_y'}; 
ptrackerr = sqrt(xtrackerr.^2+ytrackerr.^2);
MAEptrack = mean(ptrackerr);

rangeerr = cutdata1{:,'Range'}-trueranges;

fprintf("MAE range: %f\n",mean(abs(rangeerr)));
fprintf("MAE p rel loc: %f\n",MAEploc);
fprintf("MAE p track: %f\n",MAEptrack);



file = strcat('..\..\..\Figures\NDI_experiments\leader_follower_traj_onboard.eps');
xmin = -4; xmax = 6; xtick=1;
ymin = -4; ymax = 4; ytick = 1;
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
plot(x2,y2,'color',colors(2,:));
plot(x1,y1,'color',colors(1,:));
xlabel('x [m]','FontUnits','points','interpreter','latex','FontSize',fontsize,'FontName','Times');
ylabel('y [m]','FontUnits','points','interpreter','latex','FontSize',fontsize,'FontName','Times');
legend('leader','follower');
if (printfigs)
    print(file,'-depsc2');
end

file = strcat('..\..\..\Figures\NDI_experiments\leader_follower_plocerr_onboard.eps');
xmin = 0; xmax = 0.8; xtick=0.1;
ymin = 0; ymax = 300; ytick = 100;
fontsize = 20;
nbins = 50;
h = figure;
if (printfigs)
    set(h,'Visible','off');
end
hold on;
grid on;
set(gca,'xtick',xmin:xtick:xmax,'ytick',ymin:ytick:ymax,'FontSize',fontsize,'FontName','Times');
histogram(plocerr,nbins);
axis([xmin xmax ymin ymax]);
line([MAEploc MAEploc],get(gca,'YLim'),'Color','r','linewidth',2);
xlabel('Localization error [m]','FontUnits','points','interpreter','latex','FontSize',fontsize,'FontName','Times');
ylabel('Instances','FontUnits','points','interpreter','latex','FontSize',fontsize,'FontName','Times');
legend('errors','mean');
if (printfigs)
    print(file,'-depsc2');
end



file = strcat('..\..\..\Figures\NDI_experiments\leader_follower_ptrackerr_onboard.eps');
xmin = 0; xmax = 1.5; xtick=0.2;
ymin = 0; ymax = 350; ytick = 50;
fontsize = 20;
nbins = 50;
h = figure;
if (printfigs)
    set(h,'Visible','off');
end
hold on;
grid on;
set(gca,'xtick',xmin:xtick:xmax,'ytick',ymin:ytick:ymax,'FontSize',fontsize,'FontName','Times');
histogram(ptrackerr,nbins);
axis([xmin xmax ymin ymax]);
line([MAEptrack MAEptrack],get(gca,'YLim'),'Color','r','linewidth',2);
xlabel('Tracking error [m]','FontUnits','points','interpreter','latex','FontSize',fontsize,'FontName','Times');
ylabel('Instances','FontUnits','points','interpreter','latex','FontSize',fontsize,'FontName','Times');
legend('errors','mean');
if (printfigs)
    print(file,'-depsc2');
end




file = strcat('..\..\..\Figures\NDI_experiments\leader_follower_rangeerr_Onboard.eps');
xmin = -0.6; xmax = 1; xtick=0.2;
ymin = 0; ymax = 1000; ytick = 200;
fontsize = 20;
nbins = 50;
h = figure;
if (printfigs)
    set(h,'Visible','off');
end
hold on;
grid on;
set(gca,'xtick',xmin:xtick:xmax,'ytick',ymin:ytick:ymax,'FontSize',fontsize,'FontName','Times');
histogram(rangeerr(rangeerr>-10),nbins);
axis([xmin xmax ymin ymax]);
line([mean(rangeerr) mean(rangeerr)],get(gca,'YLim'),'Color','r','linewidth',2);
xlabel('Range errror [m]','FontUnits','points','interpreter','latex','FontSize',fontsize,'FontName','Times');
ylabel('Instances','FontUnits','points','interpreter','latex','FontSize',fontsize,'FontName','Times');
legend('errors','mean');
if (printfigs)
    print(file,'-depsc2');
end

linewidth = 3;
curfontsize = 26;
ymin = -4; ymax = 7; ytick=2;
xmin = 50; xmax = 100; xtick = 10;
file = strcat('..\..\..\Figures\NDI_experiments\leader_follower_xcomp_Onboard.eps');
folx = cutdata1d{:,'gps_x'};
leadx = cutdata2d{:,'gps_x'};
foly = cutdata1d{:,'gps_y'};
leady = cutdata2d{:,'gps_y'};
tmtmp1 = newt1d>50 & newt1d<100;
tmtmp2 = newt2d>50 & newt2d<100;


h = figure;
if (printfigs)
    set(h,'Visible','off');
end
hold on;
grid on;
set(gca,'xtick',xmin:xtick:xmax,'ytick',ymin:ytick:ymax,'FontSize',curfontsize,'FontName','Times');
plot(newt1d(tmtmp1),folx(tmtmp1),'linewidth',linewidth);
plot(newt2d(tmtmp2),leadx(tmtmp2),'--','linewidth',linewidth);
axis([xmin xmax ymin ymax]);
xlabel('Time [s]','FontUnits','points','interpreter','latex','FontSize',curfontsize,'FontName','Times');
ylabel('x [m]','FontUnits','points','interpreter','latex','FontSize',curfontsize,'FontName','Times');
leg1 = legend('follower','delayed leader');
set(leg1,'interpreter','latex');
if (printfigs)
    print(file,'-depsc2');
end


ymin = -4; ymax = 7; ytick=2;
xmin = 50; xmax = 100; xtick = 10;
file = strcat('..\..\..\Figures\NDI_experiments\leader_follower_ycomp_Onboard.eps');

h=figure;
if (printfigs)
    set(h,'Visible','off');
end
hold on;
grid on;
set(gca,'xtick',xmin:xtick:xmax,'ytick',ymin:ytick:ymax,'FontSize',curfontsize,'FontName','Times');
plot(newt1d(tmtmp1),foly(tmtmp1),'linewidth',linewidth);
plot(newt2d(tmtmp2),leady(tmtmp2),'--','linewidth',linewidth);
axis([xmin xmax ymin ymax]);
xlabel('Time [s]','FontUnits','points','interpreter','latex','FontSize',curfontsize,'FontName','Times');
ylabel('y [m]','FontUnits','points','interpreter','latex','FontSize',curfontsize,'FontName','Times');
leg1= legend('follower','delayed leader');
set(leg1,'interpreter','latex');
if (printfigs)
    print(file,'-depsc2');
end




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


