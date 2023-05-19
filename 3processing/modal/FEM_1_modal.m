%--------------------------------------------------------------------------
% MODAL ANALYSIS
% Truong Thanh Chung. Aug 2021.
%--------------------------------------------------------------------------
function resp = FEM_1_modal(in_data,model,opt)
showMode    = opt.showMode;
if showMode>6
    disp('Max mode  = 6')
    showMode = 6;
end
L           = model.freeDOFs;
Kgl         = model.Ksys.Kgl(L,L);
Mgl         = model.Mgl(L,L);
[E_Vec,wn]  = FEM_2_eigs(Kgl,Mgl,showMode);
D           = zeros(length(model.Mgl),1);
D(L,:)      = E_Vec(:, size(E_Vec,2)-showMode+1);
D           = D';
wn          = wn(size(E_Vec,2)-showMode+1);
dof         = size(model.Mgl);
resp.modal.modeShape = D;
%% 2D FRAME
if in_data.EL(1,2)==0 || in_data.EL(1,2)==1 || in_data.EL(1,2)==2 || in_data.EL(1,2)==333
    FEM_2_modal_animateModeShape(in_data,model,L,E_Vec,wn,showMode,opt)
end
%% 3D FRAME
if in_data.EL(1,2)==3
    h = figure(); hold on;
    set(h,'name',['Mode ', num2str(showMode), ': T =  ',num2str(2*pi/wn) ' [s]']);
    [lab,frame] = getScale(in_data);
    deN = getScaleMode(in_data,D,dof);
    FEM_2_modal_modeShape(in_data,lab,D,deN,frame,dof,1)
    view(3);
end
%% 3D TRUSS
if in_data.EL(1,2)==31
    h = figure(); hold on;
    set(h,'name',['Mode ', num2str(showMode), ': T =  ',num2str(2*pi/wn) ' [s]']);
    [lab,frame] = getScale(in_data);
    deN = getScaleMode(in_data,D,dof);
    FEM_2_modal_modeShape(in_data,lab,D,deN,frame,dof,1)
    view(3);
