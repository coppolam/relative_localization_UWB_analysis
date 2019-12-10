% inputtype = "Kalman_acc_north"   ;
% inputtype = "Kalman_no_heading3";
% inputtype = "Kalman_full_no_B";

obj.input = [];
    
if obj.kalmanmodel=="Kalman_full_B"
    %% Symbolic equations to change!
    
    %Symbolic representation of state vector
    syms x_rel y_rel z_rel ownvx ownvy othvx othvy B
    obj.state = [x_rel;y_rel;ownvx;ownvy;othvx;othvy;z_rel;B];
    
    %State transition function
    obj.fsym = [othvx-ownvx;othvy-ownvy;0;0;0;0;0;0];
    
    %Observation equation. We are observing range, ownvx, ownvy, othvx,
    %othvy, z_rel
    obj.hsym = [sqrt(x_rel^2 + y_rel^2+z_rel^2)+B;ownvx;ownvy;othvx;othvy;z_rel];
    
    %% Initialisations
    %initial guess of initial state [x_rel;y_rel;ownvx;ownvy;othvx;othvy;z_rel;B]
    obj.x_0 = [0.1;0.1;0;0;0;0;0;0.5];
    obj.n = size(obj.x_0,1);
    
    %initial guess of the state estimation covariance
    obj.P_0 = diag([2 2 0.1 0.1 0.1 0.1 0.1 0.1]);
    

    
    
    %Initialising noise matrices
    %Q is the process noise matrix (x_rel;y_rel;ownvx;ownvy;othvx;othvy;z_rel;B)
    %R is the measurement noise matrix ( range, ownvx, ownvy, othvx, othvy, z_rel)
    %G is noise input matrix
    obj.Q = diag([(1e-1)^2 (1e-1)^2 (3e-1)^2 (3e-1)^2 (3e-1)^2 (3e-1)^2 (3e-1)^2 (3e-1)^2]);
  
    %obj.R = diag([0.3 1e-2 1e-2 1e-2 1e-2 1e-2]);
    obj.R = diag([0.3 0.2 0.2 0.2 0.2 1e-2]);
    obj.G = eye(obj.n);
 


    
elseif obj.kalmanmodel=="Kalman_full_no_B"
    %% Symbolic equations to change!
    
    %Symbolic representation of state vector
    syms x_rel y_rel z_rel ownvx ownvy othvx othvy
    obj.state = [x_rel;y_rel;ownvx;ownvy;othvx;othvy;z_rel];
    
    %State transition function
    obj.fsym = [othvx-ownvx;othvy-ownvy;0;0;0;0;0];
    
    %Observation equation. We are observing range, ownvx, ownvy, othvx,
    %othvy, z_rel
    obj.hsym = [sqrt(x_rel^2 + y_rel^2+z_rel^2);ownvx;ownvy;othvx;othvy;z_rel];
    
    %% Initialisations
    %initial guess of initial state [x_rel;y_rel;ownvx;ownvy;othvx;othvy;z_rel;B]
    %x_0 = [0.1;0.1;0;0;0;0;0];
    obj.x_0 = [1;1;1;1;1;1;1];
    obj.n = size(obj.x_0,1);
    
    %initial guess of the state estimation covariance
    obj.P_0 = diag([4 4 2 2 2 2 2]);
    
    

    
    %Initialising noise matrices
    %Q is the process noise matrix (x_rel;y_rel;ownvx;ownvy;othvx;othvy;z_rel;B)
    %R is the measurement noise matrix ( range, ownvx, ownvy, othvx, othvy, z_rel)
    %G is noise input matrix
    obj.Q = diag([(1e-1)^2 (1e-1)^2 (3e-1)^2 (3e-1)^2 (3e-1)^2 (3e-1)^2 (3e-1)^2]);
  
    obj.R = diag([0.15^2 (2e-1)^2 (2e-1)^2 (2e-1)^2 (2e-1)^2 (2e-1)^2]);
    obj.G = eye(obj.n);
