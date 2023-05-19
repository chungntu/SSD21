%--------------------------------------------------------------------------
% ASSEMBLE STIFFNESS AND MASS MATRIX
% BCIZ Plate. ELEMENT TYPE 9
% Truong Thanh Chung. Aug 2021.
%--------------------------------------------------------------------------
function [rowK, colK,valK,valM] = FEM_2_assemKM_BCIZPlate (in_data,dofN,ndPerElem)
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
    E=in_data.EL(i,6); 
    h = in_data.EL(i,7);
    miu = in_data.EL(i,8); 
    x1 = in_data.ND(node1,2); y1 = in_data.ND(node1,3);
    x2 = in_data.ND(node2,2); y2 = in_data.ND(node2,3);
    x3 = in_data.ND(node3,2); y3 = in_data.ND(node3,3);
    [Klc,ML] = D2_BCIZ (x1,y1,x2,y2,x3,y3,E,h,miu);
    t1 = node1*dofN; t2 = node2*dofN; t3 = node3*dofN;
    A = (0.5 * det([1 1 1; x1 x2 x3; y1 y2 y3]) );
    ML = ML.*in_data.mater.rhoX;
    bg = [(t1-2):t1];  md1= [(t2-2):t2]; md2= [(t3-2):t3];
    qL     = [bg md1 md2];
    rowLoc = reshape(repmat(qL,dofPerElem,1),Lsq,1);
    colLoc = repmat(qL',dofPerElem,1);
    linAr  = cIdx:cIdx+Lsq-1;
    rowK(linAr) = rowK(linAr) + rowLoc;
    colK(linAr) = colK(linAr) + colLoc;
    valK(linAr) = valK(linAr) + Klc(:);
    valM(linAr) = valM(linAr) + ML(:);
    cIdx = cIdx + Lsq;
end
