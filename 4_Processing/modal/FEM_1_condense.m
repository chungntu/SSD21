function resp = FEM_1_condense(in_data,model)
resp.condense = [];
if isfield(in_data,'MASS_')
    if ~isempty(in_data.MASS_)
        %% CONDENSATION USING GUYAN REDUCTION
        L = model.freeDOFs;
        KK = full(model.Ksys.Kgl(L,L));
        MM = full(model.Mgl(L,L));
        SlaveDofs = slaveDOFs(in_data,L);
        [KR,MR,~,~,~] = GuyanReduction(KK,MM,1,SlaveDofs);
        [UR, DR] = eig(KR,MR,'vector');
        [DR, ind] = sort(DR);
        UR = UR(:,ind)./max(abs(UR));
        resp.condense.DR = DR;
        resp.condense.UR = UR;
        write2fileModalAnalysis(UR,DR)
    end
end
end

function write2fileModalAnalysis(UR,DR)
% PRINT RESULTS
idx = 1;
fprintf('==================================================================================================================================== \n');
fprintf('MODAL ANALYSIS WITH STATIC CONDENSATION\n');
fprintf('\n');
fprintf('#MODE : PERIOD [sec] : FREQUENCY [rad/s]\n');
for i = 1:length(DR)
    fprintf('# %d: T = %5.3f [sec] : %5.3f [rad/s] \n', idx, ...
        2*pi/DR(i).^0.5, DR(i).^0.5);
    idx = idx + 1;
end
fprintf('\n');
fprintf('MODE SHAPE\n');
for i=1:size(UR,1)
    for j = 1:size(UR,2)
        if abs(UR(i,j)) < 1E-6; UR(i,j) = 0; end
        fprintf('% 5.3f   ',UR(i,j));
    end
    fprintf('\n');
end

% WRITE TO FILE
fid = fopen('Modal Analysis Results.txt','wt');
fprintf(fid,'MODAL ANALYSIS WITH STATIC CONDENSATION\n');
fprintf(fid,'\n');
fprintf(fid,'#MODE : PERIOD [sec] : FREQUENCY [rad/s]\n');
idx = 1;
for i = 1:length(DR)
    fprintf(fid, '# %d: T = %5.3f [sec] : %5.3f [rad/s] \n', idx, ...
        2*pi/DR(i).^0.5, DR(i).^0.5);
    idx = idx + 1;
end
fprintf(fid,'\n');
fprintf(fid, 'MODE SHAPE\n');
for i = 1:size(UR,1)
    for j = 1:size(UR,2)
        if abs(UR(i,j)) < 1E-6; UR(i,j) = 0; end
        fprintf(fid,'% 5.3f   ',UR(i,j));
    end
    fprintf(fid,'\n');
end
fclose(fid);
end