elseif obj.kalmanmodel=="Kalman_acc_north"
    %% Symbolic equations to change!
    
    %Symbolic representation of state vector
    syms x_rel y_rel z_rel ownvx ownvy othvx othvy ownax ownay othax othay
    obj.state = [x_rel;y_rel;ownvx;ownvy;othvx;othvy;z_rel;ownax;ownay;othax;othay];
    
    %State transition function
    obj.fsym = [othvx-ownvx;othvy-ownvy;ownax;ownay;othax;othay;0;0;0;0;0];
    
    %Observation equation. We are observing range, ownvx, ownvy, othvx,
    %othvy, z_rel, ownax, ownay, othax, othay
    obj.hsym = [sqrt(x_rel^2 + y_rel^2+z_rel^2);ownvx;ownvy;othvx;othvy;z_rel;ownax;ownay;othax;othay];
    
    %% Initialisations
    %initial guess of initial state [x_rel;y_rel;ownvx;ownvy;othvx;othvy;z_rel;ownax;ownay;othax;othay]
    %x_0 = [0.1;0.1;0;0;0;0;0];
    obj.x_0 = [1;1;1;1;1;1;1;1;1;1;1];
    obj.n = size(obj.x_0,1);
    
    %initial guess of the state estimation covariance
    obj.P_0 = diag([4 4 2 2 2 2 2 2 2 2 2]);
    
    

    
    %Initialising noise matrices
    %Q is the process noise matrix (x_rel;y_rel;ownvx;ownvy;othvx;othvy;z_rel;ownax;ownay;othax;othay)
    %R is the measurement noise matrix ( range, ownvx, ownvy, othvx, othvy, z_rel, ownax, ownay, othax, othay)
    %G is noise input matrix
    obj.Q = diag([(1e-1)^2 (1e-1)^2 (3e-1)^2 (3e-1)^2 (3e-1)^2 (3e-1)^2 (1e-3)^2 (6e-1)^2 (6e-1)^2 (6e-1)^2 (6e-1)^2]);
  
    obj.R = diag([0.15^2 (2e-1)^2 (2e-1)^2 (2e-1)^2 (2e-1)^2 0.05^2 0.1^2 0.1^2 0.1^2 (0.1)^2]);
    obj.G = eye(obj.n);
elseif obj.kalmanmodel=="Kalman_mario"
    %% Symbolic equations to change!
    
    %Symbolic representation of state vector
    syms x12 y12 z1 z2 u1 v1 u2rot v2rot psi1 psi2 r1m r2m
    obj.state = [x12;y12;u1;v1;u2rot;v2rot;psi2;psi1;z2;z1];
    
    %State transition function
    obj.fsym = [u2rot - u1;
            v2rot - v1;
            0;
            0;
            0;
            0;
            0;
            0;
            0;
            0;];
    
    %Observation equation. 
    obj.hsym = [sqrt(x12^2 + y12^2+(z2-z1)^2);
        u1;
        v1;
        cos(psi2-psi1)*u2rot+sin(psi2-psi1)*v2rot;
        -sin(psi2-psi1)*u2rot+cos(psi2-psi1)*v2rot;
        psi2;
        psi1;
        z2;
        z1];
    
    %% Initialisations
    %initial guess of initial state [x_rel;y_rel;ownvx;ownvy;othvx;othvy;z_rel;B]
    %x_0 = [0.1;0.1;0;0;0;0;0];
    obj.x_0 = ones(10,1);
    obj.n = size(obj.x_0,1);
    
    %initial guess of the state estimation covariance
    obj.P_0 = diag(4*ones(size(obj.x_0)));
    
    
    
    
    %Initialising noise matrices
    %Q is the process noise matrix (x_rel;y_rel;ownvx;ownvy;othvx;othvy;z_rel;B)
    %R is the measurement noise matrix ( range, ownvx, ownvy, othvx, othvy, z_rel)
    %G is noise input matrix
    obj.Q = diag([(1e-1)^2 (1e-1)^2 (5e-1)^2 (5e-1)^2 (5e-1)^2 (5e-1)^2 (5e-1)^2 (5e-1)^2 (5e-1)^2 (5e-1)^2]);
    
    obj.R = diag([0.1^2 (2e-1)^2 (2e-1)^2 (2e-1)^2 (2e-1)^2 (2e-1)^2 (2e-1)^2 (2e-1)^2 (2e-1)^2 ]);
    obj.G = eye(obj.n);
