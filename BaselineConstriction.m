close all
clear
clc

l = 0;

% shows that 0.005 tolerance and lower resolution solution is just as good
% as higher resolution (v7 is low)
%RBC_core = {'With1Hgb_v6','With1Hgb_v7'} t_end = 180


clear WF m_f m_fr
dt = 0.01;
LineColor = {[1 0 0],[0 0 0],[1 0 1],[0 0 1/2],[1 0 0],[0 0 0],[1 0 1],[0 0 1/2],[0 0 0],[1 0 1],[0 0 1/2]};
g_max = 80;
Hgb = [0 1 5 10 15 20 25 30 35 40];

for RBC_core = Hgb
    l = l + 1;
time = [5+100*(l-1):dt:98+100*(l-1)];
hold_data = importdata(['2NO_0NOd_3NOsens_50bGC_1081Hz_10VD_6sNOkernel_GammaWith' num2str(RBC_core) 'Hgb_v8.csv']);

g = 1;
[a index] = unique(hold_data(:,1));
hold_data = hold_data(index,:); %don't take replicate values
WF{1,g} = interp1(hold_data(:,1),hold_data(:,2),time')'; %concentration
WF{2,g} = interp1(hold_data(:,1),hold_data(:,3),time')'; %dilation

c{l}(g,:) = WF{1,g};
m{l}(g,:) = WF{2,g};


figure(l)
title([num2str(RBC_core) ' \muM pfHgb'])
subplot(2,1,1), hold on, plot(time,movmean(c{l}(g,:),25),'Color',[LineColor{l} 1],'LineWidth',2)
title('Concentration [nM]'),xlabel('time [s]'), ylabel('NO in smooth muscle'),%axis([6 30 5 20])

subplot(2,1,2), hold on, plot(time,m{l}(g,:),'Color',[LineColor{l} 1],'LineWidth',2),%axis([6 30 -5 40])
title('Vessel Response'),xlabel('time [s]'), ylabel('\DeltaVessel Diameter [%]')
title([num2str(RBC_core) ' \muM pfHgb'])
clear WF m_f m_fr
end

baseline = cell2mat(cellfun(@mean,m,'UniformOutput',0));
baseline_std = cell2mat(cellfun(@std,m,'UniformOutput',0));

baseline_top = baseline + baseline_std;
baseline_bottom = baseline - baseline_std;

figure, hold on
plot(Hgb,baseline,'k')
h = fill([Hgb flip(Hgb)],[baseline_top flip(baseline_bottom)],'k','LineStyle','none')
set(h,'facea',0.1)
xlabel('plasma free Hemoglobin (\muM)')
ylabel('\Delta vessel diameter (%)')
title('')
