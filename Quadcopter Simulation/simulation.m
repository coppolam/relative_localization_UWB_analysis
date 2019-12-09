qc = QuadCopter("ACCELERATION");
%qc = QuadCopter("POSITION");
%qc = QuadCopter("VELOCITY");

dt = 0.001;
time = 0:dt:8;
input = [1;1;1];
qc.setInput(input);
statestore = zeros(3,length(time));
velstore = zeros(3,length(time));
accstore = zeros(3,length(time));
index = 1;
for i = time
    qc.updateModel(dt);
    statestore(:,index) = qc.getState();
    velstore(:,index) = qc.getVelocity();
    accstore(:,index) = qc.getAcc();
    index = index + 1;
end

figure;
hold on;
plot(time,statestore(1,:));
plot(time,statestore(2,:));
plot(time,statestore(3,:));
xlabel('time [s]');
ylabel('pos [m]');
legend('x','y','z');

figure;
hold on;
plot(time,velstore(1,:));
plot(time,velstore(2,:));
plot(time,velstore(3,:));
xlabel('time [s]');
ylabel('velocity [m]');
legend('x','y','z');

figure;
hold on;
plot(time,accstore(1,:));
plot(time,accstore(2,:));
plot(time,accstore(3,:));
xlabel('time [s]');
ylabel('acc [m]');
legend('x','y','z');