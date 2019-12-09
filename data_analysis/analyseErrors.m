clearvars;
addpath('../Kalman');
addpath('../Log_handling');
datapath = '../../../Data/NDI/01-02-2018/onboard';
addpath(datapath);


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


startt = 100;
endt = 350;
delay = 5;

[syncdata1,syncdata2,tm1,tm2] = syncData(data1,data2,'Range','time');


[cutdata1,cutdata2,newt] = cutOutData(syncdata1,syncdata2,startt,endt,startt,endt,'time');
[cutdata1d,cutdata2d,newtd] = cutOutData(syncdata1,syncdata2,startt,endt,startt-delay,endt-delay,'time');



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
dtarr2 = cutdata2{:,'dt'};
rarr = cutdata1{:,'Range'};
rarr2 = cutdata2{:,'Range'};


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

figure;
hold on;
plot(newt,plocerr);
plot(newt,cutdata1{:,'dt'});
xlabel('time [s]');
ylabel('Loc error [m]');

figure
hold on;
plot(rarr);
plot(rarr2);
legend('range1','range2');

figure;
hold on;
plot(dtarr);
plot(dtarr2);
legend('dt1','dt2');

figure;
hold on;
plot(dtarr);
plot(plocerr);
legend('dt','locerr');

% figure;
% hold on;
% plot(dtarr(270:290));
% plot(dtarr2(270:290));
% legend('dt1','dt2');
% 
% figure;
% hold on;
% plot(plocerr(270:290));
% ylabel('loc err');
% 
% figure;
% hold on;
% plot(rarr(270:290));
% plot(rarr2(270:290));
% legend('r1','r2');
% 
% figure;
% hold on;
% plot(kalx21(270:290));
% ylabel('kalx21');
% 
% figure;
% hold on;
% plot(kaly21(270:290));
% ylabel('kaly21');
% 
% figure;
% hold on;
% plot(x1(270:290));
% ylabel('x1');
% 
% figure;
% hold on;
% plot(x2(270:290));
% ylabel('x2');


% figure;
% hold on;
% plot(cutdata1{:,'dt'});
% plot(plocerr);
% legend('dt','localization error');
% 
% figure;
% hold on;
% plot(newt,cutdata1{:,'gps_vx'});
% plot(newt,cutdata1{:,'optic_vx'});
% xlabel('time [s]');
% ylabel('Vx1 [m]');
% legend('gps','optic');
% 
% figure;
% hold on;
% plot(newt,cutdata1{:,'gps_vy'});
% plot(newt,cutdata1{:,'optic_vy'});
% xlabel('time [s]');
% ylabel('Vy1 [m]');
% legend('gps','optic');
% 
% figure;
% hold on;
% plot(newt,cutdata2{:,'gps_vx'});
% plot(newt,cutdata2{:,'optic_vx'});
% xlabel('time [s]');
% ylabel('Vx2 [m]');
% legend('gps','optic');
% 
% figure;
% hold on;
% plot(newt,cutdata2{:,'gps_vy'});
% plot(newt,cutdata2{:,'optic_vy'});
% xlabel('time [s]');
% ylabel('Vy2 [m]');
% legend('gps','optic');
% 
% figure;
% hold on;
% plot(newt,cutdata1{:,'state_z'});
% plot(newt,cutdata1{:,'gps_z'});
% plot(newt,cutdata1{:,'sonar_z'});
% xlabel('time [s]');
% ylabel('height [m]');
% legend('state','gps','sonar');