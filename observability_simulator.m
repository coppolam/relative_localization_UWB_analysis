init;
rng(5);
%% Select experiment type as per the paper
% Fig 5 = statleader + accehead
% Fig 6 = statleader + acc
% Fig 7 = statfollower + acchead
% Fig 8 = statfollower + acc

behavior = 'statleader';
% behavior = 'statfollower';
% behavior = 'parallelequal';
% behavior = 'paralleldiff';
% behavior = 'circlexy';

% type = 'acc';
type = 'acchead';

%% Other parameters
filename = strcat(behavior,'_',type);
rangenoise = 0.0;
initpkalman = false;
kalmanfreq = 20; % [Hz]

printfigs = true;
fontsize = 25;
linewidth =  2.5;
gamticks = 0.5;
zoomlines = {'SE','SE'; 'NW','NW'};
pxticks2 = [0,0.2];
pyticks2 = [0,1.5];
    
if (strcmpi(behavior,'statfollower') && strcmpi(type,'acchead'))    
    tticks = 0.5;
    tend = 2;

    pticks = 0.5;
    prange = [0,1.5];

    pzoom = true;
    pzoomarea = [0 0.2 0 1.4];
    pzoomput = [0.6 1.8 0.4 1.45];

    gamrange = [0,1.5];

    gamzoom = true;
    gamzoomarea = [0 0.2 0 1.1];
    gamzoomput = [0.6 1.8 0.4 1.4];
elseif (strcmpi(behavior,'statfollower') && strcmpi(type,'acc'))    
    tticks = 0.5;
    tend = 2;
    pticks = 1;
    prange = [0,5];

    pzoom = true;
    pzoomarea = [0 0.2 0 1.4];
    pzoomput = [0.2 1.3 1.7 4.6];

    gamrange = [0.5,1.5];

    gamzoom = false;
    gamzoomarea = [0 0.2 0 1.1];
    gamzoomput = [0.6 1.8 0.4 1.4];
elseif (strcmpi(behavior,'statleader') && strcmpi(type,'acchead'))    
    tticks = 0.5;
    tend = 2;
    pticks = 0.5;
    prange = [0,1.5];

    pzoom = true;
    pzoomarea = [0 0.2 0 1.4];
    pzoomput = [0.6 1.8 0.4 1.45];

    gamrange = [0,1.5];

    gamzoom = true;
    gamzoomarea = [0 0.2 0 1.1];
    gamzoomput = [0.6 1.8 0.4 1.4];
elseif (strcmpi(behavior,'statleader') && strcmpi(type,'acc'))    
    tticks = 0.5;
    tend = 2;
    pticks = 0.5;
    prange = [0,1.5];

    pzoom = true;
    pzoomarea = [0 0.2 0 1.4];
    pzoomput = [0.6 1.8 0.4 1.45];

    gamrange = [0,1.5];

    gamzoom = false;
    gamzoomarea = [0 0.2 0 1.1];
    gamzoomput = [0.6 1.8 0.4 1.4];
elseif (strcmpi(behavior,'paralleldiff') && strcmpi(type,'acc'))    
    tticks = 5;
    tend = 20;
    pticks = 1;
    prange = [0,4];

    pzoom = true;
    pzoomarea = [0 0.3 0 1.4];
    pzoomput = [4 15 1.2 3.7];

    gamrange = [0,1.5];

    gamzoom = true;
    gamzoomarea = [0 1 0 1.1];
    gamzoomput = [4 17 0.4 1.4];
elseif (strcmpi(behavior,'paralleldiff') && strcmpi(type,'acchead'))    
    tticks = 0.5;
    tend = 3;
    pticks = 0.5;
    prange = [0,1.5];

    pzoom = true;
    pzoomarea = [0 0.2 0 1.4];
    pzoomput = [0.7 2.7 0.4 1.45];

    gamrange = [0,1.5];

    gamzoom = true;
    gamzoomarea = [0 0.2 0 1.1];
    gamzoomput = [0.6 2.6 0.4 1.4];
end

if (strcmpi(behavior,"oscillate"))
    p0l = [0.5;0.5];
    v0l = [2;2];
    a0l = [0;0];
    r0l = 0;

    p0f = [0;0];
    v0f = [2;2];
    a0f = [0;0];
    r0f = 0;
    afinarr = [1;1];

    al = @(t) a0l;
    vl = @(t) v0l;
    pl = @(t) p0l + v0l*t;

    af = @(t) (-Afoladd*sin(wfoladd*t)).*afinarr;
    vf = @(t) ((Afoladd/wfoladd)*cos(wfoladd*t)).*afinarr+v0f;
    pf = @(t) ((Afoladd/(wfoladd^2))*sin(wfoladd*t)).*afinarr + v0f*t + p0f;
