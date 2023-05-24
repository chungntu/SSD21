%      Compute the stiffness matrix for a two dimensional beam element
%      on elastic foundation.



function [M,K,Ke,T] = beam2w (x1, y1, x2, y2, E, A, I, ka, kt)
L = sqrt((x2-x1)^2 + (y2-y1)^2 );
c = (x2-x1) / L;
s = (y2-y1) / L;
T = [ c s 0   0 0 0 ;
    -s c 0   0 0 0 ;
    0 0 1   0 0 0 ;
    0 0 0   c s 0 ;
    0 0 0  -s c 0 ;
    0 0 0   0 0 1 ];
K1 =[E*A/L   0            0      -E*A/L      0          0 ;
    0   12*E*I/L^3   6*E*I/L^2  0   -12*E*I/L^3  6*E*I/L^2;
    0   6*E*I/L^2    4*E*I/L    0   -6*E*I/L^2   2*E*I/L;
    -E*A/L  0            0       E*A/L      0          0 ;
    0   -12*E*I/L^3 -6*E*I/L^2  0   12*E*I/L^3  -6*E*I/L^2;
    0   6*E*I/L^2    2*E*I/L    0   -6*E*I/L^2   4*E*I/L];
K2=L/420*[140*ka   0       0      70*ka    0       0     ;
    0    156*kt   22*kt*L    0    54*kt  -13*kt*L ;
    0    22*kt*L  4*kt*L^2   0   13*kt*L -3*kt*L^2;
    70*ka    0       0     140*ka    0       0     ;
    0    54*kt    13*kt*L    0   156*kt  -22*kt*L ;
    0   -13*kt*L -3*kt*L^2   0  -22*kt*L  4*kt*L^2];
Ke=K1+K2;
K=T'*Ke*T;

M = zeros(6,6);
