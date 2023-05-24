%--------------------------------------------------------------------------
% PLOT LUMP MASS
% Truong Thanh Chung. Aug 2021.
%--------------------------------------------------------------------------
function plotMovingLumpMass(in_data,ND_d,lab)
sizeMASS = 50;
maxMASS = max(max(in_data.MASS(:,2:end)));
MASS = in_data.MASS(:,2:end)/maxMASS;
for i=1:size(in_data.MASS)
    NODE = find(in_data.ND(:,1)==in_data.MASS(i,1));
    epxilon = 1E-5;
    if  isfield(in_data,'MASS')
        % X-DIRECTION MASS
        if in_data.MASS(i,2)>epxilon
            plotSizeMASS = sizeMASS*MASS(i,1)^(1/3);
            quiver(ND_d(NODE,2),ND_d(NODE,3),lab,0,...
                'Linewidth',2,'MaxHeadSize',1,'Color','r'); hold on;
            hold on;
            plot(ND_d(NODE,2),ND_d(NODE,3),'.r',...
                'MarkerSize',plotSizeMASS)
            gf = text(ND_d(NODE,2)+lab,ND_d(NODE,3),...
                num2str(in_data.MASS(i,2))); set_font(gf);
        end
        % Y-DIRECTION MASS
        if in_data.MASS(i,3)>epxilon
            plotSizeMASS = sizeMASS*MASS(i,2)^(1/3);
            quiver(ND_d(NODE,2),ND_d(NODE,3),0,lab,...
                'Linewidth',2,'MaxHeadSize',1,'Color','r'); hold on;
            hold on;
            plot(ND_d(NODE,2),ND_d(NODE,3),'.r',...
                'MarkerSize',plotSizeMASS)
            gf = text(ND_d(NODE,2)-lab/2,ND_d(NODE,3)+1.2*lab,...
                num2str(in_data.MASS(i,3))); set_font(gf);
        end
    end
end
end

function set_font (gf)
set(gf,'FontSize',10,'Color','k');
end
