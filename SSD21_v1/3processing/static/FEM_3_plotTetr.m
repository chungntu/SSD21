function FEM_3_plotTetr( in_data, resp, dof_, SIG_main) 

% -------------------------------------------------------------------------

plot_loads_yn = 0;
plot_constr_yn = 0;

NF =215;
figure(NF);
axis equal; axis off; hold on; view(3);
title('Displacements from static loads');
warning off

maxX = max(in_data.ND(:,2));   minX = min(in_data.ND(:,2));
maxY = max(in_data.ND(:,3));   minY = min(in_data.ND(:,3));
maxZ = max(in_data.ND(:,4));   minZ = min(in_data.ND(:,4));
labx = (maxX / 5); laby = (maxY / 5); labz = (maxZ / 5);
labx = min([labx laby labz]); laby = labx;  labz=labx;

deN = max([max(abs(resp.static.D(1:3:dof_(1)))) ...
      max(abs(resp.static.D(2:3:dof_(1)))) ...
      max(abs(resp.static.D(3:3:dof_(1))))]);
dx = labx *resp.static.D(1:3:dof_(1)) /deN;
dy = laby *resp.static.D(2:3:dof_(1)) /deN;
dz = labz *resp.static.D(3:3:dof_(1)) /deN;

ND_d = in_data.ND;
ND_d(:,2) = in_data.ND(:,2)+dx';
ND_d(:,3) = in_data.ND(:,3)+dy';
ND_d(:,4) = in_data.ND(:,4)+dz';

v = [.8 .8 .8];

