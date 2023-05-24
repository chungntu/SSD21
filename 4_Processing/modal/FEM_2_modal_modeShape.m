% -------------------------------------------------------------------------
% PLOT MODE SHAPE MODAL ANALYSIS
% Truong Thanh Chung. Aug 2021.
% -------------------------------------------------------------------------
function FEM_2_modal_modeShape(in_data,lab,D,deN,frame,dof,scl)
[dofN,EL_TYPE,~] = elemType(in_data);
switch EL_TYPE
    case {0,1,2,333} % 2D Frame
        D_scl = D*scl;
        scaleFactor = lab/deN;
        for i=1:size(in_data.EL,1)
            node1 = in_data.EL(i,3);
            node2 = in_data.EL(i,4);
            ex = [in_data.ND(node1,2) in_data.ND(node2,2)];
            ey = [in_data.ND(node1,3) in_data.ND(node2,3)];
            dofElement = [node1*3-2 node1*3-1 node1*3 node2*3-2 node2*3-1 node2*3];
            ed = D_scl(dofElement);
            [exc,eyc] = beam2crd(ex,ey,ed,scaleFactor);
            xc = exc'; yc = eyc';
            plot(xc,yc,'k','Linewidth',2)
            hold on
        end
        axis equal; axis off; axis(frame);
        ND_d(:,2) = in_data.ND(:,2)+(D_scl(1:dofN:dof(1))')*scaleFactor;
        ND_d(:,3) = in_data.ND(:,3)+(D_scl(2:dofN:dof(1))')*scaleFactor;
        plotRestraint(in_data,ND_d,lab); hold on
        plotMovingLumpMass(in_data,ND_d,lab); hold off
    case {3} % 3D Frame
        ND_d(:,2) = in_data.ND(:,2)+(D(1:dofN:dof(1))'./deN)*2*lab*scl;
        ND_d(:,3) = in_data.ND(:,3)+(D(2:dofN:dof(1))'./deN)*2*lab*scl;
        ND_d(:,4) = in_data.ND(:,4)+(D(3:dofN:dof(1))'./deN)*2*lab*scl;
        for i=1:size(in_data.EL,1)
            node1 = find(in_data.ND(:,1)==in_data.EL(i,3));
            node2 = find(in_data.ND(:,1)==in_data.EL(i,4));
            plot3([in_data.ND(node1,2) in_data.ND(node2,2)],...
                [in_data.ND(node1,3) in_data.ND(node2,3)],...
                [in_data.ND(node1,4) in_data.ND(node2,4)],'k:');
            hold on
        end
        for i=1:size(in_data.EL,1)
            node1 = find(in_data.ND(:,1)==in_data.EL(i,3));
            node2 = find(in_data.ND(:,1)==in_data.EL(i,4));
            plot3([ND_d(node1,2) ND_d(node2,2)],...
                [ND_d(node1,3) ND_d(node2,3)],...
                [ND_d(node1,4) ND_d(node2,4)],'b-','Linewidth',1);
            axis equal; axis off; axis(frame);
            hold on
        end
        plotRestraint(in_data,ND_d,lab); hold off
    case {31} % 3D Truss
        ND_d(:,2) = in_data.ND(:,2)+(D(1:dofN:dof(1))'./deN)*2*lab*scl;
        ND_d(:,3) = in_data.ND(:,3)+(D(2:dofN:dof(1))'./deN)*2*lab*scl;
        ND_d(:,4) = in_data.ND(:,4)+(D(3:dofN:dof(1))'./deN)*2*lab*scl;
        for i=1:size(in_data.EL,1)
            node1 = find(in_data.ND(:,1)==in_data.EL(i,3));
            node2 = find(in_data.ND(:,1)==in_data.EL(i,4));
            plot3([in_data.ND(node1,2) in_data.ND(node2,2)],...
                [in_data.ND(node1,3) in_data.ND(node2,3)],...
                [in_data.ND(node1,4) in_data.ND(node2,4)],'k:');
            hold on
        end
        for i=1:size(in_data.EL,1)
            node1 = find(in_data.ND(:,1)==in_data.EL(i,3));
            node2 = find(in_data.ND(:,1)==in_data.EL(i,4));
            plot3([ND_d(node1,2) ND_d(node2,2)],...
                [ND_d(node1,3) ND_d(node2,3)],...
                [ND_d(node1,4) ND_d(node2,4)],'b-','Linewidth',1);
            axis equal; axis off; axis(frame);
            hold on
        end
        plotRestraint(in_data,ND_d,lab); hold off
end
end
