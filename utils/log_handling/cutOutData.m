function [ dataout1, dataout2, newt1, newt2 ] = cutOutData( datain1, datain2, startt1, endt1, startt2,endt2, timevar )
%CUTOUTDATA Cut out table between two times, and return new time array

if nargin<4
    timevar = 'time';
end

ortimearr = datain1{:,timevar};
tmask = ortimearr>startt1 & ortimearr < endt1;
newt1 = ortimearr(tmask)-startt1;
dataout1 = datain1(tmask,:);

ortimearr = datain2{:,timevar};
tmask = ortimearr>startt2 & ortimearr < endt2;
newt2 = ortimearr(tmask)-startt2;
dataout2 = datain2(tmask,:);

height1 = height(dataout1);
height2 = height(dataout2);
minheight = min(height1,height2);

dataout2 = dataout2(1:minheight,:);
dataout1 = dataout1(1:minheight,:);

newt1= newt1(1:minheight);
newt2= newt2(1:minheight);
% dt = endt1-startt1;
% step = 1/(minheight-1)*dt;
% newt = 0:step:dt;


end

