function resp = FEM_1_dynm(inData,model)
resp.dynm = [];
if isfield(inData,'JointMass')
    if ~isempty(inData.JointMass)
        % STATIC CONDENSATION
        L = model.freeDOFs;
        KK = full(model.Ksys.Kgl(L,L));
        MM = full(model.Mgl(L,L));
        SlaveDofs = slaveDOFs(inData,L);
        [KR,MR,~,~,~] = GuyanReduction(KK,MM,1,SlaveDofs);
        % GET EARTHQUAKE ACCELERATION
        [fileName,pathname] =  uigetfile('*.dat');
        if (isequal(fileName,0) || isequal(pathname,0))
            disp('USER CANCEL');
        else
            fullPath = fullfile(pathname,fileName);
            % RUN TIME HISTORY ANALYSIS
            earthquakeAcc = load(fullPath);
            t = earthquakeAcc(:,1);
            xg = earthquakeAcc(:,2);
            xg_ms = xg*9.81 ;                               % change unit from g to m/s^2
            [phi,omega2] = eig(KR,MR);
            zeta = 0.05;                                    % damping ratio
            CR = inv(phi')*2*zeta*omega2.^0.5*inv(phi);     % damping matrix
            x0 = zeros(size(MR,1),1);
            xd0 = zeros(size(MR,1),1);                      % initial conditions
            F = -MR*ones(size(MR,1),1)*xg_ms';              % earthquake force
            x = newmark(MR,CR,KR,F,t,x0,xd0,'average');     % solve dipl using Newmark
            figure('Position',[600 100 800 400]);
            plot(t,x,'LineWidth',1.5);
            grid on; axis tight; xlabel('t (s)'); ylabel('Disp (m)');
            set(gca,'Fontsize',14)
            animateTimeHistory(inData,model,x,t)
            resp.dynm = x;
        end
    end
end
