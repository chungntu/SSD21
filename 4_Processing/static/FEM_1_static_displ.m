%--------------------------------------------------------------------------
% SOLVE STATIC DISPLACEMENT
% Truong Thanh Chung. Aug 2021.
%--------------------------------------------------------------------------
function resp = FEM_1_static_displ(inData,model,opt)
LVEC        = model.LVEC;
Kgl         = model.Ksys.Kgl;
freeDOFs    = model.freeDOFs;
if  isfield(inData,'DBC')
    D = FEM_2_DBC(Kgl,freeDOFs,LVEC,inData);
    resp.static.D = D';
else
    D = (Kgl(freeDOFs,freeDOFs))\LVEC(freeDOFs)';
    resp.static.D = zeros(1,size(Kgl,1));       % add this line (27/4/2023)
    resp.static.D(freeDOFs) = D;
end
%% SAVE DISPLACEMENT TO FILE
dofN         = elemType(inData);
displacement = zeros(size(inData.ND,1), dofN+1);
displacement(1:size(inData.ND,1),1) = (1:size(inData.ND,1))';
for i = 1:size(inData.ND,1)
    displacement(i,dofN-(dofN-1)+1:dofN+1) = resp.static.D(i*dofN-(dofN-1):i*dofN);
end
[~,EL_TYPE,~] = elemType(inData);
if opt.writeCmd == 1
    if EL_TYPE == 0 || EL_TYPE == 1 || EL_TYPE == 2 || EL_TYPE == 333
        write2fileStaticAnalysis(displacement)
    end
end
end

% GROUND DISPLACEMENT (DBC)
function D  = FEM_2_DBC(Kgl,freeDOFs,LVEC,inData)
dim         = size(Kgl,1);
un          = setdiff(1:dim,freeDOFs);
un          = setdiff(un,inData.DBC.dofs);
DBC_dofs    = [inData.DBC.dofs';un'];
DBC_displ   = [inData.DBC.displ';zeros(length(un),1)];
dof_unknown = setdiff(1:dim,DBC_dofs);
m           = length(DBC_dofs);
n           = length(dof_unknown);
D = [Kgl(dof_unknown,dof_unknown),spalloc(n,m,1);spalloc(m,n,1),speye(m,m)]\[LVEC(dof_unknown)'-Kgl(dof_unknown,DBC_dofs)*DBC_displ;DBC_displ];
D([dof_unknown';DBC_dofs]) = D;
end

function write2fileStaticAnalysis(displacement)
% PRINT RESULTS
fprintf('==================================================================================================================================== \n');
fprintf('LINEAR STATIC ANALYSIS\n');
fprintf('NODE DISPLACEMENT\n');
for ii = 1:size(displacement,1)
    fprintf('#Node %d : % 5.8f % 5.8f % 5.8f\n', ii, displacement(ii,2), displacement(ii,3), displacement(ii,4));
end
% WRITE TO FILE
fid = fopen('Static Analysis Results.txt','wt');
fprintf(fid,'LINEAR STATIC ANALYSIS\n');
fprintf(fid,'NODE DISPLACEMENT\n');
for ii=1:size(displacement,1)
    fprintf(fid,'#Node %d  : % 5.8f % 5.8f % 5.8f\n', ii, displacement(ii,2), displacement(ii,3), displacement(ii,4));
end
end
