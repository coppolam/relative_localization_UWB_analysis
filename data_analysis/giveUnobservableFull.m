function [ valarr,binvalarr ] = giveUnobservableFull( cutdata1, cutdata2,threshold )
%PLOTUNOBSERVABLE Summary of this function goes here
%   Detailed explanation goes here
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



end

