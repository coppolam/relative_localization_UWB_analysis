function [ syncout1, syncout2, timemask1, timemask2 ] = syncData( in1, in2, synccol, timearr )
%SYNCDATA This function will return synced data in the case there are 2
%logs that do not have synced time. In order for this to work, the logs
%must have at least one column of data that is the same (but delayed) in
%both tables.



delayn = findDelay(in1{:,synccol},in2{:,synccol});
%delayn = -36

time1 = in1{:,timearr};
time2 = in2{:,timearr};

timeind1 = min(find(time1,50,'first'));
timeind2 = min(find(time2,50,'first'));
starttime1 = time1(timeind1);
starttime2 = time2(timeind2);
deltastarttime = starttime1-starttime2;

if(isnan(delayn) || delayn == 0)

elseif(delayn<0)
    timedelay = time1(abs(delayn))-time1(timeind1)+deltastarttime;
    time1 = time1-timedelay;
    in1{:,timearr} = time1;
else
    timedelay = time2(abs(delayn))-time2(timeind2)-deltastarttime;
    time2 = time2-timedelay;
    in2{:,timearr} = time2;
end

mintime = round(max(time1(timeind1),time2(timeind2))+3);
maxtime = min(time1(end),time2(end));

timemask1 = time1>=mintime & time1<=maxtime;
timemask2 = time2>=mintime & time2<=maxtime;

st1 = sum(timemask1);
st2 = sum(timemask2);
stdif = abs(st2-st1);

if (st1>st2)
    firstind = find(timemask1,1);
    for i =1:stdif
        timemask1(firstind+st1-i)=0;        
    end
elseif (st2>st1)
    firstind = find(timemask2,1);
    for i =1:stdif
        timemask2(firstind+st1-i)=0;        
    end
end


syncout1 = in1(timemask1,:);
syncout2 = in2(timemask2,:);




end