elseif obj.kalmanmodel=="Kalman_mario_no_heading"
    %% Symbolic equations to change!
    
    %Symbolic representation of state vector
    syms x12 y12 z1 z2 u1 v1 u2rot v2rot psi1 psi2 r1m r2m
    obj.state = [x12;y12;u1;v1;u2rot;v2rot;psi2;psi1;z2;z1];
    obj.input = [r1m;r2m];
    
    %State transition function
    obj.fsym = [u2rot - u1 + r1m*y12;
            v2rot - v1 - r1m*x12;
            0;
            0;
            0;
            0;
            0;
            0;
            0;
            0;];
    
    %Observation equation. 
    obj.hsym = [sqrt(x12^2 + y12^2+(z2-z1)^2);
        u1;
        v1;
        cos(psi2-psi1)*u2rot+sin(psi2-psi1)*v2rot;
        -sin(psi2-psi1)*u2rot+cos(psi2-psi1)*v2rot;
        psi2;
        psi1;
        z2;
        z1];
    
    %% Initialisations
    %initial guess of initial state [x_rel;y_rel;ownvx;ownvy;othvx;othvy;z_rel;B]
    %x_0 = [0.1;0.1;0;0;0;0;0];
    obj.x_0 = ones(10,1);
    obj.n = size(obj.x_0,1);
    
    %initial guess of the state estimation covariance
    obj.P_0 = diag(4*ones(size(obj.x_0)));
    
    
    
    
    %Initialising noise matrices
    %Q is the process noise matrix (x_rel;y_rel;ownvx;ownvy;othvx;othvy;z_rel;B)
    %R is the measurement noise matrix ( range, ownvx, ownvy, othvx, othvy, z_rel)
    %G is noise input matrix
    obj.Q = diag([(5e-1)^2 (5e-1)^2 (5e-1)^2 (5e-1)^2 (5e-1)^2 (5e-1)^2 (5e-1)^2 (5e-1)^2 (5e-1)^2 (5e-1)^2]);
    
    obj.R = diag([0.1^2 (2e-1)^2 (2e-1)^2 (2e-1)^2 (2e-1)^2 (2e-1)^2 (2e-1)^2 (2e-1)^2 (2e-1)^2 ]);
    obj.G = eye(obj.n);
elseif (obj.kalmanmodel == "Kalman_no_heading")
    syms x12 y12 z1 b12 u1 v1 z2 b21 u2 v2 pm qm rm u1dm v1dm R12 u1m v1m z1m
    obj.state = [x12;y12;z1;b12;u1;v1];
    obj.input = [z2;b21;u2;v2;pm;qm;rm;u1dm;v1dm];
    
    obj.fsym = [-cos(b21-b12)*u2+sin(b21-b12)*v2-u1-qm*(z2-z1)+rm*y12;
        -sin(b21-b12)*u2-cos(b21-b12)*v2-v1-rm*x12+pm*(z2-z1);
        0;
        y12/(x12^2+y12^2)*(-cos(b21-b12)*u2+sin(b21-b12)*v2-u1-qm*(z2-z1)+rm*y12)+...
        x12/(x12^2+y12^2)*(-sin(b21-b12)*u2-cos(b21-b12)*v2-v1-rm*x12+pm*(z2-z1));
        u1dm;
        v1dm];
    
    obj.hsym = [sqrt(x12^2+y12^2);
        u1;
        v1;
        z1];
    
    obj.x_0 = [0.1;0.1;0;0.1;0;0];
    obj.n = size(obj.x_0,1);
    
    %initial guess of the state estimation covariance
    obj.P_0 = diag([4^2 4^2 0^2 4^2 1^2 1^2]);
    
   
    
    %Initialising noise matrices
    %Q is the process noise matrix
    %R is the measurement noise matrix 
    %G is noise input matrix
    obj.Q = diag([(0.1)^2 (0.1)^2 (0.01)^2 (0.1)^2 (0.1)^2 (0.1)^2]);
  
    obj.R = diag([0.1^2 1^2 1^2 0.001]);
    obj.G = eye(obj.n);
    
