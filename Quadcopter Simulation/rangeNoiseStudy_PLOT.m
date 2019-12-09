clearvars;
clear all
close all

restoredefaultpath;
addpath('../Kalman');

compahead = true;

typearr       = [2];
rangenoise    = [0];      % [0 0.1 0.25 0.5 1 2 4 8];
angles        = [0:1/8*pi:2*pi]; % 0 parallel, pi/2 not parallel
rangenoise = 0;
scalearr      = [0:0.2:2];
nruns         = 10;
kalmanfreq    = 20; % [Hz]

% Plots
tticks = 0.5;
pticks = 0.5;
prange = [0,1.5];
fontsize = 25;
linewidth =  2.5;

% Store Matrices
storeres = zeros(length(typearr)*length(angles),length(scalearr));
storestd = zeros(length(typearr)*length(angles),length(scalearr));
indres   = zeros(length(typearr)*length(angles),length(scalearr),nruns);

tic
% Initialize
typeindex = 1;
dyawarr = [];
for typen = typearr
    switch typen
        case 1
            type = 'acchead';
        case 2
            type = 'acc';
    end
    
    headingindex = 1;
    for dheading = angles
        
        scaleindex = 1;
        for scale = scalearr
            % obj.input = [u1dm;v1dm;u2dm;v2dm;r1m;r2m];
            noiseinp = zeros(6,1);
            % obj.meas = [R;z1;z2;u1;v1;u2;v2]
            noisemeas = [rangenoise;zeros(6,1)];
            
            if (strcmpi(type,'acchead'))
                % obj.meas = [R;gam;z1;z2;u1;v1;u2;v2]
                noisemeas = [noisemeas;0];
            end
            initpkalman = true;
            tend = 20;
            
            %%%%%% Parallel Motion %%%%%%
            % Leader
            p0l = [1;1];
            v0l = [1;0];
            a0l = [0;0];
            r0l = 0;
            % Follower
            p0f = [0;0];
            Rot = [cos(dheading) -sin(dheading); sin(dheading) cos(dheading)];
            v0f = scale * Rot * v0l;
            a0f = [0;0];
            r0f = 0;
            
            % Leader/follower model
            al   = @(t) a0l;
            vl   = @(t) v0l + a0l * t;
            pl   = @(t) p0l + a0l/2*t^2 + v0l*t;
            af   = @(t) a0f;
            vf   = @(t) v0f + a0f * t;
            pf   = @(t) p0f + a0f/2*t^2 + v0f*t;
            
            if (strcmpi(type,"acc"))
                kalmanmodel = "Kalman_no_heading3";
                kalmantype = "EKF";
                % obj.input = [u1dm;v1dm;u2dm;v2dm;r1m;r2m];
                noiseinp = zeros(6,1);
                % obj.meas = [R;z1;z2;u1;v1;u2;v2]
                noisemeas = zeros(7,1);
                % obj.state = [x12;y12;z1;z2;u1;v1;u2;v2;gam];
                P0 = diag([2^2 2^2 1^2 1^2 1^2 1^2 1^2 1^2 1^2]);
            elseif (strcmpi(type,"acchead"))
                kalmanmodel = "Kalman_heading3";
                kalmantype = "EKF";
                % obj.input = [u1dm;v1dm;u2dm;v2dm;r1m;r2m];
                noiseinp = zeros(6,1);
                % obj.meas = [R;gam;z1;z2;u1;v1;u2;v2]
                noisemeas = zeros(8,1);
                % obj.state = [x12;y12;z1;z2;u1;v1;u2;v2;gam];
                P0 = diag([2^2 2^2 1^2 1^2 1^2 1^2 1^2 1^2 1^2]);
            end
            
            dt         = 1/kalmanfreq;
            tarr       = 0:dt:tend;
            kalmant    = 0;
            
            plarr = zeros(2,length(tarr));
            vlarr = zeros(2,length(tarr));
            alarr = zeros(2,length(tarr));
            
            pfarr = zeros(2,length(tarr));
            vfarr = zeros(2,length(tarr));
            afarr = zeros(2,length(tarr));
            avgerr = zeros(1,nruns);
            
            Qin = noiseinp + 0.1;
            Qin = diag(Qin);
            Rin = noisemeas + 0.1;
            Rin = diag(Rin);
            
            for i = 1:nruns
                p = pl(0)-pf(0);
                x0 = [0.1;0.1;0;0;vf(0);vl(0);0];
                km = KalmanClass(kalmanmodel,kalmantype,x0,P0,Qin,Rin);
                kalmanarr = zeros(km.n,length(tarr));
                rangenoisereal = rangenoise * randn(size(tarr));

                rng(i);
                index = 1;
                % run trial for each time step
                for t = tarr
                    %     kalmanarr(:,index) = km.x_k_k;
                    if(strcmpi(type,"acc"))
                        % obj.input = [u1dm;v1dm;u2dm;v2dm;r1m;r2m];
                        inputin = [af(t);al(t);0;0];
                        %             inputin = [0;0;0;0;0;0];
                        % obj.meas = [R;z1;z2;u1;v1;u2;v2]
                        R = norm(pl(t)-pf(t)) + rangenoisereal(index);
                        measurein = [R;0;0;vf(t);vl(t)];
                    elseif(strcmpi(type,"acchead"))
                        inputin = [af(t);al(t);0;0];
                        R = norm(pl(t)-pf(t));
                        measurein = [R;0;0;vf(t);vl(t);0];
                    end
                    
                    inputin = inputin + noiseinp.*randn(size(noiseinp));
                    measurein = measurein + noisemeas.*randn(size(noisemeas));
                    km.updateKalman(inputin,measurein,dt);
                    
                    kalmanarr(:,index) = km.x_kp1_kp1;
                    
                    % store
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
                avgerr(i) = abserrtotal(end);
