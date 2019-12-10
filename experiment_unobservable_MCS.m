init;
datapath = 'data/01-02-2018/GPS';
addpath(datapath);

printfigs = false;
fontsize = 20;

datafile1 = 'IP22_5.txt';
datafile2 = 'IP44_5.txt';
datafile1 = fullfile(datapath,datafile1);
datafile2 = fullfile(datapath,datafile2);
data1 = extractDelimitedFile(datafile1);
data2 = extractDelimitedFile(datafile2);

header1 = data1.Properties.VariableNames;
header2 = data2.Properties.VariableNames;

startt = 90;
endt   = 290;
delay  = 5;
start2 = 25;
endt2  = 60;

[syncdata1,syncdata2,tm1,tm2] = syncData(data1,data2,'Range','time');

[cutdata1,cutdata2,newt1,newt2] = cutOutData(syncdata1,syncdata2,startt,endt,startt,endt,'time');
[cutdata1d,cutdata2d,newt1d,newt2d] = cutOutData(syncdata1,syncdata2,startt,endt,startt-delay,endt-delay,'time');

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

xlocerr = kalx21-truex21;
ylocerr = kaly21-truey21;
plocerr = sqrt(xlocerr.^2+ylocerr.^2);
MAEploc = mean(plocerr);

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
thresholdvel = 0.0316;
valvelarr = zeros(1,nvars);
countsvel = 0;
binvalvelerr = ones(1,nvars);
valarr = zeros(1,nvars);
binvalarr = ones(1,nvars);
for i = 1:nvars
    curstate = truestate(:,i);
    curinput = trueinput(:,i);
    val = checkFullCond(curstate,curinput);
    valvel = checkVelCond(curstate);
    valvelarr(i) = valvel;
    valarr(i) = val;
    if(abs(val)<threshold)
        binvalarr(i)=0;
        counts = counts + 1;
    end
    if(abs(valvel)<thresholdvel)
        binvalvelarr(i)=0;
        countsvel = countsvel + 1;
    end
    
end

percvelunobs = countsvel/nvars*100;
percunobs = counts/nvars*100;
fprintf("percentage lower than threshold full, vel: %f, %f\n",percunobs,percvelunobs);
nbins = 50;

file = strcat('figures/unobsGPS2tarr.eps');

tmask = (newt1>start2 & newt1<endt2);
xax = [start2 endt2];
yax = [-35 35];

facealpha = 0.3;

xverts = [start2 endt2 endt2 start2];
yverts = [-[threshold threshold] [threshold threshold]];
dtt = 5;
h = figure;
hold on;
set(gca,'FontSize',fontsize,...
    'FontUnits','points','FontWeight','normal','FontName','Times',...
    'xtick',start2:dtt:endt2,'ytick',yax(1):10:yax(2));
grid on;
plot(newt1(tmask),valarr(tmask));
hleg = patch(xverts,yverts,'r','FaceAlpha',facealpha);

axis([xax yax]);
xlabel('time [s]','FontUnits','points','interpreter','latex','FontSize',fontsize,'FontName','Times');
ylabel('Observability value','FontUnits','points','interpreter','latex','FontSize',fontsize,'FontName','Times');
[BL,BLicons] = legend(hleg,'unobservable');
PatchInLegend = findobj(BLicons, 'type', 'patch');
set(PatchInLegend, 'facea', facealpha)
if(printfigs)
    print(h,file,'-depsc2');
end

linewidth=2;
left_color = [0    0.4470    0.7410];
right_color = [1 0 0];

file = strcat('figures/dtcorr.eps');
tcompstart = 130;
tcompend = 136;
newtshift = newt1-0.0376;
newtshifttm = newtshift>tcompstart & newtshift<tcompend;
newttm2 = newt1>tcompstart & newt1<tcompend;
dtarrtmp = cutdata1{:,'dt'};

file = strcat('figures/unobscorr.eps');
h = figure;
set(h,'defaultAxesColorOrder',[left_color; right_color]);
grid on
set(gca,'FontSize',fontsize,...
    'FontUnits','points','FontWeight','normal','FontName','Times');
hold on;
yyaxis left
plot(newt1(newttm2),plocerr(newttm2),'linewidth',linewidth);
ylabel('Localization error [m]');
yyaxis right
plot(newt1(newttm2),-1*(binvalarr(newttm2)-1),'--','linewidth',linewidth,'color',right_color);
ylabel('Unobservable','FontUnits','points','interpreter','latex','FontSize',fontsize,'FontName','Times');
xlabel('time [s]','FontUnits','points','interpreter','latex','FontSize',fontsize,'FontName','Times');

if(printfigs)
    print(h,file,'-depsc2');
end
xax = [-60 60];
xt = 20;
yax = [0 500];
file = strcat('figures/unobsGPS2hist.eps');
fontsize = 26;
h = figure;
grid on
set(gca,'FontSize',fontsize,...
    'FontUnits','points','FontWeight','normal','FontName','Times',...
    'xtick',xax(1):xt:xax(2));
hold on;
histogram(valarr,nbins);
axis([xax yax]);
line([mean(valarr) mean(valarr)],get(gca,'YLim'),'Color','r','linewidth',2);
xlabel('Observability value','FontUnits','points','interpreter','latex','FontSize',fontsize,'FontName','Times');
ylabel('Instances','FontUnits','points','interpreter','latex','FontSize',fontsize,'FontName','Times');
leg1=legend('values','mean');
set(leg1,'interpreter','latex');

if(printfigs)
    print(h,file,'-depsc2');
end