end
%% CST ELEMENT
if in_data.EL(1,2)==4
    h = figure(); hold on;
    set(h,'name',['Mode ', num2str(showMode), ': T =  ',num2str(2*pi/wn) ' [s]']);
    n_dof_node = 2;
    maxX = max(in_data.ND(:,2)); minX = min(in_data.ND(:,2));
    maxY = max(in_data.ND(:,3)); minY = min(in_data.ND(:,3));
    labx = (maxX / 12); laby = (maxY / 12);
    labx = min([labx laby]); laby = labx;
    max_D_x = max(abs(D(1:n_dof_node:dof(1))));
    max_D_y = max(abs(D(n_dof_node:n_dof_node:dof(1))));
    ND_d = in_data.ND;
    deN = max([max_D_x  max_D_y]);
    ND_d(:,2) = in_data.ND(:,2)+(D(1:n_dof_node:dof(1))'./deN)*1.5*labx;
    ND_d(:,3) = in_data.ND(:,3) + ...
        (D(n_dof_node:n_dof_node:dof(1))'./deN)*1.5*laby;
    plot(ND_d(:,2),ND_d(:,3),'r.'); hold on;
    % PLOT DEFORMED SHAPE
    for i=1:size(in_data.EL,1)
        node1 = find(ND_d(:,1)==in_data.EL(i,3));
        node2 = find(ND_d(:,1)==in_data.EL(i,4));
        node3 = find(ND_d(:,1)==in_data.EL(i,5));
        plot([ND_d(node1,2) ND_d(node2,2) ND_d(node3,2) ND_d(node1,2)], ...
            [ND_d(node1,3) ND_d(node2,3) ND_d(node3,3) ND_d(node1,3)],'r-');
        axis equal; axis off;
        axis([(minX-labx) (maxX+labx) (minY-laby) (maxY+laby) ]);
    end
    % CONSTRAINT
    for i=1:size(in_data.CON)
        node_i = find(in_data.ND(:,1)==in_data.CON(i,1));
        if in_data.CON(i,2)==0
            plot([in_data.ND(node_i,2) in_data.ND(node_i,2)-labx*0.5], ...
                [in_data.ND(node_i,3) in_data.ND(node_i,3)], ...
                'b-','LineWidth',3);
            hold on;
            plot([in_data.ND(node_i,2) in_data.ND(node_i,2)-labx*0.5], ...
                [in_data.ND(node_i,3) in_data.ND(node_i,3)], ...
                'b-','LineWidth',3);
            hold on;
        end
        if in_data.CON(i,3)==0
            plot([in_data.ND(node_i,2) in_data.ND(node_i,2)],...
                [in_data.ND(node_i,3) in_data.ND(node_i,3)-laby*0.5], ...
                'b-','LineWidth',3);
            hold on;
            plot([in_data.ND(node_i,2) in_data.ND(node_i,2)], ...
                [in_data.ND(node_i,3) in_data.ND(node_i,3)-laby*0.5], ...
                'b-','LineWidth',3);
            hold on;
        end
    end
    axis equal; axis off;
    view(2);
end
%% CSQ ELEMENT
if in_data.EL(1,2)==5 || in_data.EL(1,2)==51
    h = figure(); hold on;
    set(h,'name',['Mode ', num2str(showMode), ': T =  ',num2str(2*pi/wn) ' [s]']);
    n_dof_node = 2;
    maxX = max(in_data.ND(:,2)); minX = min(in_data.ND(:,2));
    maxY = max(in_data.ND(:,3)); minY = min(in_data.ND(:,3));
    labx = (maxX / 12); laby = (maxY / 12);
    labx = min([labx laby]); laby = labx;
    max_D_x = max(abs(D(1:n_dof_node:dof(1))));
    max_D_y = max(abs(D(n_dof_node:n_dof_node:dof(1))));
    ND_d = in_data.ND;
    deN = max([max_D_x  max_D_y]);
    ND_d(:,2) = in_data.ND(:,2)+(D(1:n_dof_node:dof(1))'./deN)*1.5*labx;
    ND_d(:,3) = in_data.ND(:,3) + ...
        (D(n_dof_node:n_dof_node:dof(1))'./deN)*1.5*laby;
    for i=1:size(in_data.EL,1)
        node1 = find(in_data.ND(:,1)==in_data.EL(i,3));
        node2 = find(in_data.ND(:,1)==in_data.EL(i,4));
        node3 = find(in_data.ND(:,1)==in_data.EL(i,5));
        node4 = find(in_data.ND(:,1)==in_data.EL(i,6));
        plot([ND_d(node1,2) ND_d(node2,2) ND_d(node3,2) ...
            ND_d(node4,2) ND_d(node1,2)],...
            [ND_d(node1,3) ND_d(node2,3) ND_d(node3,3) ...
            ND_d(node4,3) ND_d(node1,3)],'r-');
        axis equal; axis off;
        axis([(minX-2*labx) (maxX+2*labx) ...
            (minY-2*laby) (maxY+2*laby)]);
        hold on
    end
    % CONSTRAINT
    for i=1:size(in_data.CON)
        node_i = find(in_data.ND(:,1)==in_data.CON(i,1));
        if in_data.CON(i,2)==0
            plot([in_data.ND(node_i,2) in_data.ND(node_i,2)-labx*0.5], ...
                [in_data.ND(node_i,3) in_data.ND(node_i,3)], ...
                'b-','LineWidth',3);
            hold on;
            plot([in_data.ND(node_i,2) in_data.ND(node_i,2)-labx*0.5], ...
                [in_data.ND(node_i,3) in_data.ND(node_i,3)], ...
                'b-','LineWidth',3);
            hold on;
        end
        if in_data.CON(i,3)==0
            plot([in_data.ND(node_i,2) in_data.ND(node_i,2)],...
                [in_data.ND(node_i,3) in_data.ND(node_i,3)-laby*0.5], ...
                'b-','LineWidth',3);
            hold on;
            plot([in_data.ND(node_i,2) in_data.ND(node_i,2)], ...
                [in_data.ND(node_i,3) in_data.ND(node_i,3)-laby*0.5], ...
                'b-','LineWidth',3);
            hold on;
        end
    end
    axis equal; axis off;
    view(2);
    hold off;
end
%% 3D-BRICK
if in_data.EL(1,2)==6
    h = figure(); hold on;
    set(h,'name',['Mode ', num2str(showMode), ': T =  ',num2str(2*pi/wn) ' [s]']);
    
    n_dof_node = 3;
    maxX = max(in_data.ND(:,2)); minX = min(in_data.ND(:,2));
    maxY = max(in_data.ND(:,3)); minY = min(in_data.ND(:,3));
    maxZ = max(in_data.ND(:,4)); minZ = min(in_data.ND(:,4));
    labx = (maxX / 20); laby = (maxY / 20); labz = (maxZ / 20);
    labx = max([labx laby labz]); laby = labx;  labz=labx;
    max_D_x = max(abs(D(1:n_dof_node:dof(1))));
    max_D_y = max(abs(D(2:n_dof_node:dof(1))));
    max_D_z = max(abs(D(3:n_dof_node:dof(1))));
    ND_d = in_data.ND;
    deN = max([max_D_x  max_D_y  max_D_z]);
    ND_d(:,2) = in_data.ND(:,2)+(D(1:n_dof_node:dof(1))'./deN)*0.25*labx;
    ND_d(:,3) = in_data.ND(:,3)+(D(2:n_dof_node:dof(1))'./deN)*0.25*labx;
    ND_d(:,4) = in_data.ND(:,4)+(D(3:n_dof_node:dof(1))'./deN)*0.25*labx;
    [qu] = FEM_3_surfBrick(in_data.ND(:,2:end),in_data.EL(:,3:10));
    tot_d = sqrt( (D(1:n_dof_node:dof(1))).^2 + ...
        (D(2:n_dof_node:dof(1))).^2 + (D(3:n_dof_node:dof(1))).^2 );
    hold on;
    for i=1:size(qu,1)
        patch([ND_d(qu(i,1),2) ND_d(qu(i,2),2) ND_d(qu(i,3),2) ...
            ND_d(qu(i,4),2)], ...
            [ND_d(qu(i,1),3) ND_d(qu(i,2),3) ND_d(qu(i,3),3) ...
            ND_d(qu(i,4),3)], ...
            [ND_d(qu(i,1),4) ND_d(qu(i,2),4) ND_d(qu(i,3),4) ...
            ND_d(qu(i,4),4)], ...
            [tot_d(qu(i,1)) tot_d(qu(i,2)) tot_d(qu(i,3)) tot_d(qu(i,4))]);
    end
    view(3)
    axis equal; axis off;
end
%% BCIZ PLATE
if in_data.EL(1,2)==9
    maxX = max(in_data.ND(:,2)); minX = min(in_data.ND(:,2));
    maxY = max(in_data.ND(:,3)); minY = min(in_data.ND(:,3));
    labx = (maxX / 6); laby =  (maxY / 6);
    labx = min(labx,laby); laby = labx;
    SCz = labx*1.2;
    labz = SCz/2;
    max_D_z = max(abs(D(1:3:dof(1))));
    ND_d = in_data.ND;
    ND_d(:,4) = (D(1:3:dof(1))'./max_D_z)*0.5*SCz;
    for i=1:size(in_data.EL,1)
        node1 = find(ND_d(:,1)==in_data.EL(i,3));
        node2 = find(ND_d(:,1)==in_data.EL(i,4));
        node3 = find(ND_d(:,1)==in_data.EL(i,5));
        plot3([ND_d(node1,2) ND_d(node2,2) ND_d(node3,2) ND_d(node1,2)], ...
            [ND_d(node1,3) ND_d(node2,3) ND_d(node3,3) ND_d(node1,3)], ...
            [ND_d(node1,4) ND_d(node2,4) ND_d(node3,4) ND_d(node1,4)],'r-');
        axis equal; axis off; view(3); hold on;
        axis([(-1.1*minX) (1.1*maxX) (-1.1*minY) (1.1*maxY) (-SCz) (SCz)]);
    end
end
%% Tetrahedron 3D
if in_data.EL(1,2)==10
    h = figure(); hold on;
    set(h,'name',['Mode ', num2str(showMode), ': T =  ',num2str(2*pi/wn) ' [s]']);
    n_dof_node = 3;
    maxX = max(in_data.ND(:,2)); minX = min(in_data.ND(:,2));
    maxY = max(in_data.ND(:,3)); minY = min(in_data.ND(:,3));
    maxZ = max(in_data.ND(:,4)); minZ = min(in_data.ND(:,4));
    labx = (maxX / 20); laby = (maxY / 20); labz = (maxZ / 20);
    labx = max([labx laby labz]);
    max_D_x = max(abs(D(1:n_dof_node:dof(1))));
    max_D_y = max(abs(D(2:n_dof_node:dof(1))));
    max_D_z = max(abs(D(3:n_dof_node:dof(1))));
    ND_d = in_data.ND;
    deN = max([max_D_x  max_D_y  max_D_z]);
    ND_d(:,2) = in_data.ND(:,2)+(D(1:n_dof_node:dof(1))'./deN)*0.25*labx;
    ND_d(:,3) = in_data.ND(:,3)+(D(2:n_dof_node:dof(1))'./deN)*0.25*labx;
    ND_d(:,4) = in_data.ND(:,4)+(D(3:n_dof_node:dof(1))'./deN)*0.25*labx;
    tri2 = FEM_3_surfTet(in_data.ND(:,2:4),in_data.EL(:,3:6));
    tot_d = sqrt( (D(1:n_dof_node:dof(1))).^2 + ...
        (D(2:n_dof_node:dof(1))).^2 + (D(3:n_dof_node:dof(1))).^2 );
    tot_d = tot_d./max(tot_d);
    trimesh(tri2,ND_d(:,2),ND_d(:,3),ND_d(:,4),'CData',(tot_d'), ...
        'facecolor','interp','edgecolor','y');
    axis equal;
    axis off;
    hold on;
    maxX = max(in_data.ND(:,2));
    labx = (maxX / 12);
    maxY = max(in_data.ND(:,3));
    laby = (maxY / 12);
    maxZ = max(in_data.ND(:,4));
    labz = (maxZ / 12);
    labx = min([labx laby labz]); laby = labx;  labz=labx;
    for i=1:size(in_data.CON)
        node_i = find(in_data.ND(:,1)==in_data.CON(i,1));
        if in_data.CON(i,2)==0
            plot3([in_data.ND(node_i,2) in_data.ND(node_i,2)-labx], ...
                [in_data.ND(node_i,3) in_data.ND(node_i,3)], ...
                [in_data.ND(node_i,4) in_data.ND(node_i,4)], ...
                'k-','LineWidth',3);
            hold on;
            plot3([in_data.ND(node_i,2) in_data.ND(node_i,2)-labx], ...
                [in_data.ND(node_i,3) in_data.ND(node_i,3)], ...
                [in_data.ND(node_i,4) in_data.ND(node_i,4)], ...
                'k-','LineWidth',3);
            hold on;
        end
        if in_data.CON(i,3)==0
            plot3([in_data.ND(node_i,2) in_data.ND(node_i,2)], ...
                [in_data.ND(node_i,3) in_data.ND(node_i,3)-laby], ...
                [in_data.ND(node_i,4) in_data.ND(node_i,4)], ...
                'k-','LineWidth',3);
            hold on;
            plot3([in_data.ND(node_i,2) in_data.ND(node_i,2)], ...
                [in_data.ND(node_i,3) in_data.ND(node_i,3)-laby], ...
                [in_data.ND(node_i,4) in_data.ND(node_i,4)], ...
                'k-','LineWidth',3);
            hold on;
        end
        if in_data.CON(i,4)==0
            plot3([in_data.ND(node_i,2) in_data.ND(node_i,2)], ...
                [in_data.ND(node_i,3) in_data.ND(node_i,3)], ...
                [in_data.ND(node_i,4) in_data.ND(node_i,4)-labz], ...
                'k-','LineWidth',3);
            hold on;
            plot3([in_data.ND(node_i,2) in_data.ND(node_i,2)], ...
                [in_data.ND(node_i,3) in_data.ND(node_i,3)], ...
                [in_data.ND(node_i,4) in_data.ND(node_i,4)-labz], ...
                'k-','LineWidth',3);
            hold on;
        end
    end
    hold off;
end
%% TYPE 666
if in_data.EL(1,2)==666
    h = figure(); hold on;
    set(h,'name',['Mode ', num2str(showMode), ': T =  ',num2str(2*pi/wn) ' [s]']);
    for i=1:size(in_data.EL,1)
        node1 = find(in_data.ND(:,1)==in_data.EL(i,3));
        node2 = find(in_data.ND(:,1)==in_data.EL(i,4));
        node3 = find(in_data.ND(:,1)==in_data.EL(i,5));
        node4 = find(in_data.ND(:,1)==in_data.EL(i,6));
        node5 = find(in_data.ND(:,1)==in_data.EL(i,7));
        node6 = find(in_data.ND(:,1)==in_data.EL(i,8));
        node7 = find(in_data.ND(:,1)==in_data.EL(i,9));
        node8 = find(in_data.ND(:,1)==in_data.EL(i,10));
        plot3([ND_d(node1,2) ND_d(node2,2) ND_d(node3,2) ND_d(node4,2) ...
            ND_d(node1,2) ND_d(node5,2) ND_d(node6,2) ND_d(node7,2) ...
            ND_d(node8,2) ND_d(node5,2)], ...
            [ND_d(node1,3) ND_d(node2,3) ND_d(node3,3) ND_d(node4,3) ...
            ND_d(node1,3) ND_d(node5,3) ND_d(node6,3) ND_d(node7,3) ...
            ND_d(node8,3) ND_d(node5,3)], ...
            [ND_d(node1,4) ND_d(node2,4) ND_d(node3,4) ND_d(node4,4) ...
            ND_d(node1,4) ND_d(node5,4) ND_d(node6,4) ND_d(node7,4) ...
            ND_d(node8,4) ND_d(node5,4)],'r-','LineWidth',1);
        
        plot3([ND_d(node2,2) ND_d(node6,2) ND_d(node7,2) ND_d(node3,2) ...
            ND_d(node2,2) ND_d(node1,2) ND_d(node5,2) ND_d(node8,2) ...
            ND_d(node4,2) ND_d(node1,2)], ...
            [ND_d(node2,3) ND_d(node6,3) ND_d(node7,3) ND_d(node3,3) ...
            ND_d(node2,3) ND_d(node1,3) ND_d(node5,3) ND_d(node8,3) ...
            ND_d(node4,3) ND_d(node1,3)], ...
            [ND_d(node2,4) ND_d(node6,4) ND_d(node7,4) ND_d(node3,4) ...
            ND_d(node2,4) ND_d(node1,4) ND_d(node5,4) ND_d(node8,4) ...
            ND_d(node4,4) ND_d(node1,4)],'r-','LineWidth',1);
        hold on;
        axis equal; axis off;
        axis([(minX-labx) (maxX+labx) (minY-laby) (maxY+laby) ...
            (minZ-labz)    (maxZ+labz)]); % plot scale
    end
end