elseif    obj.kalmanmodel == "Kalman_no_heading2"
    syms x12 y12 z1 u1 v1 gam z2 u2 v2 u1dm v1dm pm1 qm1 rm1 rm2 R12 u1m v1m z1m u2dm v2dm
    obj.state = [x12;y12;z1;u1;v1;gam;u2;v2];
    obj.input = [z2;u1dm;v1dm;pm1;qm1;rm1;rm2;u2dm;v2dm];
    
        obj.fsym = [cos(gam)*u2 - sin(gam)*v2 - u1 - qm1*(z2-z1) + rm1*y12;
            sin(gam)*u2 + cos(gam)*v2 - v1 + pm1*(z2-z1) - rm1*x12;
            0;
            u1dm;
            v1dm;
            rm2-rm1;
            u2dm;
            v2dm];

    obj.hsym = [sqrt(x12^2+y12^2+(z2-z1)^2);
        u1;
        v1;
        z1;
        u2;
        v2;
        gam];
    
    obj.x_0 = [1;1;1;1;1;0;1;1];
    obj.n = size(obj.x_0,1);
    
    %initial guess of the state estimation covariance
    obj.P_0 = diag([4^2 4^2 2^2 2^2 2^2 1^2 2^2 2^2]);
    
   
    
    %Initialising noise matrices
    %Q is the process noise matrix [z2m,u1dm,v1dm,p1m,q1m,r1m,r2m,u2dm,v2dm]
    %R is the measurement noise matrix 
    %G is noise input matrix
    %obj.Q = diag([(0.1)^2 (0.1)^2 (0.01)^2 (0.3)^2 (0.3)^2 (0.1)^2 (0.3)^2 (0.3)^2]);
    %obj.Q = diag([(0)^2 (0.1^2) (0.1^2) (0)^2 (0)^2 (0.02)^2 (0.02)^2 (0.02)^2 (0.02)^2]);
    
    % for noisy measurements
%     obj.Q = diag([(0.3)^2 (0.3)^2 (0.05)^2 (0.1)^2 (0.1)^2 (0.1)^2 (0.1)^2 (0.1)^2]);
%     obj.R = diag([0.15^2 0.2^2 0.2^2 0.05^2 0.2^2 0.2^2]);
%     obj.G = eye(obj.n);

    % for non noisy measurements
    obj.Q = diag([(0.2)^2 (0.2)^2 (0.001)^2 (0.05)^2 (0.05)^2 (0.05)^2 (0.05)^2 (0.05)^2]);
    obj.R = diag([0.01^2 0.05^2 0.05^2 0.001^2 0.05^2 0.05^2 0.001^2]);
    obj.G = eye(obj.n);
  
    
    
%     obj.Q = diag([(0.03)^2 (3.5^2) (3.5^2) (0)^2 (0)^2 (1)^2 (1)^2 (3.5)^2 (3.5)^2]);
%     obj.Q = diag([(0.1)^2 (0.1^2) (0.1^2) (0.1)^2 (0.1)^2 (0.1)^2 (0.1)^2 (0.1)^2 (0.1)^2]);
  
%     obj.R = diag([0.25^2 0.2^2 0.2^2 0.05^2 0.2^2 0.2^2 0.01^2]);
% %     obj.R = diag([0.1^2 0.2^2 0.2^2 0.1^2 0.2^2 0.2^2 0.01^2]);
%     obj.G = [qm1, 0, 0, 0, z2-z1, -y12, 0, 0, 0;
%         -pm1, 0, 0, -(z2-z1), 0, x12, 0, 0, 0;
%         0,0,0,0,0,0,0,0,0;
%         0, -1, 0,0,0,0,0,0,0;
%         0,0,-1,0,0,0,0,0,0;
%         0,0,0,0,0,1,-1,0,0;
%         0,0,0,0,0,0,0,-1,0;
%         0,0,0,0,0,0,0,0,-1];

elseif    obj.kalmanmodel == "Kalman_no_heading3"
    syms x12 y12 z1 u1 v1 gam z2 u2 v2 u1dm v1dm r1m r2m R12 u1m v1m z1m u2dm v2dm
    obj.state = [x12;y12;z1;z2;u1;v1;u2;v2;gam];
    obj.input = [u1dm;v1dm;u2dm;v2dm;r1m;r2m];
    
        obj.fsym = [cos(gam)*u2 - sin(gam)*v2 - u1  + r1m*y12;
            sin(gam)*u2 + cos(gam)*v2 - v1 - r1m*x12;
            0;
            0;
            u1dm+r1m*v1;
            v1dm-r1m*u1;
            u2dm+r2m*v2;
            v2dm-r2m*u2;
            r2m-r1m;];
