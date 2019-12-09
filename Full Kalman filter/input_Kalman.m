inputtype = "Kalman_full_no_B"   ;

    
if inputtype=="Kalman_full_B"
    %% Symbolic equations to change!
    
    %Symbolic representation of state vector
    syms x_rel y_rel z_rel ownvx ownvy othvx othvy B
    state = [x_rel;y_rel;ownvx;ownvy;othvx;othvy;z_rel;B];
    
    %State transition function
    fsym = [othvx-ownvx;othvy-ownvy;0;0;0;0;0;0];
    
    %Observation equation. We are observing range, ownvx, ownvy, othvx,
    %othvy, z_rel
    Zsym = [sqrt(x_rel^2 + y_rel^2+z_rel^2)+B;ownvx;ownvy;othvx;othvy;z_rel];
    
    %% Initialisations
    %initial guess of initial state [x_rel;y_rel;ownvx;ownvy;othvx;othvy;z_rel;B]
    x_0 = [0.1;0.1;0;0;0;0;0;0.5];
    n = size(x_0,1);
    
    %initial guess of the state estimation covariance
    P_0 = diag([1 1 0.1 0.1 0.1 0.1 0.1 0.1]);
    
    %setting up measurement input matrix
    Z_k = horzcat(range_m,own_vx,own_vy,oth_vx,oth_vy,oth_z-own_z);
    Z_store = Z_k;
    
    
    %Initialising noise matrices
    %Q is the process noise matrix (x_rel;y_rel;ownvx;ownvy;othvx;othvy;z_rel;B)
    %R is the measurement noise matrix ( range, ownvx, ownvy, othvx, othvy, z_rel)
    %G is noise input matrix
    Q = diag([(1e-1)^2 (1e-1)^2 (3e-1)^2 (3e-1)^2 (3e-1)^2 (3e-1)^2 (3e-1)^2 (3e-1)^2]);
  
    R = diag([0.5 1e-2 1e-2 1e-2 1e-2 1e-2]);
    G = eye(n);
 

elseif inputtype=="Kalman_full_mistakes"
    %% Symbolic equations to change!
    
    %Symbolic representation of state vector
    syms x_rel y_rel z_rel ownvx ownvy othvx othvy B
    state = [x_rel;y_rel;ownvx;ownvy;othvx;othvy;z_rel;B];
    
    %State transition function
    fsym = [othvx-ownvx;othvy-ownvy;0;0;0;0;0;0];
    
    %Observation equation. We are observing range, ownvx, ownvy, othvx,
    %othvy, z_rel
    Zsym = [sqrt(x_rel^2 + y_rel^2+z_rel^2)+B;ownvx;ownvy;othvx;othvy;z_rel];
    
    %% Initialisations
    %initial guess of initial state [x_rel;y_rel;ownvx;ownvy;othvx;othvy;z_rel;B]
    x_0 = [0.1;0.1;0;0;0;0;0;0];
    n = size(x_0,1);
    
    %initial guess of the state estimation covariance
    P_0 = diag([1 1 0.1 0.1 0.1 0.1 0.1 0.25]);
    
    %setting up measurement input matrix
    Z_k = horzcat(range_m,own_vx,own_vy,oth_vx,oth_vy,oth_z-own_z);
    Z_store = Z_k;
    
    
    %Initialising noise matrices
    %Q is the process noise matrix (x_rel;y_rel;ownvx;ownvy;othvx;othvy;z_rel;B)
    %R is the measurement noise matrix ( range, ownvx, ownvy, othvx, othvy, z_rel)
    %G is noise input matrix
    Q = diag([(1e-1)^2 (1e-1)^2 (3e-1)^2 (3e-1)^2 (3e-1)^2 (3e-1)^2 (3e-1)^2 (3e-1)^2]);
  
    R = diag([0.5 1e-2 1e-2 1e-2 1e-2 1e-2]);
    G = eye(n);
 
    
elseif inputtype=="Kalman_full_no_B"
    %% Symbolic equations to change!
    
    %Symbolic representation of state vector
    syms x_rel y_rel z_rel ownvx ownvy othvx othvy
    state = [x_rel;y_rel;ownvx;ownvy;othvx;othvy;z_rel];
    
    %State transition function
    fsym = [othvx-ownvx;othvy-ownvy;0;0;0;0;0];
    
    %Observation equation. We are observing range, ownvx, ownvy, othvx,
    %othvy, z_rel
    Zsym = [sqrt(x_rel^2 + y_rel^2+z_rel^2);ownvx;ownvy;othvx;othvy;z_rel];
    
    %% Initialisations
    %initial guess of initial state [x_rel;y_rel;ownvx;ownvy;othvx;othvy;z_rel;B]
    %x_0 = [0.1;0.1;0;0;0;0;0];
    x_0 = [0.0;3.0;0;0;0;0;0];
    n = size(x_0,1);
    
    %initial guess of the state estimation covariance
    P_0 = diag([1 1 0.1 0.1 0.1 0.1 0.1]);
    
    %setting up measurement input matrix
    %Z_k = horzcat(range_m,own_vx,own_vy,oth_vx,oth_vy,oth_z-own_z);
    %Z_store = Z_k;
    
    
    %Initialising noise matrices
    %Q is the process noise matrix (x_rel;y_rel;ownvx;ownvy;othvx;othvy;z_rel)
    %R is the measurement noise matrix ( range, ownvx, ownvy, othvx, othvy, z_rel)
    %G is noise input matrix
    Q = diag([(1e-1)^2 (1e-1)^2 (3e-1)^2 (3e-1)^2 (3e-1)^2 (3e-1)^2 (3e-1)^2]);
  
    R = diag([0.5 1e-2 1e-2 1e-2 1e-2 1e-2]);
    G = eye(n);
     
end