elseif (strcmpi(behavior,"accelfollower"))
    p0l = [0.5;0.5];
    v0l = [2;2];
    a0l = [0;0];
    r0l = 0;

    p0f = [0;0];
    v0f = [2;2];
    a0f = [0;0];
    r0f = 0;
    afinarr = [1;1];

    al = @(t) a0l;
    vl = @(t) v0l;
    pl = @(t) p0l + v0l*t;
    af = @(t) [0.5;0.5];
    vf = @(t) v0f+[0.5;0.5]*t;
    pf = @(t) p0f + [0.5;0.5]/2*t^2 + v0f*t;
elseif (strcmpi(behavior,"statleader"))
    p0l = [1;1];
    v0l = [0;0];
    a0l = [0;0];
    r0l = 0;

    p0f = [0;0];
    v0f = [1;0];
    a0f = [0;0];
    r0f = 0;
    afinarr = [1;1];

    al = @(t) a0l;
    vl = @(t) v0l;
    pl = @(t) p0l;
    af = @(t) a0f;
    vf = @(t) v0f+a0f*t;
    pf = @(t) p0f + a0f/2*t^2 + v0f*t;
elseif (strcmpi(behavior,"statfollower"))
    p0l = [1;1];
    v0l = [1;0];
    a0l = [0;0];
    r0l = 0;
    

    p0f = [0;0];
    v0f = [0;0];
    a0f = [0;0];
    r0f = 0;
    afinarr = [1;1];

    al = @(t) a0l;
    vl = @(t) v0l + a0l*t;
    pl = @(t) p0l + a0l/2*t^2 + v0l*t;
    yawl = @(t) 0;
    rl = @(t) 0;
    
    af = @(t) a0f;
    vf = @(t) v0f;
    pf = @(t) p0f;
    yawf = @(t) 0;
    rf = @(t) 0;
elseif (strcmpi(behavior,"parallelequal"))
    p0l = [1;1];
    v0l = [2;0];
    a0l = [0;0];
    r0l = 0;

    p0f = [0;0];
    v0f = [1;0];
    a0f = [0;0];
    r0f = 0;
    afinarr = [1;1];

    al = @(t) a0l;
    vl = @(t) v0l + a0l*t;
    pl = @(t) p0l + a0l/2*t^2 + v0l*t;
    af = @(t) a0f;
    vf = @(t) v0f + a0f * t;
    pf = @(t) p0f + a0f/2*t^2 + v0f*t;
elseif (strcmpi(behavior,"paralleldiff"))
    p0l = [1;1];
    v0l = [1;0];
    a0l = [0;0];
    r0l = 0;

    p0f = [0;0];
    v0f = [0;1];
    a0f = [0;0];
    r0f = 1;
    afinarr = [1;1];

    al = @(t) a0l;
    vl = @(t) v0l + a0l*t;
    pl = @(t) p0l + a0l/2*t^2 + v0l*t;
    af = @(t) a0f;
    vf = @(t) v0f + a0f * t;
    pf = @(t) p0f + a0f/2*t^2 + v0f*t;
elseif (strcmpi(behavior,"circlexy"))
    periodleader = 20; %s;
    wleader = 2*pi/periodleader; % [rad/s]
    radiusleader = 4;
    periodfollower = 20; % [s]
    wfollower = -2*pi/periodfollower;
    radiusfollower = 3;
    p0l = [4;0];
    v0l = [1;0];
    a0l = [0;0];
    r0l = 0;

    p0f = [0;0];
    v0f = [2;0];
    a0f = [0;0];
    r0f = 0;
    afinarr = [1;1];

    al = @(t) [-(wleader^2)*radiusleader*cos(wleader*t);-(wleader^2)*radiusleader*sin(wleader*t)];
    vl = @(t) [-wleader*radiusleader*sin(wleader*t);wleader*radiusleader*cos(wleader*t)];
    pl = @(t) [radiusleader*cos(wleader*t);radiusleader*sin(wleader*t)];
    rl = @(t) 0;
    yawl = @(t) 0;
    af = @(t) [(wfollower^2)*radiusfollower*sin(wfollower*t);-(wfollower^2)*radiusfollower*cos(wfollower*t)];
    vf = @(t) [-wfollower*radiusfollower*cos(wfollower*t);-wfollower*radiusfollower*sin(wfollower*t)];
    pf = @(t) [-radiusfollower*sin(wfollower*t);radiusfollower*cos(wfollower*t)];
    rf = @(t) 0;
    yawf = @(t) 0;