%         obj.fsym = [cos(gam)*u2 - sin(gam)*v2 - u1  + r1m*y12;
%             sin(gam)*u2 + cos(gam)*v2 - v1 - r1m*x12;
%             0;
%             0;
%             0;
%             0;
%             0;
%             0;
%             r2m-r1m;];



    obj.hsym = [sqrt(x12^2+y12^2+(z2-z1)^2);
        z1;
        z2;
        u1;
        v1;
        u2;
        v2;];
    
    obj.x_0 = [1;1;1;1;1;1;1;1;1];
    obj.n = size(obj.x_0,1);
    
    %initial guess of the state estimation covariance
    obj.P_0 = diag([4^2 4^2 4^2 4^2 4^2 4^2 4^2 4^2 4^2]);
    
   
    
    %Initialising noise matrices
    %Q is the process noise matrix [z2m,u1dm,v1dm,p1m,q1m,r1m,r2m,u2dm,v2dm]
    %R is the measurement noise matrix 
    %G is noise input matrix
    %obj.Q = diag([(0.1)^2 (0.1)^2 (0.01)^2 (0.3)^2 (0.3)^2 (0.1)^2 (0.3)^2 (0.3)^2]);
    %obj.Q = diag([(0)^2 (0.1^2) (0.1^2) (0)^2 (0)^2 (0.02)^2 (0.02)^2 (0.02)^2 (0.02)^2]);
%     
%     % for noisy measurements
%     obj.Q = diag([(0.5)^2 (0.5)^2 (0.05)^2 (0.05)^2 (2)^2 (2)^2 (2)^2 (2)^2 (0.5)^2]);
%     obj.R = diag([0.1^2 0.05^2 0.05^2 0.2^2 0.2^2 0.2^2 0.2^2]);
%     obj.G = eye(obj.n);

% %     for non noisy measurements
%     obj.Q = diag([(0.01)^2 (0.01)^2 (0.01)^2 (0.01)^2 (0.05)^2 (0.05)^2 (0.05)^2 (0.05)^2 (0.05)^2]);
%     obj.R = diag([0.01^2 0.01^2 0.01^2 0.05^2 0.05^2 0.05^2 0.05^2]);
%     obj.G = eye(obj.n);
  
    
% % %     
    obj.Q = diag([(2)^2 (2^2) (2^2) (2)^2 (0.3)^2 (0.3)^2 ]);
%     obj.Q = diag([(0.8)^2 (0.8^2) (0.8^2) (0.8)^2 (0.05)^2 (0.05)^2]);
%     obj.Q = diag([(0.01)^2 (0.01^2) (0.01^2) (0.01)^2 (0.01)^2 (0.01)^2]);
%   
%     obj.R = diag([0.01^2 0.02^2 0.02^2 0.025^2 0.025^2 0.025^2 0.025^2]);
    obj.R = diag([0.1^2 0.01^2 0.01^2 0.2^2 0.2^2 0.2^2 0.2^2]);
    obj.G = [0 0 0 0 y12 0;
        0 0 0 0 -x12 0;
        0 0 0 0 0 0;
        0 0 0 0 0 0;
        1 0 0 0 v1 0;
        0 1 0 0 -u1 0;
        0 0 1 0 v2 0;
        0 0 0 1 -u2 0;
        0 0 0 0 -1 1];
 elseif    obj.kalmanmodel == "Kalman_heading3"
    syms x12 y12 z1 u1 v1 gam z2 u2 v2 u1dm v1dm r1m r2m R12 u1m v1m z1m u2dm v2dm
    obj.state = [x12;y12;z1;z2;u1;v1;u2;v2;gam];
    obj.input = [u1dm;v1dm;u2dm;v2dm;r1m;r2m];
    
        obj.fsym = [cos(gam)*u2 - sin(gam)*v2 - u1  + r1m*y12;
            sin(gam)*u2 + cos(gam)*v2 - v1 - r1m*x12;
            0;
            0;
            u1dm+r1m*v1;
            v1dm-r1m*u1;
            u2dm+r2m*v2;
            v2dm-r2m*u2;
            r2m-r1m;];
%         obj.fsym = [cos(gam)*u2 - sin(gam)*v2 - u1  + r1m*y12;
%             sin(gam)*u2 + cos(gam)*v2 - v1 - r1m*x12;
%             0;
%             0;
%             0;
%             0;
%             0;
%             0;
%             r2m-r1m;];



    obj.hsym = [sqrt(x12^2+y12^2+(z2-z1)^2);
        z1;
        z2;
        u1;
        v1;
        u2;
        v2;
        gam];
    
    obj.x_0 = [1;1;1;1;1;1;1;1;1];
    obj.n = size(obj.x_0,1);
    
    %initial guess of the state estimation covariance
    obj.P_0 = diag([4^2 4^2 4^2 4^2 4^2 4^2 4^2 4^2 4^2]);
    
   
    
    %Initialising noise matrices
    %Q is the process noise matrix [z2m,u1dm,v1dm,p1m,q1m,r1m,r2m,u2dm,v2dm]
    %R is the measurement noise matrix 
    %G is noise input matrix
    %obj.Q = diag([(0.1)^2 (0.1)^2 (0.01)^2 (0.3)^2 (0.3)^2 (0.1)^2 (0.3)^2 (0.3)^2]);
    %obj.Q = diag([(0)^2 (0.1^2) (0.1^2) (0)^2 (0)^2 (0.02)^2 (0.02)^2 (0.02)^2 (0.02)^2]);
