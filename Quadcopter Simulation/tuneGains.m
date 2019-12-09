addContainingDirAndSubDir();
gains0 = [-2;0;-5];
typendi = "BODYFRAME";
typesim = "PARTICLE";
tau = 5;
kalmanmodel = "Kalman_no_heading3";
smoothr = 50;
smootha = 50;
noise = [0,0,0,0,0];
rangenoise = 0;
noise = [0, 0.2, 5, 0.4,0.05]; % p, v, a, r, yaw
rangenoise = 0.1;
kalmanfreq = 20;
control = "recording";
if strcmpi(control,"recording")
    load('leadervars.mat')
else
    leaderinparr = [];
    leaderrinparr = [];
    tinparr = [];
end
errfunc = @(x) gainErrFunc(x,typendi,typesim,tau,kalmanmodel,smoothr,smootha,noise,rangenoise,kalmanfreq ,control,leaderinparr,leaderrinparr,tinparr);



options = optimset('MaxIter',500,'PlotFcns',@optimplotfval);

gains = fminsearch(errfunc,gains0,options);