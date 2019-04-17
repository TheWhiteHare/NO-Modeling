function [NO_production] = getNO_Production_v2(t,ii,NO_mult)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
addpath('C:\Users\wdh130\Documents\NO-Modeling-Data\Vasomotion\WGN_NO_production')
   

time = [0:0.01:20];
NO_production_est = zeros(1,length(time));

NO_production_est(601:650) = ones(1,50);
NO_production = interp1(time,NO_production_est,t)*NO_mult;


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