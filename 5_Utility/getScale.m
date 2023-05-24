%--------------------------------------------------------------------------
% GET VALUE TO PLOT ARROWS, AND GET FRAME OF FIGURES
% Truong Thanh Chung. Aug 2021.
%--------------------------------------------------------------------------
function [lab,frame] = getScale(in_data)
[dofN,EL_TYPE,ndPerElem] = elemType (in_data);
switch EL_TYPE
    case {0,1,2,333} % 2D Frame
        maxX = max(in_data.ND(:,2)); minX = min(in_data.ND(:,2));
        maxY = max(in_data.ND(:,3)); minY = min(in_data.ND(:,3));
        
        zoom = 1.5;

        lab = max(abs(zoom*[maxX/12, maxY/12,minX/12,minY/12]));
        frame = [(minX-2.5*lab) (maxX+2.5*lab) (minY-2.5*lab) (maxY+2.5*lab)];
    case {3,31} % 3D Frame/Truss
        maxX = max(in_data.ND(:,2)); minX = min(in_data.ND(:,2));
        maxY = max(in_data.ND(:,3)); minY = min(in_data.ND(:,3));
        maxZ = max(in_data.ND(:,4)); minZ = min(in_data.ND(:,4));
        lab = max(abs([maxX/6,maxY/6,maxZ/6,minX/6,minY/6,minZ/6]));
        frame = [(minX-2.5*lab) (maxX+2.5*lab) (minY-2.5*lab) (maxY+2.5*lab) (minZ-2.5*lab) (maxZ+2.5*lab)];
end
