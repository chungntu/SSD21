%--------------------------------------------------------------------------
% PLOT GUI DATA 3D BRICK
% Truong Thanh Chung. Aug 2021.
%--------------------------------------------------------------------------
function FEM_1_plotGUIdata_brick(in_data)
axis equal; axis off; view(3); hold on;
for i=1:size(in_data.EL)
    node1 = find(in_data.ND(:,1)==in_data.EL(i,3));
    node2 = find(in_data.ND(:,1)==in_data.EL(i,4));
    node3 = find(in_data.ND(:,1)==in_data.EL(i,5));
    node4 = find(in_data.ND(:,1)==in_data.EL(i,6));
    node5 = find(in_data.ND(:,1)==in_data.EL(i,7));
    node6 = find(in_data.ND(:,1)==in_data.EL(i,8));
    node7 = find(in_data.ND(:,1)==in_data.EL(i,9));
    node8 = find(in_data.ND(:,1)==in_data.EL(i,10));
    
    plot3([in_data.ND(node1,2) in_data.ND(node2,2) in_data.ND(node3,2) in_data.ND(node4,2) in_data.ND(node1,2) ...
        in_data.ND(node5,2) in_data.ND(node6,2) in_data.ND(node7,2) in_data.ND(node8,2) in_data.ND(node5,2)],...
        [in_data.ND(node1,3) in_data.ND(node2,3) in_data.ND(node3,3) in_data.ND(node4,3) in_data.ND(node1,3) ...
        in_data.ND(node5,3) in_data.ND(node6,3) in_data.ND(node7,3) in_data.ND(node8,3) in_data.ND(node5,3)],...
        [in_data.ND(node1,4) in_data.ND(node2,4) in_data.ND(node3,4) in_data.ND(node4,4) in_data.ND(node1,4) ...
        in_data.ND(node5,4) in_data.ND(node6,4) in_data.ND(node7,4) in_data.ND(node8,4) in_data.ND(node5,4)],...
        'Color',[0.4 0.1 0.7],'LineWidth',1);
    
    plot3([in_data.ND(node2,2) in_data.ND(node6,2) in_data.ND(node7,2) in_data.ND(node3,2) in_data.ND(node2,2) ...
        in_data.ND(node1,2) in_data.ND(node5,2) in_data.ND(node8,2) in_data.ND(node4,2) in_data.ND(node1,2)],...
        [in_data.ND(node2,3) in_data.ND(node6,3) in_data.ND(node7,3) in_data.ND(node3,3) in_data.ND(node2,3) ...
        in_data.ND(node1,3) in_data.ND(node5,3) in_data.ND(node8,3) in_data.ND(node4,3) in_data.ND(node1,3)],...
        [in_data.ND(node2,4) in_data.ND(node6,4) in_data.ND(node7,4) in_data.ND(node3,4) in_data.ND(node2,4) ...
        in_data.ND(node1,4) in_data.ND(node5,4) in_data.ND(node8,4) in_data.ND(node4,4) in_data.ND(node1,4)],...
        'Color',[0.4 0.1 0.7],'LineWidth',1);
    if size(in_data.EL)<100
        h=text(in_data.ND(node1,2) , in_data.ND(node1,3), in_data.ND(node1,4), num2str(node1)); set(h,'FontSize',8);
        set(h,'Color','k');
        h=text(in_data.ND(node2,2) , in_data.ND(node2,3), in_data.ND(node2,4), num2str(node2)); set(h,'FontSize',8);
        set(h,'Color','k');
        h=text(in_data.ND(node3,2) , in_data.ND(node3,3), in_data.ND(node3,4), num2str(node3)); set(h,'FontSize',8);
        set(h,'Color','k');
        h=text(in_data.ND(node4,2) , in_data.ND(node4,3), in_data.ND(node4,4), num2str(node4)); set(h,'FontSize',8);
        set(h,'Color','k');
        h=text(in_data.ND(node5,2) , in_data.ND(node5,3), in_data.ND(node5,4), num2str(node5)); set(h,'FontSize',8);
        set(h,'Color','k');
        h=text(in_data.ND(node6,2) , in_data.ND(node6,3), in_data.ND(node6,4), num2str(node6)); set(h,'FontSize',8);
        set(h,'Color','k');
        h=text(in_data.ND(node7,2) , in_data.ND(node7,3), in_data.ND(node7,4), num2str(node7)); set(h,'FontSize',8);
        set(h,'Color','k');
        h=text(in_data.ND(node8,2) , in_data.ND(node8,3), in_data.ND(node8,4), num2str(node8)); set(h,'FontSize',8);
        set(h,'Color','k');
        x1= in_data.ND(node1,2)/8  +  in_data.ND(node2,2)/8 +  in_data.ND(node3,2)/8  + in_data.ND(node4,2)/8 +...
            in_data.ND(node5,2)/8  +  in_data.ND(node6,2)/8 +  in_data.ND(node7,2)/8  + in_data.ND(node8,2)/8;
        y1= in_data.ND(node1,3)/8  +  in_data.ND(node2,3)/8 +  in_data.ND(node3,3)/8  + in_data.ND(node4,3)/8 +...
            in_data.ND(node5,3)/8  +  in_data.ND(node6,3)/8 +  in_data.ND(node7,3)/8  + in_data.ND(node8,3)/8;
        z1= in_data.ND(node1,4)/8  +  in_data.ND(node2,4)/8 +  in_data.ND(node3,4)/8  + in_data.ND(node4,4)/8 +...
            in_data.ND(node5,4)/8  +  in_data.ND(node6,4)/8 +  in_data.ND(node7,4)/8  + in_data.ND(node8,4)/8;
        h=text(x1 , y1, z1, num2str(in_data.EL(i,1))); set(h,'FontSize',6); set(h,'Color','m');
    end
