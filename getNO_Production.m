function [NO_production] = getNO_Production(t,ii,NO_mult)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
addpath('C:\Users\wdh130\Documents\NO-Modeling-Data\Vasomotion\WGN_NO_production')
   
delay = 6;
if t <= delay
    NO_production = 0;
else
%fs = 6;
fs = 30;
Gam = importdata(['WGN_' num2str(ii) '.csv'])';
time = 1/fs:1/fs:length(Gam)/fs;


interp_Gam = interp1(time,Gam',t,'spline','extrap');

NO_production = (interp_Gam*NO_mult);
end

% addpath('C:\Users\wdh130\Documents\NO-Modeling-Data\Vasomotion\WGN_NO_production')
%    
% delay = 6;
% if t <= delay
%     NO_production = 0;
% elseif t>=7
%     NO_production = 0;
% else
%     NO_production = NO_mult;
% end

end