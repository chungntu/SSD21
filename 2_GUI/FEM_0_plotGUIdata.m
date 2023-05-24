%--------------------------------------------------------------------------
% PLOT GUI DATA
% Truong Thanh Chung. Aug 2021.
%--------------------------------------------------------------------------
function FEM_0_plotGUIdata(inData,opt)
if ~isempty(inData)
    if opt.GUI
        [dofN,EL_TYPE,~] = elemType(inData);
        dof_ = size(inData.ND,1)*dofN;
        switch EL_TYPE
            case {0,1,2,333}
                FEM_1_plotGUIdata_2DStructure(inData,opt);
            case {3,31}
                FEM_1_plotGUIdata_3DStructure(inData);
            case {4,5,51}
                FEM_1_plotGUIdata_CSTQ(inData);
            case {6}
                FEM_1_plotGUIdata_brick (inData);
            case {9}
                FEM_1_plotGUIdata_bend(inData, dof_, 120, showNode);
            case {10}
                FEM_1_plotGUIdata_tetrah(inData);
        end
    end
end
