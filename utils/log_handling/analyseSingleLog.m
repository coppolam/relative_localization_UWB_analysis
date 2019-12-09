datapath = '../../../Data/NDI/29-01-2018_2';
datatype = '.txt';
delimiter = ',';
data = extractDelimitedFile(datapath,datatype,delimiter);
header = data.Properties.VariableNames;

fc = 9;
fs = 20;
[b,a] = butter(2,fc/(fs/2));
ax = data{:,'state_ax'};
axsmooth = filter(b,a,ax);

r = data{:,'state_r'};
rsmooth = filter(b,a,r);

figure;
hold on;
plot(data{:,'time'},data{:,'state_z'});
plot(data{:,'time'},data{:,'sonar_z'});
plot(data{:,'time'},data{:,'gps_z'});
xlabel('time [s]');
ylabel('z [m]');
legend('state','sonar','gps');

figure;
hold on;
plot(data{:,'time'},data{:,'state_x'});
plot(data{:,'time'},data{:,'gps_x'});
xlabel('time [s]');
ylabel('z [m]');
legend('state','gps');

figure;
hold on;
plot(data{:,'time'},data{:,'state_vx'});
plot(data{:,'time'},data{:,'gps_vx'});
plot(data{:,'time'},data{:,'optic_vx'});
xlabel('time [s]');
ylabel('vx [m/s]');
legend('state','gps','optic');

figure;
hold on;
plot(data{:,'time'},data{:,'state_z'});
plot(data{:,'time'},data{:,'gps_z'});
xlabel('time [s]');
ylabel('y [m]');
legend('state','gps');

figure;
hold on;
plot(data{:,'time'},data{:,'state_vy'});
plot(data{:,'time'},data{:,'gps_vy'});
plot(data{:,'time'},data{:,'optic_vy'});
xlabel('time [s]');
ylabel('vy [m/s]');
legend('state','gps','optic');


figure;
hold on;
plot(data{:,'time'},data{:,'state_ax'});
plot(data{:,'time'},data{:,'smooth_ax'},'--');
xlabel('time [s]');
ylabel('ax [m/s2]');

figure;
hold on;
plot(data{:,'time'},data{:,'state_r'});
plot(data{:,'time'},data{:,'smooth_r'});
xlabel('time [s]');
ylabel('r [rad/s]');