%                 newfigure(1);
%                 grid on
%                 plot(tarr,abserrtotal,'linewidth',linewidth);
%                 xlabel('Time [s]','FontUnits','points','interpreter','latex','FontSize',fontsize,'FontName','Times');
%                 ylabel('$||\mathbf{p}||_2$ error [m]','FontUnits','points','interpreter','latex','FontWeight','normal','FontSize',fontsize,'FontName','Times');
%                 newfigure(2);
%                 plot(plarr(1,:),plarr(2,:),'k--'); hold on
%                 plot(pfarr(1,:),pfarr(2,:),'r--'); hold on
%                 plot(pfarr(1,:)+kalmanarr(1,:),pfarr(2,:)+kalmanarr(2,:),'g-')
%                 legend('Leader','Follower','Est.')
%                 axis equal
%                 grid on
%                 keyboard
            end
            
            fprintf("type %i, v_scale %.2f, angle %.2f, avg error is %f with std %f \n",typen,scale,rad2deg(dheading),mean(avgerr), std(avgerr));
            
            indres  ((typeindex-1)*(length(angles))+headingindex,scaleindex,:) = avgerr;
            storeres((typeindex-1)*(length(angles))+headingindex,scaleindex  ) = mean(avgerr);
            storestd((typeindex-1)*(length(angles))+headingindex,scaleindex  ) = std(avgerr);
            scaleindex = scaleindex + 1;
            
        end
        headingindex = headingindex + 1;
    end
    
    typeindex = typeindex+1;
end
toc
%%
close all
figure(1)
surf(scalearr,angles,storeres);
xlabel('Speed Scale')
ylabel('Relative Angle')
zlabel('Mean Error')

%% polar
figure(2)
[TH,R] = meshgrid(angles,scalearr);
[X,Y] = pol2cart(TH,R);
surf(X,Y,storeres');
axis on
axis image
grid on
%%
polarscatter(angles,headingindex,[],storeres)


% toc
% save('storeresmat','storeres','storestd');
% save('indresmat','indres');