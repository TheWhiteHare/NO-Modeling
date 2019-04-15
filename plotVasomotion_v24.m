clear
clc
addpath('C:\Users\wdh130\Documents\NO-Modeling-Data\Vasomotion')
addpath('C:\Users\wdh130\Documents\NO-Modeling-Data\Vasomotion\WGN_NO_production')
f_name = {
    '5NO_0NOd_1NOsens_50bGC_1500Hz_20VD_6sNOkernel_GammaWith1Hgb_45_Hct_RawGamma_dynamic_v24.csv',
    '5NO_0NOd_3NOsens_50bGC_1500Hz_20VD_6sNOkernel_GammaWith1Hgb_45_Hct_RawGamma_dynamic_v24.csv',
    '5NO_0NOd_5NOsens_50bGC_1500Hz_20VD_6sNOkernel_GammaWith1Hgb_45_Hct_RawGamma_dynamic_v24.csv',
    '5NO_0NOd_3NOsens_50bGC_1500Hz_20VD_6sNOkernel_GammaWith20Hgb_45_Hct_RawGamma_dynamic_v24.csv',
    '5NO_0NOd_3NOsens_50bGC_1500Hz_20VD_6sNOkernel_GammaWith40Hgb_45_Hct_RawGamma_dynamic_v24.csv',
    '5NO_0NOd_3NOsens_50bGC_1500Hz_20VD_6sNOkernel_GammaWith1Hgb_45_Hct_RawGamma_static_v24.csv'};

f_name_label = {
    'm_1',
    'm_3',
    'm_5',
    'Hgb_20',
    'Hgb_40',
    'static'};

tapers = [101 201];

for ii = 1:length(f_name)
[ data.(f_name_label{ii}) ] = ExtractVasodynamics_v24( f_name{ii}, tapers );
end

data_segment = {[1 2 3],[2 4 5],[1 2 3 4 5 6]};
kk = 3;
line_color_index = {[1 0 0],[0 1 0],[0 0 1],[1 0 1],[0 1 1],[0 0 0]}

figure, 
subplot(2,3,[1 2 4 5]) ,hold on
for ii = data_segment{kk}
plot(data{ii}.spectrumHz,data{ii}.spectrumPower,'Color',line_color_index{ii})
end
legend(f_name_label{data_segment{kk}})
set(gca,'XScale','log','YScale','log')
title('Vasodynamics Sprectrum')

fs = 6;
subplot(2,3,3), hold on
for ii = data_segment{kk}
plot([0:1/fs:15],data{ii}.HRF,'Color',line_color_index{ii},'LineWidth',3)
end
legend(f_name_label{data_segment{kk}})

subplot(2,3,6), hold on
for ii = data_segment{kk}
plot(data{ii}.NOspectrumHz,data{ii}.NOspectrumPower,'Color',line_color_index{ii})
end
legend(f_name_label{data_segment{kk}})
set(gca,'XScale','log','YScale','linear')
title('NO Production Sprectrum')

subplot(2,3,[1 2 4 5]), hold on
for ii = data_segment{kk}
high = data{ii}.Serr{1}(1,:);
low = data{ii}.Serr{1}(2,:);
Hz = data{ii}.spectrumHz(1,:);
f = fill([Hz flip(Hz)],[high flip(low)],'r','Linestyle','none')
set(f,'facea',1/5);
set(f,'facec',line_color_index{ii})
end

% figure, hold on
% for ii = data_segment{kk}
% plot([15:1/fs:1500],data{ii}.dilation,'Color',line_color_index{ii})
% end
% title('NO Production Sprectrum')














