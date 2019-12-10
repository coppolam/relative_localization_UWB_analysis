function [ X,Y, zarr4, zarrcrit4,xarr,yarr ] = getHeatCond( state0, input0, xrange, yrange, threshold,dx,dy)

x0 = state0(1);
y0 = state0(2);
xarr = x0-xrange:dx:x0+xrange;%
yarr = y0-yrange:dy:y0+yrange;%

xarrcrit = [];
yarrcrit = [];
zarrcrit = [];

zarr4 = zeros(length(yarr),length(xarr));
zarrcrit4 = zeros(length(yarr),length(xarr));
for xind = 1:length(xarr)
    for yind = 1:length(yarr)
        state = state0;
        state(1) = xarr(xind);
        state(2) = yarr(yind);
        curval = abs(checkFullCond(state,input0));
        zarr4(yind,xind) = curval;
        if(curval<threshold)
            xarrcrit = xarr(xind);
            yarrcrit = yarr(yind);
            zarrcrit(yind,xind) = 1;
            zarrcrit4(yind,xind) = 1;
        else
            zarrcrit4(yind,xind)=0;
        end
    end
end


[X,Y]=meshgrid(xarr,yarr);

% tmp = xarr;
% xarr = yarr;
% yarr = tmp;


end

