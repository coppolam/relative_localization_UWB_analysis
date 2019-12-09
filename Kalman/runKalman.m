function [ x_k_k_arr ] = runKalman( measurein, inputin, dtin, kalmanmodel,type,x_0,P_0,Q,R )
%RUNKALMAN This function simply runs the kalman filter (which is described
%in KalmanClass) for l steps, where for every l steps the measurein and
%inputin give the measurements and input into the kalman filter. The other
%inputs are required to create a KalmanClass instance.

km = KalmanClass(kalmanmodel,type,x_0,P_0,Q,R);

if(size(measurein,1)>size(measurein,2))
    measurein=measurein.';
end
if(size(inputin,1)>size(inputin,2))
    inputin=inputin.';
end

l = size(measurein,2);

x_k_k_arr = zeros(km.n,l);

ranges = measurein(1,:);

% fc = 1; % [Hz]
% fs = 20;
% [b,a] = butter(2,fc/(fs/2));
% 
% rangebut = filter(b,a,ranges);




for i = 1:l-1
    km.updateKalman(inputin(:,i),measurein(:,i),dtin(i));
    x_k_k_arr(:,i) = km.x_k_k;
end


end

