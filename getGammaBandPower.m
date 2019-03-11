function [NO_production] = getGammaBandPower(t,ii)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
% ii = 1;
% t = 5.01;
cd('C:\Users\wdh130\Documents\MATLAB\NOFeedbackData')
%delay = 6;
% if t <= delay
%     NO_production = 0;
% else
fs = 30;
Gam = importdata(['GammaBandPower_' num2str(ii) '.csv'])';
time = 1/fs:1/fs:length(Gam)/fs;

interp_Gam = interp1(time,Gam',t,'spline','extrap');
NO_production = interp_Gam;
% end
end

