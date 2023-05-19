%--------------------------------------------------------------------------
% RUN ANALYSIS
% Truong Thanh Chung. Aug 2021.
%--------------------------------------------------------------------------
function resp = FEM_0_run(inData,model,opt)
if ~isempty(inData)
    % STATIC ANALYSIS
    if opt.staticLinear
        [D,stress,Np] = FEM_1_static(inData,model,opt);
        resp.staticLinear.D = D;
        resp.staticLinear.stress = stress;
        resp.staticLinear.Np = Np;
    end
    % MODAL ANALYSIS
    if opt.modalLinear
        resp.modalLinear = FEM_1_modal(inData,model,opt);
    end
    % STATIC CONDENSATION FOR MODAL ANALYSIS
    if opt.modalLinearCondense
        resp.modalLinearCondense = FEM_1_condense(inData,model);
    end
    % DYNAMIC EARTHQUAKE ANALYSIS
    if opt.dynm.flag
        resp.dynm = FEM_1_dynm2(inData,model,opt);
    end
    if opt.top.flag
        resp.top = FEM_1_top(inData,opt);
    end
    if ~opt.staticLinear && ~opt.modalLinear && ~opt.modalLinearCondense && ~opt.dynm.flag && ~opt.top.flag
        resp = 0;
    end
end
