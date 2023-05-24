%--------------------------------------------------------------------------
% TYPE OF STRUCTURE (FRAME, PLATE, SOLID)
% Truong Thanh Chung. Aug 2021.
%--------------------------------------------------------------------------
function [dofN,EL_TYPE,ndPerElem] = elemType(inData)
EL_TYPE = inData.EL(1,2);
switch EL_TYPE
    case {0,1,2,333} % 2D Frame
        dofN = 3; ndPerElem  = 2;
    case {31} % 3D Truss
        dofN = 3; ndPerElem  = 2;
    case {3}% 3D Frame
        dofN = 6; ndPerElem  = 2;
    case {4} % CST elem
        dofN = 2; ndPerElem  = 3;
    case {5,51} % CSQ elem
        dofN = 2; ndPerElem  = 4;
    case {6} % 3D-brick
        dofN = 3; ndPerElem  = 8;
    case {9} % BCIZ plate
        dofN = 3; ndPerElem  = 3;
    case {10} % Tetrahedron 3D
        dofN = 3; ndPerElem  = 4;
    otherwise % Unknown element
        dofN = 0; ndPerElem  = 0;
        return;
end
