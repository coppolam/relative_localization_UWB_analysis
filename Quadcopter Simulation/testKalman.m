clearvars;
addContainingDirAndSubDir();
rng(1);

smoothr = 1;
smootha = 1;
kalmanmodel = "Kalman_no_heading3";
% kalmanmodel = "Kalman_no_acc";
%kalmanmodel = "Kalman_mario_no_heading";
%kalmanmodel = "Kalman_full_no_B";
%kalmanmodel="Kalman_mario";
relativemotion = "xy"; % x, y, or xy
controlleader = "yaw"; % yaw or position or stationary or straight
controlfollower = "yaw"; % yaw or position or updown or straight
periodleader = 20; % [s]
radiusleaderstart = 4;
radiusleaderend = 4;
leaderaddr = 0.00; % [rad/s]
periodfollower = -20; % [s]
radiusfolxstart = 3;
radiusfolxend = 3;
radiusfolystart = 3;
radiusfolyend = 3;
followeraddr = -0.2; % [rad/s]
followeraddr = 0;
vfstraight = 3;
afadd = 5; % [m/s2]
Ffadd = 2*afadd; % [N]
periodfadd = 0.1; % [s]
wfadd = 2*pi/periodfadd; % [rad/s]
straightcontroller = Controller(2,0,1,0);

tend = 20; % [s]

switch relativemotion
    case "x"
        followeroffset = pi;
        vfstraightx = vfstraight;
        vfstraighty = 0;
    case "y"
        followeroffset = 0;
        vfstraightx = 0;
        vfstraighty = vfstraight;
    case "xy"
        followeroffset = pi/2;
        vfstraightx = vfstraight;
        vfstraighty = vfstraight;
end


kalmanfreq = Inf; % [Hz]
dynupdatefreq = 500; % [Hz]



noise = zeros(5,1);
rangenoise = 1;
noise = [0.1, 0.1, 0.1,0.1,0.1]; % p, v, a, r, yaw
% rangenoise = 0.1;


dt = 1/dynupdatefreq;

tarr = 0:dt:tend;
oldt = 0;





wleader = 2*pi/periodleader;
wfollower = 2*pi/periodfollower;

plarr=zeros(3,length(tarr));
vlarr=zeros(3,length(tarr));
vlbarr = zeros(3,length(tarr));
alarr=zeros(3,length(tarr));
albarr=zeros(3,length(tarr));
pfarr=zeros(3,length(tarr));
vfarr=zeros(3,length(tarr));
afarr=zeros(3,length(tarr));
afbarr = zeros(3,length(tarr));
vfobsarr=zeros(3,length(tarr));
afobsarr = zeros(3,length(tarr));
vfbarr = zeros(3,length(tarr));
afbobsarr = zeros(3,length(tarr));
yawfarr = zeros(1,length(tarr));
rfarr = zeros(1,length(tarr));
yawfobsarr = zeros(1,length(tarr));
rfobsarr = zeros(1,length(tarr));
x12arr = zeros(1,length(tarr));
y12arr = zeros(1,length(tarr));
esterrbody = zeros(2,length(tarr));

kalarr = [];
kalpfarr = [];
kalplarr = [];
kaltarr = [];
kallyaw = [];
kalfyaw = [];
kalrotarr = [];
kalreldistarr = [];

t=0;
p0l = [cos(wleader*t)*radiusleaderstart;sin(wleader*t)*radiusleaderstart;0];
v0l = [0;0;0];
a0l = [0;0;0];
maxvl = Inf;
maxal = Inf;
maxrl = Inf;

p0f = [cos(wfollower*t+followeroffset)*radiusfolxstart;sin(wfollower*t+followeroffset)*radiusfolystart;0];
v0f = [0;0;0];
a0f = [0;0;0];
maxvf = Inf;
maxaf = Inf;
maxrf = Inf;



if controlleader == "yaw"
    yaw0l = pi/2;
    r0l = 0;
    leader = Particle("VELOCITY",p0l,v0l,a0l,yaw0l,r0l,noise,maxvl,maxal,maxrl,kalmanmodel,smoothr,smootha );
