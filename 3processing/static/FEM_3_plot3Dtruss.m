function FEM_3_plot3Dtruss(in_data,resp)
[lab,frame] = getScale(in_data);
dof = size(in_data.ND,1)*3;
deN = max([max(resp.static.D(1:3:dof(1))), max(resp.static.D(2:3:dof(1))),max(resp.static.D(3:3:dof(1))) ]);
dx = resp.static.D(1:3:dof(1)) ;
dy = resp.static.D(2:3:dof(1)) ;
dz = resp.static.D(3:3:dof(1)) ;
ND_d_real = in_data.ND;
ND_d_real(:,2) = in_data.ND(:,2) + dx';
ND_d_real(:,3) = in_data.ND(:,3) + dy';
ND_d_real(:,4) = in_data.ND(:,4) + dz';
ND_d_plot = in_data.ND;
ND_d_plot(:,2) = in_data.ND(:,2)+dx'/deN*lab/5;
ND_d_plot(:,3) = in_data.ND(:,3)+dy'/deN*lab/5;
ND_d_plot(:,4) = in_data.ND(:,4)+dz'/deN*lab/5;
% STRESS
for i=1:size(in_data.EL)
    node1 = find(ND_d_real(:,1)==in_data.EL(i,3));
    node2 = find(ND_d_real(:,1)==in_data.EL(i,4));
    L_0 = sqrt((in_data.ND(node2,2)-in_data.ND(node1,2))^2 + ...
        (in_data.ND(node2,3)-in_data.ND(node1,3))^2 + ...
        (in_data.ND(node2,4)-in_data.ND(node1,4))^2);
    L_1 = sqrt((ND_d_real(node2,2)-ND_d_real(node1,2))^2 + ...
        (ND_d_real(node2,3)-ND_d_real(node1,3))^2 + ...
        (ND_d_real(node2,4)-ND_d_real(node1,4))^2);
    dL = L_1-L_0;
    E = in_data.EL(i,5);
    stress(i,:) = [i E*dL/L_0];
end
%% PLOT ELEMENTS
figure(3000);
axis equal; axis off; hold on; view(3);
title('Biểu đồ biến dạng - ứng suất do lực dọc (đỏ - kéo, xanh - nén)');
for i=1:size(in_data.EL)
    node1 = find(in_data.ND(:,1)==in_data.EL(i,3));
    node2 = find(in_data.ND(:,1)==in_data.EL(i,4));
    plot3([in_data.ND(node1,2) in_data.ND(node2,2)], ...
        [in_data.ND(node1,3) in_data.ND(node2,3)],[in_data.ND(node1,4) ...
        in_data.ND(node2,4)],'k:','LineWidth',1);
end
for i=1:size(in_data.EL)
    node1 = find(ND_d_real(:,1)==in_data.EL(i,3));
    node2 = find(ND_d_real(:,1)==in_data.EL(i,4));
    if stress(i,2)>0
        plot3([ND_d_plot(node1,2) ND_d_plot(node2,2)], ...
            [ND_d_plot(node1,3) ND_d_plot(node2,3)], ...
            [ND_d_plot(node1,4) ND_d_plot(node2,4)],'r', 'LineWidth',1);
    end
    if stress(i,2)<0
        plot3([ND_d_plot(node1,2) ND_d_plot(node2,2)], ...
            [ND_d_plot(node1,3) ND_d_plot(node2,3)], ...
            [ND_d_plot(node1,4) ND_d_plot(node2,4)],'b', 'LineWidth',1);
    end
    if stress(i,2)==0
        plot3([ND_d_plot(node1,2) ND_d_plot(node2,2)], ...
            [ND_d_plot(node1,3) ND_d_plot(node2,3)], ...
            [ND_d_plot(node1,4) ND_d_plot(node2,4)], ...
            'k','LineWidth',1);
    end
end
save FEM_STATIC_TRUSS_stress.txt stress -ascii;
disp(['Lưu ứng suất lực dọc của dàn không gian']);
%% CONSTRAINT
plotRestraint(in_data,in_data.ND,lab); hold off
axis(frame);
rotate3d(gca); set(gcf,'Pointer','arrow');
hold off;
