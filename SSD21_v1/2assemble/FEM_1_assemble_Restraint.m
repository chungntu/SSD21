%--------------------------------------------------------------------------
% ASSIGN RESTRAINTS
% Truong Thanh Chung. Aug 2021.
%--------------------------------------------------------------------------
function freeDOFs = FEM_1_assemble_Restraint(in_data)
dofN    = elemType (in_data);
dof_    = size(in_data.ND,1)*dofN;
L0      = 1:dof_;
ind     = 1;
for i = 1:size(in_data.CON,1)
    for k=1:dofN
        if in_data.CON(i,1+k)==0
            freeDOFs(ind) = in_data.CON(i,1)*dofN-(dofN-k);
            ind = ind+1;
        end
    end
end
% Free DOFs
freeDOFs = setdiff(L0,freeDOFs);