end


if (strcmpi(type,"acc"))
    kalmanmodel = "Kalman_no_heading3";
    kalmantype = "EKF";

    % obj.input = [u1dm;v1dm;u2dm;v2dm;r1m;r2m];
    noiseinp = [0;0;0;0;0.1;0.1];
    noiseinp = zeros(6,1);
    % obj.meas = [R;z1;z2;u1;v1;u2;v2]
    noisemeas = [rangenoise;0;0;0.2;0.2;0.2;0.2];
    noisemeas = zeros(7,1);
    % obj.state = [x12;y12;z1;z2;u1;v1;u2;v2;gam];
    x0 = [0.1;0.1;0;0;vf(0);vl(0);1];
    P0 = diag([2^2 2^2 1^2 1^2 1^2 1^2 1^2 1^2 1^2]);
elseif (strcmpi(type,"acchead"))
    kalmanmodel = "Kalman_heading3";
    kalmantype = "EKF";

    % obj.input = [u1dm;v1dm;u2dm;v2dm;r1m;r2m];
    noiseinp = [0;0;0;0;0.1;0.1];
    noiseinp = zeros(6,1);
    % obj.meas = [R;gam;z1;z2;u1;v1;u2;v2]
    noisemeas = [rangenoise;0;0;0;0.2;0.2;0.2;0.2];
    noisemeas = zeros(8,1);
    % obj.state = [x12;y12;z1;z2;u1;v1;u2;v2;gam];
    x0 = [0.1;0.1;0;0;vf(0);vl(0);1];
    P0 = diag([2^2 2^2 1^2 1^2 1^2 1^2 1^2 1^2 1^2]);
elseif (strcmpi(type,"noacc"))
    kalmanmodel = "Kalman_no_acc";
    kalmantype = "EKF";

    % obj.input = [u1;v1;u2;v2;r1m;r2m];
    noiseinp = [0.2;0.2;0.2;0.2;0.1;0.1];
    noiseinp = zeros(6,1);
    % obj.meas = [R;z1;z2]
    noisemeas = [rangenoise;0;0];
    noisemeas = zeros(3,1);
    
    % obj.state = [x12;y12;z1;z2;gam];    
    x0 = [0.1;0.1;0;0;0];
    P0 = diag([2^2 2^2 1^2 1^2 1^2]);    
end


dt = 1/kalmanfreq;
tarr = 0:dt:tend;
kalmant = 0;

tfoladd = 0.1; % [s];
wfoladd = 2*pi/tfoladd; % [rad/s]
Afoladd = 0.2*wfoladd; % [m/s^2]

plarr = zeros(2,length(tarr));
vlarr = zeros(2,length(tarr));
alarr = zeros(2,length(tarr));

pfarr = zeros(2,length(tarr));
vfarr = zeros(2,length(tarr));
afarr = zeros(2,length(tarr));


if (initpkalman)
   p = pl(0)-pf(0);
   yaw = yawl(0)-yawf(0);
   x0 = [p;0;0;vf(0);vl(0);yaw];
   P0 = eye(length(x0));      
end

Qin = noiseinp + 0.1;
Qin = diag(Qin);
Rin = noisemeas + 0.1;
Rin = diag(Rin);

km = KalmanClass(kalmanmodel,kalmantype,x0,P0,Qin,Rin);

kalmanarr = zeros(km.n,length(tarr));

index = 2;
kalmanarr(:,1) = x0;
plarr(:,1) = pl(0);
vlarr(:,1) = vl(0);
alarr(:,1) = al(0);

pfarr(:,1) = pf(0);
vfarr(:,1) = vf(0);
afarr(:,1) = af(0);

