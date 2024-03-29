function [M,K,Ke,T] = FEM_ELEMENT_2D_FF_BEAM (x1, y1, x2, y2, E, A, I, rho)
L = sqrt((x2-x1)^2 + (y2-y1)^2 );
c = (x2-x1) / L;
s = (y2-y1) / L;
 T = [ c s 0   0 0 0 ;
      -s c 0   0 0 0 ;
       0 0 1   0 0 0 ;
       0 0 0   c s 0 ;
       0 0 0  -s c 0 ;
       0 0 0   0 0 1 ];
Ke =  E*[ A/L      0        0      -A/L       0        0    ;
            0  12*I/L^3   6*I/L^2     0   -12*I/L^3  6*I/L^2 ;
            0    6*I/L^2  4*I/L       0    -6*I/L^2  2*I/L   ;
          -A/L      0        0       A/L       0        0    ;
            0  -12*I/L^3 -6*I/L^2     0    12*I/L^3 -6*I/L^2 ;
            0    6*I/L^2  2*I/L       0    -6*I/L^2  4*I/L   ];
Me = (rho*A*L/420)*[140      0      0   70      0        0;
                      0    156   22*L    0     54    -13*L;
                      0   22*L  4*L^2    0   13*L   -3*L^2;
                     70      0      0  140      0        0;
                      0     54   13*L    0    156    -22*L;
                      0  -13*L -3*L^2    0  -22*L    4*L^2];
Me2 = (rho*A*L/2)*[1 0 0 0 0 0;
                   0 1 0 0 0 0;
                   0 0 0 0 0 0;
                   0 0 0 1 0 0;
                   0 0 0 0 1 0;
                   0 0 0 0 0 0];
K = T'*Ke*T;
M = T'*Me*T;
