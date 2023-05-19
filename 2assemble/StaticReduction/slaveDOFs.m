% -------------------------------------------------------------------------
% CALCULATE SLAVE DOFS FOR STATIC CONSDENSATION ALGORITHM
% Truong Thanh Chung. Aug 2021.
% -------------------------------------------------------------------------
function SlaveDofs = slaveDOFs(in_data,L)
dofN        = elemType (in_data);
dof_        = size(in_data.ND,1)*dofN;
MASS_       = in_data.MASS(:,2:end);
MASS_       = reshape(MASS_',1,[]);
locTOTAL    = 1:dof_;
locCON      = setdiff(locTOTAL,L);
locMASS     = find(MASS_>1E-3);
locNEWMASS = [];
for i=1:length(locMASS)
    A = locCON==locMASS(i);
    if sum(A)==0
        B = locCON<locMASS(i);
        x = sum(B);
        locNEWMASS_tmp = locMASS(i) - x;
        locNEWMASS = [ locNEWMASS locNEWMASS_tmp];
    end
end
locNEWTOTAL = 1:length(L);
SlaveDofs = setdiff(locNEWTOTAL,locNEWMASS);
