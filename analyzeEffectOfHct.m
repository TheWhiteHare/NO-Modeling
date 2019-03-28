function [ output ] = analyzeEffectOfHct( input )
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
%       output.(Hct20/Hct40/Hct60).NO_production
%       output.(Hct20/Hct40/Hct60).concentration
%       output.(Hct20/Hct40/Hct60).dilation
%       output.(Hct20/Hct40/Hct60).variance
%       output.(Hct20/Hct40/Hct60).HRF
%       output.(Hct20/Hct40/Hct60).spectrumPower
%       output.(Hct20/Hct40/Hct60).spectrumHz
%   Increasing Hct decreases the thickness of the CFL.          
%________________________________________________________________________________________________________________________

input = 'C:\Users\wdh130\Documents\MATLAB-BACKUP\NOFeedbackData'; %placeholder for input

%%
addpath(input)

Hct = [20 40 60];
file_number = [1071:1:1080];
dt = 1/6;
time = [15:dt:285];

params.Fs = 1/dt;
params.tapers = [5 9];
params.fpass = [0.025 3];

for s = 1:length(Hct)
    for ii = 1:length(file_number)
        if s == 2
            f_name = ['2NO_0NOd_3NOsens_50bGC_' num2str(file_number(ii)) 'Hz_10VD_6sNOkernel_GammaWith1Hgb_RawGamma_v10.csv'];
        else
            f_name = ['2NO_0NOd_3NOsens_50bGC_' num2str(file_number(ii)) 'Hz_10VD_6sNOkernel_GammaWith1Hgb_' num2str(Hct(s)) '_Hct_RawGamma_v11.csv'];
        end
        hold_data = importdata(f_name);
        [a index] = unique(hold_data(:,1));
        hold_data = hold_data(index,:); %don't take replicate values
        
        % get concentrations and dilations predicted by the model_______________________________________________________________
        output.(['Hct' num2str(Hct(s))]).concentration(ii,:) = interp1(hold_data(:,1),hold_data(:,2),time')'; %concentration
        output.(['Hct' num2str(Hct(s))]).dilation(ii,:) = interp1(hold_data(:,1),hold_data(:,3),time')'; %dilation
        
        % get the variance of the vessel dynamics_______________________________________________________________________________
        output.(['Hct' num2str(Hct(s))]).variance(ii,:) = var(output.(['Hct' num2str(Hct(s))]).dilation(ii,:));
        
        % get the power spectrum of the vessel dynamics_________________________________________________________________________
        [output.(['Hct' num2str(Hct(s))]).spectrumPower(ii,:), output.(['Hct' num2str(Hct(s))]).spectrumHz(ii,:)] = mtspectrumc(output.(['Hct' num2str(Hct(s))]).dilation(ii,:),params);
        
        % deconvolve the hemodynamics response function from the white
        % gaussian noise input and the vasodilation output from COMSOL__________________________________________________________
        
        fs = 6; %get white gaussian noise NO production given to COMSOL
        Gam = importdata(['GammaBandPower_' num2str(file_number(ii)) '.csv'])';
%         fc = 0.75;
%         [b,a] = butter(6,fc/(fs/2));
%         Gam = filtfilt(b, a, Gam);
        
        time_Gam = 1/fs:1/fs:length(Gam)/fs;
        output.(['Hct' num2str(Hct(s))]).NO_production(ii,:) = interp1(time_Gam,Gam',time,'spline','extrap');
        
        kernel_length = round(10/dt); %get a 10s kernel estimate
        From = detrend(output.(['Hct' num2str(Hct(s))]).NO_production(ii,:)); %remove DC component
        To = detrend(output.(['Hct' num2str(Hct(s))]).dilation(ii,:)); %remove DC component
        [output.(['Hct' num2str(Hct(s))]).HRF(ii,:)] = deconvolveHRF(From,To,kernel_length); %calculate HRF with Toeplitz matrix
        
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

