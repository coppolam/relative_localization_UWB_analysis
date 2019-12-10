h22 = cutdata22{:,'gps_z'};
u22 = cutdata22{:,'gps_vx'};
v22 = cutdata22{:,'gps_vy'};
h2meas22 = cutdata22{:,'track_z'};
kalx44_22 = cutdata22{:,'kal_x'};
kaly44_22 = cutdata22{:,'kal_y'};
h44_22 = cutdata44_22{:,'gps_z'};
x22 = cutdata22{:,'gps_x'};
y22 = cutdata22{:,'gps_y'};
x44_22 = cutdata44_22{:,'gps_x'};
y44_22 = cutdata44_22{:,'gps_y'};
truex44_22 = x44_22-x22;
truey44_22 = y44_22-y22;
trueranges22 = sqrt(truex44_22.^2+truey44_22.^2+(h22-h2meas22).^2);

% EKF error
xlocerr22 = kalx44_22-truex44_22; % Error in x
ylocerr22 = kaly44_22-truey44_22; % Error in y
plocerr22 = sqrt(xlocerr22.^2+ylocerr22.^2); % EKF output range error
MAEploc22 = mean(plocerr22); % EKF MAE range error

% Tracking error when following path
xtrackerr22 = cutdata22d{:,'gps_x'}-cutdata44_22d{:,'gps_x'};
ytrackerr22 = cutdata22d{:,'gps_y'}-cutdata44_22d{:,'gps_y'}; 
ptrackerr22 = sqrt(xtrackerr22.^2+ytrackerr22.^2);
MAEptrack22 = mean(ptrackerr22); 

% Raw range error from UWB
rangeerr22 = cutdata22{:,'Range'}-trueranges22;

fprintf("Mean range 22: %f, MAX: %f\n",mean(trueranges22),max(trueranges22));
fprintf("MAE range 22: %f, MAX: %f\n",mean(abs(rangeerr22)),max(abs(rangeerr22)));
fprintf("MAE p rel loc 22: %f, MAX: %f\n",MAEploc22,max(abs(plocerr22)));
fprintf("MAE p track 22: %f, MAX: %f\n",MAEptrack22,max(abs(ptrackerr22)));