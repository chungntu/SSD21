%--------------------------------------------------------------------------
% STATIC ANALYSIS FOR 3D FRAME
% Truong Thanh Chung. Aug 2021.
%--------------------------------------------------------------------------
function FEM_3_plot3Dbeam(in_data,resp)
figure(2); axis equal; axis off; hold on; view(3);
title('Biến dạng kết cấu');
for i=1:size(in_data.EL)
   node1 = find(in_data.ND(:,1)==in_data.EL(i,3));
   node2 = find(in_data.ND(:,1)==in_data.EL(i,4));
   plot3([in_data.ND(node1,2) in_data.ND(node2,2)], ...
      [in_data.ND(node1,3) in_data.ND(node2,3)],[in_data.ND(node1,4) ...
      in_data.ND(node2,4)],'k:','LineWidth',1);
end
[lab,frame] = getScale(in_data);
dof = size(in_data.ND,1)*6;
deN = max([max(resp.static.D(1:6:dof(1))) max(resp.static.D(2:6:dof(1))) ...
      max(resp.static.D(3:6:dof(1))) ]);
dx = resp.static.D(1:6:dof(1)) ;
dy = resp.static.D(2:6:dof(1));
dz = resp.static.D(3:6:dof(1));
ND_d_plot = in_data.ND;
ND_d_plot(:,2) = in_data.ND(:,2)+ dx'*lab/deN;
ND_d_plot(:,3) = in_data.ND(:,3)+ dy'*lab/deN;
ND_d_plot(:,4) = in_data.ND(:,4)+ dz'*lab/deN;
for i=1:size(in_data.EL)
   node1 = find(ND_d_plot(:,1)==in_data.EL(i,3));
   node2 = find(ND_d_plot(:,1)==in_data.EL(i,4));
   plot3([ND_d_plot(node1,2) ND_d_plot(node2,2)], [ND_d_plot(node1,3) ND_d_plot(node2,3)], ... 
      [ND_d_plot(node1,4) ND_d_plot(node2,4)],'b-','LineWidth',2);
end
plotRestraint(in_data,in_data.ND,lab); hold off
rotate3d(gca); set(gcf,'Pointer','arrow');
axis(frame)
hold off;
