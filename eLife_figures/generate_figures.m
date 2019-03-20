function [data] = generate_figures()
% generate_figure_main: main script for generating figures for manuscript
% Author: William Davis Haselden
%         The Pennsylvania State University, University Park, PA

close all; clear all; clc;
currentFolder = pwd;
addpath(genpath(currentFolder));
fileparts = strsplit(currentFolder, filesep);
if ismac
    rootfolder = fullfile(filesep, fileparts{1:end},'Data');
else
    rootfolder = fullfile(fileparts{1:end},'Data');
end
addpath(genpath(rootfolder))

%% perform data analysis
[data] = generate_structures(rootfolder);

%% Figure 1
% illustration of Krogh cylinder and input parameters of model (no data)
%% Figure 2
fig_2_a_b(data);
fig_2_c_d_e(data);
%% Figure 3
fig_3_a_b_c(data);
fig_3_d_e_f(data);
%% Figure 4
fig_4_a_b_c_d();
fig_4_e_f(data);
%% Figure 5
fig_5_a_b(data);
%% Figure 6

fig_6_a(data);
fig_6_b(data);
fig_6_c(data);
fig_6_d(data);
fig_6_e(data);

end

