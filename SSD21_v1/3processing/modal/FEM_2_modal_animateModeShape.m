% -------------------------------------------------------------------------
% MODAL ANALYSIS
% Truong Thanh Chung. Aug 2021.
% -------------------------------------------------------------------------
function FEM_2_modal_animateModeShape(in_data,model,L,E_Vec,wn,showMode,opt)
D       = zeros(length(model.Mgl),1);
D(L,:)  = E_Vec(:, size(E_Vec,2)-showMode+1);
D       = D';                                       % mode shape vector
w       = wn(size(E_Vec,2)-showMode+1);             % frequecy (rad/s)
dof     = size(model.Mgl,1);                        % number of mass
[lab,frame] = getScale(in_data);
max_D_x     = max(abs(D(1:3:dof)));
max_D_y     = max(abs(D(2:3:dof)));
deN         = max([max_D_x, max_D_y]);
% PLOT MODE SHAPE
h = figure(); hold on;
set(h,'name',['MODE SHAPE ', num2str(showMode), ': T =  ',num2str(2*pi/w) ' [s]']);
axis equal; axis off; axis(frame);
delta = 0.5;
if opt.anim % DO ANIMATION
    for scl = repmat([-1:delta:1,1-delta:-delta:-1],1,2)
        if ishandle(h)
            FEM_2_modal_modeShape(in_data,lab,D,deN,frame,dof,scl)
            drawnow
            hold off
        else
            break
        end
    end
else % JUST SHOW THE STATIC MODE SHAPE
    FEM_2_modal_modeShape(in_data,lab,D,deN,frame,dof,1)
end
