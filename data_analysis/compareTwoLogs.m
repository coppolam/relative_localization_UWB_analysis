clearvars;
addpath('../Kalman');
addpath('../Log_handling');
datapath = '../../../Data/multi_NDI/08-02-2018';

addpath(datapath);


datapathtypes = '.txt';
delimiter = ',';
data1 = extractDelimitedFile(datapath,datapathtypes,delimiter);
data2 = extractDelimitedFile(datapath,datapathtypes,delimiter);


[syncdata1,syncdata2,tm1,tm2] = syncData(data1,data2,'Range','time');

header1 = data1.Properties.VariableNames;
header2 = data2.Properties.VariableNames;

time1 = syncdata1{:,'time'};
time2 = syncdata2{:,'time'};
dtarr = syncdata1{:,'dt'};

x1 = syncdata1{:,'gps_x'};
y1 = syncdata1{:,'gps_y'};
h1 = syncdata1{:,'gps_z'};
u1 = syncdata1{:,'gps_vx'};
v1 = syncdata1{:,'gps_vy'};
h2meas = syncdata1{:,'track_z'};
x2 = syncdata2{:,'gps_x'};
y2 = syncdata2{:,'gps_y'};
u2 = syncdata2{:,'gps_vx'};
v2 = syncdata2{:,'gps_vy'};
h2 = syncdata2{:,'gps_z'};
truex21 = x2-x1;
truey21 = y2-y1;

kalx21 = syncdata1{:,'kal_x'};
kaly21 = syncdata1{:,'kal_y'};
kalh1 = syncdata1{:,'kal_h1'};
kalh2 = syncdata1{:,'kal_h2'};
ranges = syncdata1{:,'Range'};
trueranges = sqrt(truex21.^2+truey21.^2+(h1-h2meas).^2);

x2_est = x1 + kalx21;
y2_est = y1 + kaly21;

rangeerr =  syncdata1{:,'Range'} - trueranges;
rangeMAE = mean(abs(rangeerr));
rangeRMSE = sqrt(mean(rangeerr.^2));




figure; 
hold on;
plot(data1{:,'gps_x'},data1{:,'gps_y'});
title('trajectory 1');

figure; 
hold on;
plot(data2{:,'gps_x'},data2{:,'gps_y'});
title('trajectory 2');

figure;
hold on;
plot(time1,syncdata1{:,'Range'});
plot(time2,syncdata2{:,'Range'});
xlabel('time [s]');
ylabel('range [m]');
legend('follower','leader');

figure;
hold on;
plot(time1,syncdata1{:,'Range'});
plot(time1,trueranges);
xlabel('time [s]');
ylabel('range [m]');
legend('measured','true');

figure;
hold on;
plot(time1,syncdata1{:,'kal_h1'});
plot(time1,syncdata1{:,'gps_z'});
plot(time1,syncdata1{:,'sonar_z'});
xlabel('time [s]');
ylabel('h1 for follower [m]');
legend('kalman','true','sonar');

figure;
hold on;
plot(time2,syncdata2{:,'kal_h2'});
plot(time1,syncdata1{:,'gps_z'});
plot(time2,syncdata2{:,'track_z'});
xlabel('time [s]');
ylabel('h2 for leader[m]');
legend('kalman','true','measured');

figure;
hold on;
plot(time1,syncdata1{:,'kal_h2'});
plot(time2,syncdata2{:,'gps_z'});
plot(time1,syncdata1{:,'track_z'});
xlabel('time [s]');
ylabel('h2 for follower [m]');
legend('kalman','true','measured');

figure;
hold on;
plot(time1,syncdata1{:,'kal_u1'});
plot(time1,syncdata1{:,'gps_vx'});
plot(time1,syncdata1{:,'optic_vx'});
xlabel('time [s]');
ylabel('u1 [m]');
legend('kalman','true','measured');

figure;
hold on;
plot(time1,syncdata1{:,'kal_u2'});
plot(time2,syncdata2{:,'gps_vx'});
plot(time1,syncdata1{:,'track_vx'});
xlabel('time [s]');
ylabel('u2 [m]');
legend('kalman','true','measured');

figure;
hold on;
plot(time1,syncdata1{:,'kal_v2'});
plot(time2,syncdata2{:,'gps_vy'});
plot(time1,syncdata1{:,'track_vy'});
xlabel('time [s]');
ylabel('v2 [m]');
legend('kalman','true','measured');

