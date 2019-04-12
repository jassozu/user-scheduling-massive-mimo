clear;
close all;
clc;

load('../results/rate_mf_M_500_K_5_MC_10000.mat');

M = 500;
K = 5;

% Ploting Figures

linewidth = 2;
fontname  = 'Times New Roman';
fontsize  = 20;

BIN_WIDTH_CDF  = 0.005;

BAR_SIZE = 0.4;

% NS - No selection
% RS - Random selection
% ICIBS - ICI-based selection

legend_text = {'NS', 'RS', 'ICIBS'};
location = 'northwest';

cat = categorical(legend_text);
cat = reordercats(cat,legend_text);

root_rate_fit = '../figures/rate/fit_';
root_erg_rate = '../figures/rate/erg_cap_';
root_out_prob = '../figures/rate/out_prob_';

colours = get(gca,'colororder');
close;

p_u = zeros(3,K);

psi_range = (0:0.01:0.4);

f_u = zeros(K,length(psi_range));

for k = 1:K
    curvefit = fit(psi(k,:)',rate_u(k,:)','poly2');
    
    p_u(1,k) = curvefit.p1;
    p_u(2,k) = curvefit.p2;
    p_u(3,k) = curvefit.p3;
    
    f_u(k,:) = p_u(1,k)*psi_range.^2 + p_u(2,k)*psi_range + p_u(3,k);
    
    figure;
    
    set(gcf,'position',[0 0 800 600]);
    
    plot(psi(k,:),rate_u(k,:),'.','color',colours(1,:),'linewidth',linewidth);
    hold on;
    plot(psi_range,f_u(k,:),'-','color',colours(2,:),'linewidth',linewidth);
    
    xlabel('Interchannel inteference','fontname',fontname,'fontsize',fontsize);
    ylabel('Uplink rate (b/s/Hz)','fontname',fontname,'fontsize',fontsize);
    
    legend({'Data','Fitted curve'},'fontname',fontname,'fontsize',fontsize);
    
    set(gca,'fontname',fontname,'fontsize',fontsize);
    
    xlim([0 0.4]);
    
    saveas(gcf,[root_rate_fit 'uplink_M_' num2str(M) '_' num2str(k) '_user'],'fig');
    saveas(gcf,[root_rate_fit 'uplink_M_' num2str(M) '_' num2str(k) '_user'],'png');
    saveas(gcf,[root_rate_fit 'uplink_M_' num2str(M) '_' num2str(k) '_user'],'epsc2');
end

p_d = zeros(3,K);

psi_range = (0:0.01:0.4);

f_d = zeros(K,length(psi_range));

for k = 1:K
    curvefit = fit(psi(k,:)',rate_d(k,:)','poly2');
    
    p_d(1,k) = curvefit.p1;
    p_d(2,k) = curvefit.p2;
    p_d(3,k) = curvefit.p3;
    
    f_d(k,:) = p_d(1,k)*psi_range.^2 + p_d(2,k)*psi_range + p_d(3,k);
    
    figure;
    
    set(gcf,'position',[0 0 800 600]);
    
    plot(psi(k,:),rate_d(k,:),'.','color',colours(1,:),'linewidth',linewidth);
    hold on;
    plot(psi_range,f_d(k,:),'-','color',colours(2,:),'linewidth',linewidth);
    
    xlabel('Interchannel inteference','fontname',fontname,'fontsize',fontsize);
    ylabel('Downlink rate (b/s/Hz)','fontname',fontname,'fontsize',fontsize);
    
    legend({'Data','Fitted curve'},'fontname',fontname,'fontsize',fontsize);
    
    set(gca,'fontname',fontname,'fontsize',fontsize);
    
    xlim([0 0.4]);
    
    saveas(gcf,[root_rate_fit 'downlink_M_' num2str(M) '_' num2str(k) '_user'],'fig');
    saveas(gcf,[root_rate_fit 'downlink_M_' num2str(M) '_' num2str(k) '_user'],'png');
    saveas(gcf,[root_rate_fit 'downlink_M_' num2str(M) '_' num2str(k) '_user'],'epsc2');
end

[values_u,edges_u]             = histcounts(sum(rate_u),'binwidth',BIN_WIDTH_CDF,'normalization','cdf');
[values_rs_u,edges_rs_u]       = histcounts(sum(rate_rs_u),'binwidth',BIN_WIDTH_CDF,'normalization','cdf');
[values_icibs_u,edges_icibs_u] = histcounts(sum(rate_icibs_u),'binwidth',BIN_WIDTH_CDF,'normalization','cdf');

figure;

set(gcf,'position',[0 0 800 600]);

plot(edges_u,[values_u 1],'-','color',colours(1,:),'linewidth',linewidth);
hold on;
plot(edges_rs_u,[values_rs_u 1],'-','color',colours(2,:),'linewidth',linewidth);
plot(edges_icibs_u,[values_icibs_u 1],'-','color',colours(3,:),'linewidth',linewidth);

