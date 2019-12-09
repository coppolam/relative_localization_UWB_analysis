
clear all
close all

leadertablevars = extractData('Choose leader log');
leadervars = table2array(leadertablevars);
followertablevars = extractData('Choose follower log');
followervars = table2array(followertablevars);



keySet =   {'msg','acid','time','dt','ownx','owny','ownz','ownvx','ownvy','ownvz','range_m',...
    'othvx_m','othvy_m','othz_m','relx_kal','rely_kal','ownvx_kal','ownvy_kal','othvx_kal',...
    'othvy_kal','relh_kal'};
valueSet = 1:length(keySet);
map = containers.Map(keySet,valueSet);


leaderrange_m = leadervars(:,map('range_m'));
followerrange_m = followervars(:,map('range_m'));


followertime = followervars(:,map('time'));
leadertime = leadervars(:,map('time'));

delayn = findDelay(leaderrange_m,followerrange_m,4000,10,2000);
if(isnan(delayn) || delayn == 0)
    timedelay=0;
elseif(delayn<0)
    timedelay = leadertime(abs(delayn))-leadertime(2);
    leadertime = leadertime-timedelay;
else
    timedelay = leadertime(abs(delayn))-leadertime(2);
    followertime=followertime-timedelay;
end

mintime = 5;
maxtime = min(max(followertime),max(leadertime));

followertimemask = (followertime>=mintime) & (followertime <= maxtime);
leadertimemask = (leadertime>=mintime) & (leadertime <= maxtime);

[syncleadervars,syncfollowervars] = extractSyncedData(leadervars,followervars,leadertimemask,followertimemask);

leadertime = leadertime(leadertimemask);
followertime = followertime(followertimemask);

if(size(leadertime,1)>size(followertime,1))
    leadertime = leadertime(1:size(followertime,1));
elseif (size(followertime,1)>size(leadertime,1))
    followertime = followertime(1:size(leadertime,1));
end

leaderx = syncleadervars(:,map('ownx'));
followerx = syncfollowervars(:,map('ownx'));

leadery = syncleadervars(:,map('owny'));
followery = syncfollowervars(:,map('owny'));

leaderrange_m = syncleadervars(:,map('range_m'));
followerrange_m = syncfollowervars(:,map('range_m'));

leadervx = syncleadervars(:,map('ownvx'));
followervx = syncfollowervars(:,map('ownvx'));

leadervy = syncleadervars(:,map('ownvy'));
followervy = syncfollowervars(:,map('ownvy'));



true_relx = syncleadervars(:,map('ownx'))-syncfollowervars(:,map('ownx'));
true_rely = syncleadervars(:,map('owny'))-syncfollowervars(:,map('owny'));

truerange = sqrt(true_relx.^2+true_rely.^2);

kal_relx = syncfollowervars(:,map('relx_kal'));
kal_rely = syncfollowervars(:,map('rely_kal'));

figure;
hold on;
grid on;
plot(true_relx,true_rely);
plot(kal_relx,kal_rely,'r');
xlabel('x location [m]');
ylabel('y location [m]');
legend('true relative trajectory','kalman relative trajectory');

figure;
hold on;
grid on;
plot(leadertime,true_relx);
plot(followertime,kal_relx,'r');
xlabel('time [s]');
ylabel('x location [m]');
legend('true relative x','kalman relative x');

figure;
hold on;
grid on;
plot(leadertime,true_rely);
plot(followertime,kal_rely,'r');
xlabel('time [s]');
ylabel('y location [m]');
legend('true relative y','kalman relative y');

figure;
hold on;
grid on;
plot(leadertime,leaderrange_m);
plot(followertime,followerrange_m);
xlabel('time [s]');
ylabel('range [m]');
legend('leader range','follower range');

figure;
hold on;
grid on;
plot(leadertime,truerange);
plot(leadertime,leaderrange_m,'r');
xlabel('time [s]');
ylabel('range [m]');
legend('true range','measured range');

figure;
hold on;
grid on;
plot(leadertime,leaderx);
plot(followertime,followerx);
xlabel('time [s]');
ylabel('x direction [m]');
legend('leader','follower');

figure;
hold on;
grid on;
plot(leadertime,leadervx);
plot(followertime,followervx);
xlabel('time [s]');
ylabel('vx [m/s]');
legend('leader','follower');

figure;
hold on;
grid on;
plot(leadertime,leadervy);
plot(followertime,followervy);
xlabel('time [s]');
ylabel('vy [m/s]');
legend('leader','follower');

figure;
hold on;
grid on;
plot(followertime,syncfollowervars(:,map('othvx_m')));
plot(followertime,syncfollowervars(:,map('othvx_kal')));
xlabel('time [s]')
ylabel('vx [m/s]');
legend('measured vx other','kalman vx other');

figure;
hold on;
grid on;
plot(followertime,syncfollowervars(:,map('othvy_m')));
plot(followertime,syncfollowervars(:,map('othvy_kal')));
xlabel('time [s]')
ylabel('vy [m/s]');
legend('measured vy other','kalman vy other');


figure;
hold on;
grid on;
plot(followertime,syncfollowervars(:,map('ownvx')));
plot(followertime,syncfollowervars(:,map('ownvx_kal')));
xlabel('time [s]')
ylabel('vx [m/s]');
legend('own vx optitrack','own vx kalman');

figure;
hold on;
grid on;
plot(followertime,syncfollowervars(:,map('ownvy')));
plot(followertime,syncfollowervars(:,map('ownvy_kal')));
xlabel('time [s]')
ylabel('vy [m/s]');
legend('own vy optitrack','own vy kalman');


