function FEM_3_plotCSTQ( inData, SIGsys, resp, dof, NF)

% Plot stress field

% -------------------------------------------------------------------------
warning off


maxX = max(inData.ND(:,2)); minX = min(inData.ND(:,2));
maxY = max(inData.ND(:,3)); minY = min(inData.ND(:,3));
labx = (maxX / 10); laby = (maxY / 10);
labx = max([labx laby]); laby = labx;
if 1
    if inData.EL(1,2)==4
        MAX_SIG = (SIGsys(1:3:length(SIGsys)) + ...
            SIGsys(2:3:length(SIGsys))).*0.5 + ...
            sqrt((SIGsys(1:3:length(SIGsys)) - ...
            SIGsys(2:3:length(SIGsys))).^2 + ...
            SIGsys(3:3:length(SIGsys)).^2.*4);
        MIN_SIG = (SIGsys(1:3:length(SIGsys)) + ...
            SIGsys(2:3:length(SIGsys))).*0.5 - ...
            sqrt((SIGsys(1:3:length(SIGsys)) - ...
            SIGsys(2:3:length(SIGsys))).^2 + ...
            SIGsys(3:3:length(SIGsys)).^2.*4);
        maxSIGmax = max(MAX_SIG); minSIGmax = min(MAX_SIG);
        maxSIGmin = max(MIN_SIG); minSIGmin = min(MIN_SIG);
        SIG_nd = zeros(size(inData.ND,1),1);
        SIG_nd_nr = zeros(size(inData.ND,1),1);
    end
    
    if inData.EL(1,2)==5 | inData.EL(1,2)==51
        MAX_SIG = (SIGsys(1:3:end,:)+SIGsys(2:3:end,:)).*0.5 + ...
            sqrt((SIGsys(1:3:end,:)-SIGsys(2:3:end,:)).^2 + ...
            SIGsys(3:3:end,:).^2.*4);
        MIN_SIG = (SIGsys(1:3:end,:)+SIGsys(2:3:end,:)).*0.5 - ...
            sqrt((SIGsys(1:3:end,:)-SIGsys(2:3:end,:)).^2 + ...
            SIGsys(3:3:end,:).^2.*4);
        maxSIGmax = max(MAX_SIG); minSIGmax = min(MAX_SIG);
        maxSIGmin = max(MIN_SIG); minSIGmin = min(MIN_SIG);
        SIG_nd = zeros(size(inData.ND,1),1);
        SIG_nd_nr = zeros(size(inData.ND,1),1);
    end
    
    for i=1:size(inData.EL)
        if inData.EL(i,2)==4
            node1 = find(inData.ND(:,1)==inData.EL(i,3));
            node2 = find(inData.ND(:,1)==inData.EL(i,4));
            node3 = find(inData.ND(:,1)==inData.EL(i,5));
            SIG_nd(node1,1:3) = SIG_nd(node1,1) + MAX_SIG(i)';
            SIG_nd(node2,1:3) = SIG_nd(node2,1) + MAX_SIG(i)';
            SIG_nd(node3,1:3) = SIG_nd(node3,1) + MAX_SIG(i)';
            SIG_nd_nr(node1,1:3) = SIG_nd_nr(node1,1) + [1];
            SIG_nd_nr(node2,1:3) = SIG_nd_nr(node2,1) + [1];
            SIG_nd_nr(node3,1:3) = SIG_nd_nr(node3,1) + [1];
        end
        if inData.EL(i,2)==5
            node1 = find(inData.ND(:,1)==inData.EL(i,3));
            node2 = find(inData.ND(:,1)==inData.EL(i,4));
            node3 = find(inData.ND(:,1)==inData.EL(i,5));
            node4 = find(inData.ND(:,1)==inData.EL(i,6));
            SIG_nd(node1,1:3) = SIG_nd(node1,1) + MAX_SIG(i,2)';
            SIG_nd(node2,1:3) = SIG_nd(node2,1) + MAX_SIG(i,3)';
            SIG_nd(node3,1:3) = SIG_nd(node3,1) + MAX_SIG(i,4)';
            SIG_nd(node4,1:3) = SIG_nd(node4,1) + MAX_SIG(i,5)';
            SIG_nd_nr(node1,1:3) = SIG_nd_nr(node1,1) + [1];
            SIG_nd_nr(node2,1:3) = SIG_nd_nr(node2,1) + [1];
            SIG_nd_nr(node3,1:3) = SIG_nd_nr(node3,1) + [1];
            SIG_nd_nr(node4,1:3) = SIG_nd_nr(node4,1) + [1];
        end
    end
    SIG_nd_max = SIG_nd./SIG_nd_nr;
    figure(NF); hold off;
    
    for i=1:size(inData.EL)
        if inData.EL(i,2)==4
            lp=subplot(121);
            node1 = find(inData.ND(:,1)==inData.EL(i,3));
            node2 = find(inData.ND(:,1)==inData.EL(i,4));
            node3 = find(inData.ND(:,1)==inData.EL(i,5));
            trisurf([1 2 3],inData.ND([node1 node2 node3],2),...
                inData.ND([node1 node2 node3],3), ...
                SIG_nd_max([node1 node2 node3],1));
            hold on;
        end
        if inData.EL(i,2)==5 | inData.EL(i,2)==51
            lp=subplot(121);
            node1 = find(inData.ND(:,1)==inData.EL(i,3));
            node2 = find(inData.ND(:,1)==inData.EL(i,4));
            node3 = find(inData.ND(:,1)==inData.EL(i,5));
            node4 = find(inData.ND(:,1)==inData.EL(i,6));
            trisurf([1 2 3 4],inData.ND([node1 node2 node3 node4],2),...
                inData.ND([node1 node2 node3 node4],3), ...
                SIG_nd_max([node1 node2 node3 node4],1) );
            hold on;
        end
    end
    
    %% MAX
    
    shading interp; axis equal;  colormap(hsv); lighting phong;
    axis off; title('Stress field - MAX (tension)'); view(2); hold on;
    if isfield(inData.mater,'ex')
        axis([min(inData.ND(:,2))  max(inData.ND(:,2)) ...
            min(inData.ND(:,3)) max(inData.ND(:,3)) ...
            min(inData.mater.rb_) max(inData.mater.rb)  ]);
        caxis([ min(inData.mater.rb_) max(inData.mater.rb)  ]);
    end
    
    
    SIG_nd    = zeros(size(inData.ND,1),1);
    SIG_nd_nr = zeros(size(inData.ND,1),1);
    
    for i=1:size(inData.EL)
        if inData.EL(i,2)==4
            node1 = find(inData.ND(:,1)==inData.EL(i,3));
            node2 = find(inData.ND(:,1)==inData.EL(i,4));
            node3 = find(inData.ND(:,1)==inData.EL(i,5));
            SIG_nd(node1,1:3) = SIG_nd(node1,1) + MIN_SIG(i)';
            SIG_nd(node2,1:3) = SIG_nd(node2,1) + MIN_SIG(i)';
            SIG_nd(node3,1:3) = SIG_nd(node3,1) + MIN_SIG(i)';
            SIG_nd_nr(node1,1:3) = SIG_nd_nr(node1,1) + [1];
            SIG_nd_nr(node2,1:3) = SIG_nd_nr(node2,1) + [1];
            SIG_nd_nr(node3,1:3) = SIG_nd_nr(node3,1) + [1];
        end
        if inData.EL(i,2)==5 | inData.EL(i,2)==51
            node1 = find(inData.ND(:,1)==inData.EL(i,3));
            node2 = find(inData.ND(:,1)==inData.EL(i,4));
            node3 = find(inData.ND(:,1)==inData.EL(i,5));
            node4 = find(inData.ND(:,1)==inData.EL(i,6));
            SIG_nd(node1,1:3) = SIG_nd(node1,1) + MIN_SIG(i,2)';
            SIG_nd(node2,1:3) = SIG_nd(node2,1) + MIN_SIG(i,3)';
            SIG_nd(node3,1:3) = SIG_nd(node3,1) + MIN_SIG(i,4)';
            SIG_nd(node4,1:3) = SIG_nd(node4,1) + MIN_SIG(i,5)';
            SIG_nd_nr(node1,1:3) = SIG_nd_nr(node1,1) + [1];
            SIG_nd_nr(node2,1:3) = SIG_nd_nr(node2,1) + [1];
            SIG_nd_nr(node3,1:3) = SIG_nd_nr(node3,1) + [1];
            SIG_nd_nr(node4,1:3) = SIG_nd_nr(node4,1) + [1];
        end
    end
    SIG_nd_min = SIG_nd./SIG_nd_nr;
    figure(NF); hold on;
    
    for i=1:size(inData.EL)
        if inData.EL(i,2)==4
            rp=subplot(122);
            node1 = find(inData.ND(:,1)==inData.EL(i,3));
            node2 = find(inData.ND(:,1)==inData.EL(i,4));
            node3 = find(inData.ND(:,1)==inData.EL(i,5));
            trisurf([1 2 3],inData.ND([node1 node2 node3],2),...
                inData.ND([node1 node2 node3],3), ...
                SIG_nd_min([node1 node2 node3],1));
            hold on;
        end
        if inData.EL(i,2)==5 | inData.EL(i,2)==51
            rp=subplot(122);
            node1 = find(inData.ND(:,1)==inData.EL(i,3));
            node2 = find(inData.ND(:,1)==inData.EL(i,4));
            node3 = find(inData.ND(:,1)==inData.EL(i,5));
            node4 = find(inData.ND(:,1)==inData.EL(i,6));
            trisurf([1 2 3 4],inData.ND([node1 node2 node3 node4],2),...
                inData.ND([node1 node2 node3 node4],3), ...
                SIG_nd_min([node1 node2 node3 node4],1) );
            hold on;
        end
    end
    
    %% MIN
    shading interp; axis equal;  colormap(hsv); axis off;
    title('Stress field - MIN (compression) '); view(2); hold on
    set(NF,'name',[' Stress Field. MAX = ' num2str(max(SIG_nd_max(:,1))) ...
        '   MIN = '  num2str(min(SIG_nd_min(:,1)))],'NumberTitle','off', ...
        'position',[ 50 50 800 420 ]);
    if isfield(inData.mater,'ex')
        axis([min(inData.ND(:,2))  max(inData.ND(:,2)) ...
            min(inData.ND(:,3)) max(inData.ND(:,3)) ...
            min(inData.mater.rb_) max(inData.mater.rb)  ]);
        caxis('manual');
        caxis([ min(inData.mater.rb_) max(inData.mater.rb)  ]);
    end
    
    
    figure(NF); hold on;
    
    for i=1:size(inData.EL)
        if inData.EL(i,2)==4
            yy = (MAX_SIG(i) - minSIGmax)*1/(maxSIGmax - minSIGmax);
            node1 = find(inData.ND(:,1)==inData.EL(i,3));
            node2 = find(inData.ND(:,1)==inData.EL(i,4));
            node3 = find(inData.ND(:,1)==inData.EL(i,5));
            Xi = [1 1 1; ...
                inData.ND(node1,2) inData.ND(node2,2) inData.ND(node3,2); ...
                inData.ND(node1,3) inData.ND(node2,3) ...
                inData.ND(node3,3)]*[1/3; 1/3; 1/3];
        end;
        if inData.EL(i,2)==5 | inData.EL(i,2)==51
            yy = (MAX_SIG(i,1) - minSIGmax(1))*1/(maxSIGmax(1) - minSIGmax(1));
            node1 = find(inData.ND(:,1)==inData.EL(i,3));
            node2 = find(inData.ND(:,1)==inData.EL(i,4));
            node3 = find(inData.ND(:,1)==inData.EL(i,5));
            node4 = find(inData.ND(:,1)==inData.EL(i,6));
            xi = 0; niu=0;
            N1 = 1/4*(1-xi)*(1-niu);
            N2 = 1/4*(1+xi)*(1-niu);
            N3 = 1/4*(1+xi)*(1+niu);
            N4 = 1/4*(1-xi)*(1+niu);
            Xi = [1; inData.ND(node1,2)*N1 + inData.ND(node2,2)*N2 + ...
                inData.ND(node3,2)*N3 + inData.ND(node4,2)*N4; ...
                inData.ND(node1,3)*N1 + inData.ND(node2,3)*N2 + ...
                inData.ND(node3,3)*N3 + inData.ND(node4,3)*N4];
        end;
        
        angle_max = 0.5*atan(2*(SIGsys(i*3))/(SIGsys(i*3-2)-SIGsys(i*3-1)));
        vv = (SIGsys(i*3-2)) - (SIGsys(i*3-1));
        yi = abs(cos(angle_max)*yy*laby);
        xi = abs(sin(angle_max)*yy*labx);
        angle_max  = angle_max*360/(2*pi);
        ANm(i) = angle_max;
        if vv>0 txy=xi*laby/labx; xi=yi*labx/laby; yi=txy; end;
        if MAX_SIG(i)>0  cv='b-'; cv='k-'; else cv='r-'; cv='k-'; end;
        
