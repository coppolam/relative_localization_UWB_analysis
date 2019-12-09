function which = latex_checkfilename(which)
% latex_checkfilename is a function which, to check the file names for spaces and points such that
% latex and other programs will not have troubles loading the file
%   Input: which: string with name
%   Output: which: string with same name but no spaces nor points

which = strrep(which, ' ', '');
which = strrep(which, '.', '');
which = strrep(which, ',', '');

end