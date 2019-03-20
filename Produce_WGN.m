
clear h1 

lpFilt = designfilt('lowpassfir','PassbandFrequency',0.35, ...
         'StopbandFrequency',0.7,'PassbandRipple',0.5, ...
         'StopbandAttenuation',65,'DesignMethod','kaiserwin','SampleRate',30);
% fvtool(lpFilt)

  fs = 30;
duration = 330;
Gam = wgn(1,fs*duration,2);

% Gam = Gam - mean(Gam);
% Gam = Gam - min(Gam)
% output = filter(lpFilt,Gam);
% %Gam = (Gam + min(Gam))/min(Gam)
% fileID = fopen('GammaBandPower_WGN.csv','a');
% fprintf(fileID,'%f\n',[output]);
% fclose(fileID);

time = 0:1/fs:(length(Gam)/fs-1/fs);
output = filter(lpFilt,Gam);
%output = output + 1; 
figure(1), subplot(1,2,1),axis square, hold on
plot(time,Gam,'k','LineWidth',2)
plot(time,output,'r','LineWidth',2)
subplot(1,2,2)
pspectrum(Gam,fs), hold on
output = detrend(output);
pspectrum(output,fs)
set(gca,'XScale','log','YScale','log');
h1 = findobj(gca, 'Type', 'Line')
set(h1(1), 'LineWidth', 2);
set(h1(1), 'Color', [1 0 0]);
set(h1(2), 'LineWidth', 2);
set(h1(2), 'Color', [0 0 0]);
set(gcf, 'Color', [1 1 1])
axis square

clear h1
fs = 30;
duration = 300;
Gam = wgn(1,fs*duration,2);
Gam = Gam.*(5/25);

ii = 1;
fs = 30;
Gam2 = importdata(['GammaBandPower_' num2str(ii) '.csv'])';
time = 1/fs:1/fs:length(Gam2)/fs;
figure, 
subplot(2,2,1)
plot(time, Gam2,'k'),title('Actual data')
subplot(2,2,2)
plot(time,Gam,'r'),title('simulated data')
subplot(2,2,[3 4])
pspectrum(Gam2,fs), hold on
pspectrum(Gam,fs), hold on
h1 = findobj(gca, 'Type', 'Line')
set(h1(1), 'LineWidth', 2);
set(h1(1), 'Color', [1 0 0]);
set(h1(2), 'LineWidth', 2);
set(h1(2), 'Color', [0 0 0]);
set(gca,'XScale','log','YScale','log');

%%
for kk = 81
fs = 6;
duration = 1100;
Gam = wgn(1,fs*duration,2);
%Gam = Gam.^2;%
%Gam = Gam.*5*10e-3;
Gam = Gam.*5*10e-3*0.5;
% 
% ii = 1;
% real_Gam = importdata(['GammaBandPower_' num2str(ii) '.csv'])';
% 
% params.Fs = 30;
% params.tapers = [5 9];
% params.fpass = [0.025 3];
% 
% time = 1/fs:1/fs:length(Gam)/fs;
% 
% figure
% subplot(2,2,1)
% plot(time, real_Gam,'k'),title('Actual data')
% subplot(2,2,2)
% plot(time,Gam,'r'),title('simulated data')
% 
% 
% subplot(2,2,[3 4]), hold on
% [Gam_f,fr] = mtspectrumc(Gam,params);
% [real_Gam_f,fr] = mtspectrumc(real_Gam,params);
% loglog(fr,Gam_f,'r','linewidth',2);
% loglog(fr,real_Gam_f,'k','linewidth',2);
% set(gca,'XScale','log','YScale','log');
% xlabel('frequency [Hz]')
% ylabel('Power')


fileID = fopen(['GammaBandPower_10' num2str(kk) '.csv'],'a');
fprintf(fileID,'%f\n',[Gam]);
fclose(fileID);
end













