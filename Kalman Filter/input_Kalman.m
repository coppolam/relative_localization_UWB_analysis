inputtype = "Kalman_B"   ;

input = [];

if inputtype=="Kalman"
     %% Symbolic equations to change!
    
    %Symbolic representation of state vector
    syms x_db y_db z_db vx_db vy_db
    state = [x_db;y_db;z_db;vx_db;vy_db];
    
    %State transition function
    fsym = [vx_db;vy_db;0;0;0];
    
    %Observation equation. We are observing range, z, vx, vy
    Zsym = [sqrt(x_db^2 + y_db^2+z_db^2);z_db;vx_db;vy_db];
    
    %% Initialisations
    Bias = range_m-sqrt((x-x_b).^2+(y-y_b).^2+(z-z_b).^2);
    B_0 = 0.08;
    %initial guess of initial state [x_db, y_db, vx_db, vy_db]
    x_0 = [x(1)-x_b;y(1)-y_b;z(1)-z_b;vx(1);vy(1)];
    n = size(x_0,1);
    
    %initial guess of the state estimation covariance
    P_0 = diag([0.2^2 0.2^2 0.4^2 0.2^2 0.2^2]);
    
    %setting up measurement input matrix
    Z_k = horzcat(range_m,z-z_b,vx,vy);
    Z_store = Z_k;
    
    % Artificially adding noise to the inputs of velocity
    sig_vxadd = 0.2; % [m/s]
    sig_vyadd = sig_vxadd; % [m/s]
    sig_zadd = 0.1; % [m] 
    Z_k = alterNoise(Z_k,[2,3,4],[sig_zadd,sig_vxadd,sig_vyadd]);
    
    %Initialising noise matrices
    %Q is the process noise matrix (x,y,z,vx,vy)
    %R is the measurement noise matrix (rho,z,vx,vy)
    %G is noise input matrix
    Q = diag([(1e-1)^2 (1e-1)^2 (3e-1)^2 (3e-1)^2 (3e-1)^2]);
    sig_rho = 0.4;
    sig_z = 0.1 + sig_zadd;
    sig_vxdb = 0.05 + sig_vxadd;
    sig_vydb = 0.05 + sig_vyadd;
    R = diag([sig_rho^2 sig_z^2 sig_vxdb^2 sig_vydb^2]);
    G = eye(n);
    
elseif inputtype=="Kalman_B"
    %% Symbolic equations to change!
    
    %Symbolic representation of state vector
    syms x_db y_db z_db vx_db vy_db B
    state = [x_db;y_db;z_db;vx_db;vy_db;B];
    
    %State transition function
    fsym = [vx_db;vy_db;0;0;0;0];
    
    %Observation equation. We are observing range, z, vx, vy
    Zsym = [sqrt(x_db^2 + y_db^2+z_db^2)+B;z_db;vx_db;vy_db];
    
    %% Initialisations
    Bias = range_m-sqrt((x-x_b).^2+(y-y_b).^2+(z-z_b).^2);
    B_0 = 0.1;
    %initial guess of initial state [x_db, y_db, vx_db, vy_db B_0]
    x_0 = [x(1)-x_b;y(1)-y_b;z(1)-z_b;vx(1);vy(1);B_0];
    n = size(x_0,1);
    
    %initial guess of the state estimation covariance
    P_0 = diag([0.05^2 0.05^2 0.05^2 0.05^2 0.05^2 0.1^2]);
    
    %setting up measurement input matrix
    Z_k = horzcat(range_m,z-z_b,vx,vy);
    Z_store = Z_k;
    
    % Artificially adding noise to the inputs of velocity
    sig_vxadd = 0.2; % [m/s]
    sig_vyadd = sig_vxadd; % [m/s]
    sig_zadd = 0.1; % [m] 
    Z_k = alterNoise(Z_k,[2,3,4],[sig_zadd,sig_vxadd,sig_vyadd]);
    
    %Initialising noise matrices
    %Q is the process noise matrix (x,y,z,vx,vy,B)
    %R is the measurement noise matrix (rho,z,vx,vy)
    %G is noise input matrix
    Q = diag([(1e-1)^2 (1e-1)^2 (3e-1)^2 (3e-1)^2 (3e-1)^2 (1e-1)^2]);
    sig_rho = 0.5;
    sig_z = 0.1 + sig_zadd;
    sig_vxdb = 0.05 + sig_vxadd;
    sig_vydb = 0.05 + sig_vyadd;
    R = diag([sig_rho^2 sig_z^2 sig_vxdb^2 sig_vydb^2]);
    G = eye(n);
