function QuadGame()
%QUADGAME Summary of this function goes here
%   Detailed explanation goes here

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% INITIALIZATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
addContainingDirAndSubDir();

ndigains = [-4,-0.1,-4];


ndihandler = NDIhandler(1.5,"EARTHFRAME","QUADCOPTER",ndigains);

% scenario = "STATIONARY_FOLLOWER";
%scenario = "TRACK_ABS_LEADER";
%scenario = "TRACK_REL_LEADER";
scenario = "NDI_TRACKING";
%observation = "REALISTIC";
observation = "PERFECT";

initpl = [0;0;0];
initvl = [0.5;0.5;0];
inital = [0.2;0.2;0];
maxvl = 4;
maxal = 5;


initpf = [-3;0;0];
initvf = [0;0;0];
initaf = [0;0;0];
maxvf = 20;
maxaf = 8;
initfolkalstate = [initpl(1)-initpf(1);initpl(2)-initpf(2);0;0;0;0;initpl(3)-initpf(3);initaf(1);initaf(2);inital(1);inital(2)];

desiredfollowerpos = initpf;
followerposerr = [0;0;0];



closereq = false;
realx = 10;
realy = 10;
scalex = round(1920/max(realx,realy));
scaley = round(1080/max(realx,realy));
realacc = 4;
axisminx = -realx/2;
axismaxx = realx/2;
axisminy = -realy/2;
axismaxy = realy/2;


showseconds = 5;

kalrelx = 0;
kalrely = 0;

keyStatus = [false, false, false, false];
keyNames = {'rightarrow','leftarrow','uparrow','downarrow'};

if (observation == "REALISTIC")
    quadLeader = QuadCopter("ACCELERATION",initpl,initvl,inital,[0,0.2,0.1],maxvl,maxal);
elseif (observation == "PERFECT")
    quadLeader = QuadCopter("ACCELERATION",initpl,initvl,inital,[0,0,0],maxvl,maxal);
end
quadLeaderInput = [0;0;0];
quadLeader.setInput(quadLeaderInput);

if (scenario == "STATIONARY_FOLLOWER" || scenario == "TRACK_ABS_LEADER")
    if (observation == "REALISTIC")
        quadFollower = QuadCopter("POSITION",initpf,initvf,initaf,[0,0.2,0.1],maxvf,maxaf,initfolkalstate);
    elseif (observation == "PERFECT")
        quadFollower = QuadCopter("POSITION",initpf,initvf,initaf,[0,0,0],maxvf,maxaf,initfolkalstate);
    end
    quadFollowerInput = initpf;
elseif (scenario == "TRACK_REL_LEADER" || scenario == "NDI_TRACKING")
    if (observation == "REALISTIC")
        quadFollower = QuadCopter("VELOCITY",initpf,initvf,initaf,[0,0.2,0.1],maxvf,maxaf,initfolkalstate);
    elseif (observation == "PERFECT")
        quadFollower = QuadCopter("VELOCITY",initpf,initvf,initaf,[0,0,0],maxvf,maxaf,initfolkalstate);
    end
    quadFollowerInput = [0;0;0];
    poscontroller = Controller(3,0.8,0.3,0.05);
end
quadFollower.setInput(quadFollowerInput);

realrelx = quadLeader.p(1)-quadFollower.p(1);
realrely = quadLeader.p(2)-quadFollower.p(2);

figHandle = figure('Name','test',...
    'NumberTitle','off',...
    'Units', 'pixels', ...
    'Position', [0, 0, scalex*realx, scaley*realy],...
    'CloseRequestFcn', @closeReqFcn,...
    'KeyPressFcn', @keyDownFcn,...
    'KeyReleaseFcn', @keyUpFcn);


