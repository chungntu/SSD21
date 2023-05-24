%--------------------------------------------------------------------------
% PLOT GUI 2D FRAME STRUCTURE
% Truong Thanh Chung. Aug 2021.
%--------------------------------------------------------------------------
function FEM_1_plotGUIdata_2DStructure(inData,opt)
[lab,frame] = getScale(inData);
%% FRAME STRUCTURE
figName = figure; set(figName,'name','STRUCTURE');
axis equal; axis off; axis(frame); hold on;
shift = 0.1;
for ELEMENT=1:size(inData.EL)
    node1 = inData.EL(ELEMENT,3);
    node2 = inData.EL(ELEMENT,4);
    % PLOT STRUCTURE
    switch inData.EL(ELEMENT,2)
        case {0}
            plot([inData.ND(node1,2),inData.ND(node2,2)],...
                [inData.ND(node1,3),inData.ND(node2,3)],'k-','LineWidth',2);
        case {333} % PIN-PIN BEAM ELEMENT. THIS CASE PLOT LINE WITH CIRCLE AT BOTH ENDS, SHRINK THE LINE BY 5%
            xL  = [0.1;0.9];
            xNode1 = inData.ND(node1,2);  yNode1 = inData.ND(node1,3);
            xNode2 = inData.ND(node2,2);  yNode2 = inData.ND(node2,3);
            L = sqrt((xNode2-xNode1)^2 + (yNode2-yNode1)^2 ) ;
            cosa = (xNode2-xNode1) / L; sina = (yNode2-yNode1) / L;
            x = xL*L;
            T = [cosa,sina;-sina,cosa];
            coor_beam = [x,x.*0]*T; % transform horizontal beam to an inclined beam
            coor_beam_x = coor_beam(:,1) + xNode1;
            coor_beam_y = coor_beam(:,2) + yNode1;
            plot(coor_beam_x,coor_beam_y,'k-o','LineWidth',2,'MarkerSize',6,'MarkerEdgeColor','k','MarkerFaceColor','w');
        case {1} % FIX-PIN BEAM
            xL  = [0;0.9];
            xNode1 = inData.ND(node1,2);  yNode1 = inData.ND(node1,3);
            xNode2 = inData.ND(node2,2);  yNode2 = inData.ND(node2,3);
            L = sqrt((xNode2-xNode1)^2 + (yNode2-yNode1)^2 ) ;
            cosa = (xNode2-xNode1) / L; sina = (yNode2-yNode1) / L;
            x = xL*L;
            T = [cosa,sina;-sina,cosa];
            coor_beam = [x,x.*0]*T; % transform horizontal beam to an inclined beam
            coor_beam_x = coor_beam(:,1) + xNode1;
            coor_beam_y = coor_beam(:,2) + yNode1;
           plot(coor_beam_x,coor_beam_y,'k-o','LineWidth',2,'MarkerSize',6,'MarkerEdgeColor','k','MarkerFaceColor','w','MarkerIndices',2);
        case {2} % PIN-FIX BEAM
            xL  = [0.1;1];
            xNode1 = inData.ND(node1,2);  yNode1 = inData.ND(node1,3);
            xNode2 = inData.ND(node2,2);  yNode2 = inData.ND(node2,3);
            L = sqrt((xNode2-xNode1)^2 + (yNode2-yNode1)^2 ) ;
            cosa = (xNode2-xNode1) / L; sina = (yNode2-yNode1) / L;
            x = xL*L;
            T = [cosa,sina;-sina,cosa];
            coor_beam = [x,x.*0]*T; % transform horizontal beam to an inclined beam
            coor_beam_x = coor_beam(:,1) + xNode1;
            coor_beam_y = coor_beam(:,2) + yNode1;
           plot(coor_beam_x,coor_beam_y,'k-o','LineWidth',2,'MarkerSize',6,'MarkerEdgeColor','k','MarkerFaceColor','w','MarkerIndices',1);

           
    end
    % PLOT NODES NUMBER ---------------------------------------------------
    if size(inData.EL)<250
        nodeLabel = text(inData.ND(node1,2)+shift,inData.ND(node1,3)+shift,...
            num2str(node1)); set_font1(nodeLabel);
        nodeLabel = text(inData.ND(node2,2)+shift,inData.ND(node2,3)+shift,...
            num2str(node2));
        set_font1(nodeLabel);
        % PLOT ELEMENTS NUMBER ------------------------------------------------
        x1 = (inData.ND(node2,2)+inData.ND(node1,2))/2 + shift;
        y1 = (inData.ND(node2,3)+inData.ND(node1,3))/2 + shift;
        frameLabel = text(x1,y1,num2str(inData.EL(ELEMENT,1)));
        set_font2(frameLabel);
    end
    % PLOT UNIFORM LOADS
    plotUniformLoad(inData,lab,ELEMENT)
