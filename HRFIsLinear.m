%________________________________________________________________________________________________________________________
% Written by W. Davis Haselden
% M.D./Ph.D. Candidate, Department of Neuroscience
% The Pennsylvania State University & Herhsey College of Medicine
%________________________________________________________________________________________________________________________
%
%   Purpose: displays that the response function is linear
%________________________________________________________________________________________________________________________
%
%   Inputs: sequentially increasing pulses of NO from 1.1-1.9 times as much
%   No production for 1 second
%
%   Outputs: plot of HRF response from a pulse of NO. Left plot is the raw
%   response and the right plot is the normalized to the maximal response
%________________________________________________________________________________________________________________________

cd('C:\Users\wdh130\Documents\NO-Modeling-Data')

NO_Mult = [1.1 1.3 1.5 1.7 1.9];
time = [0:1/6:20];

figure, hold on
for ii = 1:length(NO_Mult)
hold_data = importdata([num2str(NO_Mult(ii)) 'NO_1NOd_3NOsens_10VD_6sNOkernel_v2.csv']);
[a index] = unique(hold_data(:,1));
hold_data = hold_data(index,:); %don't take replicate values

% get concentrations and dilations predicted by the model_______________________________________________________________
scaling.concentration(ii,:) = (interp1(hold_data(:,1),hold_data(:,2),time')'); %concentration
scaling.dilation(ii,:) = (interp1(hold_data(:,1),hold_data(:,3),time')'); %dilation

subplot(1,2,1), hold on
plot(time,scaling.dilation(ii,:))

subplot(1,2,2), hold on
plot(time,scaling.dilation(ii,:)/max(scaling.dilation(ii,:)))
end

subplot(1,2,1)
xlabel('time (s)')
ylabel('dilation (%)')
title('vasodilatory response to NO pulse (1 sec)')
legend('1.1','1.3','1.5','1.7','1.9')

subplot(1,2,2)
xlabel('time (s)')
ylabel('dilation normalized to maximum')
title('Normalized: vasodilatory response to NO pulse (1 sec)')
legend('1.1','1.3','1.5','1.7','1.9')