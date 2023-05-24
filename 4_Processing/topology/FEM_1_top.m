%--------------------------------------------------------------------------
% TOPOLOGY OPTIMIZATION
% Truong Thanh Chung. Aprial 2023.
%--------------------------------------------------------------------------
function xflip = FEM_1_top(inData,opt)
volfrac = opt.top.volfrac;
penal = 3;
rmin = 1.5;
nel = size(inData.EL,1);
lx = max(inData.ND(:,2)) - min(inData.ND(:,2));
ly = max(inData.ND(:,3)) - min(inData.ND(:,3));
if inData.EL(1,14)-inData.EL(2,14) ~=0
    nelx = lx/abs((inData.EL(1,14)-inData.EL(2,14)));
    nely = nel/nelx;
    labelDir = 'horzontal';
else
    nely = ly/abs((inData.EL(1,15)-inData.EL(2,15)));
    nelx = nel/nely;
    labelDir = 'vertical';
end
%--------------------------------------------------------------------------
% EXAMPLE DEFINE PASSIVE AREA
% for ely = 1:nely
%     for elx = 1:nelx
%         if sqrt((ely-nely/2.)^2+(elx-nelx/3.)^2) <  nely/3
%             passive(ely,elx) = 1;
%         else
%             passive(ely,elx) = 0;
%         end
%     end
% end
%--------------------------------------------------------------------------
x(1:nel) = volfrac;
loop = 0;
change = 1.;
% START ITERATION
figure; hold on
while change > opt.top.change
    loop = loop + 1;
    xold = x;
    %FE-ANALYSIS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    inData.EL(:,7) = reshape(x,numel(x),1).^penal;           % UPDATE ELASTIC MODULUS
    model = FEM_0_assemble(inData,opt);
    [D,~,~] = FEM_1_static(inData,model,opt);
    U = D.static.D;
    U = U';
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % OBJECTIVE FUNCTION AND SENSITIVITY ANALYSIS
    [KE] = lk;
    c = 0;
    for i=1:nel
        node = inData.EL(i,3:6);
        Ue = U([2*node(1)-1,2*node(1),2*node(2)-1,2*node(2),2*node(3)-1,2*node(3),2*node(4)-1,2*node(4)],1);
        c = c + x(i)^penal*Ue'*KE*Ue;
        dc(i) = -penal*x(i)^(penal-1)*Ue'*KE*Ue;
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % FILTERING OF SENSITIVITIES
    coordsArea = inData.EL(:,[14,15]);
    % Select a point to find its neighbors
    for i = 1:nel
        % Calculate the distance between the selected point and all other points
        distances = sqrt(sum(bsxfun(@minus, coordsArea(i,:), coordsArea).^2, 2));
        % Find the indices of all points within rmin
        neigh_indices = find(distances < rmin);
        fac = rmin - distances(distances < rmin);
        sum2 = sum(fac);
        dc(i) = sum(fac'.*x(neigh_indices).*dc(neigh_indices))/(x(i)*sum2);
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % DESIGN UPDATE BY THE OPTIMALITY CRITERIA METHOD
    if exist('passive', 'var')
        x = OC_new_pasive(nel,x,volfrac,dc,labelDir,nelx,nely,passive);
    else
        x = OC_new(nel,x,volfrac,dc);
    end
    % PLOT
    change = max(max(abs(x-xold)));
    if isequal(labelDir, 'vertical')
        xflip =  reshape(x,nely,nelx);
    else
        xflip =  rot90(reshape(x,nelx,nely));
    end
    colormap(gray); imagesc(-xflip); axis equal; axis tight; axis off;pause(1e-6);
end
