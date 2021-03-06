function [ new_r_l ] = calculateRBCCoreRadius( Vessel_dynamic, Vessel, Hct )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here



Vessel_dynamic = Vessel_dynamic*10^6;

(Vessel - cfl_thickness(Vessel_dynamic,Hct))/(Vessel - cfl_thickness(Vessel))

new_r_l = Vessel_dynamic - CFL;
%Hct modifier

end

function [t_cfl] = cfl_thickness(r_RBC,Hct)
CFL = ((r_RBC*2)^2*(-0.0016761)+(r_RBC*2)*(0.1699527)+0.034637); %vessel radius modifier

[p] = pchip([0.2 0.45 0.6],[5 2.8 1.9],Hct)

CFL = CFL*p/2.8
end



