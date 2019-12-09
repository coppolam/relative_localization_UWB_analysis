classdef KalmanClass < handle
    %KALMANCLASS Summary of this class goes here
    %   Detailed explanation goes here

    properties
        ticker = tic;
        oldtime;
        newtime;
        
        state;
        input;
        type; %type of Kalman filter, can be "EKF" or "IEKF"
        kalmanmodel; % type of model, can be "Kalman_no_heading3" or "Kalman_full_no_B"
        fsym;
        fsymf;
        Fxsym;
        Fxsymf;
        hsym;
        hsymf;
        Hxsym;
        Hxsymf;
        x_0;
        n;
        P_0;
        Parr;
        Q;
        R;
        G;
        Gsym;
        Gsymf;
        maxIterations = 300;
        epsilon = 1e-11;
        Ox;
        
        x_k_k;
        x_kp1_k;
        x_kp1_kp1;
        z_kp1_k;
        z_kp1_kp1;
        P_k_k;
        P_kp1_k;
        P_kp1_kp1;
        
        lastleadera;
        
        
    end
    
    methods
        function obj = KalmanClass(kalmanmodel,type,x_0,P_0,Q,R)
            % x_0 is the initial state of the kalman filter, containing:
            % [x_rel;y_rel;ownvx;ownvy;othvx;othvy;z_rel;(ownax;ownay;othax;othay)]
            % measurements are:
            % range, ownvx, ownvy, othvx, othvy, z_rel, (ownax, ownay,
            %   othax, othay)
            switch nargin
                case 0
                    obj.type = "EKF";
                    obj.kalmanmodel = "Kalman_no_heading5";
                case 1
                    obj.type="EKF";
                    obj.kalmanmodel = kalmanmodel;
                case 2
                    obj.type = type;
                    obj.kalmanmodel = kalmanmodel;
                case 3
                    if(size(x_0,1)<size(x_0,2))
                        x_0 = x_0';
                    end
                    obj.type = type;               
                    obj.kalmanmodel = kalmanmodel;
                case 4
                    if(size(x_0,1)<size(x_0,2))
                        x_0 = x_0';
                    end
                    obj.type = type;         
                    obj.kalmanmodel = kalmanmodel;
                case 6
                    if(size(x_0,1)<size(x_0,2))
                        x_0 = x_0';
                    end
                    obj.type = type;         
                    obj.kalmanmodel = kalmanmodel;
            end
            input_KalmanClass;
            Setup_KalmanClass;
            if (nargin==3 || nargin == 4 || nargin == 6)
                obj.x_0 = x_0;
                obj.x_k_k = x_0;
                obj.P_k_k = P_0;
            end
            if (nargin == 6)
                obj.Q = Q;
                obj.R = R;
            end
            obj.Parr = [];
            obj.oldtime = toc(obj.ticker);                
        end
        
        function updateKalman(obj,inp,measurements,dt)
            if nargin<4
                obj.newtime = toc(obj.ticker);
                dt = obj.newtime-obj.oldtime;
                obj.oldtime = obj.newtime;
            end
            if(size(measurements,1)<size(measurements,2))
                measurements = measurements';
            end
            if(size(inp,1)<size(inp,2))
                inp = inp';
            end
            finp = [obj.x_k_k;inp];
            finp_cell = num2cell(finp);
            %x_k_k_inp = num2cell(obj.x_k_k);
            obj.x_kp1_k = obj.x_k_k + obj.fsymf(finp_cell{:})*dt;
            %obj.x_kp1_k = rksolution(obj.fsymf,obj.x_k_k,inp,dt);
            %mse = mean((obj.x_kp1_k-test).^2);
            
            Fx = obj.Fxsymf(finp_cell{:});
            
            obj.G = obj.Gsymf(finp_cell{:});
            
            
            % the continuous to discrete time transformation of Df(x,u,t)
            [phi, gamma] = c2d(Fx, obj.G, dt);
            
            %%%%%---------------How to set up GAMMA manually---------%%%%%%%%
            
            %     gamma = eye(7)*dt;
            %     gamma(1,3) = -dt^2/2;
            %     gamma(2,4) = -dt^2/2;
            %     gamma(1,5) = dt^2/2;
            %     gamma(2,6) = dt^2/2;
            
            
            obj.P_kp1_k = phi*obj.P_k_k*phi.' + gamma*obj.Q*gamma.';
            %obj.P_kp1_k = phi*obj.P_k_k*phi.' + obj.Q;
