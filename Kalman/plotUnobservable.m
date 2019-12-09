addpath('../Figure_handling');

unobsstate = [2.1155;1.0528;-0.4687;1.7497;0.9176;0.4387;0.5876];
unobsinput = [0.8963;0.0467;0.0624;0.0534;0;0];

p1 = [0;0];
p2 = [unobsstate(1);unobsstate(2)];
gam = unobsstate(3);
Rm = [cos(gam) -sin(gam); sin(gam) cos(gam)];
v1 = [unobsstate(4);unobsstate(5)];
v2 = [unobsstate(6);unobsstate(7)];
a1 = [unobsinput(1);unobsinput(2)];
a2 = [unobsinput(3);unobsinput(4)];

xax = [-1;5];
yax = [-1;5];
figure;
hold on;
axis([xax;yax]);
plot(0,0,'o','linewidth',2);
arrow(p1,p2);
arrow(p1,v1);
arrow(p1,a1);
% plot(p2(1),p2(2),'o','linewidth',2);
arrow(p1,Rm*v2);
arrow(p1,Rm*a2);
% arrow(p2,Rm*a2);
