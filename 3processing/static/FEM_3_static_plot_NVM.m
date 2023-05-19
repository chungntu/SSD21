%--------------------------------------------------------------------------
% PLOT NORMAL, SHEAR AND MOMENT DIAGRAMS
% Truong Thanh Chung. Aug 2021.
%--------------------------------------------------------------------------
function [Np,Vp,Mp] = FEM_3_static_plot_NVM(inData,resp,opt)
% CALCULATE N,V,M
xL  = (0:0.05:1)'; N  = length(xL);
Np  = zeros(N,size(inData.EL,1));
Vp  = zeros(N,size(inData.EL,1));
Mp  = zeros(N,size(inData.EL,1));
for ELEMENT = 1:size(inData.EL,1)
    [Np(:,ELEMENT),Vp(:,ELEMENT),Mp(:,ELEMENT)] = calculateNVM(inData,resp,xL,ELEMENT,opt);
end
if opt.writeCmd == 1
    write2fileNVM(Np,Vp,Mp)
end
if opt.staticShowFigNVM
    maxN = max(max(abs(Np)));
    maxV = max(max(abs(Vp)));
    maxM = max(max(abs(Mp)));
    Npn = Np/maxN;
    Vpn = Vp/maxV;
    Mpn = Mp/maxM;
    [lab,frame] = getScale(inData);
    show = 0.2;
    %% PLOT NORMAL FORCES
    nDiag = figure; hold on;
    set(nDiag,'name','LONGITUDINAL FORCES DIAGRAM');
    axis equal; axis off; axis(frame);
    for ELEMENT = 1:size(inData.EL,1)
        node1 = inData.EL(ELEMENT,3);
        node2 = inData.EL(ELEMENT,4);
        xNode1 = inData.ND(node1,2);  yNode1 = inData.ND(node1,3);
        xNode2 = inData.ND(node2,2);  yNode2 = inData.ND(node2,3);
        L = sqrt((xNode2-xNode1)^2 + (yNode2-yNode1)^2 ) ;
        cosa = (xNode2-xNode1) / L; sina = (yNode2-yNode1) / L;
        x = xL*L;
        T = [cosa,sina;-sina,cosa];
        coor_beam = [x,x.*0]*T; % transform horizontal beam to an inclined beam
        coor_beam_x = coor_beam(:,1); coor_beam_y = coor_beam(:,2);
        xn = [x,Npn(:,ELEMENT)*lab]*T;
        coor_n_x = xNode1+xn(:,1);
        coor_n_y = yNode1+xn(:,2);
        if Npn(1,ELEMENT)<0
            plot(coor_n_x,coor_n_y,'r-', 'Linewidth',2); hold on
        end
        if Npn(1,ELEMENT)>0
            plot(coor_n_x,coor_n_y,'b-', 'Linewidth',2); hold on
        end
        % DECORATION
        for jj = 1:length(x)
            plot([coor_n_x(jj);xNode1+coor_beam_x(jj)],...
                [coor_n_y(jj);yNode1+coor_beam_y(jj)],'k-'); hold on
        end
        % LABEL
        if opt.staticLabelNVM
            if  abs(Npn(1,ELEMENT)) > show
                gf = text(xNode1+xn(1,1),yNode1+xn(1,2)-lab/2,...
                    num2str(round((Np(1,ELEMENT)),2)));
                set_font(gf);
            end
        end
        % PLOT STRUCTURE
        plot(xNode1+coor_beam_x,yNode1+coor_beam_y,'k-','Linewidth',1); hold on
    end
    plotRestraint(inData,inData.ND,lab);
    if opt.staticScaleBar
        plotScaleBar(1/maxN,maxN,[0 -frame(4)/5]);
    end
    if opt.exportFig
        export_fig nDiag -transparent
    end
    hold off
    %% PLOT SHEAR FORCES
    vDiag = figure; hold on;
    set(vDiag,'name','SHEAR FORCES DIAGRAM');
    axis equal; axis off; axis(frame);
    for ELEMENT = 1:size(inData.EL,1)
        node1 = inData.EL(ELEMENT,3);
        node2 = inData.EL(ELEMENT,4);
        xNode1 = inData.ND(node1,2);  yNode1 = inData.ND(node1,3);
        xNode2 = inData.ND(node2,2);  yNode2 = inData.ND(node2,3);
        L = sqrt((xNode2-xNode1)^2 + (yNode2-yNode1)^2 ) ;
        cosa = (xNode2-xNode1) / L; sina = (yNode2-yNode1) / L;
        x = xL*L;
        T = [cosa,sina;-sina,cosa];
        coor_beam = [x,x.*0]*T; % transform horizontal beam to an inclined beam
        coor_beam_x = coor_beam(:,1); coor_beam_y = coor_beam(:,2);
        xv = [x,-Vpn(:,ELEMENT)*lab]*T;
        coor_v_x = xNode1+xv(:,1);
        coor_v_y = yNode1+xv(:,2);
        plot(coor_v_x,coor_v_y,'r-', 'Linewidth',2); hold on
        % DECORATION
        for jj = 1:length(x)
            plot([coor_v_x(jj);xNode1+coor_beam_x(jj)],...
                [coor_v_y(jj);yNode1+coor_beam_y(jj)],'k-'); hold on
        end
        % LABEL
        if opt.staticLabelNVM
            if  abs(Vpn(1,ELEMENT)) > show
                gf = text(xNode1+xv(1,1),yNode1+xv(1,2)-lab/2,...
                    num2str(round(abs(Vp(1,ELEMENT)),2)));
                set_font(gf);
            end
        end
        % PLOT STRUCTURE
        plot(xNode1+coor_beam_x,yNode1+coor_beam_y,'k-','Linewidth',1); hold on
    end
    plotRestraint(inData,inData.ND,lab);
    % PLOT SCALE BAR
    if opt.staticScaleBar
        plotScaleBar(1/maxV,maxV,[0 -frame(4)/5]);
    end
    if opt.exportFig
        export_fig vDiag -transparent
    end
    
    hold off
    %% PLOT MOMENT
    mDiag = figure; hold on;
    set(mDiag,'name','MOMENT DIAGRAM');
    axis equal; axis off; axis(frame);
    for ELEMENT = 1:size(inData.EL,1)
        node1 = inData.EL(ELEMENT,3);
        node2 = inData.EL(ELEMENT,4);
        xNode1 = inData.ND(node1,2);  yNode1 = inData.ND(node1,3);
        xNode2 = inData.ND(node2,2);  yNode2 = inData.ND(node2,3);
        L = sqrt((xNode2-xNode1)^2 + (yNode2-yNode1)^2 ) ;
        cosa = (xNode2-xNode1) / L; sina = (yNode2-yNode1) / L;
        x = xL*L;
        T = [cosa,sina;-sina,cosa];
        coor_beam = [x,x.*0]*T; % transform horizontal beam to an inclined beam
        coor_beam_x = coor_beam(:,1); coor_beam_y = coor_beam(:,2);
        xm = [x,-Mpn(:,ELEMENT)*lab]*T;
        coor_m_x = xNode1+xm(:,1);
        coor_m_y = yNode1+xm(:,2);
        plot(coor_m_x,coor_m_y,'r-', 'Linewidth',2); hold on
        % DECORATION
        for jj = 1:length(x)
            plot([coor_m_x(jj);xNode1+coor_beam_x(jj)],...
                [coor_m_y(jj);yNode1+coor_beam_y(jj)],'k-'); hold on
        end
        % LABEL
        if opt.staticLabelNVM
            if  abs(Mpn(1,ELEMENT)) > show
                gf = text(xNode1+xm(1,1),yNode1+xm(1,2)-lab/2,...
                    num2str(round(abs(Mp(1,ELEMENT)),2)));
                set_font(gf);
            end
            % CALCULATE MAXIMA MOMENT
            TF = islocalmax(Mpn(:,ELEMENT));
            k_max = find(TF);
            if ~isempty(k_max)
                if abs(Mpn(k_max,ELEMENT)) > show
                    gf = text(xNode1+xm(k_max,1)-lab,yNode1+xm(k_max,2)-lab/2,...
                        num2str(round(abs(Mp(k_max,ELEMENT)),2)));
                    set_font(gf);
                end
            end
            TF = islocalmin(Mpn(:,ELEMENT));
            k_min = find(TF);
            if ~isempty(k_min)
                if abs(Mpn(k_min,ELEMENT)) > show
                    gf = text(xNode1+xm(k_min,1)-lab,yNode1+xm(k_min,2)+lab/2,...
                        num2str(round(abs(Mp(k_min,ELEMENT)),2)));
                    set_font(gf);
                end
            end
        end
        % PLOT STRUCTURE
        plot(xNode1+coor_beam_x,yNode1+coor_beam_y,'k-','Linewidth',1); hold on
    end
    plotRestraint(inData,inData.ND,lab);
    % PLOT SCALE BAR
    if opt.staticScaleBar
        plotScaleBar(1/maxM,maxM,[0 -frame(4)/5]);
    end
    hold off
    if opt.exportFig
        export_fig mDiag -transparent
    end
    
