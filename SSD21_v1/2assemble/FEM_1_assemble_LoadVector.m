%--------------------------------------------------------------------------
% ASSEMBLE LOAD VECTOR
% Truong Thanh Chung. Aug 2021.
%--------------------------------------------------------------------------
function LVEC = FEM_1_assemble_LoadVector(in_data)
LVEC = FEM_2_concentratedLoad(in_data);
[~,EL_TYPE] = elemType(in_data);
if EL_TYPE ==0 || EL_TYPE==1 || EL_TYPE==2 || EL_TYPE==333
    LVEC_UNIFORM = FEM_2_uniformLoad(in_data);
    LVEC = LVEC + LVEC_UNIFORM;
end
end
% CONCENTRATED LOAD
function LVEC = FEM_2_concentratedLoad(in_data)
dofN = elemType(in_data);
dof_ = size(in_data.ND,1)*dofN;
LVEC = spalloc(1,dof_,1);
for i=1:size(in_data.LOAD_,1)
    t4 = in_data.LOAD_(i,1)*dofN-(dofN-1);
    for k=1:size(in_data.LOAD_,2)-1
        LVEC(t4+k-1) = in_data.LOAD_(i,k+1); %#ok<*SPRIX>
    end
end
end
% UNIFORM LOAD
function LVEC_UNIFORM = FEM_2_uniformLoad(in_data)
dof_        = size(in_data.ND,1)*3;
Nbeams      = size(in_data.EL,1);
LVEC_UNIFORM  = sparse(dof_,1,0);
for ELEMENT = 1:Nbeams
    node1 = in_data.EL(ELEMENT,3);
    node2 = in_data.EL(ELEMENT,4);
    x1 = in_data.ND(node1,2); y1 = in_data.ND(node1,3);
    x2 = in_data.ND(node2,2); y2 = in_data.ND(node2,3);
    L =  sqrt((x2-x1)^2+(y2-y1)^2);
    g = [ 3*node1-2 ; 3*node1-1 ; 3*node1 ; 3*node2-2 ; 3*node2-1 ; 3*node2 ];
    c = (x2-x1) / L;
    s = (y2-y1) / L;
    T = [ c s 0   0 0 0 ;
        -s c 0   0 0 0 ;
        0 0 1   0 0 0 ;
        0 0 0   c s 0 ;
        0 0 0  -s c 0 ;
        0 0 0   0 0 1 ];
    Qr   = [-s c;c s]*[in_data.qx(ELEMENT) in_data.qy(ELEMENT)]';
    Qadd = [Qr(2)*c*L/2 Qr(2)*s*L/2 0 Qr(2)*c*L/2 Qr(2)*s*L/2 0]';
    P_local = [ 0 ; Qr(1)*L/2 ; Qr(1)*L^2/12 ; 0 ; ...
        Qr(1)*L/2 ; -Qr(1)*L^2/12 ];
    LVEC_UNIFORM(g) = LVEC_UNIFORM(g) + Qadd + T' * P_local;
end
LVEC_UNIFORM = LVEC_UNIFORM';
end

