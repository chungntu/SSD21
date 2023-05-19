%--------------------------------------------------------------------------
% ASSEMBLE STIFFNESS AND MASS MATRIX
% 2D CSQ (CONSTANT STRAIN QUADRILATERAL) MEMBRANE ELEMENT
% Truong Thanh Chung. Aug 2021.
%--------------------------------------------------------------------------
function [rowK, colK,valK,valM] = FEM_2_assemKM_CSQ (in_data,dofN,ndPerElem)
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
    node4 = find(in_data.ND(:,1)==in_data.EL(i,6));
    Em = in_data.EL(i,7);
    hT = in_data.EL(i,8:11);
    miu_1 = in_data.EL(i,12);
    rho_=in_data.EL(i,13);
    if in_data.EL(i,2)==5
        [Bsys,Esys,Klc,Msys] = FEM_ELEMENT_CSQ(in_data.ND(node1,2),in_data.ND(node1,3), ...
            in_data.ND(node2,2),in_data.ND(node2,3),in_data.ND(node3,2),in_data.ND(node3,3),...
            in_data.ND(node4,2),in_data.ND(node4,3), Em, hT, miu_1,rho_);
    end
    if in_data.EL(i,2)==51
        ex = in_data.PML.ex;
        ey = in_data.PML.ey;
        [Bsys,Esys,Klc,Msys] = D2_CSQ_PML (in_data.ND(node1,2),in_data.ND(node1,3), ...
            in_data.ND(node2,2),in_data.ND(node2,3),in_data.ND(node3,2),in_data.ND(node3,3),...
            in_data.ND(node4,2),in_data.ND(node4,3), Em, hT, miu_1, ex, ey);
            Msys = Msys.*diag([ex ey ex ey ex ey ex ey]);
    end
    t1 = node1*dofN; t2 = node2*dofN; t3 = node3*dofN; t4 = node4*dofN;
    bg = [(t1-(dofN-1)):t1];  md1= [(t2-(dofN-1)):t2];
    md2= [(t3-(dofN-1)):t3];  en = [(t4-(dofN-1)):t4];
    qL  = [bg md1 md2 en];
    rowLoc = reshape(repmat(qL,dofPerElem,1),Lsq,1);
    colLoc = repmat(qL',dofPerElem,1);
    linAr = cIdx:cIdx+Lsq-1;
    rowK(linAr) = rowK(linAr) + rowLoc;
    colK(linAr) = colK(linAr) + colLoc;
    valK(linAr) = valK(linAr) + Klc(:);
    valM(linAr) = valM(linAr) + Msys(:);
    cIdx = cIdx + Lsq;
end
