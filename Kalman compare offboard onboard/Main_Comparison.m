clear all;
%filepath = '/home/steven/Dropbox/Thesis/Data/Fly_Decawave_onboard_Kalman/2017_09_13_SynchFlight/Relative_localization_Pgain_0-2';
filepath = '../../../Data/Fly_Decawave_onboard_Kalman/08-09-2017_Spiral_tests';
filepathtypes = fullfile(filepath,'/*.txt');
[filename, pathname] = uigetfile(filepathtypes,'select file 1');
file1 = fullfile(pathname,filename);
[filename, pathname] = uigetfile(filepathtypes,'select file 2');
file2 = fullfile(pathname,filename);

X_K1 = Kalman_main(file1);
X_K2 = Kalman_main(file2);

data1 = extractData(file1);
data2 = extractData(file2);

header = {'msg_count','AC_ID','time','dt','own_x','own_y',...
    'own_z','own_vx','own_vy','own_vz','Range','track_vx_meas',...
    'track_vy_meas','track_z_meas','kal_x','kal_y','kal_vx','kal_vy',...
    'kal_oth_vx','kal_oth_vy','kal_rel_h','kal_bias'};


[synconboard1, synconboard2, mask1, mask2] = syncData(data1,data2,'Range','time');

syncoffboard1= X_K1(mask1,:);
syncoffboard2 = X_K2(mask2,:);

figure;
hold on;
plot(synconboard1{:,'time'},synconboard2{:,'own_x'}-synconboard1{:,'own_x'})
plot(synconboard1{:,'time'},synconboard1{:,'kal_x'});
plot(synconboard1{:,'time'},syncoffboard1{:,'kal_x'});
xlabel('time [s]');
ylabel('relative x [m]');
legend('true','onboard kalman','offboard kalman');

figure;
hold on;
plot(synconboard1{:,'time'},synconboard2{:,'own_y'}-synconboard1{:,'own_y'})
plot(synconboard1{:,'time'},synconboard1{:,'kal_y'});
plot(synconboard1{:,'time'},syncoffboard1{:,'kal_y'});
xlabel('time [s]');
ylabel('relative y [m]');
legend('true','onboard kalman','offboard kalman');

figure;
hold on;
plot(synconboard1{:,'time'},synconboard2{:,'own_z'}-synconboard1{:,'own_z'})
plot(synconboard1{:,'time'},synconboard1{:,'kal_rel_h'});
plot(synconboard1{:,'time'},syncoffboard1{:,'kal_rel_h'});
xlabel('time [s]');
ylabel('relative z [m]');
legend('true','onboard kalman','offboard kalman');

figure;
hold on;
plot(synconboard1{:,'time'},synconboard1{:,'own_z'});
plot(synconboard1{:,'time'},synconboard2{:,'own_z'});
xlabel('time [s]');
ylabel('height [m]');
legend('first one','second one');


