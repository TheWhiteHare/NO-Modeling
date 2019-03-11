function [NO_production] = getGammaBandPowerWGN(t,ii)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
% ii = 1;
% t = 5.01;
cd('C:\Users\wdh130\Documents\MATLAB\NOFeedbackData')



% lpFilt = designfilt('lowpassiir','FilterOrder',6, ...
%          'PassbandFrequency',0.45,'PassbandRipple',0.1, ...
%          'SampleRate',30);
%  fvtool(lpFilt)
 if t <= 0
     NO_production = 0;
 else
 lpFilt = designfilt('lowpassfir','PassbandFrequency',0.35, ...
         'StopbandFrequency',0.7,'PassbandRipple',0.5, ...
         'StopbandAttenuation',65,'DesignMethod','kaiserwin','SampleRate',30);
% fvtool(lpFilt)

% output = filter(lpFilt,y1);

  fs = 30;
% duration = 330;
% Gam = wgn(1,fs*duration,2);
% Gam = sqrt(Gam.^2);
% Gam = Gam - mean(Gam);
% Gam = Gam - min(Gam)
% output = filter(lpFilt,Gam);
% %Gam = (Gam + min(Gam))/min(Gam)
% fileID = fopen('GammaBandPower_WGN.csv','a');
% fprintf(fileID,'%f\n',[output]);
% fclose(fileID);

output = importdata(['GammaBandPower_WGN.csv']);
time = 0:1/fs:(length(output)/fs-1/fs);
% output = filter(lpFilt,Gam);
%  
% figure(1), subplot(1,2,1),axis square, hold on
% plot(time,Gam,'k','LineWidth',2)
% plot(time,output,'r','LineWidth',2)
% subplot(1,2,2)
% pspectrum(Gam,fs), hold on
% pspectrum(output,fs)
% set(gca,'XScale','log','YScale','log');
% h1 = findobj(gca, 'Type', 'Line')
% set(h1(1), 'LineWidth', 2);
% set(h1(1), 'Color', [1 0 0]);
% set(h1(2), 'LineWidth', 2);
% set(h1(2), 'Color', [0 0 0]);
% set(gcf, 'Color', [1 1 1])
% axis square

interp_Gam = interp1(time,output,t,'spline');
NO_production = interp_Gam;
 end
end

