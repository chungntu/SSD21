function FEM_3_plotBRICK( in_data, resp, dof_, SIG_main) 

% -------------------------------------------------------------------------

NF = 2;
figure(NF);
axis equal; axis off; hold on; view(3);
title('Displacements from static loads');
warning off

maxX = max(in_data.ND(:,2));   minX = min(in_data.ND(:,2));
maxY = max(in_data.ND(:,3));   minY = min(in_data.ND(:,3));
maxZ = max(in_data.ND(:,4));   minZ = min(in_data.ND(:,4));
labx = (maxX / 11); laby = (maxY / 11); labz = (maxZ / 11);
labx = max([labx laby labz]); laby = labx;  labz=labx;

deN = max([max(abs(resp.static.D(1:3:dof_(1)))) ...
      max(abs(resp.static.D(2:3:dof_(1)))) ...
      max(abs(resp.static.D(3:3:dof_(1))))]);
dx = labx *resp.static.D(1:3:dof_(1))./deN;
dy = laby *resp.static.D(2:3:dof_(1))./deN;
dz = labz *resp.static.D(3:3:dof_(1))./deN;

ND_d = in_data.ND;
ND_d(:,2) = in_data.ND(:,2)+dx';
ND_d(:,3) = in_data.ND(:,3)+dy';
ND_d(:,4) = in_data.ND(:,4)+dz';

if 1
    [qu] = FEM_3_surfBrick(in_data.ND(:,2:end),in_data.EL(:,3:10));
    ndPlot = unique(qu);
    tot_d = sqrt( (resp.static.D(1:3:dof_(1))).^2 + ...
       (resp.static.D(2:3:dof_(1))).^2 + (resp.static.D(3:3:dof_(1))).^2 );
    plot3(ND_d(ndPlot,2),ND_d(ndPlot,3),ND_d(ndPlot,4),'b.'); hold on;
    for i=1:size(qu,1)
        patch([ND_d(qu(i,1),2) ND_d(qu(i,2),2) ND_d(qu(i,3),2) ...
               ND_d(qu(i,4),2)], ...
              [ND_d(qu(i,1),3) ND_d(qu(i,2),3) ND_d(qu(i,3),3) ...
               ND_d(qu(i,4),3)], ...
              [ND_d(qu(i,1),4) ND_d(qu(i,2),4) ND_d(qu(i,3),4) ...
               ND_d(qu(i,4),4)], ...
               [tot_d(qu(i,1)) tot_d(qu(i,2)) tot_d(qu(i,3)) ...
               tot_d(qu(i,4))]);
    end
    axis equal; axis off;
end

hold on; material dull; view(3); colormap(hsv);
       camlight; lighting gouraud; % shading interp;
set(NF,'name',['  Deformed shape. MAX(x) = '  num2str(max(ND_d(:,2))) ...
      '   MAX(y) = ' num2str(max(ND_d(:,3))) '   MAX(z) = ' ...
      num2str(max(ND_d(:,4)))],'NumberTitle','off');
rotate3d(gca); set(gcf,'Pointer','arrow');

SIGvonMises = zeros(length(SIG_main),1);
for i=1:length(SIG_main)
    SIGvonMises(i) = sqrt(0.5*((SIG_main(i,1)-SIG_main(i,2))^2 + ...
        (SIG_main(i,2)-SIG_main(i,3))^2 + (SIG_main(i,1)-SIG_main(i,3)) ));
end

figure(NF+1);
axis equal; axis off; hold on; view(3);
title('Stress field');
KL = size(in_data.EL,1);
com = 2;
ts = 3;

if 1
    for i=1:size(qu,1)
        patch([ND_d(qu(i,1),2) ND_d(qu(i,2),2) ND_d(qu(i,3),2) ...
               ND_d(qu(i,4),2)], ...
              [ND_d(qu(i,1),3) ND_d(qu(i,2),3) ND_d(qu(i,3),3) ...
               ND_d(qu(i,4),3)], ...
              [ND_d(qu(i,1),4) ND_d(qu(i,2),4) ND_d(qu(i,3),4) ...
               ND_d(qu(i,4),4)], ...
              [SIGvonMises(qu(i,1)) SIGvonMises(qu(i,2)) ...
               SIGvonMises(qu(i,3)) SIGvonMises(qu(i,4))]);
    end
    axis equal; axis off;
end

hold on; material dull; view(3); colormap(hsv);
[Smax,i] = max(SIG_main(:,1)); [Smin,k] = min(SIG_main(:,1));
set(NF+1,'name',['  Max - node ' num2str(i) ': '  num2str(Smax) ...
      '/' num2str(max(SIG_main(i,2))) '/' ...
      num2str(max(SIG_main(i,3))) '. Min - node '...
      num2str(k) ': ' num2str(Smin) '/' num2str(max(SIG_main(k,2))) '/' ...
      num2str(max(SIG_main(k,3)))],'NumberTitle','off');
colorbar('vert');


maxX = max(in_data.ND(:,2));   minX = min(in_data.ND(:,2));
maxY = max(in_data.ND(:,3));   minY = min(in_data.ND(:,3));
maxZ = max(in_data.ND(:,4));   minZ = min(in_data.ND(:,4));
labx = (maxX / 11); laby = (maxY / 11); labz = (maxZ / 11);
labx = min([labx laby labz]); laby = labx;  labz=labx;

for i=1:size(in_data.CON)
   node_i = find(in_data.ND(:,1)==in_data.CON(i,1));
   if in_data.CON(i,2)==0
      plot3([in_data.ND(node_i,2) in_data.ND(node_i,2)-labx], ...
          [in_data.ND(node_i,3) in_data.ND(node_i,3)],...
          [in_data.ND(node_i,4) in_data.ND(node_i,4)],'k-','LineWidth',2);
          hold on;
   end;
   if in_data.CON(i,3)==0
      plot3([in_data.ND(node_i,2) in_data.ND(node_i,2)], ...
          [in_data.ND(node_i,3) in_data.ND(node_i,3)-laby],...
          [in_data.ND(node_i,4) in_data.ND(node_i,4)],'k-','LineWidth',2);
          hold on;
   end;
   if in_data.CON(i,4)==0
      plot3([in_data.ND(node_i,2) in_data.ND(node_i,2)], ...
          [in_data.ND(node_i,3) in_data.ND(node_i,3)], ...
          [in_data.ND(node_i,4) in_data.ND(node_i,4)-labz], ...
          'k-','LineWidth',2); hold on;
   end;
   if in_data.CON(i,4)==0 | in_data.CON(i,5)==0 | in_data.CON(i,6)==0
      plot3([in_data.ND(node_i,2) in_data.ND(node_i,2)], ...
          [in_data.ND(node_i,3) in_data.ND(node_i,3)],...
          [in_data.ND(node_i,4) in_data.ND(node_i,4)],'ks','LineWidth',2);
          hold on;
   end;
end;

rotate3d(gca); set(gcf,'Pointer','arrow');
warning on
