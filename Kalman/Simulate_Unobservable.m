% state: [px py dpsi u1 v1 u2 v2]
% input: [ax1 ay1 ax2 ay2 r1 r2]
p10 = [0;0];
p20 = [2.1155;1.0528];
v10 = [1.7497;0.9176];
v20 = [0.4387;0.5876];
a10 = [0.8963;0.0467];
a20 = [0.0624;0.0534];
dpsi0 =  -0.4687;
Rm = @(t) [cos(dpsi0) -sin(dpsi0);sin(dpsi0) cos(dpsi0)];

% a1 = @(t) [0.8963;0.0467];
% a2 = @(t) [0.0624;0.0534];
% v1 = @(t) [1.7497;0.9176]+a1(t).*t;
% v2 = @(t) [0.4387;0.5876]+a2(t).*t;
p1 = @(t) p10 + v10* t + a10 * 0.5 * t^2;
p2 = @(t) p20 +v20 * t +a20 * 0.5 *t^2;
R =  @(t) norm(p2(t)-p1(t));

tend = 1;
dt = 0.001;
tarr = 0:dt:tend;
rarr = zeros(size(t));

for i = 1:length(tarr)
    rarr(i) = R(tarr(i));
end

figure;
hold on;
plot(t,rarr);

