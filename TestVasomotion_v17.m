function [output] = TestVasomotion_v17(Mesh)

% identify if a smaller mesh can be used for increasing simulation
% through-put

state_id = {'dynamic','static'};
%Mesh = {'13'}; %high medium low - meshes
state = {'dynamic','static'};


dt = 1/6;
time = [15:dt:150];

params.Fs = 1/dt;
params.tapers = [1 1];
params.fpass = [0.025 3];

ii = 1;
file_number = [1111];

for state_i = 1:length(state_id)
for ii = 1:length(file_number)
        f_name = ['10NO_0NOd_3NOsens_50bGC_' num2str(file_number(ii)) 'Hz_20VD_6sNOkernel_GammaWith1Hgb_45_Hct_RawGamma_' state_id{state_i} '_v17.csv']
        hold_data = importdata(f_name);
        [a index] = unique(hold_data(:,1));
        hold_data = hold_data(index,:); %don't take replicate values
        
        % get concentrations and dilations predicted by the model_______________________________________________________________
        output.([state{state_i}]).concentration(ii,:) = interp1(hold_data(:,1),hold_data(:,2),time')'; %concentration
        output.([state{state_i}]).dilation(ii,:) = interp1(hold_data(:,1),hold_data(:,3),time')'; %dilation
        
        % get the variance of the vessel dynamics_______________________________________________________________________________
        output.([state{state_i}]).variance(ii,:) = var(output.([state{state_i}]).dilation(ii,:));
        
        % get the power spectrum of the vessel dynamics_________________________________________________________________________
        [output.([state{state_i}]).spectrumPower(ii,:), output.([state{state_i}]).spectrumHz(ii,:)] = mtspectrumc(output.([state{state_i}]).dilation(ii,:),params);
        
        % deconvolve the hemodynamics response function from the white
        % gaussian noise input and the vasodilation output from COMSOL__________________________________________________________
        
        fs = 6; %get white gaussian noise NO production given to COMSOL
        Gam = importdata(['WGN_' num2str(file_number(ii)) '.csv'])';
%         fc = 1;
%         [b,a] = butter(6,fc/(fs/2));
%         Gam = filtfilt(b, a, Gam);
        
        time_Gam = 1/fs:1/fs:length(Gam)/fs;
        output.([state{state_i}]).NO_production(ii,:) = interp1(time_Gam,Gam',time,'spline','extrap');
        
        kernel_length = 10/dt; %get a 10s kernel estimate
        From = detrend(output.([state{state_i}]).NO_production(ii,:)); %remove DC component
        To = detrend(output.([state{state_i}]).dilation(ii,:)); %remove DC component
        [output.([state{state_i}]).HRF(ii,:)] = deconvolveHRF(From,To,kernel_length); %calculate HRF with Toeplitz matrix

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

