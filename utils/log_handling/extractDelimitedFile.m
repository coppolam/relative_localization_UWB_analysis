function [out] = extractDelimitedFile(fileOrPath,filetype,delimiter)
% extractDelimitedFile this function extracts data from a CSV file
%   Inputs:
%       fileOrPath - {string} specifies either the file (full path) or the
%           path to the file (absolute path). If only a file path is
%           specified, then the filetype input must be specified and a UI
%           will open to select the desired file.
%	filetype - {string} contains the filetype. Must be specified if a file path
%	    rather than a file is specified. E.g. '.txt' or '.csv'
%	delimiter - {string} delimiter character. Default is ','

uimsg = 'select a file';

if nargin==1
    choosefile = false; % true - ui will open to choose file; false - last data file in path will be opened    
else
    choosefile = true;
end

if nargin<=2
    delimiter = ',';
end

%% Initialize variables.
if choosefile
    filepath = fileOrPath;
    filetypefull = horzcat('/*',filetype);
    filepathtypes = fullfile(filepath,filetypefull);
    [filename, pathname] = uigetfile(filepathtypes,uimsg);
    file = fullfile(pathname,filename);
else
    file = fileOrPath;
end

filer = fopen(file,'r');



firstrow = textscan(filer,'%s',1,'Delimiter','%[^\n\r]');
str = firstrow{1}{1};
header = strsplit(str,',');


numbertype = '%f';

format = repmat(numbertype,1,length(header));
formatSpec = horzcat(format,'%[^\n\r]');



%% Read columns of data according to the format.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(filer, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'EmptyValue', NaN,'ReturnOnError', true, 'EndOfLine', '\r\n');numrowarr = ones(1,size(dataArray,2));
for i=1:size(dataArray,2)
    numrowarr(i) = size(dataArray{i},1);
end
maxrows = max(numrowarr);
minrows = min(numrowarr);

if (maxrows~=minrows)
    stopline = maxrows-minrows;
    for i=1:size(dataArray,2)
        if (size(dataArray{i},1)==maxrows)
            dataArray{i} = dataArray{i}(1:end-stopline);
        end
    end
end

%% Close the text file.
fclose(filer);

%% Post processing for unimportable data.
% No unimportable data rules were applied during the import, so no post
% processing code is included. To generate code which works for
% unimportable data, select unimportable cells in a file and regenerate the
% script.

%% Create output variable
out = table(dataArray{1:end-1}, 'VariableNames', header);

end
