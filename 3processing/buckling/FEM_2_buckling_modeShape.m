% -------------------------------------------------------------------------
% PLOT MODE SHAPE MODAL ANALYSIS
% Truong Thanh Chung. Aug 2021.
% -------------------------------------------------------------------------
function FEM_2_buckling_modeShape(in_data,lab,D,frame,dof)
[dofN,~,~] = elemType(in_data);
fullD = [];
for ELEMENT = 1:size(in_data.EL)
    node1 = in_data.EL(ELEMENT,3);
    node2 = in_data.EL(ELEMENT,4);
    % AFTER LOAD
    ex = [in_data.ND(node1,2) in_data.ND(node2,2)];
    ey = [in_data.ND(node1,3) in_data.ND(node2,3)];
    dofElement = [node1*3-2 node1*3-1 node1*3 node2*3-2 node2*3-1 node2*3];
    ed = D(dofElement);
    [~,~,cd] = beam2crd(ex,ey,ed,1);
    fullD = [fullD cd];
end
maxD = max(max(abs(fullD)));
scaleFactor = lab/maxD;
for i=1:size(in_data.EL,1)
    node1 = in_data.EL(i,3);
    node2 = in_data.EL(i,4);
    ex = [in_data.ND(node1,2) in_data.ND(node2,2)];
    ey = [in_data.ND(node1,3) in_data.ND(node2,3)];
    dofElement = [node1*3-2 node1*3-1 node1*3 node2*3-2 node2*3-1 node2*3];
    ed = D(dofElement);
    [exc,eyc] = beam2crd(ex,ey,ed,scaleFactor);
    xc = exc'; yc = eyc';
    plot(xc,yc,'k','Linewidth',2)
    hold on
end
axis equal; axis off; axis(frame);
ND_d(:,2) = in_data.ND(:,2)+(D(1:dofN:dof(1))')*scaleFactor;
ND_d(:,3) = in_data.ND(:,3)+(D(2:dofN:dof(1))')*scaleFactor;
plotRestraint(in_data,ND_d,lab); hold off
