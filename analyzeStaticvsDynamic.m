function [output] = analyzeStaticvsDynamic()

condition = {'', '_static'};
file_number = [1071:1:1080];
dt = 1/6;
time = [15:dt:285];

params.Fs = 1/dt;
params.tapers = [5 9];
params.fpass = [0.025 3];

condition_labels = {'dynamic','static'}

for s = 1:length(condition)
    for ii = 1:length(file_number)
        f_name = ['2NO_0NOd_3NOsens_50bGC_' num2str(file_number(ii)) 'Hz_10VD_6sNOkernel_GammaWith1Hgb_RawGamma' condition{s} '_v10.csv'];
        hold_data = importdata(f_name);
        [a index] = unique(hold_data(:,1));
        hold_data = hold_data(index,:); %don't take replicate values
        
        % get concentrations and dilations predicted by the model_______________________________________________________________
        output.(condition_labels{s}).concentration(ii,:) = interp1(hold_data(:,1),hold_data(:,2),time')'; %concentration
        output.(condition_labels{s}).dilation(ii,:) = interp1(hold_data(:,1),hold_data(:,3),time')'; %dilation
        
        % get the variance of the vessel dynamics_______________________________________________________________________________
        output.(condition_labels{s}).variance(ii,:) = var(output.(condition_labels{s}).dilation(ii,:));
        
        % get the power spectrum of the vessel dynamics_________________________________________________________________________
        [output.(condition_labels{s}).spectrumPower(ii,:), output.(condition_labels{s}).spectrumHz(ii,:)] = mtspectrumc(output.(condition_labels{s}).dilation(ii,:),params);
        
        % deconvolve the hemodynamics response function from the white
        % gaussian noise input and the vasodilation output from COMSOL__________________________________________________________
        
        fs = 6; %get white gaussian noise NO production given to COMSOL
        Gam = importdata(['GammaBandPower_' num2str(file_number(ii)) '.csv'])';
        time_Gam = 1/fs:1/fs:length(Gam)/fs;
        output.(condition_labels{s}).NO_production(ii,:) = interp1(time_Gam,Gam',time,'spline','extrap');
        
        kernel_length = 10/dt; %get a 10s kernel estimate
        From = detrend(output.(condition_labels{s}).NO_production(ii,:)); %remove DC component
        To = detrend(output.(condition_labels{s}).dilation(ii,:)); %remove DC component
        [output.(condition_labels{s}).HRF(ii,:)] = deconvolveHRF(From,To,kernel_length); %calculate HRF with Toeplitz matrix
        
    end
end



end

function [HRF] = deconvolveHRF(input,output,kernel_length)

K = kernel_length;
N = length(input);
Toeplitz = toeplitz([input zeros(1, K-1)], [input(1) zeros(1, K-1)]);
Toeplitz = [ones(size(Toeplitz,1), 1) Toeplitz];
output = [output zeros(1, size(Toeplitz, 1)-length(output))];
HRF = Toeplitz\[output]';

end