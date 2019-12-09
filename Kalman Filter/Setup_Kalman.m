%% Reading drone flight data and setting parameters
% addpath('C:\Users\Steven\Google Drive\Thesis\Data\Fly_Decawave\02-08-2017');
% 
% addpath('/media/steven/Windows/Documents and Settings/Steven/Google Drive/Thesis/Data/Fly_Decawave/02-08-2017');
[time,x,y,z,vx,vy,vz,range_m,x_b,y_b,z_b] = Extract_flight_data();

%% Kalman filter parameters
%Initialising simulation with timestep dt, number of parameters n, number
%of data points N, maximum iterations for IEKF part, and epsilon
%(convergence number for IEKF)
dt = 0.1;
N = length(x);
maxIterations   = 300;
epsilon         = 1e-11;




%% Setting up symbolic functions - no need to change (only change above)!

input_Kalman;



%transforming vector function to matlabFunction to speed up evaluation
%time
Zsymf = matlabFunction(Zsym, 'vars',[state;input]);

%Jacobian of observation equation
Hxsym = jacobian(Zsym,state);
Hxsymf = matlabFunction(Hxsym, 'vars', [state;input]);


fsymf = matlabFunction(fsym,'vars',[state;input]);

%Jacobian of state transition function
Fxsym = jacobian(fsym,state);
Fxsymf = matlabFunction(Fxsym,'vars',[state;input]);

%% Test observability
Hxf = Hxsym*fsym;
Hxxf = simplify(jacobian(Hxf,state));
Hxxff = Hxxf * fsym;
Hxxxff = simplify(jacobian(Hxxff, state));

Ox = [Hxsym;Hxxf;Hxxxff];

% calculate rank by substituting initial state values 
Obsnum = (subs(Ox, state, x_0));

rankObs = double(rank(Obsnum));

if rankObs>=n
    disp('Kalman filter is observable');
else
    disp('Kalman filter is not observable');
end

%Initialising variables for simulation
x_k_k = x_0;
P_k_k = P_0;

