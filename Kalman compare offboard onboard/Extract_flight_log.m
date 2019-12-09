function [ time,own_x,own_y,own_z,own_vx,own_vy,own_vz,oth_vx,oth_vy,oth_z,range_m,rel_x_kal,rel_y_kal,own_vx_kal,own_vy_kal,oth_vx_kal,oth_vy_kal,rel_h_kal] = Extract_flight_log( file )
%EXTRACT_FLIGHT_DATA Summary of this function goes here
%   Detailed explanation goes here

tabvars = extractData(file);
vars = table2array(tabvars);



keySet =   {'msg','acid','time','dt','ownx','owny','ownz','ownvx','ownvy','ownvz','range_m',...
    'othvx_m','othvy_m','othz_m','relx_kal','rely_kal','ownvx_kal','ownvy_kal','othvx_kal',...
    'othvy_kal','relh_kal'};
valueSet = 1:length(keySet);
map = containers.Map(keySet,valueSet);


time = vars(:,map('time'));
own_x = vars(:,map('ownx'));
own_y = vars(:,map('owny'));
own_z = vars(:,map('ownz'));
own_vx = vars(:,map('ownvx'));
own_vy = vars(:,map('ownvy'));
own_vz = vars(:,map('ownvz'));
oth_vx = vars(:,map('othvx_m'));
oth_vy = vars(:,map('othvy_m'));
oth_z = vars(:,map('othz_m'));
range_m = vars(:,map('range_m'));
rel_x_kal = vars(:,map('relx_kal'));
rel_y_kal = vars(:,map('rely_kal'));
own_vx_kal = vars(:,map('ownvx_kal'));
own_vy_kal = vars(:,map('ownvy_kal'));
oth_vx_kal = vars(:,map('othvx_kal'));
oth_vy_kal = vars(:,map('othvy_kal'));
rel_h_kal = vars(:,map('relh_kal'));



end

