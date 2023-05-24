%--------------------------------------------------------------------------
% GET VALUE TO PLOT MODAL FIGURES
% Truong Thanh Chung. Aug 2021.
%--------------------------------------------------------------------------
function [deN] = getScaleMode(in_data,D,dof)
[dofN,EL_TYPE,ndPerElem] = elemType(in_data);
switch EL_TYPE
    case {0,1,2,333} % 2D Frame
    [dofN,EL_TYPE,ndPerElem] = elemType(in_data);
    max_D_x = max(abs(D(1:dofN:dof(1))));
    max_D_y = max(abs(D(2:dofN:dof(1))));
    deN     = max([max_D_x  max_D_y]);
    case {3,31} 	% 3D Frame/Truss
    [dofN,EL_TYPE,ndPerElem] = elemType(in_data);
    max_D_x = max(abs(D(1:dofN:dof(1))));
    max_D_y = max(abs(D(2:dofN:dof(1))));
    max_D_z = max(abs(D(3:dofN:dof(1))));
    deN = max([max_D_x, max_D_y, max_D_z]);
end
