%--------------------------------------------------------------------------
% 3D BEAM ELEMENT
% Truong Thanh Chung. Aug 2021.
%--------------------------------------------------------------------------
function [M,K] = FEM_ELEMENT_3DBEAM (x1, y1, z1, x2, y2, z2, E, G, b, h, rho, nu) 
L  = sqrt((x2-x1)^2 + (y2-y1)^2 + (z2-z1)^2);
A  = b*h;
kc = 10*(1+nu)/(12+11*nu);
Ay = A/kc;
Az = A/kc;
Ix  = 1;
Iy  = h*b^3/12;
Iz  = b*h^3/12;
Jx  = Iy+Iz;
Ixx = b*h^3*(1/3-0.21*h/b*(1-h^4/(12*b^4)));

if Ix==0
    J=Jx;
else
    J=Ixx;
end;

phiy = 1*12*E*Iz/(G*Az*L^2);
phiz = 1*12*E*Iy/(G*Ay*L^2);

az =  12*E*Iz/(L^3*(1+phiy));
ay =  12*E*Iy/(L^3*(1+phiz));
bz = -12*E*Iz/(L^3*(1+phiy));
by = -12*E*Iy/(L^3*(1+phiz));
cz =   6*E*Iz/(L^2*(1+phiy));
cy =   6*E*Iy/(L^2*(1+phiz));
dz =  -6*E*Iz/(L^2*(1+phiy));
dy =  -6*E*Iy/(L^2*(1+phiz));
ez = (4+phiy)*E*Iz/(L*(1+phiy));
ey = (4+phiz)*E*Iy/(L*(1+phiz));
fz = (2-phiy)*E*Iz/(L*(1+phiy));
fy = (2-phiz)*E*Iy/(L*(1+phiz));
ry = sqrt(Iy/A);
rz = sqrt(Iz/A);
A_z = ( 13/35+7/10*phiy+1/3*phiy^2+6/5*(rz/L)^2 )/( 1+phiy )^2;
A_y = ( 13/35+7/10*phiz+1/3*phiz^2+6/5*(ry/L)^2 )/( 1+phiz )^2;
B_z = ( 9/70+3/10*phiy+1/6*phiy^2-6/5*(rz/L)^2  )/( 1+phiy )^2;
B_y = ( 9/70+3/10*phiz+1/6*phiz^2-6/5*(ry/L)^2  )/( 1+phiz )^2;
C_z = ( 11/210+11/120*phiy+1/24*phiy^2+(1/10-1/2*phiy)*(rz/L)^2)*L/(1+phiy)^2;
C_y = ( 11/210+11/120*phiz+1/24*phiz^2+(1/10-1/2*phiz)*(ry/L)^2)*L/(1+phiz)^2;
D_z = ( 13/420+3/40*phiy+1/24*phiy^2-(1/10-1/2*phiy)*(rz/L)^2)*L/(1+phiy )^2;
D_y = ( 13/420+3/40*phiz+1/24*phiz^2-(1/10-1/2*phiz)*(ry/L)^2)*L/(1+phiz )^2;
E_z = ( 1/105+1/60*phiy+1/120*phiy^2+(2/15+1/6*phiy+1/3*phiy^2)*(rz/L)^2)*L^2/(1+phiy)^2;
E_y = ( 1/105+1/60*phiz+1/120*phiz^2+(2/15+1/6*phiz+1/3*phiz^2)*(ry/L)^2)*L^2/(1+phiz)^2;
F_z = -1*( 1/140+1/60*phiy+1/120*phiy^2+(1/30+1/6*phiy-1/6*phiy^2)*(rz/L)^2)*L^2/(1+phiy)^2;
F_y = -1*( 1/140+1/60*phiz+1/120*phiz^2+(1/30+1/6*phiz-1/6*phiz^2)*(ry/L)^2)*L^2/(1+phiz)^2;
Ko= [A*E/L  0   0    0      0   0 -A*E/L  0    0    0     0    0;
     0      az  0    0      0   cz  0     bz   0    0     0   cz;
     0      0   ay   0     dy   0   0     0    by   0    dy    0;
     0      0   0  G*J/L    0   0   0     0    0  -G*J/L  0    0;
     0      0   dy   0     ey   0   0     0    cy   0    fy    0;
     0      cz  0    0      0   ez  0    dz    0    0     0   fz;
    -A*E/L  0   0    0      0   0  A*E/L  0    0    0     0    0;
     0      bz  0    0      0   dz  0    az    0    0     0  -cz;
     0      0   by   0     cy   0   0     0    ay   0   -dy    0;
     0      0   0  -G*J/L   0   0   0     0    0  G*J/L   0    0;
     0      0   dy   0     fy   0   0     0   -dy   0    ey    0;
     0      cz  0    0      0   fz  0   -cz    0    0     0   ez];

Me=rho*A*L*[1/3   0      0        0      0    0  1/6     0    0    0      0    0;
             0    A_z    0        0      0  C_z    0   B_z    0    0      0 -D_z;
             0    0    A_y        0   -C_y    0    0     0  B_y    0    D_y    0;
             0    0      0    Jx/(3*A)   0    0    0     0    0 Jx/(6*A)  0    0;
             0    0   -C_y        0    E_y    0    0     0 -D_y    0    F_y    0;
             0   C_z     0        0      0  E_z    0   D_z    0    0      0  F_z;
             1/6  0      0        0      0    0    1/3   0    0    0      0    0;
             0   B_z     0        0      0  D_z    0    A_z   0    0      0 -C_z;
             0    0    B_y        0   -D_y    0    0     0  A_y    0    C_y    0;
             0    0      0    Jx/(6*A)   0    0    0     0    0 Jx/(3*A)  0    0;
             0    0    D_y        0    F_y    0    0     0  C_y    0    E_y    0;
             0  -D_z     0        0      0  F_z    0   -C_z   0    0      0    E_z];

Lxy = sqrt((x2-x1)^2 + (y2-y1)^2);
d = 0.0001*L;
thau = 0;
if Lxy>d  S1=(y2-y1)/Lxy; end;
if Lxy<=d S1=0; end;
S2 = (z2-z1)/L;
S3 = sin(thau);
if Lxy>d C1=(x2-x1)/Lxy; end;
if Lxy<=d C1=1; end;
C2 = Lxy/L;
C3 = cos(thau);
T = [C1*C2                S1*C2                S2;
   (-C1*S2*S3-S1*C3)   (-S1*S2*S3+C1*C3)    S3*C2;
   (-C1*S2*C3+S1*S3)   (-S1*S2*C3-C1*S3)    C3*C2];
T0 = zeros(3,3);
Tr = [T   T0   T0   T0;
      T0  T    T0   T0;
      T0  T0   T    T0;
      T0  T0   T0   T];
K = Tr'*Ko*Tr;
M = Tr'*Me*Tr;

