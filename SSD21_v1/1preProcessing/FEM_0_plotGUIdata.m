%--------------------------------------------------------------------------
% PLOT GUI DATA
% Truong Thanh Chung. Aug 2021.
%--------------------------------------------------------------------------
function FEM_0_plotGUIdata(in_data,opt)
if opt.GUI
    [dofN,EL_TYPE,~] = elemType(in_data);
    dof_ = size(in_data.ND,1)*dofN;
    switch EL_TYPE
        case {0,1,2,333}
            FEM_1_plotGUIdata_2DStructure(in_data);
        case {3,31}
            FEM_1_plotGUIdata_3DStructure(in_data);
        case {4,5,51}
            FEM_1_plotGUIdata_CSTQ(in_data);
        case {6}
            FEM_1_plotGUIdata_brick (in_data);
        case {9}
            FEM_1_plotGUIdata_bend(in_data, dof_, 120, showNode);
        case {10}
            FEM_1_plotGUIdata_tetrah(in_data);
    end
end
