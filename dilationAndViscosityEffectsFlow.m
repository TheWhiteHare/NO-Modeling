function [ output_args ] = dilationAndViscosityEffectsFlow( input_args )
%________________________________________________________________________________________________________________________
% Written by W. Davis Haselden
% M.D./Ph.D. Candidate, Department of Neuroscience
% The Pennsylvania State University & Herhsey College of Medicine
%________________________________________________________________________________________________________________________
%
%   Purpose: report COMSOL results on nitric oxide in the smooth muscle and changes in vessel
%   size as a function of hematocrit
%________________________________________________________________________________________________________________________
%
%   Inputs:
%
%   Outputs: 
%   notes: blood viscosity as a function of Hct taken from - 
%The apparent viscosity of blood flowing in the isolated hindlimb of the dog, and its variation with corpuscular concentration
%S. R. F. Whittaker  F. R. Winton
%First published: 10 July 1933 https://doi.org/10.1113/jphysiol.1933.sp003009
%________________________________________________________________________________________________________________________
clear
clc

%input = importdata('NOChangesWithHct.csv');
input = importdata('NOChangesWithHct_10VD.csv');
%input = importdata('NOChangesWithHct_20VD.csv');

hct = input.data(:,10);
NO = input.data(:,11);

baseline = find(hct == 0.4);

NO_sens = 3;

    GC_activation = 100./((10^0.95./NO).^0.8+1);
    GC_activation_baseline = 100/((10^0.95/NO(baseline))^0.8+1);
    dilation = (GC_activation - GC_activation_baseline)*NO_sens;
 

figure
% subplot(2,1,1)
% plot(hct,NO)
subplot(2,2,1), 
plot(hct,dilation,'b')
title('Effect of NO consumption on vessel diameter')
xlabel('Hematocrit')
ylabel('\Deltavessel diameter (%)')
axis([0.2 0.6 -5 10])


%R = 8*l*n/(pi*r^4)
%Q = pi r^4 / 8*l*n

%n = 1.24*exp(0.02471.*hct*100); %Barras 1965
p = 1.5;
f_n = @(hct,n0) n0./(1-hct);

hct_hold = [0.2 0.4 0.6];
n_hold = [2.8 4 8];
f_n = @(hct,p) interp1(hct_hold,n_hold,hct,'spline');

%hct_hold = [0.253 0.268 0.288 0.300 0.319 0.336 0.355 0.367 0.375 0.38 0.39 0.474 0.538 0.562 0.602 0.678 0.8 0.841];
%n_hold = [3.62 3.67 3.78 3.8 3.85 3.91 4.11 4.19 4.34 4.48 4.75 5.09 5.44 5.99 6.79 8.73 11.24 18.01];

%[p S] = polyfit(hct_hold,n_hold,2)
%f_n = @(hct,p) polyval(p,hct)
%f_n = @(hct) interp1(hct_hold,n_hold,hct,'spline');


%A.R. Pries blood viscosity in tube flow: dependence on diameter and
%hematocrit

subplot(2,2,[2]), hold on
plot(hct,f_n(hct,p),'r')
title('viscosity changes with Hct')
xlabel('Hematocrit')
ylabel('viscosity of blood')
axis([0.2 0.6 0 8])

delta_flow = (((((dilation+100)/100).^4)-1).*100);
subplot(2,2,[3 4]), hold on
plot(hct,delta_flow,'b')
title('Effect of NO consumption on flow')
xlabel('Hematocrit')
ylabel('\DeltaFlow (%)')
axis([0.2 0.6 -50 50])

subplot(2,2,[3 4])
delta_flow_n = 100-((f_n(hct,p)./f_n(0.4,p)).*100);
plot(hct,delta_flow_n,'r')
title('Effect of viscosity on flow')
xlabel('Hematocrit')
ylabel('\DeltaFlow (%)')
axis([0.2 0.6 -50 50])

subplot(2,2,[3 4])
flow_combined = delta_flow_n + delta_flow;
plot(hct,flow_combined,'m')
title('Combined effect of NO consumption and viscosity Q = {\pir^4}/{8*l*n}')
xlabel('Hematocrit')
ylabel('\Deltaflow (%)')
axis([0.2 0.6 -100 100])

legend('Effect of NO consumption on flow','Effect of viscosity on flow','Combined effect of NO consumption and viscosity')
end

