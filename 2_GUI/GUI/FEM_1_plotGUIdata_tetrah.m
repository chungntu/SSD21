%--------------------------------------------------------------------------
% ASSEMBLE STIFFNESS AND MASS MATRIX
% 3D TETRAHEDRON
% Truong Thanh Chung. Aug 2021.
%--------------------------------------------------------------------------
function FEM_1_plotGUIdata_tetrah ( in_data)

axis equal;
maxX = max(in_data.ND(:,2));  minX = min(in_data.ND(:,2));
maxY = max(in_data.ND(:,3));  minY = min(in_data.ND(:,3));
maxZ = max(in_data.ND(:,4));  minZ = min(in_data.ND(:,4));
labx = (maxX / 9); laby = (maxY / 9); labz = (maxZ / 9);
labx = min([labx laby labz]); laby = labx;  labz=labx;

for i=1:size(in_data.EL)
    node1 = find(in_data.ND(:,1)==in_data.EL(i,3));
    node2 = find(in_data.ND(:,1)==in_data.EL(i,4));
    node3 = find(in_data.ND(:,1)==in_data.EL(i,5));
    node4 = find(in_data.ND(:,1)==in_data.EL(i,6));
    if size(in_data.EL)<100
        h=text(in_data.ND(node1,2)+labx/2 , in_data.ND(node1,3)+labx/2, in_data.ND(node1,4), num2str(node1)); set(h,'FontSize',8);
        set(h,'Color','k');
        hold on;
        h=text(in_data.ND(node2,2)+labx/2 , in_data.ND(node2,3)+labx/2, in_data.ND(node2,4), num2str(node2)); set(h,'FontSize',8);
        set(h,'Color','k');
        h=text(in_data.ND(node3,2)+labx/2 , in_data.ND(node3,3)+labx/2, in_data.ND(node3,4), num2str(node3)); set(h,'FontSize',8);
        set(h,'Color','k');
        h=text(in_data.ND(node4,2)+labx/2 , in_data.ND(node4,3)+labx/2, in_data.ND(node4,4), num2str(node4)); set(h,'FontSize',8);
        set(h,'Color','k');
        x1= in_data.ND(node1,2)/4  +  in_data.ND(node2,2)/4 +  in_data.ND(node3,2)/4  + in_data.ND(node4,2)/4;
        y1= in_data.ND(node1,3)/4  +  in_data.ND(node2,3)/4 +  in_data.ND(node3,3)/4  + in_data.ND(node4,3)/4;
        z1= in_data.ND(node1,4)/4  +  in_data.ND(node2,4)/4 +  in_data.ND(node3,4)/4  + in_data.ND(node4,4)/4;
        h=text(x1 , y1, z1, num2str(in_data.EL(i,1))); set(h,'FontSize',6); set(h,'Color','m');
    end
end

tri2 = FEM_3_surfTet(in_data.ND(:,2:4),in_data.EL(:,3:6));
trimesh(tri2,in_data.ND(:,2),in_data.ND(:,3),in_data.ND(:,4),'facecolor','none','edgecolor','k'); axis equal
axis off; view(3);
hold on;

%% LOAD 
for i=1:size(in_data.LOAD_,1)
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

%% RESTRAINT
for i=1:size(in_data.CON,1)
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

axis([(minX-labx) (maxX+labx) (minY-laby) (maxY+laby) (minZ-labz) (maxZ+labz)]);
rotate3d(gca);

hold off;