elseif controlleader == "stationary"
    p0l = zeros(3,1);
    v0l = zeros(3,1);
    a0l = zeros(3,1);
    yaw0l = pi/2;
    r0l = 0;
    leader = Particle("POSITION",p0l,v0l,a0l,yaw0l,r0l,noise,maxvl,maxal,maxrl,kalmanmodel,smoothr,smootha );
elseif controlleader == "straight"
    p0l = [0.5;0;0];
    v0l = [vfstraightx;vfstraighty;0];
    a0l = zeros(3,1);
    yaw0l = 0;
    r0l = 0;
    leader = Particle("VELOCITYSCREEN",p0l,v0l,a0l,yaw0l,r0l,noise,maxvl,maxal,maxrl,kalmanmodel,smoothr,smootha );
else
    yaw0l = pi/2;
    r0l = 0;   
    leader = Particle("POSITION",p0l,v0l,a0l,yaw0l,r0l,noise,maxvl,maxal,maxrl,kalmanmodel,smoothr,smootha );
end
if controlfollower == "yaw"
    yaw0f = (-pi/2+followeroffset)*-periodfollower/abs(periodfollower);
    r0f = 2*pi/periodfollower;    
    follower = Particle("VELOCITY",p0f,v0f,a0f,yaw0f,r0f,noise,maxvf,maxaf,maxrf,kalmanmodel,smoothr,smootha );
elseif controlfollower == "updown"
    p0f = [-3;0;0];
    v0f = [0;0;0];
    a0f = [0;0;0];
    yaw0f = 0;
    r0f = 0;
    follower = Particle("FORCE",p0f,v0f,a0f,yaw0f,r0f,noise,maxvf,maxaf,maxrf,kalmanmodel,smoothr,smootha );
elseif controlfollower == "position"
    yaw0f = pi/2;
    %yaw0 = 0.956;
    r0f = 0;   
    follower = Particle("POSITION",p0f,v0f,a0f,yaw0f,r0f,noise,maxvf,maxaf,maxrf,kalmanmodel,smoothr,smootha );
elseif controlfollower == "straight"
    yaw0f = 0;
    r0f = 0;
    p0f = [0;0;0];
    v0f = [vfstraightx;vfstraighty;0];
    a0f = [0;0;0];
    follower = Particle("FORCE",p0f,v0f,a0f,yaw0f,r0f,noise,maxvf,maxaf,maxrf,kalmanmodel,smoothr,smootha );
end
% obj.state = [x12;y12;z1;z2;u1;v1;u2;v2;gam];
% kalmanx0 = [0;0.5;0;0;vfstraightx;vfstraighty;vfstraightx;vfstraighty;0];
% kalmanP0 = diag([4^2 4^2 1^2 1^2 1^2 1^2 1^2 1^2 1^2]);
% follower.initKalman(leader,kalmanx0,kalmanP0);
follower.initKalman(leader);



