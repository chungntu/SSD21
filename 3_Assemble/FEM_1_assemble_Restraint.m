%--------------------------------------------------------------------------
% SOLVE D = K\F, ONE NEEDS TO SPECIFY THE DOFS NEED TO CALCULATE
% FOR EXAMPLE, INGNORE DOFS ASSOCIATED WITH RESTRAINTS OR GROUND
% DISPLACEMENT
% ALSO IF THERE IS A HINGE, ONE SHOULD IGNORE THE ROTATION ANGLE OF THE HINGE
% Truong Thanh Chung. Aug 2021.
%--------------------------------------------------------------------------
function freeDOFs = FEM_1_assemble_Restraint(inData,model)
dofN        = elemType (inData);
dof_        = size(inData.ND,1)*dofN;
totalDOFs   = 1:dof_;
ind         = 1;
ignoreDOFs = inData.CON;
%% DOFS NEED TO CALCULATE
for i = 1:size(ignoreDOFs,1)
    for k = 1:dofN
        if ignoreDOFs(i,1+k)==0
            ignoreDOFs_GL(ind) = ignoreDOFs(i,1)*dofN-(dofN-k);
            ind = ind+1;
        end
    end
end
freeDOFs = setdiff(totalDOFs,ignoreDOFs_GL);
zerosColumn = find(sum(abs(model.Ksys.Kgl)) == 0);
freeDOFs = setdiff(freeDOFs,zerosColumn);
