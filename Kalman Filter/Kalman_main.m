%Kalman_main function that performs the Kalman filtering on the data
% inputs:
%   ploton - boolean to indicate whether plots are desired
% outputs: Kalman filtered measurements

clear all;
% function [alpha_true,beta_true,V_true,Cm,Z_K,X_K] = main(ploton)
% 
% if nargin<1
     ploton = true;
% end
addpath('C:\Users\Steven\Dropbox\Thesis\Data\Fly_Decawave\02-08-2017');
%addpath('/media/steven/Windows/Documents and Settings/Steven/Google Drive/Thesis/Data/Fly_Decawave/02-08-2017');

%% Running Kalman setup script containing all the flight data, state equations, etc.

Setup_Kalman;



%% Kalman filter

%Initialising matrices to store information
X_K = zeros(n,N); %Kalman filtered state
X_K(:,1) = x_k_k;
P_K = zeros(n,N); %State estimation covariance
P_K(:,1) = diag(P_k_k);
Z_K = zeros(size(Z_k,2),N); %Kalman filter outputs
STDx_cor = zeros(n, N); %Standard deviation in state estimation after Kalman filter

i=1;
while i<=N
    if i<N
        dt = time(i+1)-time(i);
    else
        dt = 0.1;
    end
    x_k_k_inp = num2cell(x_k_k);
    
    x_kp1_k = x_k_k + fsymf(x_k_k_inp{:})*dt;
    
    Fx = Fxsymf(x_k_k_inp{:});
    
    
    % the continuous to discrete time transformation of Df(x,u,t)
    [phi, gamma] = c2d(Fx, G, dt);  
    P_kp1_k = phi*P_k_k*phi.' + gamma*Q*gamma.';
    
    % do the iterative part
    eta2    = x_kp1_k;
    err     = 2*epsilon;
    
    itts    = 0;
    while (err > epsilon)
        if (itts >= maxIterations)
            fprintf('Terminating IEKF: exceeded max iterations (%d)\n', maxIterations);
            break
        end
        itts    = itts + 1;
        eta1    = eta2;
        
        eta1_inp = num2cell(eta1);
        
        Hx = Hxsymf(eta1_inp{:});    

        Ve = (Hx*P_kp1_k*Hx' + R);
        

        K_kp1 = (P_kp1_k*Hx.')/Ve;

        z_kp1 = Z_k(i,:)';
        z_kp1_k = Zsymf(eta1_inp{:});
        
        eta2    = x_kp1_k + K_kp1 * (z_kp1 - z_kp1_k - Hx*(x_kp1_k - eta1));
        err     = norm((eta2 - eta1), inf) / norm(eta1, inf);
    end
    

    x_kp1_kp1 = eta2;
    X_K(:,i) = x_kp1_kp1;
    

    
    P_kp1_kp1 = (eye(n) - K_kp1*Hx) * P_kp1_k * (eye(n) - K_kp1*Hx).' + K_kp1*R*K_kp1.';  
    P_K(:,i) = diag(P_kp1_kp1);
    stdx_cor = sqrt(diag(P_kp1_kp1));
    STDx_cor(:,i) = stdx_cor;
    
    x_kp1_kp1_inp = num2cell(x_kp1_kp1);
    z_kp1_kp1 = Zsymf(x_kp1_kp1_inp{:});
    Z_K(:,i) = z_kp1_kp1;
    
    P_k_k = P_kp1_kp1;   
    x_k_k = x_kp1_kp1;
    i = i + 1;
end
innovation = Z_k'-Z_K;
%obtain the desired information from the Kalman filter
x_ka = X_K(1,:);
y_ka = X_K(2,:);
z_ka = X_K(3,:);
vx_ka = X_K(4,:);
vy_ka = X_K(5,:);
if size(X_K,1)>=6
    B_ka = X_K(6,:);
end
rho_ka = sqrt(x_ka.^2+y_ka.^2+z_ka.^2);
rho_real = sqrt((x-x_b).^2+(y-y_b).^2+(z-z_b).^2);

xerr = x_ka'-(x-x_b);
absxerr = abs(xerr);
avgabsxerr = mean(absxerr);
fprintf('x err: %f cm, x err std: %f cm\n',avgabsxerr*100,std(xerr)*100);

yerr = y_ka'-(y-y_b);
absyerr = abs(yerr);
avgabsyerr = mean(absyerr);
fprintf('y err: %f cm, y err std: %f cm\n',avgabsyerr*100,std(yerr)*100);

zerr = z_ka'-(z-z_b);
abszerr = abs(zerr);
avgabszerr = mean(abszerr);
fprintf('z err: %f cm, z err std: %f cm\n',avgabszerr*100,std(zerr)*100);

vxerr = vx_ka'-vx;
absvxerr = abs(vxerr);
avgabsvxerr = mean(absvxerr);
fprintf('vx err: %f cm/s, vx err std: %f cm/s\n',avgabsvxerr*100,std(vxerr)*100);

vyerr = vy_ka'-vy;
absvyerr = abs(vyerr);
avgabsvyerr = mean(absvyerr);
fprintf('vy err: %f cm/s, vy err std: %f cm/s\n',avgabsvyerr*100,std(vyerr)*100);


if (ploton==true)

    
    % rho_comp = sqrt(x_ka.^2+y_ka.^2)+B_ka;
    %rho_ka_noB = rho_ka-B_ka;

    figure;
    hold on;
    plot(time,rho_real);
    plot(time,range_m);
    plot(time,rho_ka);
    legend('real range','measured range','Kalman range');
    xlabel('time [s]');
    ylabel('Range [m]');
    
    figure
    hold on
    grid on
    plot(time,x-x_b);
    plot(time,x_ka);
    legend('Real x','Kalman x','location','northwest');
    xlabel('time [s]');
    ylabel('x distance [m]');
    
    figure
    hold on
    grid on
    plot(time,y-y_b);
    plot(time,y_ka);
    legend('Real y','Kalman y','location','northwest');
    xlabel('time [s]');
    ylabel('y distance [m]');
    
    
    figure
    hold on
    grid on
    plot(time,Z_store(:,2));
    plot(time,Z_k(:,2));
    plot(time,z_ka);
    legend('real z','measured z','Kalman z');
    xlabel('t [s]');
    ylabel('height [m]');
    
    figure
    hold on
    grid on
    plot(time,Z_store(:,3));
    plot(time,Z_k(:,3));
    plot(time,vx_ka);
    legend('real vx','measured vx','Kalman vx');
    xlabel('t [s]');
    ylabel('vx [m/s]');
    
    figure
    hold on
    grid on
    plot(time,Z_store(:,4));
    plot(time,Z_k(:,4));
    plot(time,vy_ka);
    legend('real vy','measured vy','Kalman vy');
    xlabel('t [s]');
    ylabel('vy [m/s]');
    
    figure
    hold on
    grid on
    plot(x-x_b,y-y_b);
%     plot(x_ka,y_ka);
plot(0,0,'*');
    axis square
    %legend('Real trajectory','Kalman trajectory');
    legend('Drone trajectory','Beacon');
    xlabel('x distance [m]');
    ylabel('y distance [m]');
    
    figure;
    hold on;
    subplot(2,4,[1 2 5 6]);
    grid on;
    hold on
    plot(x-x_b,y-y_b);
    plot(x_ka,y_ka);
    legend('Real trajectory','Kalman trajectory');
    xlabel('x distance [m]');
    ylabel('y distance [m]');
    
    subplot(2,4,3);
    hold on
    grid on;
    plot(time,Z_store(:,3));
    plot(time,Z_k(:,3));
    plot(time,vx_ka);
    legend('real','measured','Kalman estimate');
    xlabel('t [s]');
    ylabel('vx [m/s]');
    
    subplot(2,4,4);
    hold on;
    grid on;
    plot(time,Z_store(:,4));
    plot(time,Z_k(:,4));
    plot(time,vy_ka);
    legend('real','measured','Kalman estimate');
    xlabel('t [s]');
    ylabel('vy [m/s]');
    
    subplot(2,4,7);
    hold on;
    grid on;
    plot(time,Z_store(:,2));
    plot(time,Z_k(:,2));
    plot(time,z_ka);
    legend('real','measured','Kalman estimate');
    xlabel('t [s]');
    ylabel('height [m]');
    
    subplot(2,4,8);
    hold on;
    grid on;
    plot(time,rho_real);
    plot(time,range_m);
    plot(time,rho_ka);
    legend('real','measured','Kalman estimate');
    xlabel('time [s]');
    ylabel('Range [m]');
    
    
    
%     figure
%     hold on
%     plot(time,B_ka);
%     
    
    

end
%end