figure;
hold on;
plot(syncdata1{:,'time'},syncdata1{:,'track_ax'});
plot(syncdata2{:,'time'},syncdata2{:,'state_ax'});
xlabel('time [s]');
ylabel('ax2 [m/s2]');
legend('tracked','state leader');

figure;
hold on;
plot(time1,syncdata1{:,'state_ax'});
plot(time1,syncdata1{:,'state_vx'},'linewidth',2);
xlabel('time [s]');
ylabel('x value');
legend('ax1','vx1');

figure;
hold on;
plot(time2,syncdata2{:,'state_ax'});
plot(time2,syncdata2{:,'state_vx'},'linewidth',2);
xlabel('time [s]');
ylabel('x value');
legend('ax2','vx2');


figure;
hold on;
plot(time2,x2);
plot(time1,x2_est);
xlabel('time [s]');
ylabel('x leader [m]');
legend('true','kalman');

figure;
hold on;
plot(time2,y2);
plot(time1,y2_est);
xlabel('time [s]');
ylabel('y leader [m]');
legend('true','kalman');

figure;
hold on;
plot(time1,h2meas);
plot(time2,h2);
xlabel('time [s]');
ylabel('h leader [m]');
legend('measured','true');

figure;
hold on;
plot(time1,syncdata1{:,'track_vx'});
plot(time2,syncdata2{:,'gps_vx'});
xlabel('time [s]');
ylabel('vx leader [m]');
legend('measured','true');




figure;
hold on;
plot(data1{:,'time'},data1{:,'state_z'});
plot(data1{:,'time'},data1{:,'sonar_z'});
plot(data1{:,'time'},data1{:,'gps_z'});
xlabel('time [s]');
ylabel('z1 [m]');
legend('state','sonar','gps');



figure;
hold on;
plot(data1{:,'time'},data1{:,'state_vx'});
plot(data1{:,'time'},data1{:,'gps_vx'});
plot(data1{:,'time'},data1{:,'optic_vx'});
xlabel('time [s]');
ylabel('vx1 [m/s]');
legend('state','gps','optic');

figure;
hold on;
plot(data1{:,'time'},data1{:,'state_vy'});
plot(data1{:,'time'},data1{:,'gps_vy'});
plot(data1{:,'time'},data1{:,'optic_vy'});
xlabel('time [s]');
ylabel('vy1 [m/s]');
legend('state','gps','optic');

figure;
hold on;
plot(data2{:,'time'},data2{:,'state_vx'});
plot(data2{:,'time'},data2{:,'gps_vx'});
plot(data2{:,'time'},data2{:,'optic_vx'});
xlabel('time [s]');
ylabel('vx2 [m/s]');
legend('state','gps','optic');

figure;
hold on;
plot(data2{:,'time'},data2{:,'state_vy'});
plot(data2{:,'time'},data2{:,'gps_vy'});
plot(data2{:,'time'},data2{:,'optic_vy'});
xlabel('time [s]');
ylabel('vy2 [m/s]');
legend('state','gps','optic');

comcap = 1.5;

figure;
hold on;
plot(time1,syncdata1{:,'vcom1'});
plot([time1(1),time1(end)],[comcap,comcap]);
plot([time1(1),time1(end)],-[comcap,comcap]);
xlabel('time [s]');
ylabel('vcom1 [m/s]');

figure;
hold on;
plot(time1,syncdata1{:,'vcom2'});
plot([time1(1),time1(end)],[comcap,comcap]);
plot([time1(1),time1(end)],-[comcap,comcap]);
xlabel('time [s]');
ylabel('vcom2 [m/s]');

figure;
hold on;
plot(time1,syncdata1{:,'vcom1_cap'});
plot([time1(1),time1(end)],[comcap,comcap]);
plot([time1(1),time1(end)],-[comcap,comcap]);
xlabel('time [s]');
ylabel('vcom1 cap [m/s]');

figure;
hold on;
plot(time1,syncdata1{:,'vcom2_cap'});
plot([time1(1),time1(end)],[comcap,comcap]);
plot([time1(1),time1(end)],-[comcap,comcap]);
xlabel('time [s]');
ylabel('vcom2 cap [m/s]');

figure;
hold on;
plot(time1,syncdata1{:,'rpm1'});
plot(time1,syncdata1{:,'rpm2'});
plot(time1,syncdata1{:,'rpm3'});
plot(time1,syncdata1{:,'rpm4'});

figure;
hold on;
plot(time2,syncdata1{:,'rpm1'});
plot(time2,syncdata1{:,'rpm2'});
plot(time2,syncdata1{:,'rpm3'});
plot(time2,syncdata2{:,'rpm4'});