%--------------------------------------------------------------------------
% RUN ANALYSIS
% Truong Thanh Chung. Aug 2021.
%--------------------------------------------------------------------------
function resp = FEM_0_run(in_data,model,opt)
% STATIC ANALYSIS
if opt.static
    [D,stress,Np]       = FEM_1_static(in_data,model,opt);
    resp.static.D       = D;
    resp.static.stress  = stress;
    resp.static.Np      = Np;
end
% MODAL ANALYSIS
if opt.modal
    resp.modal = FEM_1_modal(in_data,model,opt);
end
% STATIC CONDENSATION FOR MODAL ANALYSIS
if opt.condense
    resp.condense = FEM_1_condense(in_data,model);
end
% DYNAMIC EARTHQUAKE ANALYSIS
if opt.dynm
    resp.dynm = FEM_1_dynm(in_data,model);
end

if ~opt.static && ~opt.modal && ~opt.condense && ~opt.dynm 
    resp = 0;
end
