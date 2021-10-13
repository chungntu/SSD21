% -------------------------------------------------------------------------
% PLOT TIME HISTORY DISPLACEMENT OF STRUCTURE
% Truong Thanh Chung. Aug 2021.
% -------------------------------------------------------------------------
function plotTimeHistory2(in_data,lab,D,deN,frame,dof)
[dofN,EL_TYPE,~] = elemType(in_data);
switch EL_TYPE
    case {0,1,2,333} % 2D Frame
        scaleFactor = lab/deN*3;
        for i=1:size(in_data.EL,1)
            node1 = in_data.EL(i,3);
            node2 = in_data.EL(i,4);
            ex = [in_data.ND(node1,2) in_data.ND(node2,2)];
            ey = [in_data.ND(node1,3) in_data.ND(node2,3)];
            dofElement = [node1*3-2 node1*3-1 node1*3 node2*3-2 node2*3-1 node2*3];
            ed = D(dofElement);
            [exc,eyc] = beam2crd(ex,ey,ed,scaleFactor); % calculate displacement at points along the beam
            xc = exc'; yc = eyc';
            plot(xc,yc,'k','Linewidth',2)
            hold on
        end
        axis equal; axis off; axis(frame);
        ND_d(:,2) = in_data.ND(:,2)+(D(1:dofN:dof(1))')*scaleFactor;
        ND_d(:,3) = in_data.ND(:,3)+(D(2:dofN:dof(1))')*scaleFactor;
        plotRestraint(in_data,ND_d,lab); hold on
        plotMovingLumpMass(in_data,ND_d,lab); hold off
end
end