posplot = subplot(2,5,[1,2,6,7]);
posLeaderHeadPlot = animatedline('MaximumNumPoints',1,'Marker','o');
posFollowerHeadPlot = animatedline('MaximumNumPoints',1,'Color','red','Marker','o');
posLeaderPlot = animatedline('MaximumNumPoints',100);
posFollowerPlot = animatedline('MaximumNumPoints',100,'Color','red');
desFolPos = animatedline('MaximumNumPoints',1,'Color','red','Marker','o');
axis([-realx/2 realx/2 -realy/2 realy/2]);
xlabel('x [m]');
ylabel('y [m]');
%legend('leader','follower');
relposplot = subplot(2,5,[3,4,8,9]);
realRelPlot = animatedline('MaximumNumPoints',100);
realRelHeadPlot = animatedline('MaximumNumPoints',1,'Marker','o');
kalRelPlot = animatedline('MaximumNumPoints',100,'Color','red');
kalRelHeadPlot = animatedline('MaximumNumPoints',1,'Color','red','Marker','o');
axis([-realx/2 realx/2 -realy/2 realy/2]);
xlabel('x [m]');
ylabel('y [m]');
relerrorplot = subplot(2,5,5);
grid on;
relErrPlot = animatedline('MaximumNumPoints',100);
axis([0 showseconds 0 3]);
xlabel('time [s]');
ylabel('error [m]');

poserrorplot = subplot(2,5,10);
grid on;
posErrPlot = animatedline('MaximumNumPoints',100);
axis([0 showseconds 0 3]);
xlabel('time [s]');
ylabel('error [m]');



ticker = tic;
starttime = toc(ticker);

oldt = toc(ticker);

xleader = 0;
yleader = 0;
xfollower = 0;
yfollower = 0;

kalmanfreq = 15; % [Hz]
oldkalmantime = toc(ticker);
if (observation == "REALISTIC")
    kalmannoise = [0.3,0,0,0,0,0,0,0,0,0]; %range, ownvx, ownvy, othvx, othvy, z_rel, ownax, ownay, othax, othay
elseif (observation == "PERFECT")
    kalmannoise = [0,0,0,0,0,0,0,0,0,0]; %range, ownvx, ownvy, othvx, othvy, z_rel, ownax, ownay, othax, othay
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% MAIN LOOP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

