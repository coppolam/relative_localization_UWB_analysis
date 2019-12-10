h18 = cutdata18{:,'gps_z'};
u18 = cutdata18{:,'gps_vx'};
v18 = cutdata18{:,'gps_vy'};
h2meas18 = cutdata18{:,'track_z'};
kalx44_18 = cutdata18{:,'kal_x'};
kaly44_18 = cutdata18{:,'kal_y'};
h44_18 = cutdata44_18{:,'gps_z'};
x18 = cutdata18{:,'gps_x'};
y18 = cutdata18{:,'gps_y'};
x44_18 = cutdata44_18{:,'gps_x'};
y44_18 = cutdata44_18{:,'gps_y'};
truex44_18 = x44_18-x18;
truey44_18 = y44_18-y18;
trueranges18 = sqrt(truex44_18.^2+truey44_18.^2+(h18-h2meas18).^2);

dtarr = cutdata22{:,'dt'};
dtm = dtarr>0.09;

% EKF error
xlocerr18 = kalx44_18-truex44_18;
ylocerr18 = kaly44_18-truey44_18;
plocerr18 = sqrt(xlocerr18.^2+ylocerr18.^2);
MAEploc18 = mean(plocerr18);

% Tracking error when following path
xtrackerr18 = cutdata18d{:,'gps_x'}-cutdata44_18d{:,'gps_x'};
ytrackerr18 = cutdata18d{:,'gps_y'}-cutdata44_18d{:,'gps_y'}; 
ptrackerr18 = sqrt(xtrackerr18.^2+ytrackerr18.^2);
MAEptrack18 = mean(ptrackerr18);

% Raw range error from UWB
rangeerr18 = cutdata18{:,'Range'}-trueranges18;

fprintf("Mean range 18: %f, MAX: %f\n",mean(trueranges18),max(trueranges18));
fprintf("MAE range 18: %f, MAX: %f\n",mean(abs(rangeerr18)),max(abs(rangeerr18)));
fprintf("MAE p rel loc 18: %f, MAX: %f\n",MAEploc18,max(abs(plocerr18)));
fprintf("MAE p track 18: %f, MAX: %f\n",MAEptrack18,max(abs(ptrackerr18)));