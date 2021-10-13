%--------------------------------------------------------------------------
% ASSEMBLE STIFFNESS AND MASS MATRIX
% 2D FRAME
% Truong Thanh Chung. Aug 2021.
%--------------------------------------------------------------------------
function [row,col,valK,valM] = FEM_2_assemKM_2DFrame(in_data,dofN,ndPerElem)
dofPerElem  = ndPerElem*dofN;                       % dof of one element, e.g. beam 6
Lsquare     = dofPerElem*dofPerElem;                % square dofPerElem, e.g. beam 36
lngth       = (dofPerElem)^2*size(in_data.EL,1);    % square dofPerElem * number of elements
row         = zeros(lngth,1);
col         = zeros(lngth,1);
valK        = zeros(lngth,1);
valM        = zeros(lngth,1);
cIdx        = 1;
for i = 1:size(in_data.EL,1)
    node1   = in_data.EL(i,3);
    node2   = in_data.EL(i,4);
    E       = in_data.EL(i,5);
    A       = in_data.EL(i,6);
    I       = in_data.EL(i,7);
    rho     = in_data.EL(i,8);
    switch in_data.EL(i,2)
        case {0}    % Fix-Fix beam
            [M_local,K_local] = FEM_ELEMENT_2D_FF_BEAM(in_data.ND(node1,2),in_data.ND(node1,3),...
                in_data.ND(node2,2), in_data.ND(node2,3),E,A,I,rho);
        case {1}    % Fix-Pin beam
            [M_local,K_local] = FEM_ELEMENT_2D_FP_BEAM (in_data.ND(node1,2),in_data.ND(node1,3),...
                in_data.ND(node2,2), in_data.ND(node2,3),E,A,I,rho);
        case {2}    % Pin-Fix beam
            [M_local,K_local] = FEM_ELEMENT_2D_PF_BEAM (in_data.ND(node1,2),in_data.ND(node1,3),...
                in_data.ND(node2,2), in_data.ND(node2,3),E,A,I,rho);
        case {333}  % Pin-Pin beam
            [M_local,K_local] = FEM_ELEMENT_2D_PP_BEAM (in_data.ND(node1,2),in_data.ND(node1,3),...
                in_data.ND(node2,2), in_data.ND(node2,3),E,A,I,rho);
    end
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
    valM(linAr) = valM(linAr) + M_local(:);
    cIdx        = cIdx + Lsquare;
end
