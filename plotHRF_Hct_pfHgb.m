function [output] = plotHRF_Hct_pfHgb(folder_location)

%________________________________________________________________________________________________________________________
% Written by W. Davis Haselden
% M.D./Ph.D. Candidate, Department of Neuroscience
% The Pennsylvania State University & Herhsey College of Medicine
%________________________________________________________________________________________________________________________
%
%   Purpose: plot predicted hemodynamic response functions of a 10 um
%   radius vessel with 1 of 20 uM of pfHgb and 20, 45, and 60% hematocrit
%   concentrations. CFL thickness for a 20 um vessel at different Hct was
%   found in Maithili Sharan 2001 and in agreement with Sangho Kim 2007.
%________________________________________________________________________________________________________________________
%
%   Inputs: csv files are referenced by file location in input.
%   example: plotHRF_Hct_pfHgb('C:\Users\wdh130\Documents\NO-Modeling')
%
%   Comsol NVC file: dilation_feedback_altered_Hct_pfHgb.mph with
%   MATLAB livelink (dilation_matlab_kernel_7) creates csv files with:
%   time, concentration of NO in the smooth muscle (nM), and vessel
%   dilation (%).
%
%   Outputs: 
%   output.(Hct20/Hct45/Hct60).(pfHgb1uM/pfHgb20uM).(time, concentration, dilation)
%                    
%   *note cfl thickness for 20 um vessel at 20% Hct = 5 um, 45% Hct = 2.8
%   um, 60% Hct = 1.9 um
%________________________________________________________________________________________________________________________

clear
clc

l = 0;

clear WF m_f m_fr
dt = 0.01;
LineColor = {[0 0 1],[0 1 1]
             [0 0 1],[0 1 1]
             [0 0 1],[0 1 1]};
         
alpha_index = {[0.5],[0.5]
               [0.75],[0.75]
               [1],[1]};



time = [0.1:dt:25];

Hct_conc = {'Hct20','Hct45','Hct60'}
RBC_core = {'pfHgb1uM','pfHgb20uM'}


for RBC_core_index = 1:length(RBC_core)
for Hct_conc_index = 1:length(Hct_conc)
hold_data = importdata(['2NO_0NOd_3NOsens_50bGC_' Hct_conc{Hct_conc_index} '_20VD_6sNOkernel_GammaWith' RBC_core{RBC_core_index} '_RawGamma_v10.csv']);

[a index] = unique(hold_data(:,1));
hold_data = hold_data(index,:); %don't take replicate values
output.(Hct_conc{Hct_conc_index}).(RBC_core{RBC_core_index}).time = time; %interpolated time
output.(Hct_conc{Hct_conc_index}).(RBC_core{RBC_core_index}).concentration = interp1(hold_data(:,1),hold_data(:,2),time')'; %concentration
output.(Hct_conc{Hct_conc_index}).(RBC_core{RBC_core_index}).dilation = interp1(hold_data(:,1),hold_data(:,3),time')'; %dilation

figure(23)
subplot(2,1,1), hold on, plot(time,output.(Hct_conc{Hct_conc_index}).(RBC_core{RBC_core_index}).concentration,'Color',[LineColor{Hct_conc_index,RBC_core_index} alpha_index{Hct_conc_index,RBC_core_index}],'LineWidth',2)
title('Concentration [nM]'),xlabel('time [s]'), ylabel('NO in smooth muscle'),%axis([6 30 5 20])

subplot(2,1,2), hold on, plot(time,output.(Hct_conc{Hct_conc_index}).(RBC_core{RBC_core_index}).dilation,'Color',[LineColor{Hct_conc_index,RBC_core_index} alpha_index{Hct_conc_index,RBC_core_index}],'LineWidth',2),%axis([6 30 -5 40])
title('Vessel Response'),xlabel('time [s]'), ylabel('\DeltaVessel Diameter [%]')
end
end


end