end
end
function [Np,Vp,Mp] = calculateNVM(in_data,resp,xL,ELEMENT,opt)
N  = length(xL);
node1 = in_data.EL(ELEMENT,3);
node2 = in_data.EL(ELEMENT,4);
xNode1 = in_data.ND(node1,2);  yNode1 = in_data.ND(node1,3);
xNode2 = in_data.ND(node2,2);  yNode2 = in_data.ND(node2,3);
L = sqrt((xNode2-xNode1)^2 + (yNode2-yNode1)^2);
cosa = (xNode2-xNode1)/L; sina = (yNode2-yNode1)/L;
E = in_data.EL(ELEMENT,5); 
nu      = 0.3;
G       = E/(2*(1+nu));
ks      = 5/6;
A = in_data.EL(ELEMENT,6);
I = in_data.EL(ELEMENT,7); 
rho= in_data.EL(ELEMENT,8);
switch in_data.EL(ELEMENT,2)
    case {0}
        if opt.Timoshenko
            [~,~,Ke,T] = FEM_ELEMENT_2D_Timoshenko_FF_BEAM(in_data.ND(node1,2),in_data.ND(node1,3),...
                in_data.ND(node2,2), in_data.ND(node2,3),E,G,A,I,ks,rho);
        else
            [~,~,Ke,T] = FEM_ELEMENT_2D_FF_BEAM (in_data.ND(node1,2),in_data.ND(node1,3), ...
                in_data.ND(node2,2),in_data.ND(node2,3),E,A,I,rho);
        end
    case {1}
        [~,~,Ke,T] = FEM_ELEMENT_2D_FP_BEAM (in_data.ND(node1,2),in_data.ND(node1,3), ...
            in_data.ND(node2,2),in_data.ND(node2,3),E,A,I,rho);
    case {2}
        [~,~,Ke,T] = FEM_ELEMENT_2D_PF_BEAM (in_data.ND(node1,2),in_data.ND(node1,3), ...
            in_data.ND(node2,2),in_data.ND(node2,3),E,A,I,rho);
    case {333}
        [~,~,Ke,T] = FEM_ELEMENT_2D_PP_BEAM (in_data.ND(node1,2),in_data.ND(node1,3), ...
            in_data.ND(node2,2),in_data.ND(node2,3),E,A,I,rho);
