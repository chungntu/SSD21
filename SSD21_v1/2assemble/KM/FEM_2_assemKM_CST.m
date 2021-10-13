%--------------------------------------------------------------------------
% ASSEMBLE STIFFNESS AND MASS MATRIX
% 2D CST (CONSTANT STRAIN TRIANGLE) MEMBRANE ELEMENT
% Truong Thanh Chung. Aug 2021.
%--------------------------------------------------------------------------
function [rowK, colK,valK,valM] = FEM_2_assemKM_CST (in_data,dofN,ndPerElem)
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
    node3 = find(in_data.ND(:,1)==in_data.EL(i,5));
    E1=in_data.EL(i,6);
    h_1 = in_data.EL(i,7);
    miu_1 = in_data.EL(i,8);
    rho_= in_data.EL(i,9);
    [Bsys,Esys,Klc,Msys] = FEM_ELEMENT_CST (in_data.ND(node1,2),in_data.ND(node1,3), ...
        in_data.ND(node2,2),in_data.ND(node2,3), in_data.ND(node3,2),...
        in_data.ND(node3,3), E1,h_1,miu_1);
    Msys = Msys.*rho_;
    t1 = node1*dofN; t2 = node2*dofN; t3 = node3*dofN;
    bg = [(t1-(dofN-1)):t1]; md = [(t2-(dofN-1)):t2];
    en = [(t3-(dofN-1)):t3];
    qL     = [bg md en];
    rowLoc = reshape(repmat(qL,dofPerElem,1),Lsq,1);
    colLoc = repmat(qL',dofPerElem,1);
    linAr  = cIdx:cIdx+Lsq-1;
    rowK(linAr) = rowK(linAr) + rowLoc;
    colK(linAr) = colK(linAr) + colLoc;
    valK(linAr) = valK(linAr) + Klc(:);
    valM(linAr) = valM(linAr) + Msys(:);
    cIdx = cIdx + Lsq;
end
