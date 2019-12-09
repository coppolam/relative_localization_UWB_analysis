clearvars;
addpath('../Kalman');
addpath('../Quadcopter Simulation');
addpath('../Log_handling');
addpath('../../../Data/NDI/04-01-2018');



offboardkalman = 'Kalman_no_heading3';
% offboardkalman = 'Kalman_no_acc';

datapath = '../../../Data/NDI/04-01-2018';
datapathtypes = '.txt';
delimiter = ',';
datafile1 = 'IP22_follower6_trajectory.txt';
datafile2 = 'IP44_leader6_trajectory.txt';
% data1 = extractDelimitedFile(datapath,datapathtypes,delimiter);
% data2 = extractDelimitedFile(datapath,datapathtypes,delimiter);
data1 = extractDelimitedFile(datafile1);
data2 = extractDelimitedFile(datafile2);

printfigs = false;
showslice = false;

[syncdata1,syncdata2,tm1,tm2] = syncData(data1,data2,'Range','time');

startslice = 4000;
endslice = 5000;
while(startslice>height(syncdata1))
    startslice = startslice/2;
end
while(endslice>height(syncdata1))
    endslice = endslice/2;
end
if~(endslice>startslice)
    inter = startslice;
    startslice = endslice;
    endslide = inter;
end
if (endslice == startslice)
    endslice = startslice + 1;
end
    

header1 = data1.Properties.VariableNames;
header2 = data2.Properties.VariableNames;

time1 = syncdata1{:,'time'};
time2 = syncdata2{:,'time'};

dtarr = syncdata1{:,'dt'};

x1 = syncdata1{:,'own_x'};
y1 = syncdata1{:,'own_y'};
h1 = syncdata1{:,'own_z'};
u1 = syncdata1{:,'own_vx'};
v1 = syncdata1{:,'own_vy'};
h2meas = syncdata1{:,'track_z_meas'};
x2 = syncdata2{:,'own_x'};
y2 = syncdata2{:,'own_y'};
u2 = syncdata2{:,'own_vx'};
v2 = syncdata2{:,'own_vy'};
h2 = syncdata2{:,'own_z'};
truex21 = x2-x1;
truey21 = y2-y1;

u1dif = diff(u1)./dtarr(1:end-1);
v1dif = diff(v1)./dtarr(1:end-1);
u2dif = diff(u2)./dtarr(1:end-1);
v2dif = diff(v2)./dtarr(1:end-1);
u1dif(end+1) = 0; v1dif(end+1) = 0; u2dif(end+1) = 0; v2dif(end+1) = 0;

time1 = syncdata1{:,'time'};
time2 = syncdata2{:,'time'};



kalx21 = syncdata1{:,'kal_x'};
kaly21 = syncdata1{:,'kal_y'};
kalh1 = syncdata1{:,'kal_h1'};
kalh2 = syncdata1{:,'kal_h2'};
ranges = syncdata1{:,'Range'};
trueranges = sqrt(truex21.^2+truey21.^2+(h1-h2meas).^2);

x2_est = x1 + kalx21;
y2_est = y1 + kaly21;

rangeerr = trueranges - syncdata1{:,'Range'};
rangeMAE = mean(abs(rangeerr));
rangeRMSE = sqrt(mean(rangeerr.^2));






