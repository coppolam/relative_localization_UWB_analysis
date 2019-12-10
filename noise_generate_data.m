%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% noise_generate_data.m
%
% This code runs EKF instances for different noise levels for both filters and reproduces the data seen in Table 1.
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

%% Load it all up

% Indicate typearr=1 for use of heading and typearr=2 for heading-free
typearr = 2;

behavior = 'circlexy'; % Trajectory
rangenoisearr = [0 0.1 0.25 0.5 1 2 4 8]; % Noise levels on range
yawnoisearr = 0.0;
psource = [4;0];
radeps =  1;
tcent = 5;
nruns = 10;

tticks = 0.5;
pticks = 0.5;
prange = [0,1.5];
fontsize = 25;
linewidth =  2.5;

storeres = zeros(length(typearr)*length(yawnoisearr),length(rangenoisearr));
storestd = zeros(length(typearr)*length(yawnoisearr),length(rangenoisearr));
indres = zeros(length(typearr)*length(yawnoisearr),length(rangenoisearr),nruns);
kalmanfreq = 20; % [Hz]

%% Run the tests
tic
typeindex = 1;
dyawarr = [];
for typen = typearr
    switch typen
        case 1
            type = 'acchead';
        case 2
            type = 'acc';
        case 3
            type = 'noacc';
    end
    
    yawindex = 1;
    for yawnoise = yawnoisearr
        rangeindex = 1;
        for rangenoise = rangenoisearr
            % obj.input = [u1dm;v1dm;u2dm;v2dm;r1m;r2m];
            % noiseinp = [0;0;0;0;0.1;0.1];
            noiseinp = zeros(6,1);
            % obj.meas = [R;z1;z2;u1;v1;u2;v2]
            % noisemeas = [rangenoise;0.2;0.2;1;1;1;1];
            noisemeas = [rangenoise;zeros(6,1)];
            if (strcmpi(type,'acchead'))
                % obj.meas = [R;gam;z1;z2;u1;v1;u2;v2]
                noisemeas = [noisemeas;0];
            elseif(strcmpi(type,'noacc'))
                % obj.input = [u1;v1;u2;v2;r1m;r2m];
                noiseinp = [noisemeas(4:7);noiseinp(5:6)];
                noisemeas = [rangenoise;noisemeas(2:3)];
            end
            
            initpkalman = true;
            tend = 20;
            
            if (strcmpi(behavior,"circlexy"))
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
            elseif (strcmpi(behavior,"circlexyyaw"))
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
                
                al = @(t) [-(wleader^2)*radiusleader;0];
                vl = @(t) [0;wleader*radiusleader];
                pl = @(t) [radiusleader*cos(wleader*t);radiusleader*sin(wleader*t)];
                rl = @(t) wleader;
                yawl = @(t) 0 + wleader*t;
                af = @(t) [-(wfollower^2)*radiusfollower;0];
                vf = @(t) [0;wfollower*radiusfollower];
                pf = @(t) [-radiusfollower*sin(wfollower*t);radiusfollower*cos(wfollower*t)];
                rf = @(t) wfollower;
                yawf = @(t) pi/2+wfollower*t;
            elseif (strcmpi(behavior,"parallel"))
                % Leader motion
                p0l = [0;0];
                v0l = [1;1];
                a0l = [0;0];
                r0l = 0;
                
                % Follower motion
                dheading = 0.1;
                p0f = [0;0];
                v0f = [cos(dheading) -sin(dheading); sin(dheading) cos(dheading)]*v0l;
                a0f = [0;0];
                r0f = 0;
                
                % Leader model
                al = @(t) a0l;
                vl = @(t) v0l + a0l * t;
                pl = @(t) p0l + a0l/2*t^2 + v0l*t;
                rl = @(t) 0; % yaw rate
                yawl = @(t) 0; % yaw
                
                % Follower model
                af = @(t) a0f;
                vf = @(t) v0f + a0f * t;
                pf = @(t) p0f + a0f/2*t^2 + v0f*t;
                rf = @(t) 0; % yaw rate
                yawf = @(t) 0; % yaw  
                
            end
            
            
            if (strcmpi(type,"acc"))
                kalmanmodel = "Kalman_no_heading3";
                kalmantype = "EKF";
                % obj.state = [x12;y12;z1;z2;u1;v1;u2;v2;gam];
                x0 = [0.1;0.1;0;0;v0f;v0l;1];
                P0 = diag([2^2 2^2 1^2 1^2 1^2 1^2 1^2 1^2 1^2]);
            elseif (strcmpi(type,"acchead"))
                kalmanmodel = "Kalman_heading3";
                kalmantype = "EKF";
                % obj.state = [x12;y12;z1;z2;u1;v1;u2;v2;gam];
                x0 = [0.1;0.1;0;0;v0f;v0l;1];
                P0 = diag([2^2 2^2 1^2 1^2 1^2 1^2 1^2 1^2 1^2]);
            elseif (strcmpi(type,"noacc"))
                kalmanmodel = "Kalman_no_acc";
                kalmantype = "EKF";
                % obj.state = [x12;y12;z1;z2;gam];
                x0 = [0.2;0.3;0;0;0];
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
                if (strcmpi(type,'noacc'))
                    x0 = [p;0;0;yaw];
                    P0 = eye(length(x0));
                end
                if(strcmpi(behavior,'circlexyyaw'))
                    REb = [cos(yawf(0)) -sin(yawf(0))
                        sin(yawf(0)) cos(yawf(0))];
                    x0(1:2) = REb.' * x0(1:2);
                end
            end
            
            Qin = noiseinp + 0.1;
            Qin = diag(Qin);
            Rin = noisemeas + 0.1;
            Rin = diag(Rin);
            km = KalmanClass(kalmanmodel,kalmantype,x0,P0,Qin,Rin);
            
            kalmanarr = zeros(km.n,length(tarr));
            kalmanrotarr = zeros(km.n,length(tarr));
            
            avgerr = zeros(1,nruns);
            
            
            
            for i = 1:nruns
                rng(i);
                index = 1;
                yawnoisereal = yawnoise * randn(size(tarr));
                rangenoisereal = rangenoise * randn(size(tarr));
                
                for t = tarr
                    
                    if(strcmpi(type,"acc"))
                        % obj.input = [u1dm;v1dm;u2dm;v2dm;r1m;r2m];
                        inputin = [af(t);al(t);rf(t);rl(t)];
                        % obj.meas = [R;z1;z2;u1;v1;u2;v2]
                        R = norm(pl(t)-pf(t));
                        R = R + rangenoisereal(index);
                        measurein = [R;0;0;vf(t);vl(t)];
                    elseif(strcmpi(type,"acchead"))
                        dyaw = yawl(t)-yawf(t);
                        inputin = [af(t);al(t);rf(t);rl(t)];
                        R = norm(pl(t)-pf(t));
                        R = R + rangenoisereal(index);
                        
                        rsourcel = norm(pl(t)-psource);
                        rsourcef = norm(pf(t)-psource);
