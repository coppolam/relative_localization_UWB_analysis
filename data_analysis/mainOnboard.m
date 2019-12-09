clearvars;
addpath('../Kalman');
addpath('../Log_handling');
datapath = '../../../Data/multi_NDI/08-02-2018/GPS';

addpath(datapath);


datapathtypes = '.txt';
delimiter = ',';
% datafile1 = 'IP22_follower9.txt';
% datafile2 = 'IP44_leader9.txt';
data1 = extractDelimitedFile(datapath,datapathtypes,delimiter);
data2 = extractDelimitedFile(datapath,datapathtypes,delimiter);
% data1 = extractDelimitedFile(datafile1);
% data2 = extractDelimitedFile(datafile2);




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

printfigs = false;
% startt = 200;
% endt = 300;
startt = round(0.15*time1(end));
endt = round(0.7*time1(end));
delay = 6;

fs=20;
[x1r,time1r] = resample(x1,time1,fs);
y1r = resample(y1,time1,fs);
kalx21r = resample(syncdata1{:,'kal_x'},time1,fs);
kaly21r = resample(syncdata1{:,'kal_y'},time1,fs);
[x2r,time2r] = resample(x2,time2,fs);
y2r = resample(y2,time2,fs);

tm1r = time1r>startt & time1r<endt;
tm2r = time2r>startt & time2r<endt;
tm2rd = time2r>(startt-delay) & time2r<(endt-delay);

timer = ones(1,length(x1r(tm1r))).*1/fs;
timer = cumsum(timer);

minrow = min(length(x1r),length(x2r));
x1r = x1r(1:minrow); y1r = y1r(1:minrow); kalx21r = kalx21r(1:minrow); time1r = time1r(1:minrow);
kaly21r = kaly21r(1:minrow); x2r = x2r(1:minrow); y2r = y2r(1:minrow); time2r = time2r(1:minrow);
tm1r = tm1r(1:minrow); tm2r = tm2r(1:minrow); tm2rd = tm2rd(1:minrow); 


xerrtrack = x1r(tm1r)-x2r(tm2rd);
yerrtrack = y1r(tm1r)-y2r(tm2rd);
perrtrack = sqrt(xerrtrack.^2 +  yerrtrack.^2);
MAEptrack = mean(abs(perrtrack));

truex21r = x2r-x1r;
truey21r = y2r-y1r;

xerron = kalx21r - truex21r;
yerron = kaly21r - truey21r;
perron = sqrt(xerron.^2+yerron.^2);
perronpart = perron(tm1r);
MAEpon = mean(abs(perronpart));

% 
% xerron = syncdata1{:,'kal_x'}-truex21;
% yerron = syncdata1{:,'kal_y'}-truey21;
% perron = sqrt(xerron.^2+yerron.^2);
% perronpart = perron(time1>startt & time1<endt);
% MAEpon = mean(abs(perronpart));







rangeerr= syncdata1{:,'Range'}-trueranges;
rangeerrabs = abs(syncdata1{:,'Range'}-trueranges);

fprintf("MAE p rel loc: %f\n",MAEpon);
fprintf("MAE p track: %f\n",MAEptrack);


figure;
colors = get(gca,'colororder');
hold on;
plot(x2r(tm2r),y2r(tm2r));
plot(x1r(tm1r),y1r(tm1r));
xlabel('x [m]');
ylabel('y [m]');

figure;
hold on;
plot(timer,x1r(tm1r));
plot(timer,x2r(tm2rd),'--');
xlabel('time [s]');
ylabel('x [m]');
legend('follower','delayed leader');

figure;
hold on;
plot(timer,y1r(tm1r));
plot(timer,y2r(tm2rd),'--');
xlabel('time [s]');
ylabel('y [m]');
legend('follower','delayed leader');

figure;
hold on;
plot(timer,perronpart);
plot(timer,perrtrack);
xlabel('time [s]');
ylabel('|p| error');
legend('localization','tracking');