%     
%     % for noisy measurements
%     obj.Q = diag([(0.5)^2 (0.5)^2 (0.05)^2 (0.05)^2 (2)^2 (2)^2 (2)^2 (2)^2 (0.5)^2]);
%     obj.R = diag([0.1^2 0.05^2 0.05^2 0.2^2 0.2^2 0.2^2 0.2^2]);
%     obj.G = eye(obj.n);

% %     for non noisy measurements
%     obj.Q = diag([(0.01)^2 (0.01)^2 (0.01)^2 (0.01)^2 (0.05)^2 (0.05)^2 (0.05)^2 (0.05)^2 (0.05)^2]);
%     obj.R = diag([0.01^2 0.01^2 0.01^2 0.05^2 0.05^2 0.05^2 0.05^2]);
%     obj.G = eye(obj.n);
  
    
% % %     
    obj.Q = diag([(0.1)^2 (0.1^2) (0.1^2) (0.1)^2 (0.1)^2 (0.1)^2 ]);
%     obj.Q = diag([(0.8)^2 (0.8^2) (0.8^2) (0.8)^2 (0.05)^2 (0.05)^2]);
%     obj.Q = diag([(0.01)^2 (0.01^2) (0.01^2) (0.01)^2 (0.01)^2 (0.01)^2]);
%   
%     obj.R = diag([0.01^2 0.02^2 0.02^2 0.025^2 0.025^2 0.025^2 0.025^2]);
    obj.R = diag([1^2  0.01^2 0.01^2 0.1^2 0.1^2 0.1^2 0.1^2 0.1^2]);
    obj.G = [0 0 0 0 y12 0;
        0 0 0 0 -x12 0;
        0 0 0 0 0 0;
        0 0 0 0 0 0;
        1 0 0 0 v1 0;
        0 1 0 0 -u1 0;
        0 0 1 0 v2 0;
        0 0 0 1 -u2 0;
        0 0 0 0 -1 1];
   
    elseif    obj.kalmanmodel == "Kalman_no_acc"
    syms x12 y12 z1 u1 v1 gam z2 u2 v2 u1dm v1dm r1m r2m R12 u1m v1m z1m u2dm v2dm
    obj.state = [x12;y12;z1;z2;gam];
    obj.input = [u1;v1;u2;v2;r1m;r2m];
    
        obj.fsym = [cos(gam)*u2 - sin(gam)*v2 - u1  + r1m*y12;
            sin(gam)*u2 + cos(gam)*v2 - v1 - r1m*x12;
            0;
            0;
            r2m-r1m;];
%         obj.fsym = [cos(gam)*u2 - sin(gam)*v2 - u1  + r1m*y12;
%             sin(gam)*u2 + cos(gam)*v2 - v1 - r1m*x12;
%             0;
%             0;
%             0;
%             0;
%             0;
%             0;
%             r2m-r1m;];



    obj.hsym = [sqrt(x12^2+y12^2+(z2-z1)^2);
        z1;
        z2;];
    
    obj.x_0 = [1;1;1;1;1];
    obj.n = size(obj.x_0,1);
    
    %initial guess of the state estimation covariance
    obj.P_0 = diag([4^2 4^2 4^2 4^2 4^2]);
    
   
    
    %Initialising noise matrices
    %Q is the process noise matrix [z2m,u1dm,v1dm,p1m,q1m,r1m,r2m,u2dm,v2dm]
    %R is the measurement noise matrix 
    %G is noise input matrix
    %obj.Q = diag([(0.1)^2 (0.1)^2 (0.01)^2 (0.3)^2 (0.3)^2 (0.1)^2 (0.3)^2 (0.3)^2]);
    %obj.Q = diag([(0)^2 (0.1^2) (0.1^2) (0)^2 (0)^2 (0.02)^2 (0.02)^2 (0.02)^2 (0.02)^2]);