%         figure(NF); subplot(lp); hold on
%         if vv<0 & angle_max>0  plot3([Xi(2)-0.5*xi Xi(2)+0.5*xi],...
%                 [Xi(3)+0.5*yi Xi(3)-0.5*yi],[max(max(SIG_nd_max))+100 ...
%                 max(max(SIG_nd_max))+100],cv,'LineWidth',1);
%         end;
%         if vv<0 & angle_max<0
%             plot3([Xi(2)+0.5*xi Xi(2)-0.5*xi],...
%                 [Xi(3)+0.5*yi Xi(3)-0.5*yi],[max(max(SIG_nd_max))+100 ...
%                 max(max(SIG_nd_max))+100],cv,'LineWidth',1);
%         end;
%         if vv>0 & angle_max>0  plot3([Xi(2)+0.5*xi Xi(2)-0.5*xi],...
%                 [Xi(3)+0.5*yi Xi(3)-0.5*yi],[max(max(SIG_nd_max))+100 ...
%                 max(max(SIG_nd_max))+100],cv,'LineWidth',1);
%         end;
%         if vv>0 & angle_max<0  plot3([Xi(2)-0.5*xi Xi(2)+0.5*xi],...
%                 [Xi(3)+0.5*yi Xi(3)-0.5*yi],[max(max(SIG_nd_max))+100 ...
%                 max(max(SIG_nd_max))+100],cv,'LineWidth',1);
%         end;
        
    end;
    
    
    for i=1:size(inData.EL)
        yy = 1-(MIN_SIG(i,1) - minSIGmin(1))*1/(maxSIGmin(1) - minSIGmin(1));
        if inData.EL(i,2)==4
            node1 = find(inData.ND(:,1)==inData.EL(i,3));
            node2 = find(inData.ND(:,1)==inData.EL(i,4));
            node3 = find(inData.ND(:,1)==inData.EL(i,5));
            Xi = [1 1 1; inData.ND(node1,2) inData.ND(node2,2) ...
                inData.ND(node3,2); inData.ND(node1,3) ...
                inData.ND(node2,3) inData.ND(node3,3)]*[1/3; 1/3; 1/3];
        end;
        if inData.EL(i,2)==5 | inData.EL(i,2)==51
            node1 = find(inData.ND(:,1)==inData.EL(i,3));
            node2 = find(inData.ND(:,1)==inData.EL(i,4));
            node3 = find(inData.ND(:,1)==inData.EL(i,5));
            node4 = find(inData.ND(:,1)==inData.EL(i,6));
            xi = 0; niu=0;
            N1 = 1/4*(1-xi)*(1-niu);
            N2 = 1/4*(1+xi)*(1-niu);
            N3 = 1/4*(1+xi)*(1+niu);
            N4 = 1/4*(1-xi)*(1+niu);
            Xi = [1; inData.ND(node1,2)*N1 + inData.ND(node2,2)*N2 + ...
                inData.ND(node3,2)*N3 + inData.ND(node4,2)*N4; ...
                inData.ND(node1,3)*N1 + inData.ND(node2,3)*N2 + ...
                inData.ND(node3,3)*N3 + inData.ND(node4,3)*N4];
        end;
        
        angle_max = 0.5*atan(2*(SIGsys(i*3))/(SIGsys(i*3-2)-SIGsys(i*3-1)));
        vv = (SIGsys(i*3-2)) - (SIGsys(i*3-1));
        yi = abs(cos(angle_max)*yy*laby);
        xi = abs(sin(angle_max)*yy*labx);
        angle_max  = angle_max*360/(2*pi);
        
        if vv>0 txy=xi*laby/labx; xi=yi*labx/laby; yi=txy; end;
        if MIN_SIG(i)>0  cv='b-'; cv='k-'; else cv='r-'; cv='k-'; end;
        
        txy=xi*laby/labx; xi=yi*labx/laby; yi=-txy;