ind = 1;
for t = tarr
    radiusleader = radiusleaderstart + t/tend * (radiusleaderend-radiusleaderstart);
    if controlleader == "yaw"
        uleader = radiusleader*wleader^2/abs(wleader);
        leaderinp = [uleader;0;0];
        leaderr = wleader;        
    elseif controlleader == "stationary"
        leaderinp = zeros(3,1);
        leaderr = 0;
    elseif controlleader == "straight"
        leaderinp = [vfstraightx;vfstraighty;0];
        leaderr = 0;
    else
        leaderinp = [cos(wleader*t)*radiusleader;sin(wleader*t)*radiusleader;0];
        leaderr = 0+leaderaddr;
    end        
    leader.setInput(leaderinp,leaderr);
    radiusfolx = radiusfolxstart + t/tend * (radiusfolxend-radiusfolxstart);
    radiusfoly = radiusfolystart + t/tend * (radiusfolyend-radiusfolystart);
    if controlfollower == "yaw"        
        ufollower = ((radiusfolx+radiusfoly)/2)*wfollower^2/abs(wfollower);
        followerinp = [ufollower;0;0];
        followerr = wfollower;
    elseif controlfollower == "updown"
        followerinp = [0;cos(0.5*t);0];
        followerr = 0;
    elseif controlfollower == "position"       
        followerinp = [cos(wfollower*t+followeroffset)*radiusfolx;sin(wfollower*t+followeroffset)*radiusfoly;0];
        followerr = 0+followeraddr;
    elseif controlfollower == "straight"
        if (vfstraightx>0)
            xdir = vfstraightx/abs(vfstraightx);
        else
            xdir = 0;
        end
        if (vfstraighty>0)
            ydir = vfstraighty/abs(vfstraighty);
        else
            ydir = 0;
        end
        
        followerinp = [xdir*Ffadd*cos(t*wfadd);ydir*Ffadd*cos(t*wfadd);0];
        followerr = 0 + followeraddr;
    end
    follower.setInput(followerinp,followerr);
    
    leader.updateModel(dt);
    follower.updateModel(dt);    
    
    plarr(:,ind) = leader.ps;
    pfarr(:,ind) = follower.ps;
    
    vlarr(:,ind) = leader.vs;
    vfarr(:,ind) = follower.vs;
    vfobsarr(:,ind) = follower.vsobs;
    vfbarr(:,ind) = follower.vb;
    
    alarr(:,ind) = leader.as;
    vlbarr(:,ind) = leader.vb;
    albarr(:,ind) = leader.abobs;
    afarr(:,ind) = follower.as;
    afobsarr(:,ind) = follower.asobs;
    afbobsarr(:,ind) = follower.abobssmooth;
    afbarr(:,ind) = follower.ab;
    
    yawfarr(ind) = follower.yaws;
    yawfobsarr(ind) = follower.yawsobs;
    
    rfarr(ind) = follower.rs;
    rfobsarr(ind) = follower.rsobs;    
    
    folbodp = follower.RbE*(leader.p-follower.p);
    x12arr(ind) = folbodp(1);
    y12arr(ind) = folbodp(2);
    
    esterrbody(:,ind) = abs(follower.kalmanfilter.x_k_k(1:2)-folbodp(1:2));
    
    if (t-oldt>1/kalmanfreq)
        dtkal = t-oldt;
        oldt = t;
        handleKalman(follower,leader,rangenoise,dtkal)
        kaltarr(end+1) = t;
        kalarr(:,end+1) = follower.kalmanfilter.x_k_k;
        kalrotarr(:,end+1) = follower.kalmanfilter.x_k_k;
%         kalrotarr(1:2,end) = follower.RsE(1:2,1:2)*kalrotarr(1:2,end);        
        if (strcmpi(kalmanmodel,"Kalman_no_heading3") || strcmpi(kalmanmodel,"Kalman_no_heading4") ||strcmpi(kalmanmodel,"Kalman_heading3"))
            kalrotarr(1:2,end) = follower.RsE(1:2,1:2)*follower.REb(1:2,1:2)*kalrotarr(1:2,end);
            kalrotarr(5:6,end) = follower.RsE(1:2,1:2)*follower.REb(1:2,1:2)*kalrotarr(5:6,end);
            kalrotarr(7:8,end) = leader.RsE(1:2,1:2)*leader.REb(1:2,1:2)*kalrotarr(7:8,end);
            kalrotarr(9,end) = follower.Ryaw * kalrotarr(9,end);
        elseif (strcmpi(kalmanmodel,"Kalman_no_acc"))
            kalrotarr(1:2,end) = follower.RsE(1:2,1:2)*follower.REb(1:2,1:2)*kalrotarr(1:2,end);
            kalrotarr(3,end) = follower.Ryaw*kalrotarr(3,end);
        else
            kalrotarr(1:2,end) = follower.RsE(1:2,1:2)*kalrotarr(1:2,end);
        end
        kalpfarr(:,end+1) = follower.ps;
        kalplarr(:,end+1) = leader.ps;
        kallyaw(end+1) = leader.yaw;
        kalfyaw(end+1) = follower.yaw;
        kalreldistarr(end+1) = norm(leader.ps-follower.ps);
    end
    ind = ind + 1;
