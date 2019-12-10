%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% observability_simulator.m
%
% This code reproduces the simulation results used to empirically evaluate the observability conditions.
%
% The code was used in the paper:
%
% "On-board range-based relative localization for micro air vehicles in indoor leader–follower flight". 
% 
% Steven van der Helm, Mario Coppola, Kimberly N. McGuire, Guido C. H. E. de Croon.
% Autonomous Robots, March 2019, pp 1-27.
% The paper is available open-access at this link: https://link.springer.com/article/10.1007/s10514-019-09843-6
% Or use the following link for a PDF: https://link.springer.com/content/pdf/10.1007%2Fs10514-019-09843-6.pdf
% 
% Code written by Steven van der Helm and edited by Mario Coppola
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Initialize
init;
rng(5);

%% Select experiment type as per the paper
% Fig 5 = static_leader + heading
% Fig 6 = static_leader + no_heading
% Fig 7 = static_follower + heading
% Fig 8 = static_follower + no_heading
% Fig 9 = parallel_different_speeds  + heading
% Fig 10 = parallel_different_speeds + no_heading

% mode = figure number to replicate
mode = 5; 

if mode == 5
    behavior = 'static_leader';
    type = 'heading';
elseif mode == 6
    behavior = 'static_leader';
    type = 'no_heading';
elseif mode == 7
    behavior = 'static_follower';
    type = 'heading';
elseif mode == 8
    behavior = 'static_follower';
    type = 'no_heading';
elseif mode == 9
    behavior = 'parallel_different_speeds';
    type = 'heading';
    
elseif mode == 10
    behavior = 'parallel_different_speeds';
    type = 'no_heading';
    
end

    
%% Other parameters
filename = strcat(behavior,'_',type);
rangenoise = 0.1; % [m]
kalmanfreq = 50; % [Hz]
printfigs = true;

%% Behavior properties
if (strcmpi(behavior,"static_leader"))
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
    vf = @(t) v0f + a0f*t;
    pf = @(t) p0f + a0f/2*t^2 + v0f*t;
elseif (strcmpi(behavior,"static_follower"))
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
    af = @(t) a0f;
    vf = @(t) v0f;
    pf = @(t) p0f;
elseif (strcmpi(behavior,"parallel_different_speeds"))
    p0l = [1;1];
    v0l = [1;0];
    a0l = [0;0];
    r0l = 0;
    
    p0f = [0;0];
    v0f = [2;0];
    a0f = [0;0];
    r0f = 1;
    afinarr = [1;1];
    
    al = @(t) a0l;
    vl = @(t) v0l + a0l*t;
    pl = @(t) p0l + a0l/2*t^2 + v0l*t;
    af = @(t) a0f;
    vf = @(t) v0f + a0f * t;
    pf = @(t) p0f + a0f/2*t^2 + v0f*t;
end

%% Kalman filter type
kalmantype = "EKF";
if (strcmpi(type,"heading"))
    kalmanmodel = "Kalman_heading3";
    noiseinp  = zeros(6,1); % obj.input = [u1dm;v1dm;u2dm;v2dm;r1m;r2m];
    noisemeas = zeros(8,1); % obj.meas = [R;gam;z1;z2;u1;v1;u2;v2]
    x0 = [0.1;0.1;0;0;vf(0);vl(0);1]; % obj.state = [x12;y12;z1;z2;u1;v1;u2;v2;gam];
    P0 = diag([2^2 2^2 1^2 1^2 1^2 1^2 1^2 1^2 1^2]);
elseif (strcmpi(type,"no_heading"))
    kalmanmodel = "Kalman_no_heading3";
    noiseinp  = zeros(6,1); % obj.input = [u1dm;v1dm;u2dm;v2dm;r1m;r2m];
    noisemeas = zeros(7,1); % obj.meas = [R;z1;z2;u1;v1;u2;v2]
    x0 = [0.1;0.1;0;0;vf(0);vl(0);1]; % obj.state = [x12;y12;z1;z2;u1;v1;u2;v2;gam];
    P0 = diag([2^2 2^2 1^2 1^2 1^2 1^2 1^2 1^2 1^2]);
end

%% Plotting properties
fontsize  = 25;
linewidth = 2.5;
gamticks  = 0.5;
zoomlines = {'SE','SE'; 'NW','NW'};
pxticks2 = [0,0.2];
pyticks2 = [0,1.5];

if (strcmpi(behavior,'static_follower') && strcmpi(type,'heading'))
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
elseif (strcmpi(behavior,'static_follower') && strcmpi(type,'no_heading'))
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
elseif (strcmpi(behavior,'static_leader') && strcmpi(type,'heading'))
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
elseif (strcmpi(behavior,'static_leader') && strcmpi(type,'no_heading'))
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
elseif (strcmpi(behavior,'parallel_different_speeds') && strcmpi(type,'heading'))
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
elseif (strcmpi(behavior,'parallel_different_speeds') && strcmpi(type,'no_heading'))
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
    
end

%% EKF properties

dt = 1/kalmanfreq;
tarr = 0:dt:tend;
kalmant = 0;

tfoladd = 0.1; % [s];
wfoladd = 2 * pi/tfoladd; % [rad/s]
Afoladd = 0.2 * wfoladd; % [m/s^2]

plarr = zeros(2,length(tarr));
vlarr = zeros(2,length(tarr));
alarr = zeros(2,length(tarr));

pfarr = zeros(2,length(tarr));
vfarr = zeros(2,length(tarr));
afarr = zeros(2,length(tarr));

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

%% Run the Kalman filter
for t = tarr(1:end-1)
    
    if(strcmpi(type,"no_heading"))
        inputin = [af(t);al(t);0;0];
        R = norm(pl(t)-pf(t));
        measurein = [R;0;0;vf(t);vl(t)]; % obj.meas = [R;z1;z2;u1;v1;u2;v2]
    elseif(strcmpi(type,"heading"))
        inputin = [af(t);al(t);0;0];
        R = norm(pl(t)-pf(t));
        measurein = [R;0;0;vf(t);vl(t);0]; % obj.meas = [R;z1;z2;u1;v1;u2;v2;gam]
    end
    
    inputin = inputin + noiseinp.*randn(size(noiseinp));
    measurein = measurein + noisemeas.*randn(size(noisemeas));
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

%% Plot

% Localization error
h = figure;
set(gca,'XTick',0:tticks:tend,'YTick',prange(1):pticks:prange(2),'FontSize', fontsize,'FontUnits','points','FontWeight','normal','FontName','Times');
hold on
grid on
plot(tarr,abserrtotal,'linewidth',linewidth);
axis([0 tend prange(1) prange(2)]);
xlabel('Time [s]','FontUnits','points','interpreter','latex','FontSize',fontsize,'FontName','Times');
ylabel('$||\mathbf{p}||_2$ error [m]','FontUnits','points','interpreter','latex','FontWeight','normal','FontSize',fontsize,'FontName','Times');
if pzoom
    ax2= MagInset(h,-1,pzoomarea,pzoomput,zoomlines);
    set(ax2,'FontSize',fontsize);
    set(ax2,'YTickLabel',[]);
    set(ax2,'XTickLabel',[]);
    grid(ax2,'on');
end

file = strcat('figures/',filename,'_p.eps');
if (printfigs)
    print(file,'-depsc2');
end

% Yaw estimate error
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
    grid(ax2,'on');
end

file = strcat('figures/',filename,'_gamma.eps');
if (printfigs)
    print(file,'-depsc2');
end
