function FEM_0_static_Nonlinear(in_data,model,resp,opt)
if opt.staticNonlinearGeometry.flag
    if isfield(resp,'staticLinear')
        eps                             = 1E-4;                         % ERROR
        N                               = resp.staticLinear.Np(1,:);          % USE NORMAL FORCES FROM LINEAR STATIC ANALYSIS
        N0                              = [0 0 0];
        opt.write                       =  0;
        while(abs((N(1)-N0(1))/N0(1))>eps)
            % ASSEMBLE STIFFNESS MATRIX
            [dofN,~,ndPerElem]          = elemType(in_data);
            [row,col,valK]              = FEM_2_assemKM_2DFrame_Nonlinear(in_data,dofN,ndPerElem,N);
            Kgl                         = sparse(row,col,valK, dofN*size(in_data.ND,1), dofN*size(in_data.ND,1));
            model.Ksys.Kgl              = Kgl;
            D                           = FEM_1_static_displ_Nonlinear(in_data,model);
            Nnew                        = FEM_2_static_plot_Nonlinear(in_data,D,opt);
            N0                          = N;
            N                           = Nnew(1,:);
        end
        % PLOT THE LAST RESULT
        opt.write     =  1;        % WRITE TO FILE
        opt.showFig   =  1;        % SHOW NVM DIAGRAMS
        D                           = FEM_1_static_displ(in_data,model,opt);
        FEM_2_static_plot(in_data,D,opt);
    else
        disp('MUST ENABLE LINEAR STATIC ANALYSIS')
    end
end
