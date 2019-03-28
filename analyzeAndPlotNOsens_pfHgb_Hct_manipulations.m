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


clear
clc
close all

%%


%% analysis of NO sens, pfHgb, and hematocrit
tic
[ alterNOsens ] = analyzeEffectOfNOsens( ); toc
tic
[ alterpfHgb ] = analyzeEffectOfpfHgb( ); toc
[ alterHct ] = analyzeEffectOfHct( ); toc
[output] = analyzeStaticvsDynamic()


%% plot NO sens, pfHgb, and hematocrit
plotEffectOfNOsens( alterNOsens ); toc
plotEffectOfpfHgb( alterpfHgb ); toc
plotEffectOfHct( alterHct ); toc
plotEffectOfStaticvsDynamic( output )


%%
plotPerivascularNO_pfHgb();
plotPerivascularNO_Hct();