end
g = [3*node1-2; 3*node1-1; 3*node1; 3*node2-2; 3*node2-1; 3*node2];
F_local = Ke*T*resp.static.D(g)';
Ne = [-F_local(1);F_local(4)]';
Ve = [-F_local(2);F_local(5)]';
Me = [-F_local(3);F_local(6)]';
qz_local = -in_data.qz(ELEMENT)*(cosa)+in_data.qx(ELEMENT)*(sina);
qx_local = -in_data.qz(ELEMENT)*(sina)+in_data.qx(ELEMENT)*(cosa);
Np = Ne(1) + (0:N-1)'*(Ne(2)-Ne(1))/(N-1) - L*qx_local/2 + xL*L*qx_local;
Vp = Ve(1) + (0:N-1)'*(Ve(2)-Ve(1))/(N-1) - L*qz_local/2 + xL*L*qz_local;
switch in_data.EL(ELEMENT,2)
    case {0}
        Mp = Me(1) + (0:N-1)'*(Me(2)-Me(1))/(N-1)...
            - ( qz_local*L^2/12 -  qz_local*L/2*(xL*L)  + qz_local*(xL*L).^2/2);
    case{1}
        Mp = Me(1) + (0:N-1)'*(Me(2)-Me(1))/(N-1)...
            - (qz_local*L^2/8 - 5*qz_local*L/8*(xL*L) + qz_local*(xL*L).^2/2);
    case {2}
        Mp = Me(1) + (0:N-1)'*(Me(2)-Me(1))/(N-1)...
            - (-3*qz_local*L/8*(xL*L) + qz_local*(xL*L).^2/2);
    case {333}
        Mp = -(-qz_local*L/2*(xL*L) + qz_local*(xL*L).^2/2);