end
hold on;

maxX = max(in_data.ND(:,2));  minX = min(in_data.ND(:,2));
maxY = max(in_data.ND(:,3));  minY = min(in_data.ND(:,3));
maxZ = max(in_data.ND(:,4));  minZ = min(in_data.ND(:,4));
labx = (maxX / 9); laby = (maxY / 9); labz = (maxZ / 9);
labx = min([labx laby labz]); laby = labx;  labz=labx;

%% LOAD
for i=1:size(in_data.LOAD_)
    node_i = find(in_data.ND(:,1)==in_data.LOAD_(i,1));
    if in_data.LOAD_(i,2)~=0 && in_data.LOAD_(i,2)>0
        plot3([in_data.ND(node_i,2) in_data.ND(node_i,2)+labx],[in_data.ND(node_i,3) in_data.ND(node_i,3)],...
            [in_data.ND(node_i,4) in_data.ND(node_i,4)],'r-','LineWidth',3); hold on;
    end
    if in_data.LOAD_(i,2)~=0 && in_data.LOAD_(i,2)<0
        plot3([in_data.ND(node_i,2) in_data.ND(node_i,2)-labx],[in_data.ND(node_i,3) in_data.ND(node_i,3)],...
            [in_data.ND(node_i,4) in_data.ND(node_i,4)],'r-','LineWidth',3); hold on;
    end
    if in_data.LOAD_(i,3)~=0 && in_data.LOAD_(i,3)>0
        plot3([in_data.ND(node_i,2) in_data.ND(node_i,2)],[in_data.ND(node_i,3) in_data.ND(node_i,3)+laby],...
            [in_data.ND(node_i,4) in_data.ND(node_i,4)],'r-','LineWidth',3); hold on;
    end
    if in_data.LOAD_(i,3)~=0 && in_data.LOAD_(i,3)<0
        plot3([in_data.ND(node_i,2) in_data.ND(node_i,2)],[in_data.ND(node_i,3) in_data.ND(node_i,3)-laby],...
            [in_data.ND(node_i,4) in_data.ND(node_i,4)],'r-','LineWidth',3); hold on;
    end
    if in_data.LOAD_(i,4)~=0 && in_data.LOAD_(i,4)>0
        plot3([in_data.ND(node_i,2) in_data.ND(node_i,2)],[in_data.ND(node_i,3) in_data.ND(node_i,3)],...
            [in_data.ND(node_i,4) in_data.ND(node_i,4)+labz],'r-','LineWidth',3); hold on;
    end
    if in_data.LOAD_(i,4)~=0 && in_data.LOAD_(i,4)<0
        plot3([in_data.ND(node_i,2) in_data.ND(node_i,2)],[in_data.ND(node_i,3) in_data.ND(node_i,3)],...
            [in_data.ND(node_i,4) in_data.ND(node_i,4)-labz],'r-','LineWidth',3); hold on;
    end
end

%% CONSTRAINT
for i=1:size(in_data.CON)
    node_i = find(in_data.ND(:,1)==in_data.CON(i,1));
    if in_data.CON(i,2)==0
        plot3([in_data.ND(node_i,2) in_data.ND(node_i,2)-labx],[in_data.ND(node_i,3) in_data.ND(node_i,3)],...
            [in_data.ND(node_i,4) in_data.ND(node_i,4)],'g-','LineWidth',2); hold on;
    end
    if in_data.CON(i,3)==0
        plot3([in_data.ND(node_i,2) in_data.ND(node_i,2)],[in_data.ND(node_i,3) in_data.ND(node_i,3)-laby],...
            [in_data.ND(node_i,4) in_data.ND(node_i,4)],'g-','LineWidth',2); hold on;
    end
    if in_data.CON(i,4)==0
        plot3([in_data.ND(node_i,2) in_data.ND(node_i,2)],[in_data.ND(node_i,3) in_data.ND(node_i,3)],...
            [in_data.ND(node_i,4) in_data.ND(node_i,4)-labz],'g-','LineWidth',2); hold on;
    end
    if in_data.CON(i,4)==0 || in_data.CON(i,5)==0 || in_data.CON(i,6)==0
        plot3([in_data.ND(node_i,2) in_data.ND(node_i,2)],[in_data.ND(node_i,3) in_data.ND(node_i,3)],...
            [in_data.ND(node_i,4) in_data.ND(node_i,4)],'gs','LineWidth',2); hold on;
    end
end

rotate3d(gca); set(gcf,'Pointer','arrow');
axis([(minX-labx) (maxX+labx) (minY-laby) (maxY+laby) (minZ-labz) (maxZ+labz)]); % plot scale
hold off
