%--------------------------------------------------------------------------
% PLOT STATIC ANALYSIS
% Case 2D Frame: call plot deform and stress
% Case CST, CSQ: call calculate stress anf plot stress
% Truong Thanh Chung. Aug 2021.
%--------------------------------------------------------------------------
function [stress,Np] = FEM_2_static_plot(in_data,resp,opt)
stress  = [];
Np      = [];
dofN    = elemType(in_data);
dof_    = size(in_data.ND,1)*dofN;
switch in_data.EL(1,2)
    case {0,1,2,333} % 2D Frame
        if opt.showStress
            FEM_3_static_plot_deform2D(in_data,resp,opt)
        end
        [Np,~,~] = FEM_3_static_plot_NVM(in_data,resp,opt);
    case {3}        % 3D Frame
        FEM_3_plot3Dbeam(in_data,resp);
    case{31}        % 3D Truss
        FEM_3_plot3Dtruss(in_data,resp);
    case {9}        % BCIZ Plate
        FEM_3_plotBCIZ(in_data,resp,dof_,120);
    case {4,5,51}   % CST, CSQ
        SIGsys = FEM_3_stressCSTQ(in_data,resp);   % calculate stress
        stress = zeros(size(in_data.EL,1), 4);
        stress(1:size(in_data.EL,1),1)=(1:size(in_data.EL,1))';
        for i=1:size(in_data.EL,1)
            stress(i,2:end) = (SIGsys(i*3-(3-1):i*3,1))';
        end
        FEM_3_plotCSTQ(in_data, SIGsys,resp, dof_, 199);
    case {6}        % 3D Brick
        [SIGsys]   = FEM_3_stressBRICK(in_data, resp);
        [SIG_main] = FEM_3_stressMainBRICK(in_data, SIGsys);
        stress = zeros(size(in_data.ND,1), 7);
        stress(1:size(in_data.EL,1),1) = (1:size(in_data.EL,1))';
        for i=1:size(in_data.ND,1)
            stress(i,2:end) = (SIGsys(i,:));
        end
        FEM_3_plotBRICK(in_data, resp, dof_, SIG_main);
    case {10}       % 3D Tetrahedron
        [SIGsys] = FEM_3_stressTetr(in_data, resp);
        FEM_3_plotTetr(in_data, resp, dof_,SIGsys);
end