elseif inputtype=="Kalman_B_no_z"
     %% Symbolic equations to change!
    
    %Symbolic representation of state vector
    syms x_db y_db z_db vx_db vy_db B
    state = [x_db;y_db;z_db;vx_db;vy_db;B];
    
    %State transition function
    fsym = [vx_db;vy_db;0;0;0;0];
    
    %Observation equation. We are observing range, z, vx, vy, B
    Zsym = [sqrt(x_db^2 + y_db^2+z_db^2)+B;vx_db;vy_db;B];
    
    %% Initialisations
    Bias = range_m-sqrt((x-x_b).^2+(y-y_b).^2+(z-z_b).^2);
    B_0 = 0;
    %initial guess of initial state [x_db, y_db, vx_db, vy_db B_0]
    x_0 = [x(1)-x_b;y(1)-y_b;z(1)-z_b;vx(1);vy(1);B_0];
    n = size(x_0,1);
    
    %initial guess of the state estimation covariance
    P_0 = diag([0.2^2 0.2^2 0.4^2 0.2^2 0.2^2 0.2^2]);
    
    %setting up measurement input matrix
    Z_k = horzcat(range_m,vx,vy,Bias);
    
    %Initialising noise matrices
    %Q is the process noise matrix (x,y,z,vx,vy,B)
    %R is the measurement noise matrix (rho,z,vx,vy,B)
    %G is noise input matrix
    Q = diag([(1e-1)^2 (1e-1)^2 (3e-1)^2 (3e-1)^2 (3e-1)^2 (6e-1)^2]);
    sig_rho = 0.25;
    sig_x = 0.05;
    sig_y = 0.05;
    sig_z = 0.1;
    sig_vxdb = 0.05;
    sig_vydb = 0.05;
    sig_B = 0.2;
    R = diag([sig_rho^2 sig_vxdb^2 sig_vydb^2 sig_B^2]);
    G = eye(n);  
    
