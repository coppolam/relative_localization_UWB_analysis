function [ dataout ] = resampleData( datain,starttime,endtime,fs,timearr )
%RESAMPLEDATA resamples a table of data at frequency fs, and returns the
%results between start time and end time NOT FINISHED

if nargin<5
    timearr = datain{:,'time'};
end

nvars = width(datain);
orheader = datain.Properties.VariableNames;
dataheight = (endtime-starttime)*fs;
rtdata = zeros(dataheight,nvars);
newtime = cumsum(ones(dataheight,1)*1/fs);
size(rtdata)
for i=1:1
    [tmp,tmpt] = resample(datain{:,i},timearr,fs);
    size(tmp(tmpt>starttime & tmpt<endtime))
    tmpt(1)
    tmpt(end)
end

end

