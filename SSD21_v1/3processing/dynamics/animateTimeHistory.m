% -------------------------------------------------------------------------
% ANIMATE TIME HISTORY ANALYSIS
% Truong Thanh Chung. Aug 2021.
% -------------------------------------------------------------------------
function animateTimeHistory(in_data,obj,x,t)
deltaT = t(2) - t(1); 
dof = size(obj.Mgl,1);
[lab,frame] = getScale(in_data);
deN = 2*max(max(x));
D = zeros(dof,size(x,2));
epxilon =1E-5; jj= 1;
for ii=1:size(in_data.MASS,1)
    if in_data.MASS(ii,2)>epxilon
        D(3*ii-2,:) = x(jj,:); jj = jj+1;
    end
    if in_data.MASS(ii,3)>epxilon
        D(3*ii-1,:) = x(jj,:); jj = jj+1;
    end
    if in_data.MASS(ii,4)>epxilon
        D(3*ii,:) = x(jj,:); jj = jj+1;
    end
end

h = figure();
axis equal; axis off; axis(frame); hold on;
for ii = 1:10:size(x,2)
    if ishandle(h)
        plotTimeHistory2(in_data,lab,(D(:,ii))',deN,frame,dof)
        text(0.2,0.2,['t = ' num2str((ii-1)*deltaT),' s']);
        pause(0.2)
        drawnow; hold off
    else
        break
    end
end
