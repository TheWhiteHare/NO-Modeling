function [ ] = plotEffectOfHct( input )
%________________________________________________________________________________________________________________________
% Written by W. Davis Haselden
% M.D./Ph.D. Candidate, Department of Neuroscience
% The Pennsylvania State University & Herhsey College of Medicine
%________________________________________________________________________________________________________________________
%
%   Purpose: Show an example vasodilation at different NO sensitivities.
%   Calculate the variance, HRF, and power spectrum for different NO
%   sensitivities.
%________________________________________________________________________________________________________________________
%
%
%   Input: 
%       input.(NOx1/NOx3/NOx5).NO_production
%       input.(NOx1/NOx3/NOx5).concentration
%       input.(NOx1/NOx3/NOx5).dilation
%       input.(NOx1/NOx3/NOx5).variance
%       input.(NOx1/NOx3/NOx5).HRF
%       input.(NOx1/NOx3/NOx5).spectrumPower
%       input.(NOx1/NOx3/NOx5).spectrumHz
%   a 1% change in GC activation causes a 1%, 3%, or 5% change in vessel diameter (NOx1/NOx3/NOx5)   
%   
%   Output: plot examples dilations, variance,HRF, and spectrogram of NO
%   sensitivity manipulations
%________________________________________________________________________________________________________________________


dt = 1/6;
time = [0:dt:10];
Hct = [20 45 60];
LineColor = {[252,146,114]./256,[239,59,44]./256,[153,0,13]./256};

figure, 
% plot the extracted HRF___________________________________________________
subplot(6,2,[2 4 6]), hold on
for jj = 1:length(Hct)
    for ii = 1:size(input.Hct20.HRF,1)
        plot(time,input.(['Hct' num2str(Hct(jj))]).HRF(ii,:),'Color',[LineColor{jj} 1/5])
    end
    h1{jj} = plot(time,mean(input.(['Hct' num2str(Hct(jj))]).HRF,1),'Color',[LineColor{jj}],'LineWidth',3);
    
    %std_dev = std(input.(['pfHgb' num2str(pfHgb(jj)) 'uM']).HRF);
    %high = mean(input.(['pfHgb' num2str(pfHgb(jj)) 'uM']).HRF(ii,:),1)+std_dev;
    %low = mean(input.(['pfHgb' num2str(pfHgb(jj)) 'uM']).HRF(ii,:),1)-std_dev;
    %[p_h] = prctile(input.(['pfHgb' num2str(pfHgb(jj)) 'uM']).HRF,[2.5 97.5]);
    
    %f1{jj} = fill([time flip(time)],[low flip(high)],'k','LineStyle','none');
    %f1{jj} = fill([time flip(time)],[p_h(1,:) flip(p_h(2,:))],'k','LineStyle','none');
    %set(f1{jj},'facea',[1/10]);
    %set(f1{jj},'facec',[LineColor{jj}(1:3)]);
end
%xlim([0.1 9.5])
%ylim([-0.4 0.7])
legend([h1{1} h1{2} h1{3}],{'pfHgb1','pfHgb3','pfHgb5'})
xlabel('time (s)')
ylabel('a.u.')
title('hemodynamics response function')

% plot the power spectrum__________________________________________________
subplot(6,2,[8 10 12]), hold on
Hz = input.Hct20.spectrumHz(1,:);

for jj = 1:length(Hct)
    for ii = 1:size(input.Hct20.spectrumPower,1)
        plot(Hz,input.(['Hct' num2str(Hct(jj))]).spectrumPower(ii,:),'Color',[LineColor{jj} 1/5])
    end
    h1{jj} = plot(Hz,mean(input.(['Hct' num2str(Hct(jj))]).spectrumPower,1),'Color',[LineColor{jj}],'LineWidth',3);
    
    std_dev = std(input.(['Hct' num2str(Hct(jj))]).spectrumPower);
    high = mean(input.(['Hct' num2str(Hct(jj))]).spectrumPower(ii,:),1)+std_dev;
    low = mean(input.(['Hct' num2str(Hct(jj))]).spectrumPower(ii,:),1)-std_dev;
    %[p_h] = prctile(input.(['pfHgb' num2str(pfHgb(jj)) 'uM']).HRF,[2.5 97.5]);
    
    %f1{jj} = fill([Hz flip(Hz)],[low flip(high)],'k','LineStyle','none');
    %f1{jj} = fill([time flip(time)],[p_h(1,:) flip(p_h(2,:))],'k','LineStyle','none');
    %set(f1{jj},'facea',[5/10]);
    %set(f1{jj},'facec',[LineColor{jj}(1:3)]);
end
%legend([h1{1} h1{2} h1{3}],{'pfHgb1','pfHgb20','pfHgb40'})
set(gca, 'YMinorTick','on')
set(gca,'XScale','log','YScale','log')
xlim([0.025 3])
ylim([10^-8 10])
xlabel('frequency (Hz)')
ylabel('Power')
title('vasodynamics')
yt=[0.01:0.01:0.09 0.1:0.1:0.9 1];
set(gca,'xtick',yt)
set(gca,'xminorgrid','on')

% plot the variance in the baseline vessel diameter________________________
subplot(6,2,[9 11]), hold on
for jj = 1:length(Hct)
notBoxPlot([input.(['Hct' num2str(Hct(jj))]).variance],[ones(1,7).*jj])
end
set(gca,'XTick',[1 2 3])
set(gca,'XTickLabels',{'pfHgb1','pfHgb20','pfHgb40'})
ylabel('variance')
title('baseline vasodynamics')
ylim([0 1])

% plot example vasodynamics
time_all = [15:dt:300];
subplot(6,2,[5 7]), hold on
for jj = 1:length(Hct)
    plot(time_all,input.(['Hct' num2str(Hct(jj))]).dilation(1,:),'Color',[LineColor{jj}(1:3) 1],'LineWidth',2)
end
xlabel('time (s)')
ylabel('\Deltavessel diameter')
title('example trial vasodynamics')
legend({'pfHgb1','pfHgb20','pfHgb40'})
xlim([140 200])
ylim([-2 2])

% % plot the change in baseline diameter from increased pfHgb
% subplot(6,2,[1 3]), hold on
% plot(input.Hgb,input.baseline_diameter,'r','LineWidth',3)
% xlabel('plasma free Hemoglobin (\muM)')
% ylabel('\Deltabaseline diameter (%)')
% title('increased pfHgb decreases vessel diameter')
