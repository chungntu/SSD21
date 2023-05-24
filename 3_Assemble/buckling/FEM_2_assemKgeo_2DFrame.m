%--------------------------------------------------------------------------
% ASSEMBLE GEOMETRIC STIFFNESS MATRIX
% 2D FRAME
% Truong Thanh Chung. Aug 2021.
%--------------------------------------------------------------------------
function [rowKgeo,colKgeo,valKgeo] = FEM_2_assemKgeo_2DFrame(in_data,Np,dofN,ndPerElem)
dofPerElem = ndPerElem*dofN;
Lsq   = dofPerElem*dofPerElem;
lngth = (dofPerElem)^2*size(in_data.EL,1);
rowKgeo  = zeros(lngth,1);
colKgeo  = zeros(lngth,1);
valKgeo  = zeros(lngth,1);
cIdx  = 1;
nEL   = size(in_data.EL,1);
for i = 1:nEL
    node1 = in_data.EL(i,3);
    node2 = in_data.EL(i,4);
    switch in_data.EL(i,2)
        case {0}    % Fix-Fix beam
            Npi = -Np(1,i);
            Kgeo_local = FEM_ELEMENT_2D_BUCKLING_FF_BEAM(in_data.ND(node1,2),in_data.ND(node1,3),in_data.ND(node2,2),in_data.ND(node2,3),Npi);
    end
    t1 = node1*dofN; t2 = node2*dofN;
    bg = t1-(dofN-1):t1; en = t2-(dofN-1):t2;
    qL     = [bg en];
    rowLoc = reshape(repmat(qL,dofPerElem,1),Lsq,1);
    colLoc = repmat(qL',dofPerElem,1);
    linAr  = cIdx:cIdx+Lsq-1;
    rowKgeo(linAr) = rowKgeo(linAr) + rowLoc;
    colKgeo(linAr) = colKgeo(linAr) + colLoc;
    valKgeo(linAr) = valKgeo(linAr) + Kgeo_local(:);
    cIdx = cIdx + Lsq;
end
