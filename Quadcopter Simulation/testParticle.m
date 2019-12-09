clearvars;
periodfollower = -20; % [s]
radiusfol = 4;
followeroffset = pi;
tend = 15; % [s]
dt = 0.01;
tarr = 0:dt:tend;

wfollower = 2*pi/periodfollower;

p0f = [cos(followeroffset)*radiusfol;sin(followeroffset)*radiusfol;0];
v0f = [0;0;0];
a0f = [0;0;0];
yaw0 = (pi/2+followeroffset)*periodfollower/abs(periodfollower);
r0 = 0;
maxvf = Inf;
maxaf = Inf;
maxrf = Inf;

noise = zeros(5,1);

follower = Particle("VELOCITY",p0f,v0f,a0f,yaw0,r0,noise,maxvf,maxaf,maxrf);

pfarr=zeros(3,length(tarr));

ind = 1;
for t = tarr
    ufollower = radiusfol*wfollower^2/abs(wfollower);
    followerinp = [ufollower;0;0];
    followerr = wfollower;

    follower.setInput(followerinp,followerr);
    follower.updateModel(dt);    

    pfarr(:,ind) = follower.ps;

    ind = ind + 1;
end

figure
axis square
hold on
plot(pfarr(1,:),pfarr(2,:))
