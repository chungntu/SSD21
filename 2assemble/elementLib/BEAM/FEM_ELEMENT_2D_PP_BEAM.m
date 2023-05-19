function [M,K,Ke,T] = FEM_ELEMENT_2D_PP_BEAM (x1, y1, x2, y2, E, A, I, rho)



L = sqrt((x2-x1)^2 + (y2-y1)^2 );
c = (x2-x1) / L;
s = (y2-y1) / L;
Y = E*A;
Z = E*I;
                  
Ke = [Y/L   0      	0      -Y/L     0    	0;
     0   	0    	0       0   	0    	0;
     0      0       0       0       0    	0;
     -Y/L   0       0       Y/L     0    	0;
     0  	0    	0       0    	0  		0;
     0   	0    	0       0   	0   	0];
 
Me = (rho*A*L/420)*[140    	0      	0   	70      0       0;
                      0    	0      	0    	0     	0    	0;
                      0   	0      	0    	0      	0       0;
                     70    	0      	0  		140     0       0;
                      0     0     	0    	0    	0    	0;
                      0 	0      	0    	0  		0    	0];

T =  [ c s 0   0 0 0 ;
      -s c 0   0 0 0 ;
       0 0 1   0 0 0 ;
       0 0 0   c s 0 ;
       0 0 0  -s c 0 ;
       0 0 0   0 0 1 ];

K = T'*Ke*T;	
M = T'*Me*T;

