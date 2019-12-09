function [ returnmat1, returnmat2 ] = extractSyncedData( mat1,mat2,timemask1,timemask2 )
%EXTRACTSYNCEDDATA Summary of this function goes here
%   Detailed explanation goes here
colsize1 = size(mat1,2);
colsize2 = size(mat2,2);
returnmat1 = zeros(sum(timemask1),colsize1);
returnmat2 = zeros(sum(timemask2),colsize2);
for col = 1:colsize1
    tempmat1 = mat1(:,col);
    tempmat2 = mat2(:,col);
    returnmat1(:,col) = tempmat1(timemask1);
    returnmat2(:,col) = tempmat2(timemask2);
end

if(size(returnmat1,1)~= size(returnmat2,1))
    minv = min(size(returnmat1,1),size(returnmat2,1));
    if (size(returnmat1,1)<size(returnmat2,1))
        returnmat2 = returnmat2(1:minv,:);
    else
        returnmat1 = returnmat1(1:minv,:);
    end
        
end


end