end

kalgam = kallyaw-kalfyaw;
plestarr = kalrotarr(1:2,:)+kalpfarr(1:2,:);
Parr = follower.kalmanfilter.Parr;
relvxarr = abs(vlarr(1,:)-vfarr(1,:));
relaxarr = abs(alarr(1,:)-afarr(1,:));
relvyarr = abs(vlarr(2,:)-vfarr(2,:));
esterrx = kalplarr(1,:)-plestarr(1,:);
esterry = kalplarr(2,:)-plestarr(2,:);
esterr = sqrt(esterrx.^2+esterry.^2);
Px = Parr(1,:);
Py = Parr(2,:);
% smoothafobsarr = movmean(afobsarr,smootha,2);
% smoothrfobsarr = movmean(rfobsarr,smoothr);


% figure;
% hold on;
% plot(tarr,relvxarr);
% plot(tarr,relaxarr);
% plot(kaltarr,esterx);
% legend('v','a','err');
% 
% figure;
% hold on;
% plot(tarr,relaxarr+relvxarr);
% plot(kaltarr,esterx);
% legend('va','err');
% 
% figure;
% hold on;
% plot(tarr,relaxarr);
% plot(tarr,esterx);
% 
% [Rc,Pc] = corrcoef(relvxarr,esterx);

% figure;
% hold on
% axis equal
% plot(pfarr(1,:),pfarr(2,:));
% xlabel('x follower [m]');
% ylabel('y follower [m]');


% figure;
% hold on
% plot(kaltarr,kalplarr(1,:)-kalpfarr(1,:));
% plot(kaltarr,kalarr(1,:));
% xlabel('time [s]');
% ylabel('x12 [m]');
% legend('real','kalman estimate');

% figure;
% hold on
% plot(kaltarr,kalplarr(2,:)-kalpfarr(2,:));
% plot(kaltarr,kalarr(2,:));
% xlabel('time [s]');
% ylabel('y12 [m]');
% legend('real','kalman estimate');

figure;
hold on;
axis equal
plot(plarr(1,:),plarr(2,:));
plot(plestarr(1,:),plestarr(2,:));
xlabel('x [m]');
ylabel('y [m]');
legend('true leader trajectory','kalman estimate');
% 
% 
% 
figure;
hold on;
plot(tarr,plarr(1,:));
plot(kaltarr,plestarr(1,:));
plot(kaltarr,kalarr(1,:));
xlabel('time [s]');
ylabel('leader x [m]');
legend('true','kalman estimate','x12');

figure;
hold on
plot(tarr,plarr(2,:));
plot(kaltarr,plestarr(2,:));
plot(kaltarr,kalarr(2,:));
xlabel('time [s]');
ylabel('leader y[m]');
legend('true','kalman estimate','y12');

% figure;
% hold on
% plot(tarr,vfarr(1,:));
% xlabel('time [s]');
% ylabel('follower vx [m/s]');

% figure;
% hold on
% plot(tarr,afobsarr(1,:));
% plot(tarr,smoothafobsarr(1,:));
% plot(tarr,afarr(1,:),'linewidth',2);
% xlabel('time [s]');
% ylabel('follower ax [m/s2]');
% legend('Screen obs ax','Smooth sceen obs ax','True screen ax');

% figure;
% hold on
% plot(tarr,afobsarr(2,:));
% plot(tarr,smoothafobsarr(2,:));
% plot(tarr,afarr(2,:),'linewidth',2);
% xlabel('time [s]');
% ylabel('follower ay [m/s2]');
% legend('Screen obs ay','Smooth sceen obs ay','True screen ay');





% figure;
% hold on;
% plot(kaltarr,Parr(1,:));