while (closereq==false)
    ax = (keyStatus(1)-keyStatus(2))*realacc;
    ay = (keyStatus(3)-keyStatus(4))*realacc;
    newt = toc(ticker);
    dt = newt-oldt;
    oldt = newt;
    handleQuadCopters();
    handlePlots();
    handleKalman(quadFollower,quadLeader);
    handleInput();
    
    ndihandler.addVars([quadFollower.kalmanfilter.x_k_k(1),quadFollower.kalmanfilter.x_k_k(2)],quadLeader.vobs(1:2)',quadLeader.aobs(1:2)',quadFollower.vobs(1:2)');
    
    
    %xp = [0, quadLeaderState(1)];
    %yp = [0, quadLeaderState(2)];
    %set(h,'XData',xp,'YData',yp);    
end

delete(gcf);


    function handleQuadCopters()
        quadLeaderInput = [ax; ay; 0];
        quadLeader.setInput(quadLeaderInput);
        quadLeader.updateModel(dt);
        
        if (scenario=="TRACK_ABS_LEADER")
            followerinp = [xleader+desiredfollowerpos(1);yleader+desiredfollowerpos(2);0];
            followerposerr = [xleader-xfollower+desiredfollowerpos(1);...
                yleader-yfollower+desiredfollowerpos(2);0];
            quadFollowerInput = followerinp;
        elseif (scenario=="STATIONARY_FOLLOWER")
            quadFollowerInput = desiredfollowerpos;
        elseif (scenario=="TRACK_REL_LEADER")
            followerinp = [quadFollower.kalmanfilter.x_k_k(1)+desiredfollowerpos(1);
                quadFollower.kalmanfilter.x_k_k(2)+desiredfollowerpos(2);0];
            followerposerr = [xleader-xfollower+desiredfollowerpos(1);...
                yleader-yfollower+desiredfollowerpos(2);0];
            quadFollowerInput = poscontroller.getSignal(followerinp,dt);
        elseif (scenario == "NDI_TRACKING")
            Vcom = ndihandler.getNDIcommands(quadFollower.v(1),quadFollower.v(2),dt);
            followerinp = [Vcom(1);Vcom(2);0];
            quadFollowerInput = followerinp;
            
        end
        quadFollower.setInput(quadFollowerInput);
        quadFollower.updateModel(dt);
        handleKalman(quadFollower,quadLeader);
        
        quadLeaderState = quadLeader.getState();
        quadFollowerState = quadFollower.getState();
        xfollower = quadFollowerState(1);
        yfollower = quadFollowerState(2);
        xleader = quadLeaderState(1);
        yleader = quadLeaderState(2);
        %disp(['x leader: ' num2str(xleader) ', y leader: ' num2str(yleader)]);
    end

    

    function handleKalman(trackerQuad,trackedQuad)
        newkalmantime = toc(ticker);
        if (newkalmantime - oldkalmantime > 1/kalmanfreq)
            %            measurements = [range, trackerQuad.vobs(1),trackerQuad.vobs(2),trackedQuad.vobs(1),...
            %                trackedQuad.vobs(2),trackedState(3)-trackerState(3)];
            range = sqrt((trackerQuad.p(1)-trackedQuad.p(1))^2 + ...
                (trackerQuad.p(2)-trackedQuad.p(2))^2 +...
                (trackerQuad.p(3)-trackedQuad.p(3))^2);
            measurements = [range, trackerQuad.vobs(1),trackerQuad.vobs(2),trackedQuad.vobs(1),...
                trackedQuad.vobs(2),trackedQuad.p(3)-trackerQuad.p(3),trackerQuad.aobs(1),...
                trackerQuad.aobs(2),trackedQuad.aobs(1),trackedQuad.aobs(2)];
            
            
            measurements = measurements + kalmannoise.*randn(size(measurements));
            trackerQuad.updateKalman([],measurements);
            kalrelx = trackerQuad.kalmanfilter.x_k_k(1);
            kalrely = trackerQuad.kalmanfilter.x_k_k(2);
        end
    end

    function handlePlots()
        realrelx = quadLeader.p(1)-quadFollower.p(1);
        realrely = quadLeader.p(2)-quadFollower.p(2);
%         [P,~,~] = ndihandler.getOldLeaderVars();
        Pdiff = ndihandler.getCurrentError();
        P = [quadFollower.p(1)+Pdiff(1); quadFollower.p(2)+Pdiff(2)];
        
        addpoints(desFolPos,P(1),P(2));
        
        addpoints(posLeaderPlot,xleader,yleader);
        addpoints(posLeaderHeadPlot,xleader,yleader);
        addpoints(posFollowerPlot,xfollower,yfollower);
        addpoints(posFollowerHeadPlot,xfollower,yfollower);
        addpoints(realRelPlot,realrelx,realrely);
        addpoints(realRelHeadPlot,realrelx,realrely);
        addpoints(kalRelPlot,kalrelx,kalrely);  
        addpoints(kalRelHeadPlot,kalrelx,kalrely);
        
        curtime = toc(ticker);
        relerr = sqrt((kalrelx-realrelx)^2+(kalrely-realrely)^2);
        addpoints(relErrPlot,curtime,relerr);
        axes(relerrorplot);
        axis([curtime-starttime-showseconds/2 curtime-starttime+showseconds/2 0 3]);
        
        
        poserr = sqrt((followerposerr(1))^2+(followerposerr(2))^2);
        addpoints(posErrPlot,curtime,poserr);
        axes(poserrorplot);
        axis([curtime-starttime-showseconds/2 curtime-starttime+showseconds/2 0 3]);        
        drawnow;
    end

    function handleInput()
        if (keyStatus(1) && keyStatus(2))
            keyStatus(1) = false;
            keyStatus(2) = false;
        end
        if (keyStatus(3) && keyStatus(4))
            keyStatus(3) = false;
            keyStatus(4) = false;
        end
    end
    function closeReqFcn(hObject, eventdata, handles)
        closereq = true;
    end
    function keyUpFcn(hObject, eventdata, handles)
        lastKeyStatus = keyStatus;
        key = get(hObject,'CurrentKey');
        %disp(['key up: ' key]);
        keyStatus = (~strcmp(key, keyNames) & lastKeyStatus);
%         fprintf('key up ');
%         disp(keyStatus);

    end
    function keyDownFcn(hObject, eventdata, handles)
        lastKeyStatus = keyStatus;
        key = get(hObject,'CurrentKey');
        %disp(['key down: ' key]);
        keyStatus = (strcmp(key, keyNames) | lastKeyStatus);
%         fprintf('key down ');
%         disp(keyStatus);
    end


end