clearvars;
addpath('../Kalman');
addpath('../Log_handling');
datapath = '../data/NDI/01-02-2018/onboard';
addpath(datapath);

fontsize = 20;
printfigs = true;

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



[syncdata1,syncdata2,tm1,tm2] = syncData(data1,data2,'Range','time');


startt = 82;
endt = 282;
delay = 5;
start2 = 25;
endt2 = 60;

[cutdata1,cutdata2,newt] = cutOutData(syncdata1,syncdata2,startt,endt,startt,endt,'time');
[cutdata1d,cutdata2d,newtd] = cutOutData(syncdata1,syncdata2,startt,endt,startt-delay,endt-delay,'time');



header1 = data1.Properties.VariableNames;
header2 = data2.Properties.VariableNames;




time1 = cutdata1{:,'time'};
time2 = cutdata2{:,'time'};
h1 = cutdata1{:,'gps_z'};
x1 = cutdata1{:,'gps_x'};
y1 = cutdata1{:,'gps_y'};
u1 = cutdata1{:,'gps_vx'};
v1 = cutdata1{:,'gps_vy'};
a1x = cutdata1{:,'state_ax'};
a1y = cutdata1{:,'state_ay'};
r1 = cutdata1{:,'state_r'};
h2meas = cutdata1{:,'track_z'};
kalx21 = cutdata1{:,'kal_x'};
kaly21 = cutdata1{:,'kal_y'};
h2 = cutdata2{:,'gps_z'};
x2 = cutdata2{:,'gps_x'};
y2 = cutdata2{:,'gps_y'};
u2 = cutdata2{:,'gps_vx'};
v2 = cutdata2{:,'gps_vy'};
a2x = cutdata2{:,'state_ax'};
a2y = cutdata2{:,'state_ay'};
r2 = cutdata2{:,'state_r'};
psi1 = cutdata1{:,'state_psi'};
psi2 = cutdata2{:,'state_psi'};
truex21 = x2-x1;
truey21 = y2-y1;
psi21 = psi2-psi1;

truestate = [truex21.';
    truey21.';
    psi21.';
    u1.';
    v1.';
    u2.';
    v2.';];

trueinput = [a1x.';
    a1y.';
    a2x.';
    a2y.';
    r1.';
    r2.';];
    
nvars = height(cutdata1);

counts = 0;
threshold = 1;
valarr = zeros(1,nvars);
binvalarr = ones(1,nvars);
for i = 1:nvars
    curstate = truestate(:,i);
    curinput = trueinput(:,i);
    val = checkFullCond(curstate,curinput);
    valarr(i) = val;
    if(abs(val)<threshold)
        binvalarr(i)=0;
        counts = counts + 1;
    end
end

percunobs = counts/nvars*100;
fprintf("percentage lower than threshold is: %f\n",percunobs);
nbins = 50;

file = strcat('C:\Users\Steven\Dropbox\Thesis\Figures\NDI_experiments\unobsOnboard2tarr.eps');

tmask = (newt>start2 & newt<endt2);
xax = [start2 endt2];
yax = [-40 40];

facealpha = 0.3;

xverts = [start2 endt2 endt2 start2];
yverts = [-[threshold threshold] [threshold threshold]];

dtt = 5;
h = figure;
if(printfigs)
    set(h,'visible','off');
end
hold on;
set(gca,'FontSize',fontsize,...
    'FontUnits','points','FontWeight','normal','FontName','Times',...
    'xtick',start2:dtt:endt2,'ytick',yax(1):10:yax(2));
grid on;
plot(newt(tmask),valarr(tmask));
% hleg = plot(xax,[threshold, threshold],'r','linewidth',1.5);
% plot(xax,-[threshold, threshold],'r','linewidth',1.5);
hleg = patch(xverts,yverts,'r','FaceAlpha',facealpha);
% axis tight;
axis([xax yax]);
xlabel('time [s]','FontUnits','points','interpreter','latex','FontSize',fontsize,'FontName','Times');
ylabel('Observability value','FontUnits','points','interpreter','latex','FontSize',fontsize,'FontName','Times');
[BL,BLicons] = legend(hleg,'unobservable');
PatchInLegend = findobj(BLicons, 'type', 'patch');
set(PatchInLegend, 'facea', facealpha)
if(printfigs)
    print(h,file,'-depsc2');
end

% figure;
% hold on;
% plot(newt,binvalarr);
% xlabel('time [s]');
% ylabel('Observable');


fontsize = 26;

file = strcat('C:\Users\Steven\Dropbox\Thesis\Figures\NDI_experiments\unobsOnboard2hist.eps');
xax = [-60 60];
xt = 20;
yax = [0 500];
dxt = 20;
h = figure;
if(printfigs)
    set(h,'visible','off');
end
grid on
set(gca,'FontSize',fontsize,...
    'FontUnits','points','FontWeight','normal','FontName','Times',...
    'xtick',xax(1):xt:xax(2));
hold on;
histogram(valarr,nbins);
line([mean(valarr) mean(valarr)],get(gca,'YLim'),'Color','r','linewidth',2);
axis([xax yax]);
xlabel('Observability value','FontUnits','points','interpreter','latex','FontSize',fontsize,'FontName','Times');
ylabel('Instances','FontUnits','points','interpreter','latex','FontSize',fontsize,'FontName','Times');
legend('values','mean');
if(printfigs)
    print(h,file,'-depsc2');
end

% figure;
% hold on;
% histogram(abs(valarr),nbins);
% xlabel('value');
% ylabel('Instances');