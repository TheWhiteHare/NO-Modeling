close all
clear
clc

cd('C:\Users\wdh130\Documents\NO-Modeling-Data\Vasomotion')
addpath('C:\Users\wdh130\Documents\NO-Modeling-Data\Vasomotion\WGN_NO_production')
addpath('C:\Users\wdh130\Documents\NO-Modeling-Data\Vasomotion')
tapers = [71 141];
[model] = TestVasomotion_v24(tapers);

figure(2), 
subplot(2,3,[1 2 4 5]) ,hold on
for ii = 1:size(model.static.spectrumPower,1)
plot(model.dynamic.spectrumHz(ii,:),model.dynamic.spectrumPower(ii,:),'Color',[1 0 0 1/5])
plot(model.static.spectrumHz(ii,:),model.static.spectrumPower(ii,:),'Color',[0 0 1 1/5])
%plot(model.static_wall.spectrumHz(ii,:),model.static_wall.spectrumPower(ii,:),'Color',[1 0 1 1/5])
end
plot(model.dynamic.spectrumHz(ii,:),mean(model.dynamic.spectrumPower,1),'r','LineWidth',3)
plot(model.static.spectrumHz(ii,:),mean(model.static.spectrumPower,1),'b','LineWidth',3)
%plot(model.static_wall.spectrumHz(ii,:),mean(model.static_wall.spectrumPower,1),'m','LineWidth',3)
set(gca,'XScale','log','YScale','linear')
axis([0.025 1 10^-2 2])
title('Vasodynamics Sprectrum')

fs = 6;
subplot(2,3,3), hold on
for ii = 1:size(model.static.spectrumPower,1)
plot([0:1/fs:10],model.dynamic.HRF(ii,:),'Color',[1 0 0 1],'LineWidth',3)
plot([0:1/fs:10],model.static.HRF(ii,:),'Color',[0 0 1 1],'LineWidth',3)
%plot([0:1/30:10],model.static_wall.HRF(ii,:),'Color',[1 0 1 1/5])
end
xlim([0.5 8])
ylim([-5 25])
plot([0:1/fs:10],mean(model.dynamic.HRF),'r','LineWidth',3)
plot([0:1/fs:10],mean(model.static.HRF),'b','LineWidth',3)
%plot([0:1/30:10],mean(model.static_wall.HRF),'m','LineWidth',3)


% subplot(2,3,4), hold on
% for ii = 1:size(model.static.spectrumPower,1)
% plot([0:1/fs:1335],model.dynamic.dilation(ii,:),'r')
% plot([0:1/fs:1335],model.static.dilation(ii,:),'b')
% %plot(model.static_wall.dilation(ii,:),'m')
% end


subplot(2,3,6), hold on
for ii = 1:size(model.static.spectrumPower,1)
plot(model.static.NOspectrumHz(ii,:),model.static.NOspectrumPower(ii,:),'Color',[0 0 0 1/5])
end
plot(model.static.NOspectrumHz(ii,:),mean(model.static.NOspectrumPower,1),'k','LineWidth',3)
set(gca,'XScale','log','YScale','linear')
axis([0.025 3 10^-9 10^-4])
title('NO Production Sprectrum')

subplot(2,3,[1 2 4 5]), hold on
high = model.dynamic.Serr{1}(1,:);
low = model.dynamic.Serr{1}(2,:);
Hz = model.dynamic.spectrumHz(1,:);
f = fill([Hz flip(Hz)],[high flip(low)],'r','Linestyle','none')
set(f,'facea',1/5);

low_s = model.static.Serr{1}(1,:);
high_s = model.static.Serr{1}(2,:);
Hz = model.static.spectrumHz(1,:);
f_s = fill([Hz flip(Hz)],[high_s flip(low_s)],'b','Linestyle','none')
set(f_s,'facea',1/5);


%% add bootstrapping
nboot = 1000;

for ii = 1:size(model.static.spectrumPower,2)
    [Power_boot(:,ii) nbootstrap] = bootstrp(nboot,@mean,model.dynamic.spectrumPower(:,ii));
    [hold_prctile] = prctile(Power_boot(:,ii),[2.5 97.5]);
    low(ii) = hold_prctile(1);
    high(ii) = hold_prctile(2);
    
    [Power_boot_s(:,ii) nbootstrap] = bootstrp(nboot,@mean,model.static.spectrumPower(:,ii));
    [hold_prctile_s] = prctile(Power_boot_s(:,ii),[2.5 97.5]);
    low_s(ii) = hold_prctile_s(1);
    high_s(ii) = hold_prctile_s(2);
end
Hz = model.static.spectrumHz(1,:);

figure(2),subplot(2,2,1), hold on
plot(Hz,mean(Power_boot,1),'r','LineWidth',3)
f = fill([Hz flip(Hz)],[low flip(high)],'r','LineStyle','none');
set(f,'facea',1/5);
set(f,'facec',[1 0 0]);

plot(Hz,mean(Power_boot_s,1),'b','LineWidth',3)
f = fill([Hz flip(Hz)],[low_s flip(high_s)],'r','LineStyle','none');
set(f,'facea',1/5);
set(f,'facec',[0 0 1]);
set(gca,'XScale','log','YScale','linear')
axis([0.025 1 10^-2 4])
title('Vasodynamics Sprectrum')
















