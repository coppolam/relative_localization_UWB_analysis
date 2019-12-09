clearvars;
addpath('../Kalman');
addpath('../Log_handling');
datapath = '../../../Data/multi_NDI/15-10-2018';
addpath(datapath);

printfigs = false;

datafile18_44 = 'IP18_44_4.txt';
datafile44_18 = 'IP44_18_4.txt';

datafile18_44 = fullfile(datapath,datafile18_44);
datafile44_18 = fullfile(datapath,datafile44_18);
data18        = extractDelimitedFile(datafile18_44);
data44_18     = extractDelimitedFile(datafile44_18);

startt = 10;
endt   = 1000;
delay18 = 0;

[syncdata18,syncdata44_18,tm1,tm2] = syncData(data18,data44_18,'Range','time');

t18 = syncdata18{:,'time'};

[cutdata18,cutdata44_18,newt18,newt44_18]     = cutOutData(syncdata18,syncdata44_18,startt,endt,startt,endt,'time');
[cutdata18d,cutdata44_18d,newt18d,newt44_18d] = cutOutData(syncdata18,syncdata44_18,startt,endt,startt,endt,'time');

header1 = data18.Properties.VariableNames;
header2 = data44_18.Properties.VariableNames;


%% 18
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

rangeonboard = cutdata18{:,'Range'};
psionboard = cutdata18{:,'state_psi'};
rangeerr18 = cutdata18{:,'Range'}-trueranges18;

fprintf("Mean range 18: %f, MAX: %f\n",mean(trueranges18),max(trueranges18));
fprintf("MAE range 18: %f, MAX: %f\n",mean(abs(rangeerr18)),max(abs(rangeerr18)));
fprintf("MAE p rel loc 18: %f, MAX: %f\n",MAEploc18,max(abs(plocerr18)));
fprintf("MAE p track 18: %f, MAX: %f\n",MAEptrack18,max(abs(ptrackerr18)));

%% Top view from GPS
xmin = -4; xmax = 6; xtick=1;
ymin = -4; ymax = 4; ytick = 1;
fontsize = 20;
h = figure(55);
set(gca,'xtick',xmin:xtick:xmax,'ytick',ymin:ytick:ymax,'FontSize',fontsize,'FontName','Times');
colors = get(gca,'colororder');
hold on;
grid on;
axis([xmin xmax ymin ymax]);
plot(x44_18,y44_18,'x','color',colors(2,:));
plot(x18,y18,'-','color',colors(5,:));

xlabel('x');ylabel('y');
xlabel('x [m]','FontUnits','points','interpreter','latex','FontSize',fontsize,'FontName','Times');
ylabel('y [m]','FontUnits','points','interpreter','latex','FontSize',fontsize,'FontName','Times');
legend('Static','Moving','location','southeast');

%% Histogram

fontsize = 26;
nbins = 50;
file = strcat('..\..\..\Figures\static_test\rangeerr18_GPS.eps');
h = figure;
hold on;
grid on;
xmin = -1.5; xmax = 1.5; xtick = 0.5;
ymin = 0; ymax = 250; ytick = 50;
set(gca,'xtick',xmin:xtick:xmax,'ytick',ymin:ytick:ymax,'FontSize',fontsize,'FontName','Times');
histogram(rangeerr18,nbins);
axis([xmin xmax ymin ymax]);
line([mean(rangeerr18) mean(rangeerr18)],get(gca,'YLim'),'Color','r','linewidth',2);
legend('errors','mean');
xlabel('Range error [m]','FontUnits','points','interpreter','latex','FontSize',fontsize,'FontName','Times');
ylabel('Instances [m]','FontUnits','points','interpreter','latex','FontSize',fontsize,'FontName','Times');
if (printfigs)
    print(file,'-depsc2');
end

%% Log
fontsize = 20;
linewidth = 1.5;
file = strcat('..\..\..\Figures\static_test\rangeerr18_GPS_time.eps');
h = figure;
hold on;
grid on;
xmin = 0; xmax = 200; xtick = 5;
ymin = -1; ymax = 1.2; ytick = 0.5;
set(gca,'xtick',xmin:xtick:xmax,'ytick',ymin:ytick:ymax,'FontSize',fontsize,'FontName','Times');
plot(newt18,rangeerr18,'linewidth',linewidth);
axis([xmin xmax ymin ymax]);
xlabel('Time [s]');
ylabel('Range error [m]');
if (printfigs)
    print(file,'-depsc2');
end

