cd /home/mario/thesis/ModelIdentification
addpath (genpath(pwd));
addpath ../Simulation
addpath ../AuxiliaryFunctions

SetupStuff;
%%
clear
% Define main script parameters. Refer to README for description.
day = 'day3'; set = 'log1';
estimator   = 'ekf';    % Options: 'ekf', 'ukf'
estimatePn  = 0;        % 1 = Use online Pn estimator, 0 = Don't
filter      = 'RSSIinput_3D_simple'; % Type of filter to use
runs        = 50;        % # of runs (fictitious noise is added every time)

% Other parameters
npl               = 8;  % Number of plots of states (2 -> x and y)
printfigures      = 0;  % 0 = Do not save figures as eps, 1 = Save them!
showfigures       = 0;  % 0 = Hide all figures, 1 = Show figures
initialstateknown = 0;  % 0: Initial state unknown, 1 = Initial state known
filterSize        = []; % Moving average filter size, use [] for no filter
ranitalready      = 0;

noise       = [0 0.2 0.2]; % StDev: [noise_rssi noise_velocity noise_heading]
q           = 0.5;         % Standard deviation of process
r           = 0.2;         % Standard deviation of measurement

k_qadapt    = 1;
k_pnadapt   = 1;
% Qbounds     = [0.1 5];
Q11         = 0.01;
Q22         = 0.01;
R11         = 5^2;
dtguess     = 0.2;

load(['logs/',day,'/',set]);

cropday3results;        % Crops the data from day 3
time = time - time(1);  % Adjust time vector to start at 0

% Estimate reference log-distance function parameters
Pld = EstimateLogDist(RSSI, dist);
%%
%%%%% THE MEASUREMENTS OF VELOCITIES FROM THE OPTITRACK ARE IN
%%%%% THE GLOBAL FRAME OF REFERENCE, SO THERE IS NO PSI.. it's set to 0!!!!
clear P_store Rstore Pnstore gammalstore A_store H_store ...
    Pmod Pn gamma_l Q0 R0 P0 Q R P xvec zvec f h xV zV sV

zv = zeros(size(time));

% Set up state vectors
stantenna = [time, zv, zv, zv, zv, zv, zv];
stother   = [time, posx, posy, vx, vy, zv, posz];

[ x0, ~, ~, Pmod0, xvec, zvec ] = ...
    setupLocalizationParameters(filter, stantenna, stother, initialstateknown, noise, dtguess);

% Set-up some other basic stuff
N    = length(time);            % Total time steps in simulation
sV   = xvec';                   % Actual

[P0,Q0,R0] = setupPQRmatrices(xvec, zvec, q, r);

% Amend Q an R where needed
Q0(1,1) = Q11;  % We should trust the process in x. A low Q0(1,1) is good.
Q0(2,2) = Q22;  % We should trust the process in y. A low Q0(2,2) is good.
R0(1,1) = R11;  % We don't trust the RSSI range measurement.

% Initialize a bunch of values
[xV] = zeros(size(xvec,2),N); % Estimate
[zV] = zeros(size(zvec,2),N); % Measurement
[dist_estimate_store, bearing_estimate_store, xji_store, yji_store, zji_store] = startempty([runs,N]);
[Rstore, Qstore, Pnstore, gammalstore, convergence]    = startempty([N,runs]);
[P_store, A_store] = startempty([size(xvec,2),size(xvec,2),N,runs]);
H_store            = zeros(size(zvec,2),size(xvec,2),N,runs);
diverged           = 0;