%                         yawlt = 0 + yawamp/(rsourcel^2);
%                         yawft = 0 + yawamp/(rsourcef^2);
%                         yawlt = 0 + yawamp * exp((radeps*rsourcel)^2);
%                         yawft = 0 + yawamp * exp((radeps*rsourcef)^2);
%                         dyaw = yawlt-yawft;
                        dyaw = 0 + yawnoise * exp(-(radeps*(t-tcent))^2);
%                         dyaw = dyaw + yawnoisereal(index);
                        measurein = [R;0;0;vf(t);vl(t);dyaw];
                    elseif (strcmpi(type,"noacc"))
                        % obj.input = [u1;v1;u2;v2;r1m;r2m];
                        inputin = [vf(t);vl(t);rf(t);rl(t)];
                        % obj.meas = [R;z1;z2]
                        R = norm(pl(t)-pf(t));
                        R = R + rangenoisereal(index);
                        measurein = [R;0;0];
                    end
                    
                    km.updateKalman(inputin,measurein,dt);
                                       
                    plarr(:,index) = pl(t);
                    vlarr(:,index) = vl(t);
                    alarr(:,index) = al(t);
                    
                    pfarr(:,index) = pf(t);
                    vfarr(:,index) = vf(t);
                    afarr(:,index) = af(t);
                    
                    kalmanarr(:,index) = km.x_kp1_kp1;
                    
                    REb = [cos(yawf(t)) -sin(yawf(t))
                        sin(yawf(t)) cos(yawf(t))];
                    
                    kalmanrotarr(1:2,index) = REb*km.x_kp1_kp1(1:2);
                    
                    index = index + 1;
                end
                
                
                prelreal = plarr-pfarr;
                abserr = abs((plarr-pfarr)-kalmanrotarr(1:2,:));
                abserrx = abserr(1,:);
                abserry = abserr(2,:);
                abserrtotal = sqrt(abserrx.^2+abserry.^2);
                MAEx = mean(abserrx);
                MAEy = mean(abserry);
                MAEtotal = sqrt(MAEx^2+MAEy^2);
                avgerr(i) = MAEtotal;
                
            end
            
            fprintf("type %i, rangenoise %.2f, yawnoise %.2f, avg error is %f with std %f \n",typen,rangenoise,yawnoise,mean(avgerr), std(avgerr));
            
            indres  ((typeindex-1)*(length(yawnoisearr))+yawindex,rangeindex,:) = avgerr;
            storeres((typeindex-1)*(length(yawnoisearr))+yawindex,rangeindex)   = mean(avgerr);
            storestd((typeindex-1)*(length(yawnoisearr))+yawindex,rangeindex)   = std(avgerr);
            rangeindex = rangeindex + 1;
        end
        
        yawindex = yawindex + 1;
    end
    
    typeindex = typeindex+1;
end
toc

%% Save the data
% save('storeresmat','storeres','storestd');
% save('indresmat','indres');