%     
%     % for noisy measurements
%     obj.Q = diag([(0.5)^2 (0.5)^2 (0.05)^2 (0.05)^2 (2)^2 (2)^2 (2)^2 (2)^2 (0.5)^2]);
%     obj.R = diag([0.1^2 0.05^2 0.05^2 0.2^2 0.2^2 0.2^2 0.2^2]);
%     obj.G = eye(obj.n);

% %     for non noisy measurements
%     obj.Q = diag([(0.01)^2 (0.01)^2 (0.01)^2 (0.01)^2 (0.05)^2 (0.05)^2 (0.05)^2 (0.05)^2 (0.05)^2]);
%     obj.R = diag([0.01^2 0.01^2 0.01^2 0.05^2 0.05^2 0.05^2 0.05^2]);
%     obj.G = eye(obj.n);
  
    
% % %     
    obj.Q = diag([(0.01)^2 (0.01^2) (0.01^2) (0.01)^2 (0.01)^2 (0.01)^2 ]);
%     obj.Q = diag([(0.8)^2 (0.8^2) (0.8^2) (0.8)^2 (0.05)^2 (0.05)^2]);
%     obj.Q = diag([(0.01)^2 (0.01^2) (0.01^2) (0.01)^2 (0.01)^2 (0.01)^2]);
%   
%     obj.R = diag([0.01^2 0.02^2 0.02^2 0.025^2 0.025^2 0.025^2 0.025^2]);
    obj.R = diag([0.01^2 0.001^2 0.001^2]);
    obj.G = [-1 0 cos(gam) -sin(gam) y12 0;
        0 -1 sin(gam) cos(gam) -x12 0;
        0 0 0 0 0 0;
        0 0 0 0 0 0;
        0 0 0 0 -1 1];
    
    
elseif    obj.kalmanmodel == "Kalman_no_heading4"
    syms x12 y12 z1 u1 v1 gam z2 u2 v2 u1dm v1dm r1m r2m R12 u1m v1m z1m u2dm v2dm
    obj.state = [x12;y12;z1;z2;u1;v1;u2;v2;gam];
    obj.input = [r1m;r2m];
    
        obj.fsym = [cos(gam)*u2 - sin(gam)*v2 - u1  + r1m*y12;
            sin(gam)*u2 + cos(gam)*v2 - v1 - r1m*x12;
            0;
            0;
            0;
            0;
            0;
            0;
            r2m-r1m;];


    obj.hsym = [sqrt(x12^2+y12^2+(z2-z1)^2);
        z1;
        z2;
        u1;
        v1;
        u2;
        v2;];
    
    obj.x_0 = [1;1;1;1;1;1;1;1;1];
    obj.n = size(obj.x_0,1);
    
    %initial guess of the state estimation covariance
    obj.P_0 = diag([4^2 4^2 4^2 4^2 4^2 4^2 4^2 4^2 4^2]);
    
   
    
    %Initialising noise matrices
    %Q is the process noise matrix [z2m,u1dm,v1dm,p1m,q1m,r1m,r2m,u2dm,v2dm]
    %R is the measurement noise matrix 
    %G is noise input matrix
    %obj.Q = diag([(0.1)^2 (0.1)^2 (0.01)^2 (0.3)^2 (0.3)^2 (0.1)^2 (0.3)^2 (0.3)^2]);
    %obj.Q = diag([(0)^2 (0.1^2) (0.1^2) (0)^2 (0)^2 (0.02)^2 (0.02)^2 (0.02)^2 (0.02)^2]);
    
    % for noisy measurements
    obj.Q = diag([(0.2)^2 (0.2)^2 (0.05)^2 (0.05)^2 (0.35)^2 (0.35)^2 (0.35)^2 (0.35)^2 (0.15)^2]);
    obj.R = diag([0.25^2 0.05^2 0.05^2 0.25^2 0.25^2 0.25^2 0.25^2]);
    obj.G = eye(obj.n);

    % for non noisy measurements
%     obj.Q = diag([(0.1)^2 (0.1)^2 (0.01)^2 (0.01)^2 (0.3)^2 (0.3)^2 (0.3)^2 (0.3)^2 (0.1)^2]);
%     obj.R = diag([0.1^2 0.01^2 0.01^2 0.1^2 0.1^2 0.1^2 0.1^2]);
%     obj.G = eye(obj.n);
  
    
    
