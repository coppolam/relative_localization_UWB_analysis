%% Reading drone flight data and setting parameters


%% Kalman filter parameters
%Initialising simulation with timestep dt, number of parameters n, number
%of data points N, maximum iterations for IEKF part, and epsilon
%(convergence number for IEKF)

if (obj.type=="IEKF")
    obj.maxIterations   = 300;
    obj.epsilon         = 1e-11;
end

%% Setting up symbolic functions - no need to change (only change above)!
%transforming vector function to matlabFunction to speed up evaluation
%time
% a = obj.state
% b = obj.input
% c = [obj.state;obj.input]
funinp = [obj.state;obj.input];
obj.hsymf = matlabFunction(obj.hsym, 'vars',funinp);

%Jacobian of observation equation
obj.Hxsym = jacobian(obj.hsym,obj.state);
obj.Hxsymf = matlabFunction(obj.Hxsym, 'vars', funinp);


obj.fsymf = matlabFunction(obj.fsym,'vars',funinp);

%Jacobian of state transition function
obj.Fxsym = jacobian(obj.fsym,obj.state);
obj.Fxsymf = matlabFunction(obj.Fxsym,'vars',funinp);

obj.Gsymf = matlabFunction(obj.Gsym,'vars',funinp);


