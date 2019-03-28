function [ output ] = analyzeEffectOfpfHgb( input )
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
%   Inputs: file location of csv files
%
%   Outputs: 
%       output.(pfHgb1uM/pfHgb20uM/pfHgb40uM).NO_production
%       output.(pfHgb1uM/pfHgb20uM/pfHgb40uM).concentration
%       output.(pfHgb1uM/pfHgb20uM/pfHgb40uM).dilation
%       output.(pfHgb1uM/pfHgb20uM/pfHgb40uM).variance
%       output.(pfHgb1uM/pfHgb20uM/pfHgb40uM).HRF
%       output.(pfHgb1uM/pfHgb20uM/pfHgb40uM).spectrumPower
%       output.(pfHgb1uM/pfHgb20uM/pfHgb40uM).spectrumHz
%       output.baseline_diameter
%   Hgb in the CFL and 55% of the RBC core (for Hct = 0.45) have their free Hgb concentration increased         
%________________________________________________________________________________________________________________________

input = 'C:\Users\wdh130\Documents\MATLAB-BACKUP\NOFeedbackData'; %placeholder for input

%%
addpath(input)

pfHgb = [1 20 40];
file_number = [1071:1:1080];
dt = 1/6;
time = [15:dt:285];

params.Fs = 1/dt;
params.tapers = [5 9];
params.fpass = [0.025 3];

for s = 1:length(pfHgb)
    for ii = 1:length(file_number)
        f_name = ['2NO_0NOd_3NOsens_50bGC_' num2str(file_number(ii)) 'Hz_10VD_6sNOkernel_GammaWith' num2str(pfHgb(s)) 'Hgb_RawGamma_v10.csv'];
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
        Gam = importdata(['GammaBandPower_' num2str(file_number(ii)) '.csv'])';
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

%% calculate baseline diameter changes: pfHgb
Hgb = [0 1 5 10 15 20 25 30 35 40];

l = 0;
for RBC_core = Hgb
    l = l + 1;
time = [5+100*(l-1):dt:98+100*(l-1)];
hold_data = importdata(['2NO_0NOd_3NOsens_50bGC_1081Hz_10VD_6sNOkernel_GammaWith' num2str(RBC_core) 'Hgb_v8.csv']);

g = 1;
[a index] = unique(hold_data(:,1));
hold_data = hold_data(index,:); %don't take replicate values
WF{1,g} = interp1(hold_data(:,1),hold_data(:,2),time')'; %concentration
WF{2,g} = interp1(hold_data(:,1),hold_data(:,3),time')'; %dilation

c{l}(g,:) = WF{1,g};
m{l}(g,:) = WF{2,g};

end

output.Hgb = Hgb;
output.baseline_diameter = cell2mat(cellfun(@mean,m,'UniformOutput',0));

% %% calculate baseline diameter changes
% Hct = [0.2:0.05:0.6];
% NO_sens = 3;
% 
% hold_data = importdata('NOChangesWithHct_10VD.csv');
% NO_conc = hold_data.data(:,11);
% GC_activation = 100./((10.^0.95./NO_conc).^0.8+1);
% GC_activation_norm = 100./((10.^0.95./NO_conc(6)).^0.8+1); %Hct = 0.45
% baseline_delta_diameter = (GC_activation-GC_activation_norm).*NO_sens
% output.baseline_diameter = [Hct;baseline_delta_diameter']

end

function [HRF] = deconvolveHRF(input,output,kernel_length)

K = kernel_length;
N = length(input);
Toeplitz = toeplitz([input zeros(1, K-1)], [input(1) zeros(1, K-1)]);
Toeplitz = [ones(size(Toeplitz,1), 1) Toeplitz];
output = [output zeros(1, size(Toeplitz, 1)-length(output))];
HRF = Toeplitz\[output]';

end

