%--------------------------------------------------------------------------
% 2D CST ELEMENT
% Truong Thanh Chung. Aug 2021.
%--------------------------------------------------------------------------
function [B,E,K,M] = FEM_ELEMENT_CST (x1, y1, x2, y2, x3, y3, Em, h, miu)
A = (0.5 * det([1 1 1; x1 x2 x3; y1 y2 y3]));
E = Em/(1-miu^2).*[ 1  miu  0; miu  1  0; 0  0  (1-miu)/2 ];
B = [  (y2-y3)   0      (y3-y1) 0       (y1-y2)  0;
       0        (x3-x2)  0      (x1-x3)  0       (x2-x1);
       (x3-x2)  (y2-y3) (x1-x3) (y3-y1) (x2-x1)  (y1-y2) ];
B = 1/(2*A).*B;
K = A*h.*B'*E*B ;
M = zeros(6,6); 
M  = 1/12*h*A*[2 0 1 0 1 0;
               0 2 0 1 0 1;
               1 0 2 0 1 0;
               0 1 0 2 0 1;
               1 0 1 0 2 0;
               0 1 0 1 0 2];
