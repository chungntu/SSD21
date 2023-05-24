function [SIGsys] = FEM_3_stressCSTQ(in_data,resp)

% -------------------------------------------------------------------------

fj = size(in_data.EL,1);
if in_data.EL(1,2)==4 SIGsys=zeros(fj(1)*3,1); end
if in_data.EL(1,2)==5 SIGsys=zeros(fj(1)*3,5); end

for i=1:fj
    
    if in_data.EL(i,2)==4
        node1 = find(in_data.ND(:,1)==in_data.EL(i,3));
        node2 = find(in_data.ND(:,1)==in_data.EL(i,4));
        node3 = find(in_data.ND(:,1)==in_data.EL(i,5));
        
        E1=in_data.EL(i,6);
        h_1 = in_data.EL(i,7);
        miu_1 = in_data.EL(i,8);
        
        
        [Bsys,Esys] = FEM_ELEMENT_CST (in_data.ND(node1,2),in_data.ND(node1,3), ...
            in_data.ND(node2,2),in_data.ND(node2,3), ...
            in_data.ND(node3,2),in_data.ND(node3,3),E1,h_1,miu_1);
        
        Dlocal = [resp.static.D(node1*2-1) resp.static.D(node1*2) ...
            resp.static.D(node2*2-1) resp.static.D(node2*2) ...
            resp.static.D(node3*2-1) resp.static.D(node3*2)];
        SIGlocal = Esys*Bsys*Dlocal';
        
        SIGsys((i*3-2):(i*3)) = SIGlocal;
    end;
    
    if in_data.EL(i,2)==5
        node1 = find(in_data.ND(:,1)==in_data.EL(i,3));
        node2 = find(in_data.ND(:,1)==in_data.EL(i,4));
        node3 = find(in_data.ND(:,1)==in_data.EL(i,5));
        node4 = find(in_data.ND(:,1)==in_data.EL(i,6));
        
        Em=in_data.EL(i,7);
        hT = in_data.EL(i,8:11);
        miu_1 = in_data.EL(i,12);
        
        [B_lc,E_lc] = FEM_ELEMENT_CSQ (in_data.ND(node1,2),in_data.ND(node1,3), ...
            in_data.ND(node2,2),in_data.ND(node2,3), ...
            in_data.ND(node3,2),in_data.ND(node3,3), ...
            in_data.ND(node4,2),in_data.ND(node4,3), Em, hT, miu_1,0);
        
        Dlocal = [resp.static.D(node1*2-1) resp.static.D(node1*2) ...
            resp.static.D(node2*2-1) resp.static.D(node2*2) ...
            resp.static.D(node3*2-1) resp.static.D(node3*2) ...
            resp.static.D(node4*2-1) resp.static.D(node4*2)];
        
        SIGlocal_c = B_lc(:,:,1)*Dlocal';
        SIGlocal_1 = B_lc(:,:,2)*Dlocal';
        SIGlocal_2 = B_lc(:,:,3)*Dlocal';
        SIGlocal_3 = B_lc(:,:,4)*Dlocal';
        SIGlocal_4 = B_lc(:,:,5)*Dlocal';
        
        SIGsys((i*3-2):(i*3),1) = E_lc*SIGlocal_c;
        SIGsys((i*3-2):(i*3),2) = E_lc*SIGlocal_1;
        SIGsys((i*3-2):(i*3),3) = E_lc*SIGlocal_2;
        SIGsys((i*3-2):(i*3),4) = E_lc*SIGlocal_3;
        SIGsys((i*3-2):(i*3),5) = E_lc*SIGlocal_4;
        
    end;
    
end;