elseif inputtype=="Kalman_B_obs_B"
     %% Symbolic equations to change!
    
    %Symbolic representation of state vector
    syms x_db y_db z_db vx_db vy_db B
    state = [x_db;y_db;z_db;vx_db;vy_db;B];
    
    %State transition function
    fsym = [vx_db;vy_db;0;0;0;0];
    
    %Observation equation. We are observing range, z, vx, vy, B
    Zsym = [sqrt(x_db^2 + y_db^2+z_db^2)+B;z_db;vx_db;vy_db;B];
    
    %% Initialisations
    Bias = range_m-sqrt((x-x_b).^2+(y-y_b).^2+(z-z_b).^2);
    B_0 = 0.08;
    %initial guess of initial state [x_db, y_db, vx_db, vy_db B_0]
    x_0 = [x(1)-x_b;y(1)-y_b;z(1)-z_b;vx(1);vy(1);B_0];
    n = size(x_0,1);
    
    %initial guess of the state estimation covariance
    P_0 = diag([0.2^2 0.2^2 0.4^2 0.2^2 0.2^2 0.2^2]);
    
    %setting up measurement input matrix
    Z_k = horzcat(range_m,z-z_b,vx,vy,Bias);
    
    %Initialising noise matrices
    %Q is the process noise matrix (x,y,z,vx,vy,B)
    %R is the measurement noise matrix (rho,x,y,z,vx,vy,B)
    %G is noise input matrix
    Q = diag([(1e-1)^2 (1e-1)^2 (3e-1)^2 (3e-1)^2 (3e-1)^2 (6e-1)^2]);
    sig_rho = 0.2;
    sig_x = 0.05;
    sig_y = 0.05;
    sig_z = 0.1;
    sig_vxdb = 0.05;
    sig_vydb = 0.05;
    sig_B = 0.2;
    R = diag([sig_rho^2 sig_z^2 sig_vxdb^2 sig_vydb^2 sig_B^2]);
    G = eye(n);   
 elseif inputtype=="Kalman_B_obs_B_xy"     
     %% Symbolic equations to change!
    
    %Symbolic representation of state vector
    syms x_db y_db z_db vx_db vy_db vz_db B
    state = [x_db;y_db;z_db;vx_db;vy_db;vz_db;B];
    
    %State transition function
    fsym = [vx_db;vy_db;vz_db;0;0;0;0];
    
    %Observation equation. We are observing range, x, y, z, vx, vy, B
    Zsym = [sqrt(x_db^2 + y_db^2+z_db^2)+B;x_db;y_db;z_db;vx_db;vy_db;B];
    
    %% Initialisations
    Bias = range_m-sqrt((x-x_b).^2+(y-y_b).^2+(z-z_b).^2);
    B_0 = 0.08;
    %initial guess of initial state [x_db, y_db, vx_db, vy_db B_0]
    x_0 = [x(1)-x_b;y(1)-y_b;z(1)-z_b;vx(1);vy(1);vz(1);B_0];
    n = size(x_0,1);
    
    %initial guess of the state estimation covariance
    P_0 = diag([0.2^2 0.2^2 0.4^2 0.2^2 0.2^2 0.5^2 0.2^2]);
    
    %setting up measurement input matrix
    Z_k = horzcat(range_m,x-x_b,y-y_b,z-z_b,vx,vy,Bias);
    
    %Initialising noise matrices
    %Q is the process noise matrix
    %R is the measurement noise matrix (rho,x,y,z,vx,vy,B)
    %G is noise input matrix
    Q = diag([(1e-1)^2 (1e-1)^2 (3e-1)^2 (3e-1)^2 (3e-1)^2 (6e-1)^2 (6e-1)^2]);
    sig_rho = 0.2;
    sig_x = 0.05;
    sig_y = 0.05;
    sig_z = 0.1;
    sig_vxdb = 0.05;
    sig_vydb = 0.05;
    sig_B = 0.2;
    R = diag([sig_rho^2 sig_x^2 sig_y^2 sig_z^2 sig_vxdb^2 sig_vydb^2 sig_B^2]);
    G = eye(n);   
    
 elseif inputtype=="Kalman_xy"     
     %% Symbolic equations to change!
    
    %Symbolic representation of state vector
    syms x_db y_db z_db vx_db vy_db vz_db
    state = [x_db;y_db;z_db;vx_db;vy_db;vz_db];
    
    %State transition function
    fsym = [vx_db;vy_db;vz_db;0;0;0];
    
    %Observation equation. We are observing range, x, y, z, vx, vy
    Zsym = [sqrt(x_db^2 + y_db^2+z_db^2);x_db;y_db;z_db;vx_db;vy_db];
    
    %% Initialisations
    Bias = range_m-sqrt((x-x_b).^2+(y-y_b).^2+(z-z_b).^2);
    B_0 = 0.1;
    %initial guess of initial state [x_db, y_db, z_db vx_db, vy_db, vz_db]
    x_0 = [x(1)-x_b;y(1)-y_b;z(1)-z_b;vx(1);vy(1);vz(1)];
    n = size(x_0,1);
    
    %initial guess of the state estimation covariance
    P_0 = diag([0.2^2 0.2^2 0.4^2 0.2^2 0.2^2 0.5^2]);
    
    %setting up measurement input matrix
    Z_k = horzcat(range_m,x-x_b,y-y_b,z-z_b,vx,vy);
    
    %Initialising noise matrices
    %Q is the process noise matrix
    %R is the measurement noise matrix (rho,x,y,z,vx,vy)
    %G is noise input matrix
    Q = diag([(1e-3)^2 (1e-3)^2 (1e-3)^2 (1e-3)^2 (1e-3)^2 (1e-3)^2]);
    Q = diag([(1e-1)^2 (1e-1)^2 (3e-1)^2 (3e-1)^2 (3e-1)^2 (6e-1)^2]);
    sig_rho = 0.2;
    sig_x = 0.05;
    sig_y = 0.05;
    sig_z = 0.1;
    sig_vxdb = 0.05;
    sig_vydb = 0.05;
    sig_B = 0.3;
    R = diag([sig_rho^2 sig_x^2 sig_y^2 sig_z^2 sig_vxdb^2 sig_vydb^2]);
    G = eye(n);    
end
