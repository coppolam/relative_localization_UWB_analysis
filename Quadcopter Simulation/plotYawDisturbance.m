radeps =  1;
tcent = 5;
dt = 0.01;
tend = 20;

tarr = 1:dt:tend;
yawarr = zeros(size(tarr));

yawarr = yawarr + exp(-(radeps*(tarr-tcent)).^2);

figure;
hold on;
grid on;
plot(tarr,yawarr);