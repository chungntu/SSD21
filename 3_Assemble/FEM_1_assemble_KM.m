%--------------------------------------------------------------------------
% ASSEMBLE STIFFNESS AND MASS MATRIX
% Truong Thanh Chung. Aug 2021.
%--------------------------------------------------------------------------
function [Kgl,Mgl] = FEM_1_assemble_KM (inData,opt)
[dofN,EL_TYPE,ndPerElem] = elemType(inData);
switch EL_TYPE
    case {0,1,2,333}    % 2D Frame
        [row,col,valK,valM] = FEM_2_assemKM_2DFrame(inData,dofN,ndPerElem,opt);
    case {3}            % 3D Frame
        [row,col,valK,valM] = FEM_2_assemKM_3DFrame(inData,dofN,ndPerElem);
    case {31}           % 3D Truss
        [row,col,valK,valM] = FEM_2_assemKM_3DTruss(inData,dofN,ndPerElem);
    case {4}            % CST
        [row,col,valK,valM] = FEM_2_assemKM_CST(inData,dofN,ndPerElem);
    case {6}            % 3D Brick
        [row,col,valK,valM] = FEM_2_assemKM_3DBrick(inData,dofN,ndPerElem);
    case {10}           % 3D Tetrahedron
        [row,col,valK,valM] = FEM_2_assemKM_3DTetrahedron(inData,dofN,ndPerElem);
    case {5,51}         % CSQ
        [row,col,valK,valM] = FEM_2_assemKM_CSQ(inData,dofN,ndPerElem);
    case{9}             % BCIZ Plate
        [row,col,valK,valM] = FEM_2_assemKM_BCIZPlate(inData,dofN,ndPerElem);
end
Kgl = sparse(row,col,valK, dofN*size(inData.ND,1), dofN*size(inData.ND,1));
Mgl = sparse(row,col,valM, dofN*size(inData.ND,1), dofN*size(inData.ND,1));
%% ADD LUMP MASS
if  isfield(inData,'MASS')
    nrAdd = size(inData.MASS,2)-1;
    for i=1:size(inData.MASS,1)
        for j=1:nrAdd
            Mgl(inData.MASS(i,1)*dofN - (dofN-j), ...
                inData.MASS(i,1)*dofN - (dofN-j) ) = ...
                Mgl(inData.MASS(i,1)*dofN - (dofN-j), ...
                inData.MASS(i,1)*dofN - (dofN-j) ) + inData.MASS(i,j+1);
        end
    end
end