end
% PLOT CONCENTRATED LOADS
plotConcentratedLoad(inData,lab); hold on
% PLOT RESTRAINTS
plotRestraint(inData,inData.ND,lab); hold off
if opt.exportFig
    export_fig structure -transparent
end
%% MASS STRUCTURE
if ~isempty(inData.JointMass)
    if opt.modalLinear.flag || opt.modalLinearCondense.flag || opt.dynm.flag
        figMass = figure; hold on; axis equal; axis off; axis(frame);
        set(figMass,'name','LUMP MASS STRUCTURE');
        shift = 0.1;
        for ELEMENT=1:size(inData.EL)
            node1 = inData.EL(ELEMENT,3);
            node2 = inData.EL(ELEMENT,4);
            % PLOT STRUCTURE
            plot([inData.ND(node1,2),inData.ND(node2,2)],...
                [inData.ND(node1,3),inData.ND(node2,3)],'k-','LineWidth',2);
            % PLOT NODES NUMBER
            if size(inData.EL)<250
                nodeLabel = text(inData.ND(node1,2)+shift,inData.ND(node1,3)+shift,...
                    num2str(node1)); set_font1(nodeLabel);
                nodeLabel = text(inData.ND(node2,2)+shift,inData.ND(node2,3)+shift,...
                    num2str(node2));
                set_font1(nodeLabel);
                % PLOT ELEMENTS NUMBER
                x1 = (inData.ND(node2,2)+inData.ND(node1,2))/2 + shift;
                y1 = (inData.ND(node2,3)+inData.ND(node1,3))/2 + shift;
                frameLabel = text(x1,y1,num2str(inData.EL(ELEMENT,1)));
                set_font2(frameLabel);
            end
        end
        % PLOT RESTRAINTS
        plotRestraint(inData,inData.ND,lab); hold on
        plotMovingLumpMass(inData,inData.ND,lab); hold off
        if  opt.exportFig
            export_fig massStructure -transparent
        end
    end
end
end



