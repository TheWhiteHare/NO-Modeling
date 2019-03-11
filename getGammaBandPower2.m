function [NO_production] = getGammaBandPower(t,ii)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
% ii = 1;
% t = 5.01;
cd('C:\Users\wdh130\Documents\MATLAB\NOFeedbackData')



% lpFilt = designfilt('lowpassiir','FilterOrder',6, ...
%          'PassbandFrequency',0.45,'PassbandRipple',0.1, ...
%          'SampleRate',30);
%  fvtool(lpFilt)
 
 lpFilt = designfilt('lowpassfir','PassbandFrequency',0.35, ...
         'StopbandFrequency',0.7,'PassbandRipple',0.5, ...
         'StopbandAttenuation',65,'DesignMethod','kaiserwin','SampleRate',30);
fvtool(lpFilt)

% output = filter(lpFilt,y1);


duration = 300;
fs = 30;
Gam = wgn(1,fs*duration,2);
time = 1/fs:1/fs:length(Gam)/fs;
output = filter(lpFilt,Gam);

% figure(1), subplot(1,2,1), hold on
% plot(time,Gam)
% plot(time,output)
% subplot(1,2,2)
% pspectrum(output,fs)
% set(gca,'XScale','log','YScale','log');

interp_Gam = interp1(time,Gam,t,'spline');
NO_production = interp_Gam;
end

