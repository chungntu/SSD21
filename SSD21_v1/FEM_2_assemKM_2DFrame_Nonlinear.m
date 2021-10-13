%--------------------------------------------------------------------------
% ASSEMBLE STIFFNESS AND MASS MATRIX
% 2D FRAME
% Truong Thanh Chung. Aug 2021.
%--------------------------------------------------------------------------
function [row,col,valK] = FEM_2_assemKM_2DFrame_Nonlinear(in_data,dofN,ndPerElem,Np)
dofPerElem  = ndPerElem*dofN;                       % dof of one element, e.g. beam 6
Lsquare     = dofPerElem*dofPerElem;                % square dofPerElem, e.g. beam 36
lngth       = (dofPerElem)^2*size(in_data.EL,1);    % square dofPerElem * number of elements
row         = zeros(lngth,1);
col         = zeros(lngth,1);
valK        = zeros(lngth,1);
cIdx        = 1;
for i = 1:size(in_data.EL,1)
    node1   = in_data.EL(i,3);
    node2   = in_data.EL(i,4);
    E       = in_data.EL(i,5);
    A       = in_data.EL(i,6);
    I       = in_data.EL(i,7);   
    N = Np(1,i);
    K_local = FEM_ELEMENT_2D_FF_BEAM_NONLINEAR(in_data.ND(node1,2),in_data.ND(node1,3),in_data.ND(node2,2), in_data.ND(node2,3),N,E,A,I);
    t1          = node1*dofN;
    t2          = node2*dofN;
    bg          = t1-(dofN-1):t1;
    en          = t2-(dofN-1):t2;
    qL          = [bg en];
    rowLoc      = reshape(repmat(qL,dofPerElem,1),Lsquare,1);
    colLoc      = repmat(qL',dofPerElem,1);
    linAr       = cIdx:cIdx+Lsquare-1;
    row(linAr)  = row(linAr) + rowLoc;
    col(linAr)  = col(linAr) + colLoc;
    valK(linAr) = valK(linAr) + K_local(:);
    cIdx        = cIdx + Lsquare;
end