%% NDI OFF BOARD
% ndidelay = 5;
% ndihandler = NDIhandler(ndidelay,"BODYFRAME","PARTICLE",[-2,0,-5]);
% 
% index = 1;
% PLinarr = [syncdata1{:,'kal_x'},syncdata1{:,'kal_y'}].';
% VLinarr = [syncdata1{:,'track_vx_meas'},syncdata1{:,'track_vy_meas'}].';
% ALinarr = zeros(size(PLinarr));
% RLinarr = zeros(1,length(PLinarr));
% VFinarr = [syncdata1{:,'own_vx'},syncdata1{:,'own_vy'}].';
% AFinarr = zeros(size(PLinarr));
% RFinarr = zeros(1,length(PLinarr));
% gaminarr = syncdata1{:,'kal_gamma'};
% PLsinarr = [syncdata2{:,'own_x'},syncdata2{:,'own_y'}].';
% PLinarr = [data1{:,'kal_x'},data1{:,'kal_y'}].';
% VLinarr = [data1{:,'track_vx_meas'},data1{:,'track_vy_meas'}].';
% ALinarr = zeros(size(PLinarr));
% RLinarr = zeros(1,length(PLinarr));
% VFinarr = [data1{:,'own_vx'},data1{:,'own_vy'}].';
% AFinarr = zeros(size(PLinarr));
% RFinarr = zeros(1,length(PLinarr));
% gaminarr = data1{:,'kal_gamma'};
% PLsinarr = zeros(size(PLinarr));
% comarr = zeros(size(PLinarr));
% comcaparr  = zeros(size(PLinarr));
% 
% for t=time1.'
%     ndihandler.addVars(PLinarr(:,index),VLinarr(:,index),ALinarr(:,index),...
%         RLinarr(index), VFinarr(:,index),AFinarr(:,index), RFinarr(index),...
%         gaminarr(index),PLsinarr(:,index));
%     [comcap,com] = ndihandler.getNDItest(dtarr(index));
%     comarr(:,index) = com;
%     comcaparr(:,index) = comcap;
%     
%     
%     index = index + 1;
%     
%     
%     
% end

