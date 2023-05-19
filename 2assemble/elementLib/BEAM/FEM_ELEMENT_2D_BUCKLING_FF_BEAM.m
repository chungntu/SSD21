function Kgeo = FEM_ELEMENT_2D_BUCKLING_FF_BEAM (x1, y1, x2, y2,Np)
L = sqrt((x2-x1)^2 + (y2-y1)^2 );
c = (x2-x1) / L;
s = (y2-y1) / L;
T = [ c s 0   0 0 0 ;
     -s c 0   0 0 0 ;
      0 0 1   0 0 0 ;
      0 0 0   c s 0 ;
      0 0 0  -s c 0 ;
      0 0 0   0 0 1 ];
L2 = L*L;
K_geo_e = Np/L* [1        0        0         -1        0        0;
                 0        6/5      L/10       0       -6/5      L/10;
                 0        L/10     2*L2/15    0       -L/10    -L2/30;
                -1        0        0          1        0        0;
                 0       -6/5     -L/10       0        6/5     -L/10;
                 0        L/10    -L2/30      0       -L/10     2*L2/15 ];
Kgeo = T'*K_geo_e*T;
