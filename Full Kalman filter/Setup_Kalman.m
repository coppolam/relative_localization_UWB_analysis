%% Reading drone flight data and setting parameters

%filepath='/home/steven/Dropbox/Thesis/Data/Fly_Decawave_onboard_Kalman/08-09-2017_Spiral_tests';
%[time,own_x,own_y,own_z,own_vx,own_vy,own_vz,oth_vx,oth_vy,oth_z,range_m,rel_x_kal,rel_y_kal,own_vx_kal,own_vy_kal,oth_vx_kal,oth_vy_kal,rel_h_kal] = Extract_flight_log(filepath);

%% Kalman filter parameters
%Initialising simulation with timestep dt, number of parameters n, number
%of data points N, maximum iterations for IEKF part, and epsilon
%(convergence number for IEKF)
dt = 0.1;
%N = length(own_x);
maxIterations   = 1;
epsilon         = 1e-11;





input_Kalman;



%% Setting up symbolic functions - no need to change (only change above)!
%transforming vector function to matlabFunction to speed up evaluation
%time
Zsymf = matlabFunction(Zsym, 'vars',state);

%Jacobian of observation equation
Hxsym = jacobian(Zsym,state);
Hxsymf = matlabFunction(Hxsym, 'vars', state);


fsymf = matlabFunction(fsym,'vars',state);

%Jacobian of state transition function
Fxsym = jacobian(fsym,state);
Fxsymf = matlabFunction(Fxsym,'vars',state);

%% Test observability
Hxf = Hxsym*fsym;
Hxxf = simplify(jacobian(Hxf,state));
Hxxff = Hxxf * fsym;
Hxxxff = simplify(jacobian(Hxxff, state));
% H3x3f = Hxxxff * fsym;
% H4x3f = simplify(jacobian(H3x3f,state));


Ox = [Hxsym;Hxxf;Hxxxff];

rankObs = rank(Ox);

if rankObs>=n
    disp('Kalman filter is observable');
else
    disp('Kalman filter is not observable');
end

%Initialising variables for simulation
x_k_k = x_0;
P_k_k = P_0;

