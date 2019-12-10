init;

% noisy data has: noise_a_1_r_0_05_v_0_2_yaw_0_2_z_0_2
datafolder = 'data/';
filename = 'storeresmat_circle_noyaw_std';
printfigs = true;
fontsize = 16;
linewidth=2.5;
load([datafolder,filename,'.mat']);

noises = [0,0.1,0.25,0.5,1,2,4,8];
percent = ((storeres(2,:)-storeres(1,:))./storeres(1,:))*100;

file = strcat(filename,'_abs.eps');
lim = 2.4;
h = figure;
set(gca,'XTick',0:8,'YTick',0:0.2:lim,'FontSize',fontsize,'FontUnits','points','FontWeight','normal','FontName','Times');
hold on;
grid on;
e1 = errorbar(noises,storeres(1,:),storestd(1,:),'-o' ,'linewidth',linewidth);
e2 = errorbar(noises,storeres(2,:),storestd(2,:),'--o','linewidth',linewidth);
e1.CapSize = 20;
e2.CapSize = 20;
axis([0 8 0 lim]);
xlabel('Range noise $\sigma_R$ [m]','FontUnits','points','interpreter','latex','FontSize',fontsize,'FontName','Times');
ylabel('AMAE [m]','FontUnits','points','interpreter','latex','FontWeight','normal','FontSize',fontsize,'FontName','Times');
leg1 = legend('$\sum{_1}$','$\sum{_2}$','location','northwest');
set(leg1,'Interpreter','latex');
set(leg1,'FontSize',fontsize);
if (printfigs)
    print(file,'-depsc2');
end
