%inputs: [range, ownvx, ownvy, ownh, trackvx, trackvy, trackh, dt
%Z_k:( range, ownvx, ownvy, othvx, othvy, z_rel)

Setup_Kalman;
kalmantype = "EKF";
input = [2.7 0 1 1 0 0 1 0.8;
    2.7 1 1 1 0 0 1 0.3;
     2.9 1.5 1 1 0 0 1 0.2;
     3.1 0.5 1 1 0 0 1 15];

Z_k = horzcat(input(:,1),input(:,2),input(:,3),input(:,5),input(:,6),input(:,7)-input(:,4));
dtlist = input(:,end);
N = size(input,1);

i=1;
while i<=N
        
    fprintf("State is: \n");
    x_k_k'
    fprintf("Input is: ");
    Z_k(i,:)
    dt = dtlist(i);
    x_k_k_inp = num2cell(x_k_k);
    
    x_kp1_k = x_k_k + fsymf(x_k_k_inp{:})*dt;
    
    Fx = Fxsymf(x_k_k_inp{:});
    
    
    % the continuous to discrete time transformation of Df(x,u,t)
    [phi, gamma] = c2d(Fx, G, dt) 

    %P_kp1_k = phi*P_k_k*phi.' + gamma*Q*gamma.';
    P_kp1_k = phi*P_k_k*phi.' + Q;
    
    if kalmantype=="EKF"
        x_kp1_k_inp = num2cell(x_kp1_k);
        Hx = Hxsymf(x_kp1_k_inp{:});
        Ve = Hx*P_kp1_k*Hx'+R;
        K_kp1 = P_kp1_k*Hx'/Ve;
        z_kp1_k = Zsymf(x_kp1_k_inp{:});
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
            z_kp1_k = Zsymf(eta1_inp{:});
            
            eta2    = x_kp1_k + K_kp1 * (z_kp1 - z_kp1_k - Hx*(x_kp1_k - eta1));
            err     = norm((eta2 - eta1), inf) / norm(eta1, inf);
        end
        
        x_kp1_kp1 = eta2;
    end


    
    P_kp1_kp1 = (eye(n) - K_kp1*Hx) * P_kp1_k * (eye(n) - K_kp1*Hx).' + K_kp1*R*K_kp1.';  
    stdx_cor = sqrt(diag(P_kp1_kp1));
    
    x_kp1_kp1_inp = num2cell(x_kp1_kp1);
    z_kp1_kp1 = Zsymf(x_kp1_kp1_inp{:});

    P_k_k = P_kp1_kp1;   
    x_k_k = x_kp1_kp1;
    i = i + 1;
end