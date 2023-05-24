%--------------------------------------------------------------------------
% SOLVE STATIC DISPLACEMENT
% Truong Thanh Chung. Aug 2021.
%--------------------------------------------------------------------------
function resp = FEM_1_static_displ_Nonlinear(in_data,model)
LVEC        = model.LVEC;
Kgl         = model.Ksys.Kgl;
freeDOFs    = model.freeDOFs;
if  isfield(in_data,'DBC')
    D = FEM_2_DBC(Kgl,freeDOFs,LVEC,in_data);
    resp.static.D = D';
else
    D = (Kgl(freeDOFs,freeDOFs))\LVEC(freeDOFs)';
    resp.static.D(freeDOFs) = D;
end
end

% DISPLACEMENT BOUNDARY CONDITION (DBC)
function D  = FEM_2_DBC(Kgl,freeDOFs,LVEC,in_data)
dim         = size(Kgl,1);
un          = setdiff(1:dim,freeDOFs);
un          = setdiff(un,in_data.DBC.dofs);
DBC_dofs    = [in_data.DBC.dofs';un'];
DBC_displ   = [in_data.DBC.displ';zeros(length(un),1)];
dof_unknown = setdiff(1:dim,DBC_dofs);
m           = length(DBC_dofs);
n           = length(dof_unknown);
D = [Kgl(dof_unknown,dof_unknown),spalloc(n,m,1);spalloc(m,n,1),speye(m,m)]\...
    [LVEC(dof_unknown)'-Kgl(dof_unknown,DBC_dofs)*DBC_displ;DBC_displ];
D([dof_unknown';DBC_dofs]) = D;
end
