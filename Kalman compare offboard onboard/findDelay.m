function [ delay ] = findDelay( inarr1, inarr2,start,n,range )
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
%   output:
%       delay - the number of indices that inarr2 is delayed w.r.t. inarr1.
%           A negative delay means inarr2 is to the left (ahead) of inarr1
delay = 0;

if nargin<=2
    size1 = max(size(inarr1,1),size(inarr1,2));
    size2 = max(size(inarr2,1),size(inarr2,2));

    start  = round(min(size1,size2)/2);
    n = round(start/200);
    range = round(start/2);
end

for i = -range:range
    match = true;
    for j = 1:n
        tempbool = inarr1(start+j)==inarr2(start+i+j);
        match = match && tempbool;
    end
    if (match)
        delay = i;
        return
    end
end

end

