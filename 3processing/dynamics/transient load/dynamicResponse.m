%--------------------------------------------------------------------------
% DYNAMIC RESPONSE TO TRANSIENT LOAD
% Truong Thanh Chung. Aug 2021.
%--------------------------------------------------------------------------
function dynamicResponse(inData,model,d0,v0,T,dt,f,t,zeta)
dofN        = elemType (inData);
ind         = 1;
ignoreDOFs = inData.CON;
%% DOFS NEED TO CALCULATE
for i = 1:size(ignoreDOFs,1)
    for k = 1:dofN
        if ignoreDOFs(i,1+k)==0
            ignoreDOFs_GL(ind) = ignoreDOFs(i,1)*dofN-(dofN-k);
            ind = ind+1;
        end
    end
end
bc = [ignoreDOFs_GL' zeros(length(ignoreDOFs_GL),1)];
dof = size(model.Mgl,1);
ntimes=0.1:0.1:T;
nhist = 1:dof;
alpha = 0.25; delta = 0.5; % average accl
nsnap = length(ntimes);
ip = [dt T alpha delta nsnap 5 ntimes nhist];
k = model.Ksys.Kgl;
m = model.Mgl;
c = zeros(size(k));
[phi,omega2] = eig(full(k(model.freeDOFs,model.freeDOFs)),full(m(model.freeDOFs,model.freeDOFs)));
c1 = inv(phi')*2*zeta*omega2.^0.5*inv(phi);     % damping matrix
c(model.freeDOFs,model.freeDOFs) = c1;
[~,D,~,~]=step2(k,c,m,d0,v0,ip,f,bc);
animateTimeHistory2(inData,model,D,t,zeta)
