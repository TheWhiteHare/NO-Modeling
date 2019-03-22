function [ output ] = analyzeEffectOfNOsens( input )
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
%       output.(NOx1/NOx3/NOx5).NO_production
%       output.(NOx1/NOx3/NOx5).concentration
%       output.(NOx1/NOx3/NOx5).dilation
%       output.(NOx1/NOx3/NOx5).variance
%       output.(NOx1/NOx3/NOx5).HRF
%       output.(NOx1/NOx3/NOx5).spectrumPower
%       output.(NOx1/NOx3/NOx5).spectrumHz
%   a 1% change in GC activation causes a 1%, 3%, or 5% change in vessel diameter (NOx1/NOx3/NOx5)         
%________________________________________________________________________________________________________________________

input = 'C:\Users\wdh130\Documents\MATLAB-BACKUP\NOFeedbackData'; %placeholder for input

%%
addpath(input)

NO_sens = [1 3 5];
file_number = [1071:1:1080];
dt = 0.01;
time = [15:dt:295];

params.Fs = 1/dt;
params.tapers = [5 9];
params.fpass = [0.025 3];

for s = 1:length(NO_sens)
    for ii = 1:length(file_number)
        f_name = ['2NO_0NOd_' num2str(NO_sens(s)) 'NOsens_50bGC_' num2str(file_number(ii)) 'Hz_10VD_6sNOkernel_GammaWith1Hgb_RawGamma_v10.csv'];
        hold_data = importdata(f_name);
        [a index] = unique(hold_data(:,1));
        hold_data = hold_data(index,:); %don't take replicate values
        
        % get concentrations and dilations predicted by the model_______________________________________________________________
        output.(['NOx' num2str(NO_sens(s))]).concentration(ii,:) = interp1(hold_data(:,1),hold_data(:,2),time')'; %concentration
        output.(['NOx' num2str(NO_sens(s))]).dilation(ii,:) = interp1(hold_data(:,1),hold_data(:,3),time')'; %dilation
        
        % get the variance of the vessel dynamics_______________________________________________________________________________
        output.(['NOx' num2str(NO_sens(s))]).variance(ii,:) = var(output.(['NOx' num2str(NO_sens(s))]).dilation(ii,:));
        
        % get the power spectrum of the vessel dynamics_________________________________________________________________________
        [output.(['NOx' num2str(NO_sens(s))]).spectrumHz(ii,:), output.(['NOx' num2str(NO_sens(s))]).spectrumPower(ii,:)] = mtspectrumc(output.(['NOx' num2str(NO_sens(s))]).dilation(ii,:),params);
        
        % deconvolve the hemodynamics response function from the white
        % gaussian noise input and the vasodilation output from COMSOL__________________________________________________________
        
        fs = 6; %get white gaussian noise NO production given to COMSOL
        Gam = importdata(['GammaBandPower_' num2str(file_number(ii)) '.csv'])';
        time_Gam = 1/fs:1/fs:length(Gam)/fs;
        output.(['NOx' num2str(NO_sens(s))]).NO_production(ii,:) = interp1(time_Gam,Gam',time,'spline','extrap');
        
        kernel_length = 10/dt; %get a 10s kernel estimate
        From = detrend(output.(['NOx' num2str(NO_sens(s))]).NO_production(ii,:)); %remove DC component
        To = detrend(output.(['NOx' num2str(NO_sens(s))]).dilation(ii,:)); %remove DC component
        [output.(['NOx' num2str(NO_sens(s))]).HRF(ii,:)] = deconvolveHRF(From,To,kernel_length); %calculate HRF with Toeplitz matrix
        
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

