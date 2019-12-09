classdef QuadCopter < handle
    %QUADCOPTER This class contains a quadcopter simulation model. 
    %   This quadcopter model works under the assumption that the
    %   quadcopter is already controlled/stabilized on a lower level (inner
    %   loop control) such that the dynamics regarding its thrust and Euler
    %   angles can simply be defined using linear 1st/2nd order transfer
    %   functions. The linear accelerations of the quadcopter simply follow
    %   from Newtonian mechanics knowing what the quadcopter's thrust and
    %   Euler angles are.
    
    properties
        g = 9.81; % [m/s2]
        m = 1; % [kg]
        p = zeros(3,1); % [x,y,z]
        v = zeros(3,1); % [vx,vy,vz]
        a = zeros(3,1); % [ax,ay,az]
        pobs = zeros(3,1); % [x,y,z]
        vobs = zeros(3,1); % [vx,vy,vz]
        aobs = zeros(3,1); % [ax,ay,az]  
        pnoise = zeros(3,1);
        vnoise = zeros(3,1);
        anoise = zeros(3,1);
        vbind = 3; % [m/s]
        abind = 5; %[m/s2]
        inp = zeros(3,1);
        asig = zeros(3,1);
        vsig = zeros(3,1);
        psig = zeros(3,1);
        tauastart = [0.2;0.2;0.2];
        tauvstart = [1;1;1];
        taua;
        tauv;
        dynscale = 1;
        % Control mode, can be:
        %   MANUAL - manual control in simulation
        %   SPEED - match drone speed with commanded speed
        %   POSITION - match drone position with commanded position
        %   TRAJECTORYFOLLOW - have drone follow trajectory of other drone
        controlMode;
        dt = 0.01;
        Rbe = zeros(3,3);
        acontroller;
        vcontroller;
        pcontroller;
        
        kalmanfilter;
    end
    
    methods
        function obj = QuadCopter(cntrlmode,pstart,vstart,astart,noise,maxv,maxa,xothstart)
            obj.controlMode = cntrlmode;
            if nargin>1
                obj.p = pstart;
                obj.pobs = pstart;
                obj.v = vstart;
                obj.vobs = vstart;
                obj.a = astart;
                obj.aobs = astart;
                obj.pnoise = obj.pnoise + noise(1);
                obj.vnoise = obj.vnoise + noise(2);
                obj.anoise = obj.anoise + noise(3);
                obj.vbind = maxv;
                obj.abind = maxa;
            end
            if (nargin<=7)
                xothstart = [0.1;0.1;0;0;0;0;0];
            end
            obj.acontroller = Controller(3,1,0,0);
            obj.vcontroller = Controller(3,2,0,0);
            obj.pcontroller = Controller(3,1,0.5,0.2);
            %obj.kalmanfilter = KalmanClass(xothstart,"EKF");
            obj.kalmanfilter = KalmanClass();
            obj.taua = obj.tauastart;
        end
        
        function updateModel(obj,dt)
            obj.dt = dt;
            obj.genCommands();
            obj.updateLinAcc();
            obj.bindKinematics();
            obj.updateLinVel();
            obj.bindKinematics();
            obj.updateLinPos();
            obj.bindKinematics();            
        end
        
        function updateKalman(obj,inp,measurements)
            obj.kalmanfilter.updateKalman(inp,measurements);            
        end
        
        function bindKinematics(obj)
            obj.v = saturateNorm(obj.v,obj.vbind);
            obj.a = saturateNorm(obj.a,obj.abind);
        end

        function updateLinAcc(obj)
            if(obj.controlMode=="ACCELERATION" || obj.controlMode == "POSITION")
                obj.a = obj.a + (obj.asig-obj.aobs) ./ obj.taua .* obj.dt;
                obj.aobs = obj.a + obj.anoise.*randn(size(obj.aobs));
            elseif (obj.controlMode=="VELOCITY")
                
            end
        end
        function updateLinVel(obj)
            obj.tauv = obj.tauvstart + abs(obj.v)./obj.dynscale;
            if(obj.controlMode=="ACCELERATION" || obj.controlMode == "POSITION")
                obj.v = obj.v + obj.a .* obj.dt;                
            elseif (obj.controlMode=="VELOCITY")
                obj.v = obj.v + (obj.vsig-obj.vobs)./obj.tauv .* obj.dt;
            end
            obj.vobs = obj.v + obj.vnoise.*randn(size(obj.vobs));
        end
        function updateLinPos(obj)
            obj.p = obj.p + obj.v .* obj.dt;
            obj.pobs = obj.p + obj.vobs .* obj.dt;
        end
        function setInput(obj,input)
            if(size(input,1)<size(input,2))
                input = input';
            end
            obj.inp = input;
        end
        function genCommands(obj)
            switch obj.controlMode
                case "MANUAL"
                case "VELOCITY"
                    obj.vsig = obj.inp;
                case "POSITION"
                    obj.vsig = obj.pcontroller.getSignal(obj.inp-obj.pobs,obj.dt);
                    obj.asig = obj.vcontroller.getSignal(obj.psig-obj.vobs,obj.dt);
                case "ACCELERATION"
                    obj.asig = obj.inp;
            end
        end
        function state = getState(obj)
            state = obj.p;
        end
        function vel = getVelocity(obj)
            vel = obj.v;
        end
        function acc = getAcc(obj)
            acc = obj.a;
        end
    end
    
end

