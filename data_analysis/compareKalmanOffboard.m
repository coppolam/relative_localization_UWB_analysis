clearvars;
addpath('../Kalman');
addpath('../Log_handling');
datapath = '../../../Data/multi_NDI/08-02-2018/onboard';
% datapath = '../../../Data/NDI/01-02-2018/onboard';

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
h1 = syncdata1{:,'gps_z'};
u1 = syncdata1{:,'gps_vx'};
v1 = syncdata1{:,'gps_vy'};
h2meas = syncdata1{:,'track_z'};
x1 = syncdata1{:,'gps_x'};
y1 = syncdata1{:,'gps_y'};
x2 = syncdata2{:,'gps_x'};
y2 = syncdata2{:,'gps_y'};
truex21 = x2-x1;
truey21 = y2-y1;
trueranges = sqrt(truex21.^2+truey21.^2+(h1-h2meas).^2);


kalmanmodel = 'Kalman_no_heading3';
type = 'EKF';
x0 = [-3;0;-1;-1;0;0;0;0;0];
Q = diag([2^2,2^2,2^2,2^2,0.2^2,0.2^2]);
P0 = diag([16,16,16,16,16,16,16,16,16]);
R = diag([0.5^2,0.2^2,0.2^2,0.7^2,0.7^2,0.7^2,0.7^2]);

