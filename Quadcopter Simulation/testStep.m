input = [1;0;0];
rinp = 0;
[y,ind] = max(input);
barrier = 0.632*y;
tcfound = false;
dt = 0.01;
tend = 20;
tarr = 0:dt:tend;
pstart = zeros(3,1);
vstart = zeros(3,1);
astart = zeros(3,1);
yawstart =0;
rstart = 0;
noise = zeros(5,1);
maxv = Inf;
maxa = Inf;
maxr = Inf;

part = Particle("VELOCITY",pstart,vstart,astart,yawstart,rstart,noise,maxv,maxa,maxr,"Kalman_no_heading3",1,1);
parr = zeros(3,length(tarr));
varr = zeros(3,length(tarr));
aarr = zeros(3,length(tarr));

index = 1;

for t = tarr
    varr(:,index) = part.vs;
    aarr(:,index) = part.as;
    parr(:,index) = part.ps;
    if (part.v(ind)>barrier && ~tcfound)
        tcfound = true;
        fprintf("Approximate time constant of %f\n",t);
    end
    part.setInput(input,rinp);
    part.updateModel(dt);
    index = index + 1;
end

figure;
hold on;
xlabel('time [s]');
ylabel('position [m]');
plot(tarr,parr);

figure;
hold on;
xlabel('time [s]');
ylabel('velocity [m/s]');
plot(tarr,varr);