%     obj.Q = diag([(0.1)^2 (0.1^2) (0.1^2) (0.1)^2 (0.1)^2 (0.1)^2 ]);
% %     obj.Q = diag([(0.01)^2 (0.01^2) (0.01^2) (0.01)^2 (0.005)^2 (0.005)^2]);
%   
%     obj.R = diag([0.2^2 0.01^2 0.01^2 0.2^2 0.2^2 0.2^2 0.2^2 0.01^2]);
% %     obj.R = diag([0.01^2 0.001^2 0.001^2 0.005^2 0.005^2 0.005^2 0.005^2 0.001^2]);
%     obj.G = [0 0 0 0 y12 0;
%         0 0 0 0 -x12 0;
%         0 0 0 0 0 0;
%         0 0 0 0 0 0;
%         1 0 0 0 0 0;
%         0 1 0 0 0 0;
%         0 0 1 0 0 0;
%         0 0 0 1 0 0;
%         0 0 0 0 -1 1];
elseif    obj.kalmanmodel == "Kalman_no_heading5"
        syms x12 y12 z1 u1 v1 gam z2 u2 v2 u1dm v1dm r1m r2m R12 u1m v1m z1m u2dm v2dm
    obj.state = [x12;y12;z1;z2;u1;v1;u2;v2;gam];
    obj.input = [r1m;r2m];
    
        obj.fsym = [cos(gam)*u2 - sin(gam)*v2 - u1 + r1m*y12;
            sin(gam)*u2 + cos(gam)*v2 - v1  - r1m*x12;
            0;
            0;
            0;
            0;
            0;
            0;
            r2m-r1m;];


    obj.hsym = [sqrt(x12^2+y12^2+(z2-z1)^2);
        z1;
        z2;
        u1;
        v1;
        u2;
        v2;];
    
    obj.x_0 = [1;1;1;1;1;1;1;1;1];
    obj.n = size(obj.x_0,1);
    
    %initial guess of the state estimation covariance
    obj.P_0 = diag([4^2 4^2 4^2 4^2 4^2 4^2 4^2 4^2 4^2]);
    
   
    
    %Initialising noise matrices
    %Q is the process noise matrix [z2m,u1dm,v1dm,p1m,q1m,r1m,r2m,u2dm,v2dm]
    %R is the measurement noise matrix 
    %G is noise input matrix
    %obj.Q = diag([(0.1)^2 (0.1)^2 (0.01)^2 (0.3)^2 (0.3)^2 (0.1)^2 (0.3)^2 (0.3)^2]);
    %obj.Q = diag([(0)^2 (0.1^2) (0.1^2) (0)^2 (0)^2 (0.02)^2 (0.02)^2 (0.02)^2 (0.02)^2]);
%     
%     % for noisy measurements
%     obj.Q = diag([(0.5)^2 (0.5)^2 (0.05)^2 (0.05)^2 (2)^2 (2)^2 (2)^2 (2)^2 (0.5)^2]);
%     obj.R = diag([0.1^2 0.05^2 0.05^2 0.2^2 0.2^2 0.2^2 0.2^2]);
%     obj.G = eye(obj.n);

% %     % for non noisy measurements
%     obj.Q = diag([(0.02)^2 (0.02)^2 (0.01)^2 (0.01)^2 (0.05)^2 (0.05)^2 (0.05)^2 (0.05)^2 (0.20)^2]);
%     obj.R = diag([0.01^2 0.001^2 0.001^2 0.02^2 0.02^2 0.02^2 0.02^2]);
%     obj.G = eye(obj.n);
  
    
% % %     
%     obj.Q = diag([(2)^2 (2^2) (2^2) (2)^2 (0.1)^2 (0.1)^2 ]);
    obj.Q = diag([(0.02)^2 (0.02)^2]);
%   
% %     obj.R = diag([0.1^2 0.2^2 0.2^2 0.25^2 0.25^2 0.25^2 0.25^2]);
    obj.R = diag([0.01^2 0.001^2 0.001^2 0.01^2 0.01^2 0.01^2 0.01^2]);
    obj.G = [y12 0;
        -x12 0;
         0 0;
         0 0;
        0 0;
         0 0;
         0 0;
       0 0;
         -1 1];
    

end
obj.x_k_k = obj.x_0;
obj.P_k_k = obj.P_0;
obj.Gsym = obj.G;
