%--------------------------------------------------------------------------
% ASSEMBLE STIFFNESS AND MASS MATRIX
% Truong Thanh Chung. Aug 2021.
%--------------------------------------------------------------------------
function [Kgl,Mgl] = FEM_1_assemble_KM (in_data)
[dofN,EL_TYPE,ndPerElem] = elemType(in_data);
switch EL_TYPE
    case {0,1,2,333}    % 2D Frame
        [row,col,valK,valM] = FEM_2_assemKM_2DFrame(in_data,dofN,ndPerElem);
    case {3}            % 3D Frame
        [row,col,valK,valM] = FEM_2_assemKM_3DFrame(in_data,dofN,ndPerElem);
    case {31}           % 3D Truss
        [row,col,valK,valM] = FEM_2_assemKM_3DTruss(in_data,dofN,ndPerElem);
    case {4}            % CST
        [row,col,valK,valM] = FEM_2_assemKM_CST(in_data,dofN,ndPerElem);
    case {6}            % 3D Brick
        [row,col,valK,valM] = FEM_2_assemKM_3DBrick(in_data,dofN,ndPerElem);
    case {10}           % 3D Tetrahedron
        [row,col,valK,valM] = FEM_2_assemKM_3DTetrahedron(in_data,dofN,ndPerElem);
    case {5,51}         % CSQ
        [row,col,valK,valM] = FEM_2_assemKM_CSQ(in_data,dofN,ndPerElem);
    case{9}             % BCIZ Plate
        [row,col,valK,valM] = FEM_2_assemKM_BCIZPlate(in_data,dofN,ndPerElem);
end
Kgl = sparse(row,col,valK, dofN*size(in_data.ND,1), dofN*size(in_data.ND,1));
Mgl = sparse(row,col,valM, dofN*size(in_data.ND,1), dofN*size(in_data.ND,1));
%% ADD LUMP MASS
if  isfield(in_data,'MASS')
    nrAdd = size(in_data.MASS,2)-1;
    for i=1:size(in_data.MASS,1)
        for j=1:nrAdd
            Mgl(in_data.MASS(i,1)*dofN - (dofN-j), ...
                in_data.MASS(i,1)*dofN - (dofN-j) ) = ...
                Mgl(in_data.MASS(i,1)*dofN - (dofN-j), ...
                in_data.MASS(i,1)*dofN - (dofN-j) ) + in_data.MASS(i,j+1);
        end
    end
end