function plotConcentratedLoad(in_data,lab)
sizeArrow = lab;
if  isfield(in_data,'LOAD_')
    for i=1:size(in_data.LOAD_)
        NODE = find(in_data.ND(:,1)==in_data.LOAD_(i,1));
        if  isfield(in_data,'LOAD_')
            % PLOT CONCENTRATED LOADS -----------------------------------------
            if in_data.LOAD_(i,2)>0
                quiver(in_data.ND(NODE,2),in_data.ND(NODE,3),sizeArrow,0,...
                    'Linewidth',2,'MaxHeadSize',1,'Color','b'); hold on;
                gf = text(in_data.ND(NODE,2)+sizeArrow,in_data.ND(NODE,3)+sizeArrow/6,...
                    num2str(in_data.LOAD_(i,2))); set_font3(gf);
            end
            if in_data.LOAD_(i,2)<0
                quiver(in_data.ND(NODE,2),in_data.ND(NODE,3),-sizeArrow,0,...
                    'Linewidth',2,'MaxHeadSize',1,'Color','b'); hold on;
                gf = text(in_data.ND(NODE,2)-1.2*sizeArrow,in_data.ND(NODE,3)+sizeArrow/6,...
                    num2str(abs(in_data.LOAD_(i,2)))); set_font3(gf);
            end
            if in_data.LOAD_(i,3)>0
                quiver(in_data.ND(NODE,2),in_data.ND(NODE,3),0,sizeArrow,...
                    'Linewidth',2,'MaxHeadSize',1,'Color','b'); hold on;
                gf = text(in_data.ND(NODE,2)+0.1*sizeArrow,in_data.ND(NODE,3)+1.2*sizeArrow,...
                    num2str(in_data.LOAD_(i,3))); set_font3(gf);
            end
            if in_data.LOAD_(i,3)<0
                quiver(in_data.ND(NODE,2),in_data.ND(NODE,3),0,-sizeArrow,...
                    'Linewidth',2,'MaxHeadSize',1,'Color','b'); hold on;
                gf = text(in_data.ND(NODE,2)+0.1*sizeArrow,in_data.ND(NODE,3)-1.2*sizeArrow,...
                    num2str(abs(in_data.LOAD_(i,3)))); set_font3(gf);
            end
            % PLOT MOMENTS ----------------------------------------------------
            r = lab/2;
            if in_data.LOAD_(i,4)>0
                th = linspace( pi/2.5, -pi/1.6, 100);
                x = r*cos(th) + in_data.ND(NODE,2);
                y = r*sin(th) + in_data.ND(NODE,3);
                plot(x,y,'LineWidth',2,'Color','b'); hold on;
                quiver(x(1),y(1),-lab/2,0,'Linewidth',2,...
                    'MaxHeadSize',5,'Color','b');
                gf = text(x(1),y(1)+0.2*sizeArrow,...
                    num2str(abs(in_data.LOAD_(i,4)))); set_font3(gf);
            end
            if in_data.LOAD_(i,4)<0
                th = linspace( -pi/2.5, pi/1.6, 100);
                x = r*cos(th) + in_data.ND(NODE,2);
                y = r*sin(th) + in_data.ND(NODE,3);
                plot(x,y,'LineWidth',2,'Color','b'); hold on;
                quiver(x(1),y(1),-lab/2,0,'Linewidth',2,...
                    'MaxHeadSize',5,'Color','b');
                gf = text(x(1),y(1)-0.2*sizeArrow,...
                    num2str(abs(in_data.LOAD_(i,4)))); set_font3(gf);
            end
        end
    end
end
end

function plotUniformLoad(in_data,lab,ELEMENT)
node1 = in_data.EL(ELEMENT,3);
node2 = in_data.EL(ELEMENT,4);
x1 = in_data.ND(node1,2);  y1 = in_data.ND(node1,3);
x2 = in_data.ND(node2,2);  y2 = in_data.ND(node2,3);
L = sqrt((x2-x1)^2+(y2-y1)^2);
c = (x2-x1)/L; s = (y2-y1)/L;
T = [ c s ; -s  c ];
% PLOT LOADS IN X-DIRECTION USING ARROW
if  isfield(in_data,'qx')&& in_data.qx(ELEMENT)~=0
    plotLoc_qx = (0:1/round(L/lab)/2:1)'*L;
    if in_data.qx(ELEMENT)<0; labx = -lab;
        plotLoc_qx_T = [plotLoc_qx,ones(length(plotLoc_qx),1)*labx*0.3]*T;
        plot(x1+plotLoc_qx_T(:,1),y1+plotLoc_qx_T(:,2),'r<',...
            'MarkerEdgeColor','b','MarkerFaceColor','b',...
            'MarkerSize',5);
    else; labx = lab;
        plotLoc_qx_T = [plotLoc_qx,ones(length(plotLoc_qx),1)*labx*0.3]*T;
        plot(x1+plotLoc_qx_T(:,1),y1+plotLoc_qx_T(:,2),'r>',...
            'MarkerEdgeColor','b','MarkerFaceColor','b',...
            'MarkerSize',5);
    end
end
% LOADS IN Z-DIRECTION USE DOT LINE
if  isfield(in_data,'qz0') && in_data.qz0(ELEMENT)~=0
    plotLoc_qz = (0:0.05:L)';
    if in_data.qz0(ELEMENT)> 0; laby = -lab; else; laby = lab; end
    plotLoc_qz_T = [plotLoc_qz,ones(length(plotLoc_qz),1)*laby*0.3]*T;
    plot(x1+plotLoc_qz_T(:,1),y1+plotLoc_qz_T(:,2),'b:','Linewidth',2);
end
end

function set_font1(h)
set(h,'fontname','times','FontSize',8,'Color','b');
end
function set_font2(h)
set(h,'fontname','times','FontSize',8,'Color','k');
end
function set_font3(gf)
set(gf,'FontSize',10,'Color','b');
end