xlabel('Uplink sum-rate (b/s/Hz)','fontname',fontname,'fontsize',fontsize);
ylabel('Outage probability','fontname',fontname,'fontsize',fontsize);

legend(legend_text,'fontname',fontname,'fontsize',fontsize,'location',location);

set(gca,'fontname',fontname,'fontsize',fontsize);

ylim([0 1]);

saveas(gcf,[root_out_prob 'uplink_sum_rate_M_' num2str(M) '_K_' num2str(K)],'fig');
saveas(gcf,[root_out_prob 'uplink_sum_rate_M_' num2str(M) '_K_' num2str(K)],'png');
saveas(gcf,[root_out_prob 'uplink_sum_rate_M_' num2str(M) '_K_' num2str(K)],'epsc2');

[values_d,edges_d]              = histcounts(sum(rate_d),'binwidth',BIN_WIDTH_CDF,'normalization','cdf');
[values_rs_d,edges_rs_d]        = histcounts(sum(rate_rs_d),'binwidth',BIN_WIDTH_CDF,'normalization','cdf');
[values_icibs_d, edges_icibs_d] = histcounts(sum(rate_icibs_d),'binwidth',BIN_WIDTH_CDF,'normalization','cdf');

figure;

set(gcf,'position',[0 0 800 600]);

plot(edges_d,[values_d 1],'-','color',colours(1,:),'linewidth',linewidth);
hold on;
plot(edges_rs_d,[values_rs_d 1],'-','color',colours(2,:),'linewidth',linewidth);
plot(edges_icibs_d,[values_icibs_d 1],'-','color',colours(3,:),'linewidth',linewidth);

xlabel('Downlink sum-rate (b/s/Hz)','fontname',fontname,'fontsize',fontsize);
ylabel('Outage probability','fontname',fontname,'fontsize',fontsize);

legend(legend_text,'fontname',fontname,'fontsize',fontsize,'location',location);

set(gca,'fontname',fontname,'fontsize',fontsize);

ylim([0 1]);

saveas(gcf,[root_out_prob 'downlink_sum_rate_M_' num2str(M) '_K_' num2str(K)],'fig');
saveas(gcf,[root_out_prob 'downlink_sum_rate_M_' num2str(M) '_K_' num2str(K)],'png');
saveas(gcf,[root_out_prob 'downlink_sum_rate_M_' num2str(M) '_K_' num2str(K)],'epsc2');

bar_sum_u = [sum(mean(rate_u,2)) sum(mean(rate_rs_u,2)) sum(mean(rate_icibs_u,2))];

figure;

set(gcf,'position',[0 0 800 600]);

bar(cat,bar_sum_u,BAR_SIZE);

xlabel('Algorithms','fontname',fontname,'fontsize',fontsize);
ylabel('Uplink average sum-rate (b/s/Hz)','fontname',fontname,'fontsize',fontsize);

set(gca,'fontname',fontname,'fontsize',fontsize);

saveas(gcf,[root_erg_rate 'uplink_sum_rate_M_' num2str(M) '_K_' num2str(K)],'fig');
saveas(gcf,[root_erg_rate 'uplink_sum_rate_M_' num2str(M) '_K_' num2str(K)],'png');
saveas(gcf,[root_erg_rate 'uplink_sum_rate_M_' num2str(M) '_K_' num2str(K)],'epsc2');

bar_sum_d = [sum(mean(rate_d,2)) sum(mean(rate_rs_d,2)) sum(mean(rate_icibs_d,2))];

figure;

set(gcf,'position',[0 0 800 600]);

bar(cat,bar_sum_d,BAR_SIZE);

xlabel('Algorithms','fontname',fontname,'fontsize',fontsize);
ylabel('Downlink average sum-rate (b/s/Hz)','fontname',fontname,'fontsize',fontsize);

set(gca,'fontname',fontname,'fontsize',fontsize);

saveas(gcf,[root_erg_rate 'downlink_sum_rate_M_' num2str(M) '_K_' num2str(K)],'fig');
saveas(gcf,[root_erg_rate 'downlink_sum_rate_M_' num2str(M) '_K_' num2str(K)],'png');
saveas(gcf,[root_erg_rate 'downlink_sum_rate_M_' num2str(M) '_K_' num2str(K)],'epsc2');

[values_u,edges_u]             = histcounts(mean(rate_u),'binwidth',BIN_WIDTH_CDF,'normalization','cdf');
[values_rs_u,edges_rs_u]       = histcounts(mean(rate_rs_u),'binwidth',BIN_WIDTH_CDF,'normalization','cdf');
[values_icibs_u,edges_icibs_u] = histcounts(mean(rate_icibs_u),'binwidth',BIN_WIDTH_CDF,'normalization','cdf');

