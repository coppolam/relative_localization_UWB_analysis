function [ output ] = alterNoise( input,cols,stds )
%ALTERNOISE This function will add Gaussian distributed white noise to the
%input on the specified columns within the input.
%   inputs:
%       input - [-] {matrix} The input matrix on which some columns will get
%           additional Gaussian white noise. Different variables are on the
%           columns, and the data collected for those variables is in the
%           columns.
%       cols - [-] {vector} specifies all the columns to which noise is added
%       stds - [-] {vector} specifies the standard deviation of the white
%           Gaussian noise that will be added to the specified columns
%   outputs:
%       output - [-] {matrix} returns the input with the added noise

matsize = size(input,1);
output = input;

for i =1:length(cols)
   output(:,cols(i)) = output(:,cols(i)) + stds(i)*randn(matsize,1);
end

end