tri2 = FEM_3_surfTet(in_data.ND(:,2:4),in_data.EL(:,3:6));
tot_d = sqrt( ND_d(:,2).^2 + ND_d(:,3).^2 +  ND_d(:,4).^2 );
tot_d = tot_d./max(tot_d);
trimesh(tri2,ND_d(:,2),ND_d(:,3),ND_d(:,4),'CData',[tot_d'], ...
        'facecolor','interp','edgecolor','k');
hold on;
trimesh(tri2,in_data.ND(:,2),in_data.ND(:,3),in_data.ND(:,4), ...
       'facecolor','none','edgecolor','k');
    

hold on; material dull; view(3); colormap(hsv);
set(NF,'name',['  Deformed shape. MAX(x) = '  num2str(max(ND_d(:,2))) ...
      '   MAX(y) = ' num2str(max(ND_d(:,3))) ...
      '  MAX(z) = ' num2str(max(ND_d(:,4)))],'NumberTitle','off');


SIGvonMises = zeros(length(SIG_main),1);
for i=1:length(SIG_main)
    SIGvonMises(i) = sqrt(0.5*((SIG_main(i,1)-SIG_main(i,2))^2 + ...
        (SIG_main(i,2)-SIG_main(i,3))^2 + (SIG_main(i,1)-SIG_main(i,3)) ));
end

figure(NF+1);
axis equal; axis off; hold on; view(3);
title('Stress field');

if 1
    qu = tri2;
    trimesh(qu,ND_d(:,2),ND_d(:,3),ND_d(:,4),'CData',[SIGvonMises'], ...
        'facecolor','interp','edgecolor','k');
    axis equal; axis off;
end

if plot_loads_yn
for i=1:size(in_data.LOAD_)
   node_i = find(in_data.ND(:,1)==in_data.LOAD_(i,1));
   if in_data.LOAD_(i,2)~=0 & in_data.LOAD_(i,2)>0
      plot3([in_data.ND(node_i,2) in_data.ND(node_i,2)+labx], ...
          [in_data.ND(node_i,3) in_data.ND(node_i,3)],...
          [in_data.ND(node_i,4) in_data.ND(node_i,4)],'r-','LineWidth',4);
      hold on;
   end;
   if in_data.LOAD_(i,2)~=0 & in_data.LOAD_(i,2)<0
      plot3([in_data.ND(node_i,2) in_data.ND(node_i,2)-labx], ...
          [in_data.ND(node_i,3) in_data.ND(node_i,3)],...
          [in_data.ND(node_i,4) in_data.ND(node_i,4)],'r-','LineWidth',4);
      hold on;
   end;
   if in_data.LOAD_(i,3)~=0 & in_data.LOAD_(i,3)>0
      plot3([in_data.ND(node_i,2) in_data.ND(node_i,2)], ...
          [in_data.ND(node_i,3) in_data.ND(node_i,3)+laby],...
          [in_data.ND(node_i,4) in_data.ND(node_i,4)],'r-','LineWidth',4);
      hold on;
   end;
   if in_data.LOAD_(i,3)~=0 & in_data.LOAD_(i,3)<0
      plot3([in_data.ND(node_i,2) in_data.ND(node_i,2)], ...
          [in_data.ND(node_i,3) in_data.ND(node_i,3)-laby],...
          [in_data.ND(node_i,4) in_data.ND(node_i,4)],'r-','LineWidth',4);
      hold on;
   end;
   if in_data.LOAD_(i,4)~=0 & in_data.LOAD_(i,4)>0
      plot3([in_data.ND(node_i,2) in_data.ND(node_i,2)], ...
          [in_data.ND(node_i,3) in_data.ND(node_i,3)],...
          [in_data.ND(node_i,4) in_data.ND(node_i,4)+labz], ...
          'r-','LineWidth',4);
      hold on;
   end;
   if in_data.LOAD_(i,4)~=0 & in_data.LOAD_(i,4)<0
      plot3([in_data.ND(node_i,2) in_data.ND(node_i,2)], ...
          [in_data.ND(node_i,3) in_data.ND(node_i,3)],...
          [in_data.ND(node_i,4) in_data.ND(node_i,4)-labz], ...
          'r-','LineWidth',4);
      hold on;
   end;
end;
end

if plot_constr_yn
    labx = (maxX / 7); laby = (maxY / 7); labz = (maxZ / 7);
    labx = min([labx laby labz]); laby = labx;  labz=labx;
    
    for i=1:size(in_data.CON)
        node_i = find(in_data.ND(:,1)==in_data.CON(i,1));
        if in_data.CON(i,2)==0
            plot3([in_data.ND(node_i,2) in_data.ND(node_i,2)-labx], ...
                [in_data.ND(node_i,3) in_data.ND(node_i,3)],...
                [in_data.ND(node_i,4) in_data.ND(node_i,4)], ...
                'r-','LineWidth',2);
            hold on;
        end;
        if in_data.CON(i,3)==0
            plot3([in_data.ND(node_i,2) in_data.ND(node_i,2)], ...
                [in_data.ND(node_i,3) in_data.ND(node_i,3)-laby],...
                [in_data.ND(node_i,4) in_data.ND(node_i,4)], ...
                'r-','LineWidth',2);
            hold on;
        end;
        if in_data.CON(i,4)==0
            plot3([in_data.ND(node_i,2) in_data.ND(node_i,2)], ...
                [in_data.ND(node_i,3) in_data.ND(node_i,3)], ...
                [in_data.ND(node_i,4) in_data.ND(node_i,4)-labz], ...
                'r-','LineWidth',2);
            hold on;
        end;
        if in_data.CON(i,4)==0 | in_data.CON(i,5)==0 | in_data.CON(i,6)==0
            plot3([in_data.ND(node_i,2) in_data.ND(node_i,2)], ...
                [in_data.ND(node_i,3) in_data.ND(node_i,3)], ...
                [in_data.ND(node_i,4) in_data.ND(node_i,4)], ...
                'rs','LineWidth',2);
            hold on;
        end;
    end;
end

axis([(minX-labx) (maxX+labx) (minY-laby) (maxY+laby) ...
      (minZ-labz) (maxZ+labz)]);
rotate3d(gca); set(gcf,'Pointer','arrow');
warning on