for ii = 1:runs
    
    dt = 0.2;
    
    [ x0, f, h, Pmod, xvec, zvec ] = ...
        setupLocalizationParameters(filter, stantenna, stother, initialstateknown, noise, dtguess);
    Pmod = makevertical(Pmod);
    zvec(:,1) = RSSI;
    P = P0; Q = Q0; R = R0; x = x0;
    Pmod0 = Pmod; Pn = Pmod0(1); gamma_l = Pmod0(2);
    disp(['Initial state: ', num2str(x)'])
                
    % Run estimator on all measurements
    for k = 1:N
        
        % Estimate dt (delta in time) based on all past values
        if k > 1
            dt = abs(time(k)-time(k-1));
        end
        
        [x, z] = makevertical(x, zvec(k,:));
        [x, P] = feval(estimator, f, x, P, h, z, Q, R, dt);
        
        % Store in standard format for later
        [xV(:,k), zV(:,k)] = makevertical(x,z);
 
        destvec     = mag([xV(1,1:k); xV(2,1:k); xV(9,1:k)], 'col');
        bearing_est = wrapToPi( atan2(xV(2,1:k), xV(1,1:k)) );
        
        % Estimate parameters
      
    end
    
    xstore{ii} = xV;
    % Store variables of the run
    xji_store(ii,:) = xV(1,:);
    yji_store(ii,:) = xV(2,:);
    
    if size(sV,1) > 8
        zji_store(ii,:)  = xV(9,:);
    end
    
    exr     = xV(1,:) - sV(1,:);
    eyr     = xV(2,:) - sV(2,:);
    ezr     = xV(9,:) - sV(9,:);
    
    emagr   = mag([exr, eyr, ezr], 'row');

    dist_estimate_store(ii,:) = destvec;
    bearing_estimate_store(ii,:) = bearing_est;
    
    % Verification tools to check for more obvious bugs
    check_mag(destvec,'<=',dist+emagr);
    check_nonan(P_store, destvec);
    
    % Print main outcomes of the iteration
    
    printoutputs;
    
end


dist_estimate_mean = mean(dist_estimate_store,1);
bearing_estimate_mean = mean(bearing_estimate_store,1);
meanx = mean(xji_store,1);
meany = mean(yji_store,1);
meanz = mean(zji_store,1);

statestore = [meanx; meany; meanz];

ex    = makevertical(meanx) - makevertical(sV(1,:));
ey    = makevertical(meany) - makevertical(sV(2,:));

if size(sV,1) > 8
    ez = makevertical(meanz) - makevertical(sV(9,:));
end

emag = mag([ex, ey, ez], 'row');

% Verification tools
check_mag (emag,'>',ex,ey,ez)
check_samesize(makevertical(meanx),makevertical(sV(1,:)))
check_samesize(makevertical(meany),makevertical(sV(2,:)))
check_samesize(makevertical(meanz),makevertical(sV(9,:)))
check_samesize(emag,ez)
%%
% Error Analysis -- Correlation with distance and bearing

plotevolutions; % Will only work if estimatePn = 1
% plotRQevolution;
% plottopview;   % Only for last run, as example
plotstates;     % Only for last run, as example
% plotmodel;      % Plots the estimated model vs. the reference model vs. data
ploterror;      % Plots the error over distance


%%
% printallfigureslatex(get(0,'Children'), 'Figures/','paper_ultrawide_half',[451,452, 499 ,449])
%% Calculate the standard deviation around the slope line
% This is scaled by the distance so that it is distance independent!

[~, vari_rxV ] = leastsquarefit(dist_estimate_mean , emag./dist_estimate_mean');
[~, vari_dist] = leastsquarefit(dist , emag./dist);

box     = 0.1;
spread  = -3:box:3;

vari_rxV_hist  = hist(vari_rxV,spread);
vari_dist_hist = hist(vari_dist,spread);

[mu_rxV,  sigma_rxV]  = GetDistributionParameters('normal',vari_rxV);
[mu_dist, sigma_dist] = GetDistributionParameters('normal',vari_dist);

count = newfigure(count,'add',['histfit_',estimator,'_avgover',num2str(runs),'runs_',day,set,est]);
stem(spread,vari_rxV_hist/length(spread),'r.'); hold on
stem(spread,vari_dist_hist/length(spread),'b.')
plot(spread, pdf('normal', spread, mu_dist, sigma_dist),'b--','LineWidth',2)
plot(spread, pdf('normal', spread, mu_rxV, sigma_rxV),'r--','LineWidth',2)
xlabel('Error about slope [m]')
ylabel('Probability Density [-]')
legend( 'Histogram Real Error','Histogram Estimated Error',...
    ['Real Error Fit (\mu = ', num2str(mu_rxV,2), ', \sigma = ', num2str(sigma_rxV,2),')'],...
    ['Estimated Error Fit (\mu = ', num2str(mu_dist,2), ', \sigma = ', num2str(sigma_dist,2),')'])

%% Analyze the correlation between P matrix and error

exl = makevertical(xji_store(1,:)) - makevertical(sV(1,:));
eyl = makevertical(yji_store(1,:)) - makevertical(sV(2,:));

count = newfigure(count,'add',['Pmatx_',estimator,'_',day,set]);
plot(time,exl);
hold on
plot(time,reshape(P_store(1,1,:,1),N,1));
plot(time,emag)
legend('ex','Px')
xlabel('Time [s]')
ylabel('Error [m]')
hold off

count = newfigure(count,'add',['Pmaty_',estimator,'_',day,set]);
plot(time,eyl);
hold on
plot(time,reshape(P_store(2,2,:,1),N,1));
plot(time,emag)
legend('ey','Py')
xlabel('Time [s]')
ylabel('Error [m]')
hold off

%% Check Distribution1
% 
% close all
tt = logdistdB(Pmod(1),Pmod(2),dist);
ttexact = logdistdB(Pld(1),Pld(2),dist);

at = RSSI;
err = tt - at;
errexact = ttexact - at;
hist(err)

%%
% close all
figure
[mean1, sigma1] = GetDistributionParameters('normal',err);
[mean2, sigma2] = GetDistributionParameters('normal',errexact);
plot(sort(randn(size(err))*sigma1),sort(err)-mean1, 'b.')
hold on
plot(sort(randn(size(errexact))*sigma2), sort(errexact)-mean2, 'r.')

xlabel('(Sorted) Normally Distributed values')
ylabel('(Sorted) Error values')
plot([-20 20],[-20 20],'k--')
hold off

xlim([-10 10])
ylim([-10 10])