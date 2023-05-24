%--------------------------------------------------------------------------
% PLOT GUI DATA QUADRILATERAL ELEMENT (CSTQ) (4-NODES)
% Truong Thanh Chung. Aug 2021.
%--------------------------------------------------------------------------
function FEM_1_plotGUIdata_CSTQ(in_data)
hold off;
maxX = max(in_data.ND(:,2)); minX = min(in_data.ND(:,2));
maxY = max(in_data.ND(:,3)); minY = min(in_data.ND(:,3));
labx = abs(maxX / 15); laby = abs(maxY / 15);
labx = max([labx laby]); laby = labx;
%% LOAD
for i=1:size(in_data.LOAD_)
    node_i = find(in_data.ND(:,1)==in_data.LOAD_(i,1));
    if in_data.LOAD_(i,2)~=0 && in_data.LOAD_(i,2)>0
        plot([in_data.ND(node_i,2) in_data.ND(node_i,2)+labx],...
            [in_data.ND(node_i,3) in_data.ND(node_i,3)],'r-','LineWidth',3); hold on;
    end
    if in_data.LOAD_(i,2)~=0 && in_data.LOAD_(i,2)<0
        plot([in_data.ND(node_i,2) in_data.ND(node_i,2)-labx],...
            [in_data.ND(node_i,3) in_data.ND(node_i,3)],'r-','LineWidth',3);hold on;
    end
    if in_data.LOAD_(i,3)~=0 && in_data.LOAD_(i,3)>0
        plot([in_data.ND(node_i,2) in_data.ND(node_i,2)],...
            [in_data.ND(node_i,3) in_data.ND(node_i,3)+laby],'r-','LineWidth',3);hold on;
    end
    if in_data.LOAD_(i,3)~=0 && in_data.LOAD_(i,3)<0
        plot([in_data.ND(node_i,2) in_data.ND(node_i,2)],...
            [in_data.ND(node_i,3) in_data.ND(node_i,3)-laby],'r-','LineWidth',3);hold on;
    end
end
%% CONSTRAINT
for i=1:size(in_data.CON)
    node_i = find(in_data.ND(:,1)==in_data.CON(i,1));
    if in_data.CON(i,2)==0
        plot([in_data.ND(node_i,2) in_data.ND(node_i,2)-labx],...
            [in_data.ND(node_i,3) in_data.ND(node_i,3)],'g-','LineWidth',2.5);
    end
    if in_data.CON(i,3)==0
        plot([in_data.ND(node_i,2) in_data.ND(node_i,2)],...
            [in_data.ND(node_i,3) in_data.ND(node_i,3)-laby],'g-','LineWidth',2.5);
    end
end
%% PLOT ELEMENTS
axis equal; axis off; view(2); hold on;
for i=1:size(in_data.EL)
    if in_data.EL(i,2)==4
        node1 = find(in_data.ND(:,1)==in_data.EL(i,3));
        node2 = find(in_data.ND(:,1)==in_data.EL(i,4));
        node3 = find(in_data.ND(:,1)==in_data.EL(i,5));
        plot([in_data.ND(node1,2) in_data.ND(node2,2) in_data.ND(node3,2) in_data.ND(node1,2)], ...
            [in_data.ND(node1,3) in_data.ND(node2,3) in_data.ND(node3,3) in_data.ND(node1,3)],...
            'Color',[0.4 0.1 0.7],'LineWidth',.1);
        if size(in_data.EL)<100
            h=text(in_data.ND(node1,2) , in_data.ND(node1,3), 0, num2str(node1)); set(h,'FontSize',8);
            set(h,'Color','k');
            h=text(in_data.ND(node2,2) , in_data.ND(node2,3), 0, num2str(node2)); set(h,'FontSize',8);
            set(h,'Color','k');
            h=text(in_data.ND(node3,2) , in_data.ND(node3,3), 0, num2str(node3)); set(h,'FontSize',8);
            set(h,'Color','k');
            x1= in_data.ND(node1,2)/3  +  in_data.ND(node2,2)/3 +  in_data.ND(node3,2)/3;
            y1= in_data.ND(node1,3)/3  +  in_data.ND(node2,3)/3 +  in_data.ND(node3,3)/3;
            h=text(x1 , y1, num2str(in_data.EL(i,1))); set(h,'FontSize',6); set(h,'Color','m');
        end
    end
    if in_data.EL(i,2)==5 || in_data.EL(i,2)==51
        node1 = find(in_data.ND(:,1)==in_data.EL(i,3));
        node2 = find(in_data.ND(:,1)==in_data.EL(i,4));
        node3 = find(in_data.ND(:,1)==in_data.EL(i,5));
        node4 = find(in_data.ND(:,1)==in_data.EL(i,6));
        plot([in_data.ND(node1,2) in_data.ND(node2,2) in_data.ND(node3,2) ...
            in_data.ND(node4,2) in_data.ND(node1,2)],...
            [in_data.ND(node1,3) in_data.ND(node2,3) in_data.ND(node3,3) in_data.ND(node4,3)...
            in_data.ND(node1,3)],'Color',[0.4 0.1 0.7],'LineWidth',.1);
        if size(in_data.EL)<100
            h=text(in_data.ND(node1,2) , in_data.ND(node1,3), 0, num2str(node1)); set(h,'FontSize',8);
            set(h,'Color','k');
            h=text(in_data.ND(node2,2) , in_data.ND(node2,3), 0, num2str(node2)); set(h,'FontSize',8);
            set(h,'Color','k');
            h=text(in_data.ND(node3,2) , in_data.ND(node3,3), 0, num2str(node3)); set(h,'FontSize',8);
            set(h,'Color','k');
            h=text(in_data.ND(node4,2) , in_data.ND(node4,3), 0, num2str(node4)); set(h,'FontSize',8);
            set(h,'Color','k');
            x1= in_data.ND(node1,2)/4  +  in_data.ND(node2,2)/4 +  in_data.ND(node3,2)/4  + in_data.ND(node4,2)/4;
            y1= in_data.ND(node1,3)/4  +  in_data.ND(node2,3)/4 +  in_data.ND(node3,3)/4  + in_data.ND(node4,3)/4;
            h=text(x1 , y1, num2str(in_data.EL(i,1))); set(h,'FontSize',6); set(h,'Color','m');
        end
    end
end

axis([(minX-labx) (maxX+labx) (minY-laby) (maxY+laby)]); drawnow
rotate3d(gca); set(gcf,'Pointer','arrow');
hold off;