%         
%         figure(NF); subplot(rp); hold on
%         if vv<0 & angle_max>0  plot3([Xi(2)-0.5*xi Xi(2)+0.5*xi],...
%                 [Xi(3)+0.5*yi Xi(3)-0.5*yi],[max(max(SIG_nd_min))+10 ...
%                 max(max(SIG_nd_min))+10],cv,'LineWidth',1);
%         end;
%         if vv<0 & angle_max<0  plot3([Xi(2)+0.5*xi Xi(2)-0.5*xi],...
%                 [Xi(3)+0.5*yi Xi(3)-0.5*yi],[max(max(SIG_nd_min))+10 ...
%                 max(max(SIG_nd_min))+10],cv,'LineWidth',1);
%         end;
%         
%         if vv>0 & angle_max>0  plot3([Xi(2)+0.5*xi Xi(2)-0.5*xi],...
%                 [Xi(3)+0.5*yi Xi(3)-0.5*yi],[max(max(SIG_nd_min))+10 ...
%                 max(max(SIG_nd_min))+10],cv,'LineWidth',1);
%         end;
%         if vv>0 & angle_max<0  plot3([Xi(2)-0.5*xi Xi(2)+0.5*xi],...
%                 [Xi(3)+0.5*yi Xi(3)-0.5*yi],[max(max(SIG_nd_min))+10 ...
%                 max(max(SIG_nd_min))+10],cv,'LineWidth',1);
%         end;
    end;
