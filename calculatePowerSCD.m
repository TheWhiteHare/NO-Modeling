% 
% l = 0;
% 
% NO_sens = [3 5 10];
% time_end = [30 30 50];
% clear WF m_f m_fr
% dt = 0.01;
% LineColor = {[1 0 0],[0 0 1]};
% 
% for RBC_core = {'Band','With20SCD'}
%     l = l + 1;
% for g = 1:10
% time = [15:dt:300];
% hold_data = importdata(['2NO_0NOd_3NOsens_50bGC_10' num2str(g) 'Hz_10VD_6sNOkernel_Gamma' RBC_core{1,1} '.csv']);
% [a index] = unique(hold_data(:,1));
% hold_data = hold_data(index,:); %don't take replicate values
% WF{1,g} = interp1(hold_data(:,1),hold_data(:,2),time')'; %concentration
% WF{2,g} = interp1(hold_data(:,1),hold_data(:,3),time')'; %dilation
% 
% m{l}(g,:) = WF{2,g};
% %m = m(1*fs:end);
% 
% 
% figure(14)
% subplot(2,2,1), hold on, plot(time(3:end),movmean(WF{1,g}(3:end),25),'Color',[LineColor{l} 1/10],'LineWidth',2)
% title('Concentration [nM]'),xlabel('time [s]'), ylabel('NO in smooth muscle'),%axis([6 30 5 20])
% 
% subplot(2,2,3), hold on, plot(time,m{l}(g,:),'Color',[LineColor{l} 1/10],'LineWidth',2),%axis([6 30 -5 40])
% title('Vessel Response'),xlabel('time [s]'), ylabel('\DeltaVessel Diameter [%]')
% 
%     params.Fs = 1/dt;
%     params.tapers = [5 9];
%     params.fpass = [0.025 3];
%     params.err = [2 0.05];
%     params.ave = 1;
%     
%     m{l}(g,:) = detrend(m{l}(g,:));
% subplot(2,2,[2 4]), hold on
% [m_f{g,l},m_fr{g,l} Serr{g,l}] = mtspectrumc(m{l}(g,:),params);
% m_f{g,l} = m_f{g,l}';
% loglog(m_fr{g,l},m_f{g,l}','Color',[LineColor{l} 1/20],'Linewidth',2);
% set(gca,'XScale','log','YScale','log');
% legend('WGN dynamic','WGN static','real gamma dynamic','real gamma static RBC core')
% title('vessel response from gamma band')
% xlabel('frequency [Hz]')
% ylabel('Power')
% end
% end
% RBC_core_avg_f = mean(cell2mat(m_f),1);
% hold_data = cell2mat(m_f);
% hold_data = hold_data(1:975);
% SEM = std(hold_data)/sqrt(length(hold_data));
% 
% hold on
% loglog(m_fr{g,l},RBC_core_avg_f(1:975),'Color',[LineColor{1}],'Linewidth',2);
% % loglog(m_fr{g,l},RBC_core_avg_f(1:975)-SEM,'Color',[LineColor{1}],'Linewidth',2);
% % loglog(m_fr{g,l},RBC_core_avg_f(1:975)+SEM,'Color',[LineColor{1}],'Linewidth',2);
% 
% hold_data = cell2mat(m_f);
% hold_data = hold_data(975:end);
% SEM = std(hold_data)/sqrt(length(hold_data));
% 
% 
% 
% loglog(m_fr{g,l},RBC_core_avg_f(976:end),'Color',[LineColor{2}],'Linewidth',2);
% 
% %%
% 
% clear m_fr2 m_f2 Serr2 params bootstat bootsam pctls
% 
% params.Fs = 1/dt;
% params.tapers = [1 1];
% params.fpass = [0.05 3];
%     
% [m_fr2,m_f2] = mtspectrumc(m{1}',params);
% 
% for ii = 1:size(m_fr2,1)
%     [bootstat{ii},bootsam{ii}] = bootstrp(1000, @mean, m_fr2(ii,:));
%     m_fr_boot(ii) = mean(bootstat{ii});
%     [pctls(ii,:)] = prctile(bootstat{ii},[2.5 97.5]);%get %tiles from the resampled data
% end
% 
% figure, hold on
% h1 = plot(m_f2, m_fr_boot,'r','LineWidth',2)
% f1 = fill([m_f2 flip(m_f2)],[pctls(:,1)' flip(pctls(:,2))'],'r','LineStyle','none');
% set(f1,'facea',1/5)
% 
% clear m_fr2 m_f2 Serr2 params bootstat bootsam pctls
% 
% params.Fs = 1/dt;
% params.tapers = [1 1];
% params.fpass = [0.05 3];
% [m_fr2,m_f2] = mtspectrumc(m{2}',params);
% 
% for ii = 1:size(m_fr2,1)
%     [bootstat{ii},bootsam{ii}] = bootstrp(1000, @mean, m_fr2(ii,:));
%     m_fr_boot(ii) = mean(bootstat{ii});
%     [pctls(ii,:)] = prctile(bootstat{ii},[2.5 97.5]);%get %tiles from the resampled data
% end
% 
% hold on
% h2 = plot(m_f2, m_fr_boot,'m','LineWidth',2)
% f2 = fill([m_f2 flip(m_f2)],[pctls(:,1)' flip(pctls(:,2))'],'m','LineStyle','none');
% set(f2,'facea',1/5)
% 
% set(gca,'YScale','log','XScale','log')
% xlim([0.05 1])
% xlabel('frequency (Hz)')
% ylabel('Power')
% legend([h1 h2],'dynamic RBC core','static RBC core')
% axis square
% title('vessel response from WGN (1:40 min)')

%%
clear
clc

hold_data = importdata('Day_data_Davis.xlsx');
%hold_data.textdata(find(~cellfun(@isempty,hold_data.textdata)))

ii = 1;
for xx = 1:17
    for yy = 2:17
        if ~isempty(hold_data.textdata{yy,xx})
            f_name{ii} = [hold_data.textdata{yy,18} hold_data.textdata{yy,xx} '_S.mat'];
            ii = ii + 1;
        else
        end
    end
end


find(strcmp(f_name, 'CE171115_171118_017_S.mat'))
find(strcmp(f_name, 'CE171115_171120_017_S.mat'))
find(strcmp(f_name, 'CE171115_171121_017_S.mat'))
find(strcmp(f_name, 'CE171115_171127_017_S.mat'))
find(strcmp(f_name, 'CE171115_171128_017_S.mat'))
find(strcmp(f_name, 'CE171115_171129_017_S.mat'))
find(strcmp(f_name, 'CE171115_171130_017_S.mat'))




cellfun(@(x) find(x == 'CE171115_171118_015_S.mat'),f_name,'UniformOutput',0)

    %params.Fs = 1/dt;
    params.tapers = [1 1];
    trial_hold = importdata(f_name{1});
    params.Fs = trial_hold.frame_rate;
    params.fpass = [0.01 (params.Fs/2)];
figure, hold on
for ii = [2 17 25 43 44 49 52] %1:52%length(f_name)
    trial_hold = importdata(f_name{ii});
    diameter_hold{ii} = trial_hold.Vessel.diameter_norm;
    %diameter{ii} = trial_hold.Vessel.diamperc_stand_seg;
    %diameter_hold{ii} = trial_hold.Vessel.diamperc_run_seg_average;
    %diameter_hold{ii} = trial_hold.Vessel.diamperc_run_seg(1,:);
    %diameter{ii} = trial_hold.Vessel.raw_diameter;
    %diameter{ii} = detrend(diameter{ii});
    
    fc = 1;
    Wn = fc/(params.Fs/2);
    [b,a] = butter(6,Wn);
    diameter{ii} = filtfilt(b,a,diameter_hold{ii})';
    
    %params.Fs = trial_hold.frame_rate;
    %params.fpass = [0.01 (params.Fs/2)];
    
    [P{ii},fr{ii}] = mtspectrumc(diameter{ii},params);
    plot(fr{ii},P{ii},'Color',[0 0 0 1/10]);
end

P{30} = [];
empties = find(cellfun(@isempty,P)); % identify the empty cells
P(empties) = [];       

for ii = 1:size(P{1},1) %power at each frequency
    hold_P = cell2mat(cellfun(@(x) x(ii),P,'UniformOutput',0));
    hold_P(isnan(hold_P))= [];
    [bootstat{ii},bootsam{ii}] = bootstrp(1000, @mean, hold_P);
    f_boot(ii) = mean(bootstat{ii});
    [pctls(ii,:)] = prctile(bootstat{ii},[2.5 97.5]);%get %tiles from the resampled data
end

figure, hold on
h1 = plot(fr{10}, f_boot,'k','LineWidth',2);
f1 = fill([fr{10} flip(fr{10})],[pctls(:,1)' flip(pctls(:,2))'],'k','LineStyle','none');
set(f1,'facea',1/5);
set(gca,'YScale','log','XScale','linear');





figure, hold on
t = [1/8.1:1/8.1:length(diameter{1})/8.1];
d = movmean(diameter{1},1);
plot(t,d,'k')







% horzcat(1,hold_data.textdata{2,:})
% 
% 
% hold_data.textdata(find(~cellfun(@isempty,hold_data.textdata)))
% 
% cellfun(@horzcat, hold_data.textdata, DD, 'UniformOutput',false)
% 
% hold_data.textdata{a,b}
% 
% hold_data.textdata(find(isempty(hold_data.textdata)))