% measurein = [syncdata1{:,'Range'}.';
%     syncdata1{:,'gps_z'}.';
%     syncdata1{:,'track_z'}.';
%     syncdata1{:,'gps_vx'}.';
%     syncdata1{:,'gps_vy'}.';
%     syncdata1{:,'track_vx'}.';
%     syncdata1{:,'track_vy'}.'];
% 
measurein = [syncdata1{:,'Range'}.';
    syncdata1{:,'gps_z'}.';
    syncdata1{:,'track_z'}.';
    syncdata1{:,'gps_vx'}.';
    syncdata1{:,'gps_vy'}.';
    syncdata2{:,'gps_vx'}.';
    syncdata2{:,'gps_vy'}.'];


% measurein = [syncdata1{:,'Range'}.';
%     syncdata1{:,'sonar_z'}.';
%     syncdata2{:,'sonar_z'}.';
%     syncdata1{:,'optic_vx'}.';
%     syncdata1{:,'optic_vy'}.';
%     syncdata2{:,'gps_vx'}.';
%     syncdata2{:,'gps_vy'}.'];

% measurein = [syncdata1{:,'Range'}.';
%     syncdata1{:,'sonar_z'}.';
%     syncdata2{:,'sonar_z'}.';
%     syncdata1{:,'optic_vx'}.';
%     syncdata1{:,'optic_vy'}.';
%     syncdata2{:,'optic_vx'}.';
%     syncdata2{:,'optic_vy'}.'];

inputin = [syncdata1{:,'smooth_ax'}.';
    syncdata1{:,'smooth_ay'}.';
    syncdata1{:,'track_ax'}.';
    syncdata1{:,'track_ay'}.';
    syncdata1{:,'smooth_r'}.';
    syncdata1{:,'track_r'}.'];
% 
% inputin = zeros(size(inputin));

dtin = syncdata1{:,'dt'};

offkal = runKalman( measurein, inputin, dtin, kalmanmodel,type,x0,P0,Q,R );

startt = 80;
endt = 280;
starti = find(time1>startt,1);
endi = find(time1>endt,1);
% startslice = 0.4;
% endslice = 0.8;
% starti = round(startslice*height(syncdata1));
% endi = round(endslice*height(syncdata1));



xerron = syncdata1{:,'kal_x'}-truex21;
yerron = syncdata1{:,'kal_y'}-truey21;
perron = sqrt(xerron.^2+yerron.^2);
perronpart = perron(starti:endi);
MAEpon = mean(abs(perronpart));


xerroff = offkal(1,:).'-truex21;
yerroff = offkal(2,:).'-truey21;
perroff = sqrt(xerroff.^2+yerroff.^2);
perroffpart = perroff(starti:endi);
MAEpoff = mean(abs(perroffpart));

rangeerr= syncdata1{:,'Range'}-trueranges;
rangeerrabs = abs(syncdata1{:,'Range'}-trueranges);

fprintf("MAE p on: %f, MAE p off: %f\n",MAEpon,MAEpoff);

% figure;
% hold on;
% plot(time1,trueranges);
% plot(time1,syncdata1{:,'Range'});
figure
hold on;
plot(time1,syncdata1{:,'Range'});
plot(time2,syncdata2{:,'Range'});
xlabel('time [s]');
ylabel('Ranges');
legend('1','2');

figure;
hold on;
plot(time1,syncdata1{:,'kal_x'});
plot(time1,offkal(1,:));
plot(time1,truex21);
xlabel('time [s]');
ylabel('x21 [m]');
legend('on board','off board','true');



figure;
hold on;
plot(time1,syncdata1{:,'kal_y'});
plot(time1,offkal(2,:));
plot(time1,truey21);
xlabel('time [s]');
ylabel('y21 [m]');
legend('on board','off board','true');

figure;
hold on;
plot(time1,syncdata1{:,'kal_x'});
plot(time1,offkal(1,:));
xlabel('time [s]');
ylabel('x21 [m]');
legend('on board','off board');

figure;
hold on;
plot(time1,syncdata1{:,'kal_y'});
plot(time1,offkal(2,:));
xlabel('time [s]');
ylabel('y21 [m]');
legend('on board','off board');

figure;
hold on;
plot(time1,syncdata1{:,'gps_vx'});
plot(time1,syncdata1{:,'optic_vx'});
% plot(time1,offkal(5,:));
xlabel('time [s]');
ylabel('vx [m/s]');
legend('gps','optic');

figure;
hold on;
plot(time1,syncdata1{:,'gps_vy'});
plot(time1,syncdata1{:,'optic_vy'});
% plot(time1,offkal(6,:));
xlabel('time [s]');
ylabel('vy [m/s]');
legend('gps','optic');

figure;
hold on;
plot(time2,syncdata2{:,'gps_vx'});
plot(time2,syncdata2{:,'optic_vx'});
xlabel('time [s]');
ylabel('vx [m/s]');
legend('gps','optic');

figure;
hold on;
plot(time2,syncdata2{:,'gps_vy'});
plot(time2,syncdata2{:,'optic_vy'});
xlabel('time [s]');
ylabel('vy [m/s]');
legend('gps','optic');

figure;
hold on;
plot(time1,syncdata1{:,'sonar_z'});
plot(time1,syncdata1{:,'gps_z'});
xlabel('time [s]');
ylabel('NED z [m]');
legend('sonar','gps');

figure;
hold on;
plot(time1,syncdata1{:,'track_z'});
plot(time2,syncdata2{:,'sonar_z'});
xlabel('time [s]');
ylabel('NED z [m]');
legend('tracked','tracked sonar');

figure;
hold on;
plot(trueranges);
plot(syncdata1{:,'Range'});
ylabel('range [m]');
legend('true','measured');

figure;
hold on;
plot(syncdata1{:,'gps_z'});
plot(syncdata1{:,'sonar_z'});
ylabel('NED z 1 [m]');
legend('gps','sonar');

figure;
hold on;
plot(syncdata1{:,'track_z'});
plot(syncdata2{:,'sonar_z'});
ylabel('NED z 2 [m]');
legend('tracked','sonar');

figure;
hold on;
plot(syncdata1{:,'gps_vx'});
plot(syncdata1{:,'optic_vx'});
ylabel('vx 1[m/s]');
legend('gps','optic');

figure;
hold on;
plot(syncdata1{:,'gps_vy'});
plot(syncdata1{:,'optic_vy'});
ylabel('vy 1[m/s]');
legend('gps','optic');

figure;
hold on;
plot(syncdata1{:,'track_vx'});
plot(syncdata2{:,'optic_vx'});
ylabel('vx 2 [m/s]');
legend('track','optic');

figure;
hold on;
plot(syncdata1{:,'track_vy'});
plot(syncdata2{:,'optic_vy'});
ylabel('vy 2 [m/s]');
legend('track','optic');

figure;
hold on;
plot(syncdata1{:,'track_vy'});
plot(syncdata2{:,'gps_vy'});

