function [ output ] = plotEffectOfNOsens( input )
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

dt = 0.01;
time = [0:dt:10];

figure, hold on
for ii = 1:10
plot(time,output.NOx1.HRF(ii,:),'Color',[1 0 0 1/10])
plot(time,output.NOx3.HRF(ii,:),'Color',[0 1 0 1/10])
plot(time,output.NOx5.HRF(ii,:),'Color',[0 0 1 1/10])
end

plot(time,mean(output.NOx1.HRF,1),'Color',[1 0 0 1],'Linewidth',2)
plot(time,mean(output.NOx3.HRF,1),'Color',[0 1 0 1],'Linewidth',2)
plot(time,mean(output.NOx5.HRF,1),'Color',[0 0 1 1],'Linewidth',2)

xlim([1 9])