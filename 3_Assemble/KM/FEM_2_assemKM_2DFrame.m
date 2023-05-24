%--------------------------------------------------------------------------
% ASSEMBLE STIFFNESS AND MASS MATRIX
% 2D FRAME
% Truong Thanh Chung. Aug 2021.
%--------------------------------------------------------------------------
function [row,col,valK,valM] = FEM_2_assemKM_2DFrame(inData,dofN,ndPerElem,opt)
dofPerElem  = ndPerElem*dofN;                       % dof of one element, e.g. beam 6
Lsquare     = dofPerElem*dofPerElem;                % square dofPerElem, e.g. beam 36
lngth       = (dofPerElem)^2*size(inData.EL,1);    % square dofPerElem * number of elements
row         = zeros(lngth,1);
col         = zeros(lngth,1);
valK        = zeros(lngth,1);
valM        = zeros(lngth,1);
cIdx        = 1;
for i = 1:size(inData.EL,1)
    node1   = inData.EL(i,3);
    node2   = inData.EL(i,4);
    E       = inData.EL(i,5);
    nu      = 0.3;
    G       = E/(2*(1+nu));
    A       = inData.EL(i,6);
    I       = inData.EL(i,7);
    ks      = 5/6;              % SHEAR CORRECTION FACTOR FOR RECTANGULAR SECTION
    rho     = inData.EL(i,8);
    switch inData.EL(i,2)
        case {0}    % Fix-Fix beam
            if opt.Timoshenko
                [M_local,K_local] = FEM_ELEMENT_2D_Timoshenko_FF_BEAM(inData.ND(node1,2),inData.ND(node1,3),...
                    inData.ND(node2,2), inData.ND(node2,3),E,G,A,I,ks,rho);
            else
                [M_local,K_local] = FEM_ELEMENT_2D_FF_BEAM(inData.ND(node1,2),inData.ND(node1,3),...
                    inData.ND(node2,2), inData.ND(node2,3),E,A,I,rho);
            end
            % BEAM ON ELASTIC FOUNDATION
            % [M_local,K_local] = beam2w(inData.ND(node1,2),inData.ND(node1,3),inData.ND(node2,2),inData.ND(node2,3),E,A,I,0,500);
            
        case {1}    % Fix-Pin beam
            if opt.Timoshenko
                disp('TIMOSHENKO BEAM NOT SUPPORTED FOR HINGES')
            end
            [M_local,K_local] = FEM_ELEMENT_2D_FP_BEAM (inData.ND(node1,2),inData.ND(node1,3),...
                inData.ND(node2,2), inData.ND(node2,3),E,A,I,rho);
        case {2}    % Pin-Fix beam
            if opt.Timoshenko
                disp('TIMOSHENKO BEAM NOT SUPPORTED FOR HINGES')
            end
            [M_local,K_local] = FEM_ELEMENT_2D_PF_BEAM (inData.ND(node1,2),inData.ND(node1,3),...
                inData.ND(node2,2), inData.ND(node2,3),E,A,I,rho);
        case {333}  % Pin-Pin beam
            if opt.Timoshenko
                disp('TIMOSHENKO BEAM NOT SUPPORTED FOR HINGES')
            end
            [M_local,K_local] = FEM_ELEMENT_2D_PP_BEAM (inData.ND(node1,2),inData.ND(node1,3),...
                inData.ND(node2,2), inData.ND(node2,3),E,A,I,rho);
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
