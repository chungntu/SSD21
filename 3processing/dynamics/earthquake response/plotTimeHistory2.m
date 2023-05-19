% -------------------------------------------------------------------------
% PLOT TIME HISTORY DISPLACEMENT OF STRUCTURE
% Truong Thanh Chung. Aug 2021.
% -------------------------------------------------------------------------
function plotTimeHistory2(inData,lab,D,deN,frame,dof)
[dofN,EL_TYPE,~] = elemType(inData);
switch EL_TYPE
    case {0,1,2,333} % 2D Frame
        scaleFactor = lab/deN*3;
        for i=1:size(inData.EL,1)
            node1 = inData.EL(i,3);
            node2 = inData.EL(i,4);
            ex = [inData.ND(node1,2),inData.ND(node2,2)];
            ey = [inData.ND(node1,3),inData.ND(node2,3)];
            dofElement = [node1*3-2 node1*3-1 node1*3 node2*3-2 node2*3-1 node2*3];
            ed = D(dofElement);
            [exc,eyc] = beam2crd(ex,ey,ed,scaleFactor); % calculate displacement at points along the beam
            plot(exc',eyc','k','Linewidth',2)
            hold on
        end
        axis equal; axis off; axis(frame);
        ND_d(:,2) = inData.ND(:,2)+(D(1:dofN:dof(1))')*scaleFactor;
        ND_d(:,3) = inData.ND(:,3)+(D(2:dofN:dof(1))')*scaleFactor;
        plotRestraint(inData,ND_d,lab); hold on
        plotMovingLumpMass(inData,ND_d,lab); hold off
end
end
