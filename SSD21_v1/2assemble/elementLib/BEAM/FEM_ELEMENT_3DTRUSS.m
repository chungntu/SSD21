%--------------------------------------------------------------------------
% 3D TRUSS ELEMENT
% Truong Thanh Chung. Aug 2021.
%--------------------------------------------------------------------------
function [M,K,T] = FEM_ELEMENT_3DTRUSS (x1, y1, z1, x2, y2, z2, E, A, rho)
L = sqrt((x2-x1)^2 + (y2-y1)^2 + (z2-z1)^2);
Lx = (x2-x1) / L;
Ly = (y2-y1) / L;
Lz = (z2-z1) / L;
Ke = A*E/L *   [1  -1;
               -1   1];
Me = (rho*A*L/4)*[1 -1;
                 -1  1];
T =  [ Lx Ly Lz    0  0  0 ;
        0  0  0   Lx Ly Lz ];
K = T'*Ke*T;	
M = T'*Me*T;
