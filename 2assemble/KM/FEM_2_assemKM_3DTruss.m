%--------------------------------------------------------------------------
% ASSEMBLE STIFFNESS AND MASS MATRIX
% 3D TRUSS. ELEMENT TYPE 31
% Truong Thanh Chung. Aug 2021.
%--------------------------------------------------------------------------
function [rowK, colK,valK,valM] = FEM_2_assemKM_3DTruss (in_data,dofN,ndPerElem)
dofPerElem = ndPerElem*dofN;
Lsq   = dofPerElem*dofPerElem;
lngth = (dofPerElem)^2*size(in_data.EL,1);
rowK  = zeros(lngth,1);
colK  = zeros(lngth,1);
valK  = zeros(lngth,1);
valM  = zeros(lngth,1);
cIdx  = 1;
sxEL = size(in_data.EL,1);
for i=1:sxEL
    node1 = find(in_data.ND(:,1)==in_data.EL(i,3));
    node2 = find(in_data.ND(:,1)==in_data.EL(i,4));
    E=in_data.EL(i,5);
    A = in_data.EL(i,6);
    I = in_data.EL(i,7);
    rho= in_data.EL(i,8);
    [M_loc,Klc] = FEM_ELEMENT_3DTRUSS(in_data.ND(node1,2),in_data.ND(node1,3),...
        in_data.ND(node1,4), in_data.ND(node2,2), in_data.ND(node2,3),...
        in_data.ND(node2,4), E, A, rho);
    t1 = node1*dofN; t2 = node2*dofN;
    bg = [t1-(dofN-1):t1]; en = [t2-(dofN-1):t2];
    qL     = [bg en];
    rowLoc = reshape(repmat(qL,dofPerElem,1),Lsq,1);
    colLoc = repmat(qL',dofPerElem,1);
    linAr  = cIdx:cIdx+Lsq-1;
    rowK(linAr) = rowK(linAr) + rowLoc;
    colK(linAr) = colK(linAr) + colLoc;
    valK(linAr) = valK(linAr) + Klc(:);
    valM(linAr) = valM(linAr) + M_loc(:);
    cIdx = cIdx + Lsq;
end
