%--------------------------------------------------------------------------
% ASSEMBLE STIFFNESS AND MASS MATRIX
% 3D BRICK
% Truong Thanh Chung. Aug 2021.
%--------------------------------------------------------------------------
function [rowK, colK,valK,valM] = FEM_2_assemKM_3DBrick (in_data,dofN,ndPerElem)
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
    node5 = find(in_data.ND(:,1)==in_data.EL(i,7));
    node6 = find(in_data.ND(:,1)==in_data.EL(i,8));
    node7 = find(in_data.ND(:,1)==in_data.EL(i,9));
    node8 = find(in_data.ND(:,1)==in_data.EL(i,10));
    x1 = in_data.ND(node1,2); y1 = in_data.ND(node1,3); z1 = in_data.ND(node1,4);
    x2 = in_data.ND(node2,2); y2 = in_data.ND(node2,3); z2 = in_data.ND(node2,4);
    x3 = in_data.ND(node3,2); y3 = in_data.ND(node3,3); z3 = in_data.ND(node3,4);
    x4 = in_data.ND(node4,2); y4 = in_data.ND(node4,3); z4 = in_data.ND(node4,4);
    x5 = in_data.ND(node5,2); y5 = in_data.ND(node5,3); z5 = in_data.ND(node5,4);
    x6 = in_data.ND(node6,2); y6 = in_data.ND(node6,3); z6 = in_data.ND(node6,4);
    x7 = in_data.ND(node7,2); y7 = in_data.ND(node7,3); z7 = in_data.ND(node7,4);
    x8 = in_data.ND(node8,2); y8 = in_data.ND(node8,3); z8 = in_data.ND(node8,4);
    Em=in_data.EL(i,11);
    miu_1 = in_data.EL(i,12);
    rho_=in_data.EL(i,13);
    [Klc,Bsys,Esys,V] = FEM_ELEMENT_BRICK(x1,y1,z1,x2,y2,z2,x3,y3,z3,x4,y4,z4,...
        x5,y5,z5,x6,y6,z6,x7,y7,z7,x8,y8,z8,Em,miu_1);
    sf = ones(24,1);
    fM = V*rho_/8.*sf';
    t1 = node1*dofN; t2 = node2*dofN; t3 = node3*dofN; t4 = node4*dofN;
    t5 = node5*dofN; t6 = node6*dofN; t7 = node7*dofN; t8 = node8*dofN;
    bg = [(t1-(dofN-1)):t1];
    md1= [(t2-(dofN-1)):t2];
    md2= [(t3-(dofN-1)):t3];
    md3= [(t4-(dofN-1)):t4];
    md4= [(t5-(dofN-1)):t5];
    md5= [(t6-(dofN-1)):t6];
    md6= [(t7-(dofN-1)):t7];
    en = [(t8-(dofN-1)):t8];
    qL     = [bg md1 md2 md3 md4 md5 md6 en];
    rowLoc = reshape(repmat(qL,dofPerElem,1),Lsq,1);
    colLoc = repmat(qL',dofPerElem,1);
    linAr  = cIdx:cIdx+Lsq-1;
    rowK(linAr) = rowK(linAr) + rowLoc;
    colK(linAr) = colK(linAr) + colLoc;
    valK(linAr) = valK(linAr) + Klc(:);
    M_loc = diag(fM);
    valM(linAr) = valM(linAr) + M_loc(:);
    cIdx = cIdx + Lsq;
end
