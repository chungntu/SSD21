function tri = FEM_3_surfTet(pt,T)

% -------------------------------------------------------------------------
Face  = [T(:,[1,2,3]);
         T(:,[1,2,4]);
         T(:,[1,3,4]);
         T(:,[2,3,4])];

nd4 = [T(:,4);T(:,3);T(:,2);T(:,1)];

Face = sort(Face,2);
[foo,ix,jx] = unique(Face,'rows');
vec = histc(jx, 1:max(jx));
qx  = find(vec==1);
tri = Face(ix(qx),:);
nd4 = nd4(ix(qx));

V1 = pt(tri(:,2),:)-pt(tri(:,1),:);
V2 = pt(tri(:,3),:)-pt(tri(:,1),:);
V3 = pt(nd4,:)-pt(tri(:,1),:);
ix = find(dot(cross(V1,V2,2),V3,2)>0);

tri(ix,[2,3]) = tri(ix,[3,2]);
