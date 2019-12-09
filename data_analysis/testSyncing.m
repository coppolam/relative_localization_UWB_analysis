clearvars;
addpath('../Log_handling');
addpath('../../../Data/NDI/04-01-2018');


file1 = '../../../Data/NDI/04-01-2018/IP22_follower9_trajectory.txt';
file2 = '../../../Data/NDI/04-01-2018/IP44_leader9_trajectory.txt';

data1 = extractDelimitedFile(file1);
data2 = extractDelimitedFile(file2);

time1 = data1{:,'time'};
time2 = data2{:,'time'};

delay = findDelay(data1{:,'Range'},data2{:,'Range'});

indexarr1 = 1:height(data1);
indexarr2 = (1:height(data2)) - delay;

timeind1 = min(find(time1,50,'first'));
timeind2 = min(find(time2,50,'first'));
starttime1 = time1(timeind1);
starttime2 = time2(timeind2);
deltastarttime = starttime1-starttime2;

timedelay = time2(abs(delay))-time2(timeind2)-deltastarttime;
time2new = time2-timedelay;
time2shift = time2 + deltastarttime;
range2 = data2{:,'Range'};

figure;
hold on;
plot(data1{:,'Range'});
plot(data2{:,'Range'});

figure;
hold on;
plot(indexarr1,data1{:,'Range'});
plot(indexarr2,data2{:,'Range'},'--');

figure;
hold on;
plot(data1{:,'time'},data1{:,'Range'});
plot(time2,data2{:,'Range'});

figure;
hold on;
plot(data1{:,'time'},data1{:,'Range'});
plot(time2new,data2{:,'Range'});

figure;
hold on;
plot(data1{:,'time'},data1{:,'Range'});
plot(time2shift(1:end-delay),range2(delay+1:end));
