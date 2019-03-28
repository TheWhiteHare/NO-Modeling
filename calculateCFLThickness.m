function [ new_r_l ] = calculateCFLThickness( Vessel, Hct )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
Vessel = Vessel*10^6;

CFL = ((Vessel*2)^2*(-0.0016761)+(Vessel*2)*(0.1699527)+0.034637); %vessel radius modifier

[p] = pchip([0.2 0.45 0.6],[5 2.8 1.9],[0.2:0.05:0.6])

CFL = CFL*p/2.8

new_r_l = Vessel - CFL;
%Hct modifier

end

