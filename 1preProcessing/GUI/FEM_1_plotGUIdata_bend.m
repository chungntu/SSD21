%--------------------------------------------------------------------------
% PLOT GUI PLATE STRUCTURE
% Truong Thanh Chung. Aug 2021.
%--------------------------------------------------------------------------
function FEM_1_plotGUIdata_bend ( in_data, dof, NF,PND)


hold off;
if 1
    maxX = max(in_data.ND(:,2));
    minX = min(in_data.ND(:,2));
    maxY = max(in_data.ND(:,3));
    minY = min(in_data.ND(:,3));
    labx = (maxX / 15); laby = (maxY / 15);
    labx = min([labx laby]); laby = labx;
    
    SCz = 1; labz = SCz/4; % Z deflection scale
    
    % plot loads:
    if NF > 100
        for i=1:size(in_data.LOAD_)
            node_i = find(in_data.ND(:,1)==in_data.LOAD_(i,1));
            if in_data.LOAD_(i,3)~=0 & in_data.LOAD_(i,3)>0
                plot3([in_data.ND(node_i,2) in_data.ND(node_i,2)+labx],...
                    [in_data.ND(node_i,3) in_data.ND(node_i,3)],[0 0],'r-','LineWidth',2); hold on;
            end;
            if in_data.LOAD_(i,3)~=0 & in_data.LOAD_(i,3)<0
                plot3([in_data.ND(node_i,2) in_data.ND(node_i,2)-labx],...
                    [in_data.ND(node_i,3) in_data.ND(node_i,3)],[0 0],'r-','LineWidth',2); hold on;
            end;
            if in_data.LOAD_(i,4)~=0 & in_data.LOAD_(i,4)>0
                plot3([in_data.ND(node_i,2) in_data.ND(node_i,2)],...
                    [in_data.ND(node_i,3) in_data.ND(node_i,3)+laby],[0 0],'r-','LineWidth',2); hold on;
            end;
            if in_data.LOAD_(i,4)~=0 & in_data.LOAD_(i,4)<0
                plot3([in_data.ND(node_i,2) in_data.ND(node_i,2)],...
                    [in_data.ND(node_i,3) in_data.ND(node_i,3)-laby],[0 0],'r-','LineWidth',2); hold on;
            end;
            if in_data.LOAD_(i,2)~=0 & in_data.LOAD_(i,2)>0
                plot3([in_data.ND(node_i,2) in_data.ND(node_i,2)],...
                    [in_data.ND(node_i,3) in_data.ND(node_i,3)],[0 labz],'r-','LineWidth',2); hold on;
            end;
            if in_data.LOAD_(i,2)~=0 & in_data.LOAD_(i,2)<0
                plot3([in_data.ND(node_i,2) in_data.ND(node_i,2)],...
                    [in_data.ND(node_i,3) in_data.ND(node_i,3)],[0 -labz],'r-','LineWidth',2); hold on;
            end;
        end;
        
        
        for i=1:size(in_data.CON)
            node_i = find(in_data.ND(:,1)==in_data.CON(i,1));
            if in_data.CON(i,3)==0
                plot3([in_data.ND(node_i,2) in_data.ND(node_i,2)-labx],...
                    [in_data.ND(node_i,3) in_data.ND(node_i,3)], [0 0],'g-','LineWidth',2); hold on;
            end;
            if in_data.CON(i,4)==0
                plot3([in_data.ND(node_i,2) in_data.ND(node_i,2)],...
                    [in_data.ND(node_i,3) in_data.ND(node_i,3)-laby], [0 0],'g-','LineWidth',2); hold on;
            end;
            if in_data.CON(i,2)==0
                plot3([in_data.ND(node_i,2) in_data.ND(node_i,2)],...
                    [in_data.ND(node_i,3) in_data.ND(node_i,3)], [0 labz],'g-','LineWidth',2); hold on;
            end;
        end;
    end;
    
    
    plot(in_data.ND(:,2),in_data.ND(:,3),'y.','Markersize',2);
    axis equal; axis off; view(3); hold on;
    for i=1:size(in_data.EL)
        if in_data.EL(i,2)==9
            node1 = find(in_data.ND(:,1)==in_data.EL(i,3));
            node2 = find(in_data.ND(:,1)==in_data.EL(i,4));
            node3 = find(in_data.ND(:,1)==in_data.EL(i,5));
            plot3([in_data.ND(node1,2) in_data.ND(node2,2) in_data.ND(node3,2) in_data.ND(node1,2)], ...
                [in_data.ND(node1,3) in_data.ND(node2,3) in_data.ND(node3,3) in_data.ND(node1,3)],...
                [0 0 0 0],'Color',[0.4 0.1 0.7],'LineWidth',1);
            if PND == 1
                h=text(in_data.ND(node1,2) , in_data.ND(node1,3), 0, num2str(node1)); set(h,'FontSize',8);
                set(h,'Color','k');
                h=text(in_data.ND(node2,2) , in_data.ND(node2,3), 0, num2str(node2)); set(h,'FontSize',8);
                set(h,'Color','k');
                h=text(in_data.ND(node3,2) , in_data.ND(node3,3), 0, num2str(node3)); set(h,'FontSize',8);
                set(h,'Color','k');
                x1= in_data.ND(node1,2)/3  +  in_data.ND(node2,2)/3 +  in_data.ND(node3,2)/3;
                y1= in_data.ND(node1,3)/3  +  in_data.ND(node2,3)/3 +  in_data.ND(node3,3)/3;
                h=text(x1 , y1, 0, num2str(in_data.EL(i,1))); set(h,'FontSize',6); set(h,'Color','m');
            end;
        end;
    end;
end;

axis([(-1.1*minX) (1.1*maxX) (-1.1*minY) (1.1*maxY) (-SCz)    (SCz)]);

rotate3d(gca); set(gcf,'Pointer','arrow');
hold off;
