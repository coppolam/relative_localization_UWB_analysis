clearvars;
addpath('../Kalman');
addpath('../Log_handling');
datapath = '../../../Data/multi_NDI/08-02-2018/onboard';
addpath(datapath);

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


startt = 80;
endt = 280;
delay18 = 8;
delay22= 4;

[syncdata18,syncdata44_18,tm1,tm2] = syncData(data18,data44_18,'Range','time');
[syncdata22,syncdata44_22,tm1,tm2] = syncData(data22,data44_22,'Range','time');

t18 = syncdata18{:,'time'};
t22 = syncdata22{:,'time'};

[cutdata18,cutdata44_18,newt18,newt44_18] = cutOutData(syncdata18,syncdata44_18,startt,endt,startt,endt,'time');
[cutdata18d,cutdata44_18d,newt18d,newt44_18d] = cutOutData(syncdata18,syncdata44_18,startt,endt,startt-delay18,endt-delay18,'time');
[cutdata22,cutdata44_22,newt22,newt44_22] = cutOutData(syncdata22,syncdata44_22,startt,endt,startt,endt,'time');
[cutdata22d,cutdata44_22d,newt22d,newt44_22d] = cutOutData(syncdata22,syncdata44_22,startt,endt,startt-delay22,endt-delay22,'time');


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

fprintf("Mean range 18: %f, MAX: %f\n",mean(trueranges18),max(trueranges18));
fprintf("MAE range 18: %f, MAX: %f\n",mean(abs(rangeerr18)),max(abs(rangeerr18)));
fprintf("MAE p rel loc 18: %f, MAX: %f\n",MAEploc18,max(abs(plocerr18)));
fprintf("MAE p track 18: %f, MAX: %f\n",MAEptrack18,max(abs(ptrackerr18)));

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

fprintf("Mean range 22: %f, MAX: %f\n",mean(trueranges22),max(trueranges22));
fprintf("MAE range 22: %f, MAX: %f\n",mean(abs(rangeerr22)),max(abs(rangeerr22)));
fprintf("MAE p rel loc 22: %f, MAX: %f\n",MAEploc22,max(abs(plocerr22)));
fprintf("MAE p track 22: %f, MAX: %f\n",MAEptrack22,max(abs(ptrackerr22)));

datapath = '../../../Data/NDI/01-02-2018/onboard';




figure;
hold on;
plot(newt18,cutdata18{:,'kal_gamma'});


% figure;
% hold on;
% plot(time1(starti:endi),rangesold(starti:endi));
% plot(newt+startt,cutdata1{:,'Range'});
% figure;
% hold on;
% plot(x1old(starti:endi));
% plot(x1cut);
% 
% figure;
% hold on;
% plot(x2old(starti2:endi2));
% plot(x2cut);
% 
% figure;
% hold on;
% plot(time1(starti:endi)-startt,truex21old(starti:endi));
% plot(newt,truex21);


% 
% threshold = 5;
% [un22, un22bin] = giveUnobservableFull(cutdata22,cutdata44_22,threshold);
% % [un18, un18bin] = giveUnobservableFull(cutdata18,cutdata44_18,threshold);
% [un, unbin] = giveUnobservableFull(cutdata1,cutdata2,threshold);
% 
% dtarr = cutdata22{:,'dt'};
% dtm = dtarr>0.09;
% 
% 
% figure;
% hold on;
% plot(newt22,dtarr);
% yyaxis right
% plot(newt22,plocerr22);
% 
% 
% 
% 
% figure;
% plot(newt22,un22);
% 
% figure;
% plot(newt22,rangeerr22);
% 
% figure;
% hold on;
% plot(newt22,cutdata44_22{:,'gps_z'});
% plot(newt22,cutdata44_22{:,'sonar_z'});
% 
% figure;
% hold on;
% plot(newt22,truex44_22);
% plot(newt22,kalx44_22);
% 
% figure;
% hold on;
% plot(newt22,truey44_22);
% plot(newt22,kaly44_22);
% 
% figure;
% hold on;
% plot(newt22,cutdata22{:,'dt'})
% 
% figure;
% histogram(plocerr22,50);