% figure;
% hold on;
% plot(tarr,rad2deg(yawfobsarr));
% plot(tarr,rad2deg(yawfarr));
% xlabel('time [s]');
% ylabel('follower yaw [deg]');
% legend('observed','true');
% 
% 
% figure;
% hold on;
% plot(tarr,rad2deg(rfobsarr));
% plot(tarr,rad2deg(smoothrfobsarr));
% plot(tarr,rad2deg(rfarr));
% xlabel('time [s]');
% ylabel('follower r [deg/s]');
% legend('observed','smooth','real');
% % 
% figure;
% hold on
% plot(tarr,afbobsarr(2,:))
% plot(tarr,afbarr(2,:))
% xlabel('time [s]');
% ylabel('follower ay [m/s2]');
% legend('Observed body ay','True body ay');

% figure;
% hold on;
% plot(tarr,vlarr(1,:));
% plot(tarr,vfarr(1,:));
% plot(tarr,abs(vlarr(1,:)-vfarr(1,:)));
% xlabel('time [s]');
% ylabel('vx [m/s]');
% legend('leader','follower','relative');

% figure;
% hold on;
% plot(tarr,vlarr(2,:));
% plot(tarr,vfarr(2,:));
% plot(tarr,abs(vlarr(2,:)-vfarr(2,:)));
% xlabel('time [s]');
% ylabel('vy [m/s]');
% legend('leader','follower','relative');

MAEx = mean(abs(esterrx));
MAEy = mean(abs(esterry));
MAEtotal = mean(esterr);

MAExb = mean(abs(esterrbody(1,:)));
MAEyb = mean(abs(esterrbody(2,:)));
esterrbodytotal = sqrt(esterrbody(1,:).^2 + esterrbody(2,:).^2);
MAEtotalb = mean(esterrbodytotal);

relvxmean = mean(abs(vlarr(1,:)-vfarr(1,:)));
relvymean = mean(abs(vlarr(2,:)-vfarr(2,:)));

fprintf("MAE x, y, total is: %f, %f %f\n",MAEx,MAEy,MAEtotal);
fprintf("Relative vx, vy: %f, %f\n",relvxmean,relvymean);
fprintf("vx*ex, vy*ey: %f, %f\n",relvxmean*MAEx,relvymean*MAEy);

relvxbmean = mean(abs(vlbarr(1,:)-vfbarr(1,:)));
relvybmean = mean(abs(vlbarr(2,:)-vfbarr(2,:)));

% fprintf("MAE xb, yb, total is: %f, %f %f\n",MAExb,MAEyb,MAEtotalb);
% fprintf("Relative vxb, vyb: %f, %f\n",relvxbmean,relvybmean);
% fprintf("vxb*exb, vyb*eyb: %f, %f\n",relvxbmean*MAExb,relvybmean*MAEyb);


figure;
hold on
plot(kaltarr,esterr);
plot([kaltarr(1),kaltarr(end)],[mean(esterr),mean(esterr)],'linewidth',2);
xlabel('time [s]');
ylabel('error [m]');
legend('Localization error','Mean localization error');



% 
% figure;
% hold on
% plot(kaltarr,rad2deg(kalarr(9,:)));
% plot(kaltarr,rad2deg(kalgam));
% xlabel('time [s]');
% ylabel('gamma [deg]');
% legend('kalman estimate','true');
% 
% figure;
% hold on;
% yyaxis left
% plot(kaltarr,esterrx);
% ylabel('Error x[m]');
% yyaxis right
% plot(tarr,x12arr);
% %plot(kaltarr,kalarr(1,:));
% ylabel('x12 [m]');
% xlabel('time [s]');
% legend('Error','x12');
% 
% figure;
% hold on;
% yyaxis left
% plot(kaltarr,esterry);
% ylabel('Error y[m]');
% yyaxis right
% plot(tarr,y12arr);
% %plot(kaltarr,kalarr(2,:));
% ylabel('y12 [m]');
% xlabel('time [s]');
% legend('Error','y12');
% 
% figure;
% hold on;
% yyaxis left
% plot(kaltarr,esterr);
% ylabel('Error y[m]');
% yyaxis right
% plot(tarr,x12arr.*y12arr);
% %plot(kaltarr,kalarr(2,:));
% ylabel('x12*y12 [m]');
% xlabel('time [s]');
% legend('Error','y12');


