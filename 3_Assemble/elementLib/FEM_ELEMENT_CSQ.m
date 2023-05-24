%--------------------------------------------------------------------------
% 2D CSQ ELEMENT
% Truong Thanh Chung. Aug 2021.
%--------------------------------------------------------------------------
function [B,E,K,M] = FEM_ELEMENT_CSQ (x1, y1, x2, y2, x3, y3, x4, y4, Em,hT,miu,rho)
E  = Em/(1-miu^2).*[ 1  miu  0; miu  1  0; 0  0  (1-miu)/2 ];
K  = zeros(8,8); K2 = zeros(8,8);
M  = zeros(8,8); M2 = zeros(8,8);
B  = zeros(3,8); B2 = zeros(3,8);
int_point = [ -sqrt(3/5)  0  sqrt(3/5) ]; 

for i=1:3
   if i==1 niu=int_point(1); end
   if i==2 niu=int_point(2); end
   if i==3 niu=int_point(3); end
   for k=1:3
      if k==1 xi=int_point(1); end
      if k==2 xi=int_point(2); end
      if k==3 xi=int_point(3); end
      R = 1/4.*[  (-1+niu) (1-niu) (1+niu) (-1-niu) ; (-1+xi) (-1-xi) (1+xi) (1-xi) ];

      J =  R * [ x1 y1; x2 y2; x3 y3; x4 y4 ];
      if inv(J) <=0 disp(['     error: negative Jacobian in element']); end
      dN = inv(J)*R;

      B1 = [dN(1,1)    0    dN(1,2)    0    dN(1,3)    0    dN(1,4)    0;
              0    dN(2,1)    0    dN(2,2)    0    dN(2,3)    0    dN(2,4);
           dN(2,1) dN(1,1) dN(2,2) dN(1,2) dN(2,3) dN(1,3) dN(2,4) dN(1,4)];
        
      N1 = 1/4*(1-xi)*(1-niu);
      N2 = 1/4*(1+xi)*(1-niu);
      N3 = 1/4*(1+xi)*(1+niu);
      N4 = 1/4*(1-xi)*(1+niu);
      
      N = [diag(ones(1,8).*N1)  diag(ones(1,8).*N2) diag(ones(1,8).*N3) diag(ones(1,8).*N4) ];
        
      hi  = hT(1)*N1 + hT(2)*N2 + hT(3)*N3 + hT(4)*N4; 
      M1 = rho.*hi.*N*N'.*det(J) ;
      K1 = hi.*B1'*E*B1.*det(J) ;
      
      if xi==0 && niu==0 B(1:3,1:8,1) = B1; end

      if k==1 M2 = M2 + 5/9.*M1; end
      if k==2 M2 = M2 + 8/9.*M1; end
      if k==3 M2 = M2 + 5/9.*M1; end
      
      if k==1 K2 = K2 + 5/9.*K1; end
      if k==2 K2 = K2 + 8/9.*K1; end
      if k==3 K2 = K2 + 5/9.*K1; end
   end
   if i==1 M = M + 5/9.*M2; end
   if i==2 M = M + 8/9.*M2; end
   if i==3 M = M + 5/9.*M2; end
   
   if i==1 K = K + 5/9.*K2; end
   if i==2 K = K + 8/9.*K2; end
   if i==3 K = K + 5/9.*K2; end
   
   K2 = K2.*0; M2 = M2.*0;
end

point_niu = [ -1 -1 1 1]; 
point_xi  = [ -1 1 1 -1]; 
c_i = 2;
for i=1:4
    niu = point_niu(i);
    xi  = point_xi(i);
    R = 1/4.*[  (-1+niu) (1-niu) (1+niu) (-1-niu) ; (-1+xi) (-1-xi) (1+xi) (1-xi) ];

    J =  R * [ x1 y1; x2 y2; x3 y3; x4 y4 ];
    dN = inv(J)*R; 

    B1 = [dN(1,1)    0    dN(1,2)    0    dN(1,3)    0    dN(1,4)       0;
        0    dN(2,1)     0    dN(2,2)    0    dN(2,3)    0    dN(2,4);
        dN(2,1) dN(1,1)  dN(2,2) dN(1,2) dN(2,3) dN(1,3) dN(2,4) dN(1,4)];
        
    B(1:3,1:8,c_i) = B1; 
    c_i = c_i+1;
end;
