function [ prel ] = GetRelativePos( pandorient1, pandorient2 )
%GetRelativePos Gets relative position between the origins of two body
%frames with respect to the first one

prel = zeros(length(pandorient1),2);

for i = 1:length(pandorient1)
    pr = R_2D(pandorient1(i,3)) * (pandorient2(i,1:2)'-pandorient1(i,1:2)');
    prel(i,:) = pr';
end

end

