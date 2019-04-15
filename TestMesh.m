function [output] = TestMesh(Mesh)

% identify if a smaller mesh can be used for increasing simulation
% through-put

pfHgb = [1 20 40];
%Mesh = {'13'}; %high medium low - meshes
dt = 1/6;
time = [15:dt:300];

params.Fs = 1/dt;
params.tapers = [5 9];
params.fpass = [0.025 3];

ii = 1;
file_number = 1071;

for Mesh_i = 1:length(Mesh)
for s = 1:length(pfHgb)
        f_name = ['3NO_0NOd_3NOsens_50bGC_1071Hz_20VD_6sNOkernel_GammaWith' num2str(pfHgb(s)) 'Hgb_45_Hct_RawGamma_v' Mesh '.csv'];
        hold_data = importdata(f_name);
        [a index] = unique(hold_data(:,1));
        hold_data = hold_data(index,:); %don't take replicate values
        
        % get concentrations and dilations predicted by the model_______________________________________________________________
        output.(['pfHgb' num2str(pfHgb(s)) 'uM']).concentration(ii,:) = interp1(hold_data(:,1),hold_data(:,2),time')'; %concentration
        output.(['pfHgb' num2str(pfHgb(s)) 'uM']).dilation(ii,:) = interp1(hold_data(:,1),hold_data(:,3),time')'; %dilation
        
        % get the variance of the vessel dynamics_______________________________________________________________________________
        output.(['pfHgb' num2str(pfHgb(s)) 'uM']).variance(ii,:) = var(output.(['pfHgb' num2str(pfHgb(s)) 'uM']).dilation(ii,:));
        
        % get the power spectrum of the vessel dynamics_________________________________________________________________________
        [output.(['pfHgb' num2str(pfHgb(s)) 'uM']).spectrumPower(ii,:), output.(['pfHgb' num2str(pfHgb(s)) 'uM']).spectrumHz(ii,:)] = mtspectrumc(output.(['pfHgb' num2str(pfHgb(s)) 'uM']).dilation(ii,:),params);
        
        % deconvolve the hemodynamics response function from the white
        % gaussian noise input and the vasodilation output from COMSOL__________________________________________________________
        
        fs = 6; %get white gaussian noise NO production given to COMSOL
        Gam = importdata(['WGN_' num2str(file_number(ii)) '.csv'])';
%         fc = 1;
%         [b,a] = butter(6,fc/(fs/2));
%         Gam = filtfilt(b, a, Gam);
        
        time_Gam = 1/fs:1/fs:length(Gam)/fs;
        output.(['pfHgb' num2str(pfHgb(s)) 'uM']).NO_production(ii,:) = interp1(time_Gam,Gam',time,'spline','extrap');
        
        kernel_length = 10/dt; %get a 10s kernel estimate
        From = detrend(output.(['pfHgb' num2str(pfHgb(s)) 'uM']).NO_production(ii,:)); %remove DC component
        To = detrend(output.(['pfHgb' num2str(pfHgb(s)) 'uM']).dilation(ii,:)); %remove DC component
        [output.(['pfHgb' num2str(pfHgb(s)) 'uM']).HRF(ii,:)] = deconvolveHRF(From,To,kernel_length); %calculate HRF with Toeplitz matrix

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

