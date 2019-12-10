init;
printfigs = false;

%% Select random seed
% Use the following to reproduce...
% rngnum = 13 -- Fig 3c + 4e
% rngnum = 17 -- Fig 3d + 4f
rngnum = 13;
rng(rngnum);

% Other seeds and expected results
% 6 - clear plot, parallel, nice but full heat map
% 7 - clear plot, v2 almost 0, circular heat map
% 8 - clear plot, very clear heat map
% 9 - clear plot, clear heat map, accelerations almost parallel
% 23 - clear plot, not parallel, semi clear heat map

%% Analyze
n = 7;
l = 6;
leg1loc = 'best';
leg2loc = 'best';
fontsize = 19;
if rngnum == 13
    leg2loc = 'southwest';
elseif rngnum == 17
    leg2loc ='northwest';
end

v1range = 5;
v2range = 5;
prange  = 5;
a1range = 5;
a2range = 5;
r1range = 3;
r2range = 3;
randrangestate = [-prange prange;
    -prange prange;
    0 2*pi;
    -v1range v1range;
    -v1range v1range;
    -v2range v2range;
    -v2range v2range;];
randrangeinput = [-a1range a1range;
    -a1range a1range;
    -a2range a2range;
    -a2range a2range;
    -r1range r1range;
    -r2range r2range;];

drawstate = randrangestate(:,1) + (randrangestate(:,2)-randrangestate(:,1)).* rand(n,1);
drawinput = randrangeinput(:,1) + (randrangeinput(:,2)-randrangeinput(:,1)).* rand(l,1);

[x,fval] = giveUnobservable(drawstate,drawinput);

state = x(1:n);
input = x(n+1:n+l);
p = state(1:2);
dpsi = state(3);
v1 = state(4:5);
v2 = state(6:7);
a1 = input(1:2);
a2 = input(3:4);
r1 = state(5);
r2 = state(6);
Rm = [cos(dpsi) -sin(dpsi);
    sin(dpsi) cos(dpsi);];
v2rot = Rm*v2;
a2rot = Rm*a2;

axcomp = [[0; 0] p v1 p+v2rot a1 p+a2rot];
axmins = min(axcomp,[],2);
axmins = floor(axmins-1);
axmaxs = max(axcomp,[],2);
axmaxs = ceil(axmaxs);

atipangle = 30;
alength = 15;
awidth = 2;
dronewidth = 5;

p1 = [0;0];
p2 = p;

%% Make figures
file = strcat('figures/cond_vectplot',num2str(rngnum),'.eps');

h = figure;
set(gcf,'units','pixels','Position',[500,300,500,550]);
set(gca,'XTick',axmins(1):axmaxs(1),'YTick',axmins(2):axmaxs(2),'FontSize',fontsize,'FontUnits','points','FontWeight','normal','FontName','Times');
colors = get(gca,'ColorOrder');
hold on;
grid on;
axis([axmins(1) axmaxs(1) axmins(2) axmaxs(2)]);

h1=arrow(p1,p2,'color',colors(3,:),'tipangle',atipangle,'length',alength,'width',awidth);
h2=arrow(p1,v1,'color',colors(4,:),'tipangle',atipangle,'length',alength,'width',awidth);
h3=arrow(p2,p2+v2rot,'color',colors(5,:),'tipangle',atipangle,'length',alength,'width',awidth);
h4=arrow(p1,a1,'color',colors(6,:),'tipangle',atipangle,'length',alength,'width',awidth);
h5=arrow(p2,p2+a2rot,'color',colors(7,:),'tipangle',atipangle,'length',alength,'width',awidth);
h6=plot(0,0,'o','linewidth',dronewidth,'color',colors(1,:));
h7=plot(p(1),p(2),'o','linewidth',dronewidth,'color',colors(2,:));
leg1= legend([h6,h7,h1,h2,h3,h4,h5],'drone 1','drone 2','$\mathbf{p}$','$\mathbf{v1}$','$\mathbf{v2}$','$\mathbf{a1}$','$\mathbf{a2}$','location',leg1loc);
xlabel('x','FontUnits','points','interpreter','latex','FontSize',fontsize,'FontName','Times');
ylabel('y','FontUnits','points','interpreter','latex','FontWeight','normal','FontSize',fontsize,'FontName','Times');
set(leg1,'Interpreter','latex');
set(leg1,'FontSize',fontsize);
if(printfigs)
    print(file,'-depsc2','-opengl');
end


xrange = 5;
yrange = 5;
dx = 0.03;
dy = 0.03;
dxtick = 2;
dytick = 2;

v1./v2rot
p

threshold = 1;
[X,Y,Z,Zcrit,xarr,yarr] = getHeatCond(state,input,xrange,yrange,threshold,dx,dy);

file = strcat('figures/cond_heatplot',num2str(rngnum),'.eps');

fontsize = 20;
h = figure('Renderer','painters');
set(gca,'FontSize',fontsize,...
    'FontUnits','points','FontWeight','normal','FontName','Times');
hold on;
axis([min(xarr) max(xarr) min(yarr) max(yarr)]);

surf(X,Y,Z,'EdgeColor','None');
view(2);
set(gca,'TickDir','out');
cb = colorbar;
hcrit = surf(X,Y,Zcrit*max(max(Z)),'EdgeColor','None','FaceColor','red');
t=get(cb,'Limits');
set(cb,'Ticks',round(linspace(t(1),t(2),5),0));
orp = plot3(p(1),p(2),max(max(Z)),'d','markersize',10,'MarkerEdgeColor','k','markerfacecolor','w');
leg = legend([hcrit,orp],'unobservable','original $\mathbf{p}$','location',leg2loc);
set(leg,'interpreter','latex','fontsize',fontsize);
xlabel('$p_x$ [m]','FontUnits','points','interpreter','latex','FontSize',fontsize,'FontName','Times');
ylabel('$p_y$ [m]','FontUnits','points','interpreter','latex','FontSize',fontsize,'FontName','Times');
if(printfigs)
    print(h,file,'-depsc2','-opengl');
end

