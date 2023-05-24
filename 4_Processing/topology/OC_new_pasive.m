%%%%%%%%%% OPTIMALITY CRITERIA UPDATE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [xnew]=OC_new_pasive(nel,x,volfrac,dc,labelDir,nelx,nely,passive)
l1 = 0; l2 = 100000; move = 0.2;
while (l2-l1 > 1e-4)
    lmid = 0.5*(l2+l1);
    xnew = max(0.001,max(x-move,min(1.,min(x+move,x.*sqrt(-dc./lmid)))));
    %%%%%%%%%%%%%%%%% PASSIVE ELEMENTS %%%%%%%%%%%%%%%%%
    if isequal(labelDir, 'vertical')
        x_new_flip =  flip(reshape(xnew,nely,nelx));
    else
        x_new_flip =  flip(reshape(xnew,nelx,nely));
    end
    x_new_flip(find(passive)) = 0.001;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    xnew = reshape(x_new_flip,1,nel);
    if sum(sum(xnew)) - volfrac*nel > 0
        l1 = lmid;
    else
        l2 = lmid;
    end
end
end
