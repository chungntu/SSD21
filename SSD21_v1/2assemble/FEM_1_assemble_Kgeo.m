%--------------------------------------------------------------------------
% ASSEMBLE GEOMETRY STIFFNESS MATRIX
% Truong Thanh Chung. Aug 2021.
%--------------------------------------------------------------------------
function Kgeo = FEM_1_assemble_Kgeo(in_data,Np)
[dofN,EL_TYPE,ndPerElem] = elemType(in_data);
switch EL_TYPE
    case {0,1,2,333}    % 2D Frame
        [rowK,colK,valK] = FEM_2_assemKgeo_2DFrame(in_data,Np,dofN,ndPerElem);     
end
Kgeo = sparse(rowK,colK,valK,dofN*size(in_data.ND,1),dofN*size(in_data.ND,1));
