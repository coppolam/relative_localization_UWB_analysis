function latex_printallfigures( figHandles , folder, mode, fignumbers)
% Use: latex_printallfigures(get(0,'Children'), folder (optional), mode)
%
% Example: latex_printallfigures(get(0,'Children'), 'Figures/', 'paper_wide_half')
% Note that the folder must already exist! 
%
% Available modes:
% paper_wide_half
% paper_wide_third (default)
% paper_ultrawide_third (default)
% paper_square_half
% paper_square_fourth

if nargin < 2
    folder = '';
    mode = '';
    fignumbers = [];
end

% Standard settings so you don't have to remember what works
if strcmp(mode,'paper_wide_third')
    w = 8;
    h = 4;
    f = 24;
elseif strcmp(mode,'paper_ultrawide_third')
    w = 12;
    h = 4;
    f = 24;
elseif strcmp(mode, 'paper_wide_half')
    w = 8;
    h = 4;
    f = 20;
elseif strcmp(mode, 'paper_square_half')
    w = 8;
    h = 8;
    f = 18;
elseif strcmp(mode, 'paper_square_half_HD')
    w = 8*3;
    h = 8*3;
    f = 18*3;
elseif strcmp(mode, 'paper_square_fourth')
    w = 8;
    h = 8;
    f = 30;
elseif strcmp(mode, 'paper_wide_fourth')
    w = 8;
    h = 4;
    f = 32;
else
    error('No known mode to save the figures specified, please specify.')
%     w = 8;
%     h = 4;
%     f = 20;
end

if isempty(fignumbers)
    for i = 1:numel(figHandles)
        latex_printfig(figHandles(i).Number,'figname',folder,w,h,f);
    end
else
    for i = 1:length(fignumbers)
        disp(['Saving figure ',num2str(fignumbers(i))]);
        latex_printfig(fignumbers(i),'figname',folder,w,h,f);
    end
end

disp('Done saving figures!')

end

