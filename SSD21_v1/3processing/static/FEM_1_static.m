%--------------------------------------------------------------------------
% LINEAR STATIC ANALYSIS
% Truong Thanh Chung. Aug 2021.
%--------------------------------------------------------------------------
function [D,stress,Np] = FEM_1_static(in_data,model,opt)
% CALCULATE NODE DISPLACEMENT
D = FEM_1_static_displ(in_data,model,opt);
% PLOT NVM OR STRESS
[stress,Np] = FEM_2_static_plot(in_data,D,opt);
