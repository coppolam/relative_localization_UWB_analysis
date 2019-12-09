%Kalman_main function that performs the Kalman filtering on the data
% inputs:
%   ploton - boolean to indicate whether plots are desired
% outputs: Kalman filtered measurements

function [out] = Kalman_main(file)
% 
ploton = false;

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
    
    %%%%%---------------How to set up GAMMA manually---------%%%%%%%%
    
%     gamma = eye(7)*dt;
%     gamma(1,3) = -dt^2/2;
%     gamma(2,4) = -dt^2/2;
%     gamma(1,5) = dt^2/2;
%     gamma(2,6) = dt^2/2;
    
    
    P_kp1_k = phi*P_k_k*phi.' + gamma*Q*gamma.';
    P_kp1_k = phi*P_k_k*phi.' + Q;
    

    
    if kalmantype=="EKF"
        x_kp1_k_inp = num2cell(x_kp1_k);
        Hx = Hxsymf(x_kp1_k_inp{:});
        Ve = Hx*P_kp1_k*Hx'+R;
        K_kp1 = P_kp1_k*Hx'/Ve;
        z_kp1_k = hsymf(x_kp1_k_inp{:});
        x_kp1_kp1 = x_kp1_k + K_kp1 * (Z_k(i,:)'-z_kp1_k);
        
        
    elseif kalmantype=="IEKF"
        % do the iterative part
        eta2    = x_kp1_k;
        err     = 2*epsilon;
        
        itts    = 0;
        while (err > epsilon)
            if (itts >= maxIterations)
                %fprintf('Terminating IEKF: exceeded max iterations (%d)\n', maxIterations);
                break
            end
            itts    = itts + 1;
            eta1    = eta2;
            
            eta1_inp = num2cell(eta1);
            
            Hx = Hxsymf(eta1_inp{:});
            
            Ve = (Hx*P_kp1_k*Hx' + R);
            
            
            K_kp1 = (P_kp1_k*Hx.')/Ve;
            
            z_kp1 = Z_k(i,:)';
            z_kp1_k = hsymf(eta1_inp{:});
            
            eta2    = x_kp1_k + K_kp1 * (z_kp1 - z_kp1_k - Hx*(x_kp1_k - eta1));
            err     = norm((eta2 - eta1), inf) / norm(eta1, inf);
        end
        
        x_kp1_kp1 = eta2;
    end
    X_K(:,i) = x_kp1_kp1;
    

    
    P_kp1_kp1 = (eye(n) - K_kp1*Hx) * P_kp1_k * (eye(n) - K_kp1*Hx).' + K_kp1*R*K_kp1.';  
    P_K(:,i) = diag(P_kp1_kp1);
    stdx_cor = sqrt(diag(P_kp1_kp1));
    STDx_cor(:,i) = stdx_cor;
    
    x_kp1_kp1_inp = num2cell(x_kp1_kp1);
    z_kp1_kp1 = hsymf(x_kp1_kp1_inp{:});
    Z_K(:,i) = z_kp1_kp1;
    
    P_k_k = P_kp1_kp1;   
    x_k_k = x_kp1_kp1;
    i = i + 1;
end
innovation = Z_k'-Z_K;

if(size(X_K,1)==7)
    out = array2table(X_K','VariableNames',{'kal_x','kal_y','kal_vx','kal_vy','kal_oth_vx','kal_oth_vy','kal_rel_h'});
elseif (size(X_K,1)==8)
    out = array2table(X_K','VariableNames',{'kal_x','kal_y','kal_vx','kal_vy','kal_oth_vx','kal_oth_vy','kal_rel_h','kal_bias'});
end 

%obtain the desired information from the Kalman filter
% x_ka = X_K(1,:);
% y_ka = X_K(2,:);
% own_vx_ka = X_K(3,:);
% own_vy_ka = X_K(4,:);
% if size(X_K,1)>=8
%     B_ka = X_K(8,:);
% end
% rho_ka = sqrt(x_ka.^2+y_ka.^2+z_ka.^2);
% rho_real = sqrt((own_x-oth_x).^2+(own_y-oth_y).^2+(own_z-oth_z).^2);

% xerr = x_ka'-(own_x-oth_x);
% absxerr = abs(xerr);
% avgabsxerr = mean(absxerr);
% fprintf('x err: %f cm, x err std: %f cm\n',avgabsxerr*100,std(xerr)*100);
% 
% yerr = y_ka'-(own_y-oth_y);
% absyerr = abs(yerr);
% avgabsyerr = mean(absyerr);
% fprintf('y err: %f cm, y err std: %f cm\n',avgabsyerr*100,std(yerr)*100);
% 
% zerr = z_ka'-(own_z-oth_z);
% abszerr = abs(zerr);
% avgabszerr = mean(abszerr);
% fprintf('z err: %f cm, z err std: %f cm\n',avgabszerr*100,std(zerr)*100);
% 
% vxerr = vx_ka'-own_vx;
% absvxerr = abs(vxerr);
% avgabsvxerr = mean(absvxerr);
% fprintf('vx err: %f cm/s, vx err std: %f cm/s\n',avgabsvxerr*100,std(vxerr)*100);
% 
% vyerr = vy_ka'-own_vy;
% absvyerr = abs(vyerr);
% avgabsvyerr = mean(absvyerr);
% fprintf('vy err: %f cm/s, vy err std: %f cm/s\n',avgabsvyerr*100,std(vyerr)*100);


if (ploton==true)

%     figure;
%     hold on;
%     plot(time,relx);
%     plot(time,rel_x_kal);
%     plot(time,x_ka);
%     xlabel('time [s]');
%     ylabel('relative x [m]');
%     legend('true','on board kalman','off board kalman');
%     
%     figure;
%     hold on;
%     plot(time,rely);
%     plot(time,rel_y_kal);
%     plot(time,y_ka);
%     xlabel('time [s]');
%     ylabel('relative y [m]');
%     legend('true','on board kalman','off board kalman');
    

end
%end