for t = tarr(1:end-1)
%     kalmanarr(:,index) = km.x_k_k;
    if(strcmpi(type,"acc"))
        % obj.input = [u1dm;v1dm;u2dm;v2dm;r1m;r2m];
        inputin = [af(t);al(t);0;0];
        %             inputin = [0;0;0;0;0;0];
        % obj.meas = [R;z1;z2;u1;v1;u2;v2]
        R = norm(pl(t)-pf(t));
        measurein = [R;0;0;vf(t);vl(t)];
    elseif(strcmpi(type,"acchead"))
        inputin = [af(t);al(t);0;0];
        R = norm(pl(t)-pf(t));
        measurein = [R;0;0;vf(t);vl(t);0];
    elseif (strcmpi(type,"noacc"))
        % obj.input = [u1;v1;u2;v2;r1m;r2m];
        inputin = [vf(t);vl(t);0;0];
        % obj.meas = [R;z1;z2]
        R = norm(pl(t)-pf(t));
        measurein = [R;0;0];
    end
    
    inputin = inputin + noiseinp.*randn(size(noiseinp));
    measurein = measurein + noisemeas.*randn(size(noisemeas));
%     measurein(1) = measurein(1) + rangenoise*randn();
    km.updateKalman(inputin,measurein,dt);

    kalmanarr(:,index) = km.x_kp1_kp1;    
    plarr(:,index) = pl(t);
    vlarr(:,index) = vl(t);
    alarr(:,index) = al(t);

    pfarr(:,index) = pf(t);
    vfarr(:,index) = vf(t);
    afarr(:,index) = af(t);

    index = index + 1;
end

prelreal = plarr-pfarr;
abserr = abs((plarr-pfarr)-kalmanarr(1:2,:));
abserrx = abserr(1,:);
abserry = abserr(2,:);
abserrtotal = sqrt(abserrx.^2+abserry.^2);
MAEx = mean(abserrx);
MAEy = mean(abserry);
MAEtotal = sqrt(MAEx^2+MAEy^2);
relvxmean = mean(abs(vlarr(1,:)-vfarr(1,:)));
relvymean = mean(abs(vlarr(2,:)-vfarr(2,:)));

fprintf("MAE x, y, total, final is: %f, %f %f %f\n",MAEx,MAEy,MAEtotal,abserrtotal(end));
fprintf("Relative vx, vy: %f, %f\n",relvxmean,relvymean);
fprintf("vx*ex, vy*ey: %f, %f\n",relvxmean*MAEx,relvymean*MAEy);

h = figure;
set(gca,'XTick',0:tticks:tend,'YTick',prange(1):pticks:prange(2),'FontSize', fontsize,'FontUnits','points','FontWeight','normal','FontName','Times');
hold on
grid on
plot(tarr,abserrtotal,'linewidth',linewidth);
axis([0 tend prange(1) prange(2)]);
xlabel('Time [s]','FontUnits','points','interpreter','latex','FontSize',fontsize,'FontName','Times');
ylabel('$||\mathbf{p}||_2$ error [m]','FontUnits','points','interpreter','latex','FontWeight','normal','FontSize',fontsize,'FontName','Times');
if(pzoom)
    ax2= MagInset(h,-1,pzoomarea,pzoomput,zoomlines);
    set(ax2,'FontSize',fontsize);
    set(ax2,'YTickLabel',[]);
    set(ax2,'XTickLabel',[]);
    % set(ax2,'XTick',pxticks2);
    % set(ax2,'YTick',pyticks2);
    grid(ax2,'on');
end

file = strcat('figures/',filename,'_p.eps');
if (printfigs)
    print(file,'-depsc2');
end

h = figure;
set(gca,'XTick',0:tticks:tend,'YTick',gamrange(1):gamticks:gamrange(2),'FontSize',fontsize,'FontUnits','points','FontWeight','normal','FontName','Times');
hold on
grid on
plot(tarr,abs(kalmanarr(9,:)),'linewidth',linewidth);
axis([0 tend gamrange(1) gamrange(2)]);
xlabel('Time [s]','FontUnits','points','interpreter','latex','FontSize',fontsize,'FontName','Times');
ylabel('$\Delta \psi$ error [rad]','FontUnits','points','interpreter','latex','FontWeight','normal','FontSize',fontsize,'FontName','Times');
if(gamzoom)
    ax2= MagInset(h,-1,gamzoomarea,gamzoomput,zoomlines);
    set(ax2,'FontSize',fontsize);
    set(ax2,'YTickLabel',[]);
    set(ax2,'XTickLabel',[]);
    % set(ax2,'XTick',pxticks2);
    % set(ax2,'YTick',pyticks2);
    grid(ax2,'on');
end

file = strcat('figures/',filename,'_gamma.eps');
if (printfigs)
    print(file,'-depsc2');
end

