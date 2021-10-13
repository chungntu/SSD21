clc; close all; restoredefaultpath; format compact
pathName = fileparts(mfilename('fullpath')); addpath(genpath(pathName));
% clearvars
opt.label  = 1;
% Input data
in_data                     = FEM_0_input;
% ASSEMBLE RESTRAINT
model.freeDOFs              = FEM_1_assemble_Restraint(in_data);
% ASSEMBLE LOAD VECTOR
model.LVEC                  = FEM_1_assemble_LoadVector(in_data);
%% LOOP


eps     = 1E-4;            % Error norm
% N       = [0.01 0 0];		% Initial normal forces
N = [resp.static.Np(1,:)];
N0      = [1 1 1];          % Normal forces of the initial former iteration
n       = 0;                % Iteration counter
while(abs((N(1)-N0(1))/N0(1))>eps)
    n = n+1;
    % ASSEMBLE STIFFNESS MATRIX
    [dofN,EL_TYPE,ndPerElem]    = elemType(in_data);
    [row,col,valK]              = FEM_2_assemKM_2DFrame_Nonlinear(in_data,dofN,ndPerElem,N);
    Kgl                         = sparse(row,col,valK, dofN*size(in_data.ND,1), dofN*size(in_data.ND,1));
    model.Ksys.Kgl              = Kgl;
    D                           = FEM_1_static_displ(in_data,model);
    [stress,Np]                 = FEM_2_static_plot(in_data,D,opt);
    N0                          = N;
    N                           = [Np(1,:)];
end
