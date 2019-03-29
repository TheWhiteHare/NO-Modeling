function [NO_production] = getGammaBandPowerHct(t,ii)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
% ii = 1;
% t = 5.01;
HOME = pwd;
cd('C:\Users\wdh130\Documents\NO-Modeling-Data\Hematocrit\WGN_NO_production')
% if t == 0
%     NO_production = 0
% else
   
delay = 6;
if t <= delay
    NO_production = 0;
else
fs = 6;%fs = 30;
Gam = importdata(['WGN_' num2str(ii) '.csv'])';
time = 1/fs:1/fs:length(Gam)/fs;

interp_Gam = interp1(time,Gam',t,'spline','extrap');
NO_production = interp_Gam;
% end

cd(HOME)
end