end
end
function write2fileNVM(Np,Vp,Mp)
% PRINT RESULTS
% Longitudinal Forces
fprintf('\n');
fprintf('LONGITUDINAL FORCES [START NODE;MIDDLE NODE;END NODE]\n');
Np_ = [Np(1,:);Np(11,:);Np(end,:)];
for i=1:size(Np_,1)
    for j = 1:size(Np_,2)
        fprintf('% 5.3f   ',Np_(i,j));
    end
    fprintf('\n');
end
% Shear Forces
fprintf('SHEAR FORCES [START NODE;MIDDLE NODE;END NODE]\n');
Vp_ = [Vp(1,:);Vp(11,:);Vp(end,:)];
for i=1:size(Vp_,1)
    for j = 1:size(Vp_,2)
        fprintf('% 5.3f   ',Vp_(i,j));
    end
    fprintf('\n');
end
% Moment
fprintf('MOMENT [START NODE;MIDDLE NODE;END NODE]\n');
Mp_ = [Mp(1,:);Mp(11,:);Mp(end,:)];
for i=1:size(Mp_,1)
    for j = 1:size(Mp_,2)
        fprintf('% 5.3f   ',Mp_(i,j));
    end
    fprintf('\n');
end
% WRITE TO FILE
fid = fopen('Static Analysis Results.txt','a+');
% Longitudinal Forces
fprintf(fid,'\n');
fprintf(fid,'LONGITUDINAL FORCES [START NODE;MIDDLE NODE;END NODE]\n');
Np_ = [Np(1,:);Np(11,:);Np(end,:)];
for i=1:size(Np_,1)
    for j = 1:size(Np_,2); fprintf(fid,'% 5.3f   ',Np_(i,j)); end
    fprintf(fid,'\n');
end
% Shear Forces
fprintf(fid,'SHEAR FORCES [START NODE;MIDDLE NODE;END NODE]\n');
Vp_ = [Vp(1,:);Vp(11,:);Vp(end,:)];
for i=1:size(Vp_,1)
    for j = 1:size(Vp_,2); fprintf(fid,'% 5.3f   ',Vp_(i,j)); end
    fprintf(fid,'\n');
end
% Moment
fprintf(fid,'MOMENT [START NODE;MIDDLE NODE;END NODE]\n');
Mp_ = [Mp(1,:);Mp(11,:);Mp(end,:)];
for i=1:size(Mp_,1)
    for j = 1:size(Mp_,2); fprintf(fid,'% 5.3f   ',Mp_(i,j)); end
    fprintf(fid,'\n');
end
end
function set_font (gf)
set(gf,'FontSize',10,'Color','b');
end
