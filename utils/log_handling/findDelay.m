function [ delay ] = findDelay( inarr1, inarr2,startpts,n,range,epsilon )
%FINDDELAY This function is used to find the delay in a signal, when two
%signal arrays are available where part of the arrays are exactly the same
%but shifted. 
%   input:
%       inarr1 - first array
%       inarr2 - second array
%       optional input:
%           start - the index of the arrays where to start searching
%           n - how many consecutive points must be equal to be considered a match
%           range - range of timedelays (+ and -) over which the arrays are searched
%               for equivalence
%           epsilon - value to how close two ranges must be to be
%               considered a match
%   output:
%       delay - the number of indices that inarr2 is delayed w.r.t. inarr1.
%           A negative delay means inarr2 is to the left (ahead) of inarr1
delay = 0;
% inarr1
% inarr2

if nargin<=2
    size1 = max(size(inarr1,1),size(inarr1,2));
    size2 = max(size(inarr2,1),size(inarr2,2));
    minsize = round(min(size1,size2));
    startpts  = [round(minsize/4),round(minsize/2),round(minsize/2+minsize/4)];
    n = round(minsize/200);
    range = round(round(min(size1,size2)/10));
    epsilon = 0.0001;
end
% start = 1000;
% range = 500;
% n = 20;
% epsilon = 0.01;
for start=startpts
    for i = -range:range
        match = abs(inarr1(start)-inarr2(start+i))<epsilon;
        curcheck = i;
        if(match)
            for j = 1:n
                othermatch = abs(inarr1(start+j)-inarr2(start+curcheck+j))<epsilon;
                match = match && othermatch;
            end
        end
        if (match)
            delay = i;
            return
        end
    end
end
end

