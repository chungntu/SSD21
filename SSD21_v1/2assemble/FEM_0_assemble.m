%--------------------------------------------------------------------------
% ASSEMBLE STIFFNESS AND MASS MATRIX
% ASSIGN LUMP MASS
% ASSIGN RESTRAINT
% Truong Thanh Chung. Aug 2021.
%--------------------------------------------------------------------------
function model = FEM_0_assemble(in_data)
% ASSEMBLE STIFFNESS AND MASS MATRIX
[model.Ksys.Kgl,model.Mgl]  = FEM_1_assemble_KM(in_data);
% ASSEMBLE RESTRAINT
model.freeDOFs              = FEM_1_assemble_Restraint(in_data);
% ASSEMBLE LOAD VECTOR
model.LVEC                  = FEM_1_assemble_LoadVector(in_data);
