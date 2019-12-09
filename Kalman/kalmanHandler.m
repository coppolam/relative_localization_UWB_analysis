classdef kalmanHandler < handle
    %KALMANHANDLER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        freq;
        oldtime = 0;
        newtime = 0;
        kalmanmodel;
        kmfilter;
        
    end
    
    methods
        function obj = kalmanHandler(freq,host)
            addpath('../Quadcopter Simulation');
            obj.kalmanmodel = host.kalmanmodel;
            obj.freq = freq;
        end
        
        function updateKalman(obj,host,trackee,dt,rangenoise)
            if(nargin<=4)
                rangenoise = 0;
            end
            %fprintf("newtime, dt before: %f, %f\n",obj.newtime,dt);
            obj.newtime = obj.newtime + dt;
            %fprintf("newtime, dt after: %f, %f\n",obj.newtime,dt);
            if((obj.newtime-obj.oldtime)>=1/obj.freq)
                curdt = obj.newtime-obj.oldtime;
                obj.oldtime = obj.newtime;
                range = norm(host.ps(1:2)-trackee.ps(1:2));
                range = range + rangenoise * randn();
                if (strcmpi(obj.kalmanmodel,'Kalman_no_heading3'))
                    ahostin = host.abobssmooth(1:2);
                    atrackeein = trackee.abobssmooth(1:2);
                    ahostin = [0;0];
                    atrackeein = [0;0];
                   inputs = [ahostin;
                       atrackeein;
                       host.robssmooth;
                       trackee.robssmooth;];
                   measurements = [range;
                       0;
                       0;
                       host.vbobs(1:2);
                       trackee.vbobs(1:2);];
                   host.updateKalman(inputs,measurements,curdt);
                end
            end
        end
        
    end
    
end