%             a = gamma
%             b = phi
%             c = obj.P_kp1_k
            
            
            if obj.type=="EKF"
                finp_kp1 = [obj.x_kp1_k;inp];
                finp_kp1_cell = num2cell(finp_kp1);
                %x_kp1_k_inp = num2cell(obj.x_kp1_k);
                Hx = obj.Hxsymf(finp_kp1_cell{:});
                Ve = Hx*obj.P_kp1_k*Hx'+obj.R;
                K_kp1 = obj.P_kp1_k*Hx'/Ve;
                obj.z_kp1_k = obj.hsymf(finp_kp1_cell{:});
                obj.x_kp1_kp1 = obj.x_kp1_k + K_kp1 * (measurements-obj.z_kp1_k);
                
                
            elseif obj.type=="IEKF"
                % do the iterative part
                eta2    = obj.x_kp1_k;
                err     = 2*obj.epsilon;
                
                itts    = 0;
                while (err > obj.epsilon)
                    if (itts >= obj.maxIterations)
                        %fprintf('Terminating IEKF: exceeded max iterations (%d)\n', maxIterations);
                        break
                    end
                    itts    = itts + 1;
                    eta1    = eta2;
                    
                    finp_kp1 = [eta1;inp];
                    finp_kp1_cell = num2cell(finp_kp1);
                    %eta1_inp = num2cell(eta1);
                    
                    Hx = obj.Hxsymf(finp_kp1_cell{:});
                    
                    Ve = (Hx*obj.P_kp1_k*Hx' + obj.R);
                    
                    
                    K_kp1 = (obj.P_kp1_k*Hx.')/Ve;
                    
                    z_kp1 = measurements;
                    obj.z_kp1_k = obj.hsymf(finp_kp1_cell{:});
                    
                    eta2    = obj.x_kp1_k + K_kp1 * (z_kp1 - obj.z_kp1_k - Hx*(obj.x_kp1_k - eta1));
                    err     = norm((eta2 - eta1), inf) / norm(eta1, inf);
                end
                
                obj.x_kp1_kp1 = eta2;
            end
            %obj.bindAngles();
            
            
            obj.P_kp1_kp1 = (eye(obj.n) - K_kp1*Hx) * obj.P_kp1_k * (eye(obj.n) - K_kp1*Hx).' + K_kp1*obj.R*K_kp1.';
%             format = repmat('%f ',1,obj.n);
%             format = horzcat(format,'\n');
%             multmat = eye(obj.n)-K_kp1*Hx
%             P_kp1k = obj.P_kp1_k
%             fprintf(format,toprint);
%             fprintf("\n");
%             fprintf("x, y convergence: %f, %f\n",toprint(1,1),toprint(2,2));

           
            
            %x_kp1_kp1_inp = num2cell(obj.x_kp1_kp1);
            %obj.z_kp1_kp1 = obj.hsymf(x_kp1_kp1_inp{:});
            
            obj.P_k_k = obj.P_kp1_kp1;
            obj.x_k_k = obj.x_kp1_kp1;
            
            obj.Parr(:,end+1) = diag(obj.P_k_k);
            
            
        end
        
        function bindAngles(obj)
            if (length(obj.x_kp1_kp1)>8)
                obj.x_kp1_kp1(9) = wrapToPi(obj.x_kp1_kp1(9));
            end
        end
        
        function testObservability(obj)
            %% Test observability
            Hxf = obj.Hxsym*obj.fsym;
            Hxxf = simplify(jacobian(Hxf,obj.state));
            Hxxff = Hxxf * obj.fsym;
            Hxxxff = simplify(jacobian(Hxxff, obj.state));
            % H3x3f = Hxxxff * fsym;
            % H4x3f = simplify(jacobian(H3x3f,state));            
            
            obj.Ox = [obj.Hxsym;Hxxf;Hxxxff];
            
            rankObs = rank(obj.Ox);
            
            if (rankObs>=obj.n)
                disp('Kalman filter is observable');
            else
                disp('Kalman filter is not observable');
            end
        end
            
    end
    
end