figure;

set(gcf,'position',[0 0 800 600]);

plot(edges_u,[values_u 1],'-','color',colours(1,:),'linewidth',linewidth);
hold on;
plot(edges_rs_u,[values_rs_u 1],'-','color',colours(2,:),'linewidth',linewidth);
plot(edges_icibs_u,[values_icibs_u 1],'-','color',colours(3,:),'linewidth',linewidth);

xlabel('Uplink rate per terminal (b/s/Hz)','fontname',fontname,'fontsize',fontsize);
ylabel('Outage probability','fontname',fontname,'fontsize',fontsize);

legend(legend_text,'fontname',fontname,'fontsize',fontsize,'location',location);

set(gca,'fontname',fontname,'fontsize',fontsize);

ylim([0 1]);

saveas(gcf,[root_out_prob 'uplink_avg_rate_ter_M_' num2str(M) '_K_' num2str(K)],'fig');
saveas(gcf,[root_out_prob 'uplink_avg_rate_ter_M_' num2str(M) '_K_' num2str(K)],'png');
saveas(gcf,[root_out_prob 'uplink_avg_rate_ter_M_' num2str(M) '_K_' num2str(K)],'epsc2');

[values_d, edges_d]             = histcounts(mean(rate_d),'binwidth',BIN_WIDTH_CDF,'normalization','cdf');
[values_rs_d, edges_rs_d]       = histcounts(mean(rate_rs_d),'binwidth',BIN_WIDTH_CDF,'normalization','cdf');
[values_icibs_d, edges_icibs_d] = histcounts(mean(rate_icibs_d),'binwidth',BIN_WIDTH_CDF,'normalization','cdf');

figure;

set(gcf,'position',[0 0 800 600]);

plot(edges_d,[values_d 1],'-','color',colours(1,:),'linewidth',linewidth);
hold on;
plot(edges_rs_d,[values_rs_d 1],'-','color',colours(2,:),'linewidth',linewidth);
plot(edges_icibs_d,[values_icibs_d 1],'-','color',colours(3,:),'linewidth',linewidth);

xlabel('Downlink rate per terminal (b/s/Hz)','fontname',fontname,'fontsize',fontsize);
ylabel('Outage probability','fontname',fontname,'fontsize',fontsize);

legend(legend_text,'fontname',fontname,'fontsize',fontsize,'location',location);

set(gca,'fontname',fontname,'fontsize',fontsize);

ylim([0 1]);

saveas(gcf,[root_out_prob 'downlink_avg_rate_ter_M_' num2str(M) '_K_' num2str(K)],'fig');
saveas(gcf,[root_out_prob 'downlink_avg_rate_ter_M_' num2str(M) '_K_' num2str(K)],'png');
saveas(gcf,[root_out_prob 'downlink_avg_rate_ter_M_' num2str(M) '_K_' num2str(K)],'epsc2');

bar_u = [mean(mean(rate_u,2)) mean(mean(rate_rs_u,2)) mean(mean(rate_icibs_u,2))];

figure;

set(gcf,'position',[0 0 800 600]);

bar(cat,bar_u,BAR_SIZE);

xlabel('Algorithms','fontname',fontname,'fontsize',fontsize);
ylabel('Uplink average rate per terminal (b/s/Hz)','fontname',fontname,'fontsize',fontsize);

set(gca,'fontname',fontname,'fontsize',fontsize);

saveas(gcf,[root_erg_rate 'uplink_avg_rate_ter_M_' num2str(M) '_K_' num2str(K)],'fig');
saveas(gcf,[root_erg_rate 'uplink_avg_rate_ter_M_' num2str(M) '_K_' num2str(K)],'png');
saveas(gcf,[root_erg_rate 'uplink_avg_rate_ter_M_' num2str(M) '_K_' num2str(K)],'epsc2');

bar_d = [mean(mean(rate_d,2)) mean(mean(rate_rs_d,2)) mean(mean(rate_icibs_d,2))];

figure;

set(gcf,'position',[0 0 800 600]);

bar(cat,bar_d,BAR_SIZE);

xlabel('Algorithms','fontname',fontname,'fontsize',fontsize);
ylabel('Downlink average rate per terminal (b/s/Hz)','fontname',fontname,'fontsize',fontsize);

set(gca,'fontname',fontname,'fontsize',fontsize);

saveas(gcf,[root_erg_rate 'downlink_avg_rate_ter_M_' num2str(M) '_K_' num2str(K)],'fig');
saveas(gcf,[root_erg_rate 'downlink_avg_rate_ter_M_' num2str(M) '_K_' num2str(K)],'png');
saveas(gcf,[root_erg_rate 'downlink_avg_rate_ter_M_' num2str(M) '_K_' num2str(K)],'epsc2');