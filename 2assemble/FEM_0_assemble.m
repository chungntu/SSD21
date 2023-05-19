%--------------------------------------------------------------------------
% ASSEMBLE STIFFNESS AND MASS MATRIX
% ASSIGN LUMP MASS
% ASSIGN RESTRAINT
% Truong Thanh Chung. Aug 2021.
%--------------------------------------------------------------------------
function model = FEM_0_assemble(inData,opt)
if ~isempty(inData)
    % ASSEMBLE STIFFNESS AND MASS MATRIX
    [model.Ksys.Kgl,model.Mgl]  = FEM_1_assemble_KM(inData,opt);
    % ASSEMBLE RESTRAINT
    model.freeDOFs              = FEM_1_assemble_Restraint(inData,model);
    % ASSEMBLE LOAD VECTOR
    model.LVEC                  = FEM_1_assemble_LoadVector(inData);
end
