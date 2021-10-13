function [SIGsys] = FEM_3_stressTetr(in_data, resp)

% -------------------------------------------------------------------------


fj = size(in_data.EL,1);
SIGsys = zeros(size(in_data.ND,1),1);

for i=1:fj
   if in_data.EL(i,2)==10
      node1 = find(in_data.ND(:,1)==in_data.EL(i,3));
      node2 = find(in_data.ND(:,1)==in_data.EL(i,4));
      node3 = find(in_data.ND(:,1)==in_data.EL(i,5));
      node4 = find(in_data.ND(:,1)==in_data.EL(i,6));
      
      if in_data.mater.E~=0    Em=in_data.mater.E;    else Em=in_data.EL(i,7);    end;
      if in_data.mater.miu~=0  miu=in_data.mater.miu; else miu = in_data.EL(i,8); end;
      if in_data.mater.rho~=0  rho=in_data.mater.rho; else rho=in_data.EL(i,9);   end;
      
      [Klc,Mlc,B_lc,E_lc] = FEM_ELEMENT_TETRAH(in_data.ND(node1,2), ...
            in_data.ND(node1,3), in_data.ND(node1,4), ...
            in_data.ND(node2,2), in_data.ND(node2,3), ...
            in_data.ND(node2,4), in_data.ND(node3,2), ...
            in_data.ND(node3,3), in_data.ND(node3,4), ...
            in_data.ND(node4,2), in_data.ND(node4,3), ...
            in_data.ND(node4,4), Em, miu);
      
      
      Dlocal = [resp.static.D(node1*3-2) resp.static.D(node1*3-1) ...
                resp.static.D(node1*3) ...
                resp.static.D(node2*3-2) resp.static.D(node2*3-1) ...
                resp.static.D(node2*3) ...
                resp.static.D(node3*3-2) resp.static.D(node3*3-1) ...
                resp.static.D(node3*3) ...
                resp.static.D(node4*3-2) resp.static.D(node4*3-1) ...
                resp.static.D(node4*3)];
      
      SIGlocal_1 = E_lc*B_lc*Dlocal';
      SIGlocal_2 = E_lc*B_lc*Dlocal';
      SIGlocal_3 = E_lc*B_lc*Dlocal';
      SIGlocal_4 = E_lc*B_lc*Dlocal';
      
      SIGsys(node1,1:6) = SIGlocal_1';
      SIGsys(node2,1:6) = SIGlocal_2';
      SIGsys(node3,1:6) = SIGlocal_3';
      SIGsys(node4,1:6) = SIGlocal_4';
  end;   
end;