% 
% comarr2 = comarr([tm1,tm1].');
% comarr = reshape(comarr2,2,height(syncdata1));
% comcaparr2 = comcaparr([tm1,tm1].');
% comcaparr = reshape(comcaparr2,2,height(syncdata1));







%%


delay = 5;

xerr = truex21-kalx21;
xMAE = mean(abs(xerr));

yerr = truey21-kaly21;
yMAE = mean(abs(yerr));

perr = sqrt(xerr.^2 + yerr.^2);
pMAE = sqrt(xMAE.^2+yMAE.^2);




fprintf('MAE on board in x, y, p of: %f, %f, %f\n',xMAE,yMAE,pMAE);

if(~showslice)

figure;
hold on;
plot(time2+delay,x2,'linewidth',1);
plot(time1,x1,'--','linewidth',1.1);
xlabel('time [s]');
ylabel('x [m]');
legend('delayed leader','follower');

figure;
hold on;
plot(time2+delay,y2);
plot(time1,y1,'--');
xlabel('time [s]');
ylabel('y [m]');
legend('delayed leader','follower');

figure;
hold on;
plot(time1,trueranges);
plot(time1,syncdata1{:,'Range'});
xlabel('time [s]');
ylabel('range [m]');
legend('true','measured');

figure;
hold on;
axis equal
plot(x2,y2);
plot(x2_est,y2_est);
xlabel('x2');
ylabel('y2');
legend('true','kalman estimate');
% 
figure;
hold on;
plot(syncdata1{:,'time'},syncdata1{:,'Range'});
plot(syncdata2{:,'time'},syncdata2{:,'Range'});
xlabel('time [s]');
ylabel('synced range [m]');

% figure;
% hold on;
% plot(time1,x1);
% plot(time1,y1);
% xlabel('time [s]');
% ylabel('distance [m]');
% legend('x1','y1');
% 
% figure;
% hold on;
% plot(time1,h1);
% plot(time1,kalh1);
% plot(time1,x_off(3,:),'--','Color','black');
% xlabel('time [s]');
% ylabel('h1 [m]');
% legend('true','onboard','offboard');
% 
% 
% figure;
% hold on;
% plot(time2,x2);
% plot(time2,y2);
% xlabel('time [s]');
% ylabel('distance [m]');
% legend('x2','y2');
% 
% figure;
% hold on;
% plot(time2,h2);
% plot(time1,kalh2);
% xlabel('time [s]');
% ylabel('h2 [m]');
% legend('true','kalman');

figure;
hold on;
plot(time1,truex21);
plot(time1,kalx21);
% plot(time1,x_off(1,:),'--','Color','black');
% plot(time1,syncdata1{:,'Range'});
xlabel('time [s]');
ylabel('x21 [m]');
legend('true','onboard kalman');

figure;
hold on;
plot(time1,truey21);
plot(time1,kaly21);
% plot(time1,x_off(2,:),'--','Color','black');
xlabel('time [s]');
ylabel('y21 [m]');
legend('true','onboard kalman');

figure;
hold on;
plot(time1,u1);
plot(time1,syncdata1{:,'kal_u1'});
xlabel('time [s]');
ylabel('u1');
legend('true','kalman');

figure;
hold on;
plot(time1,v1);
plot(time1,syncdata1{:,'kal_v1'});
xlabel('time [s]');
ylabel('v1');
legend('true','kalman');

figure;
hold on;
plot(time2,u2);
plot(time1,syncdata1{:,'track_vx_meas'});
xlabel('time [s]');
ylabel('u2');
legend('true','tracked');

figure;
hold on;
plot(time1,syncdata1{:,'track_vy_meas'});
plot(time1,syncdata1{:,'kal_v2'});
xlabel('time');
ylabel('v2');
legend('true','tracked');
% 
% figure;
% hold on;
% plot(time1,v2);
% plot(time1,syncdata1{:,'track_vy_meas'});

% figure;
% hold on;
% plot(time1,syncdata1{:,'vcom1'});
% plot(time1,syncdata1{:,'vcom1_cap'});
% xlabel('time [s]');
% ylabel('u1 com [m/s]');
% legend('true','capped');
% 
% figure;
% hold on;
% plot(time1,syncdata1{:,'vcom2'});
% plot(time1,syncdata1{:,'vcom2_cap'});
% xlabel('time [s]');
% ylabel('v1 com [m/s]');
% legend('true','capped');
% 
% figure;
% hold on; 
% plot(time1,syncdata1{:,'vcom1_cap'});
% plot(time1,syncdata1{:,'own_vx'});
% xlabel('time [s]');
% ylabel('u1 [m/s]');
% legend('commanded','true');

figure;
hold on;
plot(time1,syncdata1{:,'vcom1'});
xlabel('time [s]');
ylabel('u1 com [m/s]');
legend('onboard','offboard');

figure;
hold on;
plot(time1,syncdata1{:,'vcom2'});
xlabel('time [s]');
ylabel('v1 com [m/s]');
legend('onboard','offboard');


else

fontsize1 = 26;
linewidth1 = 1;

fontsize2 = 24;
linewidth2 = 3;

fontsize3 = 26;
linewidth3 = 1;



    
    % starti = startslice;
% endi = endslice;
starti = 3000;
endi = 5000;
timestartreal = 140;
timeendreal = 240;
timestart = 130;
timeend = 250;

time1maskreal = time1>timestartreal & time1<timeendreal;
time2maskdelayreal = time2>(timestartreal-delay) & time2<(timeendreal-delay);
time1mask = time1>timestart & time1<timeend;
time2maskdelay = time2>(timestart-delay) & time2<(timeend-delay);
t1slice = time1(time1mask);
t2slicedelay = time2(time2maskdelay);
t1slicereal = time1(time1maskreal);
t2slicereal = time2(time2maskdelayreal);
starti = find(time1maskreal,1,'first');
endi = find(time1maskreal,1,'last');


fs = 20;
x1r = resample(x1(time1mask),t1slice,fs);
y1r = resample(y1(time1mask),t1slice,fs);
x2rdelay = resample(x2(time2maskdelay),t2slicedelay,fs);
y2rdelay = resample(y2(time2maskdelay),t2slicedelay,fs);
if(length(x1r)>length(x2rdelay))
    x1r = x1r(1:length(x2rdelay));
    y1r = y1r(1:length(x2rdelay));
else
    x2rdelay = x2rdelay(1:length(x1r));
    y2rdelay = y2rdelay(1:length(x1r));
end
tr = cumsum(ones(size(x1r))*1/fs)-(timestartreal-timestart);
trmask = tr>0 & tr<(timeendreal-timestartreal);
tr = tr(trmask);
x1r = x1r(trmask);
y1r = y1r(trmask);
x2rdelay = x2rdelay(trmask);
y2rdelay = y2rdelay(trmask);





xtrajerr = x1r-x2rdelay;
ytrajerr = y1r-y2rdelay;
ptrajerr = sqrt(xtrajerr.^2 + ytrajerr.^2);



xMAEpart = mean(abs(xerr(starti:endi)));
yMAEpart = mean(abs(yerr(starti:endi)));
pMAEpart = sqrt(xMAEpart.^2+yMAEpart.^2);

xtrajMAEpart = mean(abs(xtrajerr));
ytrajMAEpart = mean(abs(ytrajerr));
ptrajMAEpart = sqrt(xtrajMAEpart.^2+ytrajMAEpart.^2);

fprintf('MAE on board partial in x, y, p of: %f, %f, %f\n',xMAEpart,yMAEpart,pMAEpart);
fprintf('MAE trajectory partial in x, y, p of: %f, %f, %f\n',xtrajMAEpart,ytrajMAEpart,ptrajMAEpart);
    % figure;
% hold on;
% plot(x2(2000:3000),y2(2000:3000));
% plot(x1(2000:3000),y1(2000:3000));
% xlabel('x coord [m]');
% ylabel('y coord [m]');
% legend('leader','follower');



% figure;
% hold on;
% plot(x2(starti:endi),y2(starti:endi));
% plot(x1(starti:endi),y1(starti:endi));
% xlabel('x coord [m]');
% ylabel('y coord [m]');
% legend('leader','follower');

ymin = -4; ymax = 4; ytick = 2;
xmin = -5; xmax = 8; xtick = 2;


h = figure;
if (printfigs)
    set(h,'Visible','off');
end
hold on;
grid on;
set(gca,'xtick',xmin:xtick:xmax,'ytick',ymin:ytick:ymax,'FontSize',fontsize1,'FontUnits','points','FontWeight','normal','FontName','Times');
plot(x2rdelay,y2rdelay,'linewidth',linewidth1,'color',[0.85,0.325,0.098]);
plot(x1r,y1r,'linewidth',linewidth1,'color',[0,0.4470,0.7410]);
xlabel('$x$ coordinate [m]','FontUnits','points','interpreter','latex','FontSize',fontsize1,'FontName','Times');
ylabel('$y$ coordinate [m]','FontUnits','points','interpreter','latex','FontSize',fontsize1,'FontName','Times');
leg1 = legend('leader','follower','location','southeast');
set(leg1,'Interpreter','latex');
set(leg1,'FontSize',fontsize1);
axis([xmin xmax ymin ymax]);


file = strcat('C:\Users\Steven\Dropbox\Thesis\Figures\NDI_experiments\leader_follower_ptraj.eps');
if (printfigs)
    print(file,'-depsc2');
end




% figure;
% hold on;
% plot(t2slicedelay+delay-timestart,x2(time2maskdelay),'linewidth',1);
% plot(t1slice-timestart,x1(time1mask),'--','linewidth',1.1);
% xlabel('time [s]');
% ylabel('x [m]');
% legend('delayed leader','follower');

% ymin = -4; ymax = 8; ytick = 2;
% xmin = 0; xmax = 100; xtick = 20;
% 
% 
% h = figure;
% if (printfigs)
%     set(h,'Visible','off');
% end
% set(gca,'xtick',xmin:xtick:xmax,'ytick',ymin:ytick:ymax,'FontSize',fontsize2,'FontUnits','points','FontWeight','normal','FontName','Times');
% hold on;
% grid on;
% plot(tr,x1r,'linewidth',linewidth2);
% plot(tr,x2rdelay,'--','linewidth',linewidth2);
% axis([xmin xmax ymin ymax]);
% xlabel('time [s]');
% ylabel('x coord [m]');
% legend('follower','delayed leader');
% 
% file = strcat('C:\Users\Steven\Dropbox\Thesis\Figures\NDI_experiments\leader_follower_x.eps');
% if (printfigs)
%         print(file,'-depsc2');
%     end
% 
% ymin = -4; ymax = 8; ytick = 2;
% xmin = 0; xmax = 100; xtick = 20;
% 
% 
% h = figure;
% if (printfigs)
%     set(h,'Visible','off');
% end
% set(gca,'xtick',xmin:xtick:xmax,'ytick',ymin:ytick:ymax,'FontSize',fontsize2,'FontUnits','points','FontWeight','normal','FontName','Times');
% hold on;
% grid on;
% plot(tr,y1r,'linewidth',linewidth2);
% plot(tr,y2rdelay,'--','linewidth',linewidth2);
% axis([xmin xmax ymin ymax]);
% xlabel('time [s]');
% ylabel('y coord[m]');
% legend('follower','delayed leader');
% 
% file = strcat('C:\Users\Steven\Dropbox\Thesis\Figures\NDI_experiments\leader_follower_y.eps');
% if (printfigs)
%         print(file,'-depsc2');
% end
    
ymin = -0.8; ymax = 0.8; ytick = 0.2;
xmin = 0; xmax = 100; xtick = 20;


h = figure;
if (printfigs)
    set(h,'Visible','off');
end
set(gca,'xtick',xmin:xtick:xmax,'ytick',ymin:ytick:ymax,'FontSize',fontsize3,'FontUnits','points','FontWeight','normal','FontName','Times');
hold on;
grid on;
plot(tr,xtrajerr,'linewidth',linewidth3);
axis([xmin xmax ymin ymax]);
xlabel('time [s]','FontUnits','points','interpreter','latex','FontSize',fontsize3,'FontName','Times');
ylabel('x error [m]','FontUnits','points','interpreter','latex','FontSize',fontsize3,'FontName','Times');


file = strcat('C:\Users\Steven\Dropbox\Thesis\Figures\NDI_experiments\leader_follower_xerr.eps');
if (printfigs)
        print(file,'-depsc2');
    end

ymin = -0.6; ymax = 0.8; ytick = 0.2;
xmin = 0; xmax = 100; xtick = 20;


h = figure;
if (printfigs)
    set(h,'Visible','off');
end
set(gca,'xtick',xmin:xtick:xmax,'ytick',ymin:ytick:ymax,'FontSize',fontsize3,'FontUnits','points','FontWeight','normal','FontName','Times');
hold on;
grid on;
plot(tr,ytrajerr,'linewidth',linewidth3);
axis([xmin xmax ymin ymax]);
xlabel('time [s]','FontUnits','points','interpreter','latex','FontSize',fontsize3,'FontName','Times');
ylabel('y error [m]','FontUnits','points','interpreter','latex','FontSize',fontsize3,'FontName','Times');

file = strcat('C:\Users\Steven\Dropbox\Thesis\Figures\NDI_experiments\leader_follower_yerr.eps');
if (printfigs)
        print(file,'-depsc2');
end

% figure;
% hold on;
% plot(t2slicedelay+delay-timestart,y2(time2maskdelay),'linewidth',1);
% plot(t1slice-timestart,y1(time1mask),'--','linewidth',1.1);
% xlabel('time [s]');
% ylabel('x [m]');
% legend('delayed leader','follower');

ymin = 0; ymax = 0.8; ytick = 0.2;
xmin = 0; xmax = 100; xtick = 20;


h = figure;
if (printfigs)
    set(h,'Visible','off');
end
set(gca,'xtick',xmin:xtick:xmax,'ytick',ymin:ytick:ymax,'FontSize',fontsize3,'FontUnits','points','FontWeight','normal','FontName','Times');
hold on;
grid on;
plot(tr,ptrajerr,'linewidth',linewidth3);
axis([xmin xmax ymin ymax]);
xlabel('time [s]','FontUnits','points','interpreter','latex','FontSize',fontsize3,'FontName','Times');
ylabel('follower error [m]','FontUnits','points','interpreter','latex','FontSize',fontsize3,'FontName','Times');


file = strcat('C:\Users\Steven\Dropbox\Thesis\Figures\NDI_experiments\leader_follower_perr.eps');
if (printfigs)
        print(file,'-depsc2');
    end

ymin = 0; ymax = 2; ytick = 0.5;
xmin = 0; xmax = 100; xtick = 20;


h = figure;
if (printfigs)
    set(h,'Visible','off');
end
set(gca,'xtick',xmin:xtick:xmax,'ytick',ymin:ytick:ymax,'FontSize',fontsize3,'FontName','Times');
xax = get(gca,'XAxis');
% set(xax,'FontSize',fontsize3,'FontUnits','points','FontWeight','normal','FontName','Times');
hold on;
grid on;
plot(time1(starti:endi)-timestartreal,abs(rangeerr(starti:endi)),'linewidth',linewidth3);
axis([xmin xmax ymin ymax]);
% plot(time1(starti:endi)-timestartreal,ranges(starti:endi),'--','linewidth',linewidth2);
xlabel('time [s]','FontUnits','points','interpreter','latex','FontSize',fontsize3,'FontName','Times');
ylabel('range error [m]','FontUnits','points','interpreter','latex','FontSize',fontsize3,'FontName','Times');
file = strcat('C:\Users\Steven\Dropbox\Thesis\Figures\NDI_experiments\leader_follower_rangeerr.eps');
if (printfigs)
        print(file,'-depsc2');
    end

end






