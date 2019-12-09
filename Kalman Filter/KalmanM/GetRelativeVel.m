function [ vrel ] = GetRelativeVel( vandorient1, vandorient2 )
%GetRelativeVel Gets relative velocity between two velocity vectors in the
%frame of reference of the first one

vrel = zeros(length(vandorient1),2);

for i = 1:length(vandorient1)
    vr = (R_2D(vandorient2(i,3)-vandorient1(i,3))*vandorient2(i,1:2)');
    vrel(i,:) = vr';
end

end