end;


%% %% DISPLACEMENT
figure(NF); hold off;
if NF>100
    max_D_x = max(abs(resp.static.D(1:2:dof(1))));
    max_D_y = max(abs(resp.static.D(2:2:dof(1))));
    
    ND_d = inData.ND;
    
    deN = max([max_D_x  max_D_y]);
    ND_d(:,2) = inData.ND(:,2)+(resp.static.D(1:2:dof(1))'./deN)*labx;
    ND_d(:,3) = inData.ND(:,3)+(resp.static.D(2:2:dof(1))'./deN)*laby;
    
    mxDISx = max(resp.static.D(1:2:dof(1)));
    mnDISx = min(resp.static.D(1:2:dof(1)));
    
    if abs(mxDISx)>abs(mnDISx) upDIS = mxDISx; else upDIS = mnDISx; end;
    
    mxDISy = max(resp.static.D(2:2:dof(1)));
    mnDISy = min(resp.static.D(2:2:dof(1)));
    
    if abs(mxDISy)>abs(mnDISy) lowDIS = mxDISy; else lowDIS = mnDISy; end;
    
    maxXd = max(ND_d(:,2)); minXd = min(ND_d(:,2));
    maxYd = max(ND_d(:,3)); minYd = min(ND_d(:,3));
    
    figure(NF+4); plot(ND_d(:,2),ND_d(:,3),'r.','MarkerSize',2);
    axis equal; axis off; hold on;
    set(NF+4,'name',['  Deformed shape. MAX(x) = '  num2str(upDIS) ...
        '   MAX(y) = ' num2str(lowDIS)], 'NumberTitle','off');
    
    
    
    for i=1:size(inData.EL)
        if inData.EL(i,2)==4
            node1 = find(ND_d(:,1)==inData.EL(i,3));
            node2 = find(ND_d(:,1)==inData.EL(i,4));
            node3 = find(ND_d(:,1)==inData.EL(i,5));
            plot([ND_d(node1,2) ND_d(node2,2) ND_d(node3,2) ND_d(node1,2)], ...
                [ND_d(node1,3) ND_d(node2,3) ND_d(node3,3) ND_d(node1,3)], ...
                'r-','LineWidth', 0.1);
        end;
        if inData.EL(i,2)==5 | inData.EL(i,2)==51
            node1 = find(inData.ND(:,1)==inData.EL(i,3));
            node2 = find(inData.ND(:,1)==inData.EL(i,4));
            node3 = find(inData.ND(:,1)==inData.EL(i,5));
            node4 = find(inData.ND(:,1)==inData.EL(i,6));
            plot([ND_d(node1,2) ND_d(node2,2) ND_d(node3,2) ND_d(node4,2) ...
                ND_d(node1,2)],[ND_d(node1,3) ND_d(node2,3) ND_d(node3,3) ...
                ND_d(node4,3) ND_d(node1,3)],'r-','LineWidth',0.1);
        end;
    end;
    
    %% CONSTRAINT
    
    for i=1:size(inData.CON)
        node_i = find(inData.ND(:,1)==inData.CON(i,1));
        if inData.CON(i,2)==0
            plot([inData.ND(node_i,2) inData.ND(node_i,2)-labx],...
                [inData.ND(node_i,3) inData.ND(node_i,3)], ...
                'b-','LineWidth',2);
            hold on;
        end;
        if inData.CON(i,3)==0
            plot([inData.ND(node_i,2) inData.ND(node_i,2)],...
                [inData.ND(node_i,3) inData.ND(node_i,3)-laby], ...
                'b-','LineWidth',2);
            hold on;
        end;
    end;
    
end
