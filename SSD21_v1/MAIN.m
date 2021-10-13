%--------------------------------------------------------------------------
% SSD21 PROGRAM. STATIC, STABILITY, DYNAMIC ANALYSIS
% Truong Thanh Chung. Aug 2021.
%--------------------------------------------------------------------------
clc; close all; restoredefaultpath; format compact
pathName = fileparts(mfilename('fullpath')); addpath(genpath(pathName)); clearvars
% SET OPTIONS WITH FLAGS 0 (NO) OR 1 (YES)
opt.GUI       =  0;        % PLOT GUI
opt.static    =  1;        % LINEAR STATIC ANALYSIS
opt.modal     =  1;        % MODAL ANALYSIS

opt.label     =  0;        % SHOW VALUE FOR STATIC FORCES DIGRAM
opt.condense  =  0;        % MODAL ANALYSIS WITH STATIC CONDENSATION
opt.dynm      =  0;        % TIME HISTORY ANALYSIS EARTHQUAKE FORCES
opt.buckling  =  0;        % BUCKLING ANALYSIS, MUST DO STATIC ANALYSIS
opt.write     =  0;        % WRITE TO FILE
opt.showFig   =  0;        % SHOW NVM DIAGRAMS
opt.anim      =  1;        % SHOW ANIMATION
% INPUT DATA
in_data = FEM_0_input;
if ~isempty(in_data)
    % PLOT GUI DATA
    FEM_0_plotGUIdata(in_data,opt)
    % ASSEMBLE STIFFNESS MATRIX, MASS MATRIX, LOAD VECTOR
    model = FEM_0_assemble(in_data);
    % ANALYSIS
    resp = FEM_0_run(in_data,model,opt);
    % LINEAR BUCKLING ANALYSIS
    FEM_0_buckling(in_data,resp,model,opt);
    %% STATIC ANALYSIS WITH NONLINEAR GEOMETRY
    FEM_0_static_Nonlinear(in_data,model,resp,opt)
end

