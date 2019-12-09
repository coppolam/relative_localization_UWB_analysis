% rng(4);
addpath('../Figure_handling');
n = 7;
l = 6;
state0 = [1;1;0;2;3;1.2;1.6];
input0 = [3;4;4;2;0;0];
x0 = [state0;input0];

v1range = 5;
v2range =5;
prange = 5;
a1range = 3;
a2range = 3;
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



[x,fval] = giveUnobservable(drawstate,drawinput,4);

state = x(1:length(state0));
input = x(length(state0)+1:length(state0)+length(input0));
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

v1
v2rot
v1./v2rot
(v1+a1)./(v2rot+a2rot)

axcomp = [[0; 0] p v1 p+v2rot a1 p+a2rot];
axmins = min(axcomp,[],2);
axmins = floor(axmins-1);
axmaxs = max(axcomp,[],2);
axmaxs = ceil(axmaxs);



atipangle = 30;
alength = 15;
awidth = 2;
dronewidth = 5;

printfigs = false;

p1 = [0;0];
p2 = p;
% h= figure;
% colors = get(gca,'ColorOrder');
% hold on;
% axis([axmins(1) axmaxs(1) axmins(2) axmaxs(2)]);
% h1=arrow(p1,p2,'color',colors(1,:),'tipangle',atipangle,'length',alength,'width',awidth);
% h2=arrow(p1,v1,'color',colors(2,:),'tipangle',atipangle,'length',alength,'width',awidth);
% h3=arrow(p2,p2+v2rot,'color',colors(4,:),'tipangle',atipangle,'length',alength,'width',awidth);
% h4=arrow(p1,a1,'color',colors(3,:),'tipangle',atipangle,'length',alength,'width',awidth);
% h5=arrow(p2,p2+a2rot,'color',colors(5,:),'tipangle',atipangle,'length',alength,'width',awidth);
% h6=plot(0,0,'o','linewidth',dronewidth,'color',colors(6,:));
% h7=plot(p(1),p(2),'o','linewidth',dronewidth,'color',colors(7,:));
% legend([h6,h7,h1,h2,h3,h4,h5],'drone 1','drone 2','p','v1','v2','a1','a2','location','best');

file = strcat('C:\Users\Steven\Dropbox\Thesis\Figures\Observability\cond4_vectplot2.eps');
fontsize = 16;
h=figure;
colors = get(gca,'ColorOrder');
set(gca,'XTick',axmins(1):axmaxs(1),'YTick',axmins(2):axmaxs(2),'FontSize',fontsize,'FontUnits','points','FontWeight','normal','FontName','Times','Position',[0.13 0.13 0.8 0.8]);
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
leg1= legend([h6,h7,h1,h2,h3,h4,h5],'drone 1','drone 2','$\mathbf{p}$','$\mathbf{v1}$','$\mathbf{v2}$','$\mathbf{a1}$','$\mathbf{a2}$','location','best');
xlabel('$x$','FontUnits','points','interpreter','latex','FontSize',fontsize,'FontName','Times');
ylabel('$y$','FontUnits','points','interpreter','latex','FontWeight','normal','FontSize',fontsize,'FontName','Times');
set(leg1,'Interpreter','latex');
set(leg1,'FontSize',fontsize);
if(printfigs)
    print(file,'-depsc2');
end

dxplot = 1;
dyplot = 1;
dx = 0.01;
dy = 0.01;
xr = 1;
yr = 1;
xrange = p(1)-xr:dx:p(1)+xr;
yrange = p(2)-yr:dy:p(2)+yr;

threshold = 0.1;
[X,Y,Z,Zcrit] = getHeatCond4(state,input,xrange,yrange,threshold);

h = figure('Renderer','painters');
% set(gca,'XTick',xrange(1):dxplot:xrange(2),...
%     'YTick',yrange(1):dyplot:yrange(2),...
%     'FontSize',fontsize,...
%     'FontUnits','points','FontWeight','normal','FontName','Times');
hold on;
% axis([-xrange xrange -yrange yrange]);
% set(gca,'XTick',-5:5);
% colormap([1 0 0;0 0 1]) %red and blue
surf(X,Y,Z,'EdgeColor','None');
view(2)
cb = colorbar;
hcrit = surf(X,Y,Zcrit,'EdgeColor','None','FaceColor','red');
t=get(cb,'Limits');
set(cb,'Ticks',round(linspace(t(1),t(2),5),2));
legend(hcrit,'unobservable','location','northwest');
xlabel('x [m]','FontUnits','points','interpreter','latex','FontSize',fontsize,'FontName','Times');
ylabel('y [m]','FontUnits','points','interpreter','latex','FontSize',fontsize,'FontName','Times');


