function [ ] = plotEffectOfNOsens( input )
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
NO_sens = [1 3 5];
LineColor = {[166,189,219]./256,[54,144,192]./256,[1,100,80]./256};

figure, 
% plot the extracted HRF___________________________________________________
subplot(6,2,[2 4 6]), hold on
for jj = 1:length(NO_sens)
    for ii = 1:size(input.NOx3.HRF,1)
        plot(time,input.(['NOx' num2str(NO_sens(jj))]).HRF(ii,:),'Color',[LineColor{jj} 1/5])
    end
    h1{jj} = plot(time,mean(input.(['NOx' num2str(NO_sens(jj))]).HRF,1),'Color',[LineColor{jj}],'LineWidth',3);
    
    %std_dev = std(input.(['NOx' num2str(NO_sens(jj))]).HRF);
    %high = mean(input.(['NOx' num2str(NO_sens(jj))]).HRF(ii,:),1)+std_dev;
    %low = mean(input.(['NOx' num2str(NO_sens(jj))]).HRF(ii,:),1)-std_dev;
    %[p_h] = prctile(input.(['NOx' num2str(NO_sens(jj))]).HRF,[2.5 97.5]);
    
    %f1{jj} = fill([time flip(time)],[low flip(high)],'k','LineStyle','none');
    %f1{jj} = fill([time flip(time)],[p_h(1,:) flip(p_h(2,:))],'k','LineStyle','none');
    %set(f1{jj},'facea',[1/10]);
    %set(f1{jj},'facec',[LineColor{jj}(1:3)]);
end
axis([0 10 -5 10])
legend([h1{1} h1{2} h1{3}],{'NOx1','NOx3','NOx5'})
xlabel('time (s)')
ylabel('a.u.')
title('hemodynamics response function')

% plot the power spectrum__________________________________________________
subplot(6,2,[8 10 12]), hold on
Hz = input.NOx1.spectrumHz(1,:);

for jj = 1:length(NO_sens)
    for ii = 1:size(input.NOx3.spectrumPower,1)
        plot(Hz,input.(['NOx' num2str(NO_sens(jj))]).spectrumPower(ii,:),'Color',[LineColor{jj} 1/5])
    end
    h1{jj} = plot(Hz,mean(input.(['NOx' num2str(NO_sens(jj))]).spectrumPower,1),'Color',[LineColor{jj}],'LineWidth',3);
    
    std_dev = std(input.(['NOx' num2str(NO_sens(jj))]).spectrumPower);
    high = mean(input.(['NOx' num2str(NO_sens(jj))]).spectrumPower(ii,:),1)+std_dev;
    low = mean(input.(['NOx' num2str(NO_sens(jj))]).spectrumPower(ii,:),1)-std_dev;
    %[p_h] = prctile(input.(['NOx' num2str(NO_sens(jj))]).HRF,[2.5 97.5]);
    
    %f1{jj} = fill([Hz flip(Hz)],[low flip(high)],'k','LineStyle','none');
    %f1{jj} = fill([time flip(time)],[p_h(1,:) flip(p_h(2,:))],'k','LineStyle','none');
    %set(f1{jj},'facea',[5/10]);
    %set(f1{jj},'facec',[LineColor{jj}(1:3)]);
end
%legend([h1{1} h1{2} h1{3}],{'NOx1','NOx3','NOx5'})
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
for jj = 1:length(NO_sens)
notBoxPlot([input.(['NOx' num2str(NO_sens(jj))]).variance],[ones(1,10).*jj])
end
set(gca,'XTick',[1 2 3])
set(gca,'XTickLabels',{'NOx1','NOx3','NOx5'})
ylabel('variance')
title('baseline vasodynamics')
ylim([0 1])

% plot example vasodynamics
time_all = [15:dt:285];
subplot(6,2,[5 7]), hold on
for jj = 1:length(NO_sens)
    plot(time_all,input.(['NOx' num2str(NO_sens(jj))]).dilation(1,:),'Color',[LineColor{jj}(1:3) 1],'LineWidth',2)
end
xlabel('time (s)')
ylabel('\Deltavessel diameter')
title('example trial vasodynamics')
%legend({'NOx1','NOx3','NOx5'})
xlim([140 200])
ylim([-2 2])



end