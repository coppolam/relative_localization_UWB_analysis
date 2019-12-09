function makeaxespi(handle, limits, xory)

ax = get(handle,'CurrentAxes');

pipoints = -2*pi:pi/2:2*pi;
pilabels = {'$-2\pi$','$-\frac{3\pi}{2}$','$-\pi$','$-\pi/2$','0','$\pi/2$','$\pi$','$\frac{3\pi}{2}$','$2\pi$'};

pointsofinterest = intersect(...
    find(pipoints>min(limits)-0.1), find(pipoints<max(limits)+0.1) );

if strcmp(xory,'x')
    ax.XTick = pipoints(pointsofinterest);
    ax.XTickLabel = pilabels(pointsofinterest);
    xlim(limits);
elseif strcmp(xory,'y')
    ax.YTick = pipoints(pointsofinterest);
    ax.YTickLabel = pilabels(pointsofinterest);
    ylim(limits);
end

end