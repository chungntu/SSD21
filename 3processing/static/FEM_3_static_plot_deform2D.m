%--------------------------------------------------------------------------
% PLOT DEFORMED STRUCTURE
% Truong Thanh Chung. Aug 2021.
%--------------------------------------------------------------------------
function FEM_3_static_plot_deform2D(in_data,resp,opt)
dof = size(in_data.ND,1)*3;
[lab,frame] = getScale(in_data);
deN = max([max(abs(resp.static.D(1:3:end))),max(abs(resp.static.D(2:3:end)))]);
if deN==0; deN = 1; end

%% CALCULATE MAXIMUM DISPLACEMENT
fullD = [];
for ELEMENT = 1:size(in_data.EL)
    node1 = in_data.EL(ELEMENT,3);
    node2 = in_data.EL(ELEMENT,4);
    % AFTER LOAD
    ex = [in_data.ND(node1,2) in_data.ND(node2,2)];
    ey = [in_data.ND(node1,3) in_data.ND(node2,3)];
    dofElement = [node1*3-2 node1*3-1 node1*3 node2*3-2 node2*3-1 node2*3];
    ed = resp.static.D(dofElement);
    [~,~,cd] = beam2crd(ex,ey,ed,1);
    fullD = [fullD cd];
end
maxD = max(max(abs(fullD)));
scaleFactor = lab/maxD;

%% PLOT DEFORMED STRUCTURE
h = figure; hold on; axis equal; axis off
set(h,'name','DEFORMED STRUCTURE'); axis(frame);
for ELEMENT = 1:size(in_data.EL)
    node1 = in_data.EL(ELEMENT,3);
    node2 = in_data.EL(ELEMENT,4);
    % BEFORE LOAD
    plot([in_data.ND(node1,2),in_data.ND(node2,2)],...
        [in_data.ND(node1,3),in_data.ND(node2,3)],'k:','LineWidth',1);
    % AFTER LOAD
    ex = [in_data.ND(node1,2) in_data.ND(node2,2)];
    ey = [in_data.ND(node1,3) in_data.ND(node2,3)];
    dofElement = [node1*3-2 node1*3-1 node1*3 node2*3-2 node2*3-1 node2*3];
    ed = resp.static.D(dofElement);
    [exc,eyc] = beam2crd(ex,ey,ed,scaleFactor);
    xc = exc'; yc = eyc';
    hold on
    axis equal
    plot(xc,yc,'k','Linewidth',2)
end
dx = resp.static.D(1:3:dof(1))*scaleFactor;
dy = resp.static.D(2:3:dof(1))*scaleFactor;
ND_d = in_data.ND;
ND_d(:,2) = in_data.ND(:,2)+dx';
ND_d(:,3) = in_data.ND(:,3)+dy';
% PLOT RESTRAINTS
plotRestraint(in_data,ND_d,lab);
% PLOT SCALE BAR
if opt.staticScaleBar
    plotScaleBar(scaleFactor,maxD,[0 -frame(4)/5]);
end
hold off
if opt.exportFig
    export_fig h -transparent
end
end
