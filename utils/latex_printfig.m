function latex_printfig(handle,filename,folder,w, h, fontsize,outtype)
% latex_printfig Saves figures in eps format to be used with Latex, and under the size
% specified. It needs checkFileName.m to run!.
%
% Developed by Mario Coppola, October 2015

% Check that at least the minimum requirements are given
if nargin < 2
    error('Specify the figure handle and the output file name')
end

% Get a name
if strcmp(filename,'figname')
    filename = get(handle,'Name');
    % If the figure is not named, then use its number
    if isempty(filename)
        filename = 'fignumber';
    end
end

if strcmp(filename,'fignumber')
    filename = num2str(handle);
end

% Default size values if unsupplied
if ~exist('w','var')
    w               = 8;
end
if ~exist('h','var')
    h               = 8;
end
if ~exist('fontsize','var')
    fontsize        = 20;
end
if ~exist('outtype','var')
    outtype = '-depsc2'; % File format for latex
end
if ~exist('folder','var')
    outtype = ''; % File format for latex
end

% Set up the full save path
filename = [folder,filename];
settexttolatex;
 
% Get axes for font size manipulation
set(handle, 'PaperPositionMode', 'manual');
set(handle, 'PaperUnits', 'inches');
set(handle, 'PaperPosition',[0 0 w h]); % last 2 are width/height.
set(ha_axes, 'fontsize', fontsize);
set(ha_legend, 'fontsize', fontsize);
set(ha_text, 'fontsize', fontsize);

filename = latex_checkfilename(filename); % Check if filename is Latex ready
%use -opengl if you have opaque things
print(handle,outtype,filename,'-loose') % Prints the figure

end