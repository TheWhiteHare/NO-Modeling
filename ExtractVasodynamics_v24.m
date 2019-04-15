function [ output ] = ExtractVasodynamics_v24( f_name, tapers )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


dt = 1/6;
time = [15:dt:1350];

params.Fs = 1/dt;
params.tapers = tapers;
params.fpass = [0.025 3];
params.err = [2 0.05];

file_number = [1500];

hold_data = importdata(f_name);
[a index] = unique(hold_data(:,1));
hold_data = hold_data(index,:); %don't take replicate values
ii = 1;

% get concentrations and dilations predicted by the model_______________________________________________________________
output.concentration(ii,:) = detrend(interp1(hold_data(:,1),hold_data(:,2),time')'); %concentration
output.dilation(ii,:) = detrend(interp1(hold_data(:,1),hold_data(:,3),time')'); %dilation

% get the variance of the vessel dynamics_______________________________________________________________________________
output.variance(ii,:) = var(output.dilation(ii,:));

% get the power spectrum of the vessel dynamics_________________________________________________________________________
[output.spectrumPower(ii,:), output.spectrumHz(ii,:), output.Serr{ii}] = mtspectrumc(output.dilation(ii,:),params);

% deconvolve the hemodynamics response function from the white
% gaussian noise input and the vasodilation output from COMSOL__________________________________________________________

fs = 30; %get white gaussian noise NO production given to COMSOL
Gam = importdata(['WGN_' num2str(file_number(ii)) '.csv'])';
%         fc = 1;
%         [b,a] = butter(6,fc/(fs/2));
%         Gam = filtfilt(b, a, Gam);

time_Gam = 1/fs:1/fs:length(Gam)/fs;
output.NO_production(ii,:) = interp1(time_Gam,Gam',time,'spline','extrap');
[output.NOspectrumPower(ii,:), output.NOspectrumHz(ii,:)] = mtspectrumc(output.NO_production(ii,:),params);


kernel_length = 15/dt; %get a 10s kernel estimate
From = detrend(output.NO_production(ii,:)); %remove DC component
To = detrend(output.dilation(ii,:)); %remove DC component
[output.HRF(ii,:)] = deconvolveHRF(From,To,kernel_length); %calculate HRF with Toeplitz matrix


end


function [HRF] = deconvolveHRF(input,output,kernel_length)

K = kernel_length;
N = length(input);
Toeplitz = toeplitz([input zeros(1, K-1)], [input(1) zeros(1, K-1)]);
Toeplitz = [ones(size(Toeplitz,1), 1) Toeplitz];
output = [output zeros(1, size(Toeplitz, 1)-length(output))];
HRF = Toeplitz\[output]';

end
