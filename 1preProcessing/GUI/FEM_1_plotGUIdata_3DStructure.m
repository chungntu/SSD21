%--------------------------------------------------------------------------
% PLOT GUI 3D FRAME STRUCTURE
% Truong Thanh Chung. Aug 2021.
%--------------------------------------------------------------------------
function FEM_1_plotGUIdata_3DStructure(in_data)
hold off; axis equal; axis off; view(3); hold on;
for i=1:size(in_data.EL)
    node1 = find(in_data.ND(:,1)==in_data.EL(i,3));
    node2 = find(in_data.ND(:,1)==in_data.EL(i,4));
    plot3([in_data.ND(node1,2) in_data.ND(node2,2)], ...
        [in_data.ND(node1,3) in_data.ND(node2,3)],[in_data.ND(node1,4) in_data.ND(node2,4)],'b-','LineWidth',1);
    if size(in_data.EL)<100
        h=text(in_data.ND(node1,2) , in_data.ND(node1,3), in_data.ND(node1,4), num2str(node1));
        set(h,'FontSize',8); set(h,'Color','k');
        h=text(in_data.ND(node2,2) , in_data.ND(node2,3), in_data.ND(node2,4), num2str(node2));
        set(h,'FontSize',8); set(h,'Color','k');
        x1= (in_data.ND(node2,2)-in_data.ND(node1,2))/1.8 + in_data.ND(node1,2);
        y1= (in_data.ND(node2,3)-in_data.ND(node1,3))/1.8 + in_data.ND(node1,3);
        z1= (in_data.ND(node2,4)-in_data.ND(node1,4))/1.8 + in_data.ND(node1,4);
        h = text(x1 , y1, z1, num2str(in_data.EL(i,1))); set(h,'FontSize',6); set(h,'Color','m');
    end
end
[lab,frame] = getScale(in_data);
for i=1:size(in_data.LOAD_)
    node_i = find(in_data.ND(:,1)==in_data.LOAD_(i,1));
    if in_data.LOAD_(i,2)~=0 && in_data.LOAD_(i,2)>0
        plot3([in_data.ND(node_i,2) in_data.ND(node_i,2)+lab],[in_data.ND(node_i,3) in_data.ND(node_i,3)],...
            [in_data.ND(node_i,4) in_data.ND(node_i,4)],'r-','LineWidth',3); hold on;
    end
    if in_data.LOAD_(i,2)~=0 && in_data.LOAD_(i,2)<0
        plot3([in_data.ND(node_i,2) in_data.ND(node_i,2)-lab],[in_data.ND(node_i,3) in_data.ND(node_i,3)],...
            [in_data.ND(node_i,4) in_data.ND(node_i,4)],'r-','LineWidth',3); hold on;
    end
    if in_data.LOAD_(i,3)~=0 && in_data.LOAD_(i,3)>0
        plot3([in_data.ND(node_i,2) in_data.ND(node_i,2)],[in_data.ND(node_i,3) in_data.ND(node_i,3)+lab],...
            [in_data.ND(node_i,4) in_data.ND(node_i,4)],'r-','LineWidth',3); hold on;
    end
    if in_data.LOAD_(i,3)~=0 && in_data.LOAD_(i,3)<0
        plot3([in_data.ND(node_i,2) in_data.ND(node_i,2)],[in_data.ND(node_i,3) in_data.ND(node_i,3)-lab],...
            [in_data.ND(node_i,4) in_data.ND(node_i,4)],'r-','LineWidth',3); hold on;
    end
    if in_data.LOAD_(i,4)~=0 && in_data.LOAD_(i,4)>0
        plot3([in_data.ND(node_i,2) in_data.ND(node_i,2)],[in_data.ND(node_i,3) in_data.ND(node_i,3)],...
            [in_data.ND(node_i,4) in_data.ND(node_i,4)+lab],'r-','LineWidth',3); hold on;
    end
    if in_data.LOAD_(i,4)~=0 && in_data.LOAD_(i,4)<0
        plot3([in_data.ND(node_i,2) in_data.ND(node_i,2)],[in_data.ND(node_i,3) in_data.ND(node_i,3)],...
            [in_data.ND(node_i,4) in_data.ND(node_i,4)-lab],'r-','LineWidth',3); hold on;
    end
end
plotRestraint(in_data,in_data.ND,lab)
rotate3d(gca); set(gcf,'Pointer','arrow');
axis(frame)
hold off;
