function FEM_0_buckling(in_data,model,resp,opt)
if opt.bucklingLinear.flag
    if isfield(resp,'staticLinear')
        [~,EL_TYPE,~] = elemType(in_data);
        if EL_TYPE == 0 || EL_TYPE == 1 || EL_TYPE == 2 || EL_TYPE == 333
            if ~isempty(in_data.JointMass)
                showMode = min(size(in_data.JointMass,1),6);
            else
                showMode = 6;
            end
            Np              = full(resp.staticLinear.Np);
            L               = model.freeDOFs;
            model.Ksys.Kgeo = FEM_1_assemble_Kgeo(in_data,Np);
            Kgl             = full(model.Ksys.Kgl);
            Kgeo            = full(model.Ksys.Kgeo);
            [eigVector,eigValues] = eig(Kgl(L,L),Kgeo(L,L),'vector');
            [eigVector,eigValues] = sortNorm(eigVector,eigValues);
            write2fileBucklingAnalysis(eigValues,eigVector,showMode)  % Print screen and write to file
            [lab,frame] = getScale(in_data);
            % PLOT BUCKLING MODE SHAPE
            for ii = 1:showMode
                D = zeros(size(model.Mgl,1),1);
                D(L,:) =  eigVector(:,ii);
                dof = size(model.Mgl,1);
                h = figure(); hold on;
                set(h,'name',['BUCKLING MODE ', num2str(ii), ': CRITICAL LOAD =  ',num2str(eigValues(ii))]);
                axis equal; axis off; axis(frame);
                FEM_2_buckling_modeShape(in_data,lab,D',frame,dof)
            end
        end
    else
        disp('MUST ENABLE LINEAR STATIC ANALYSIS')
    end
end
end

function write2fileBucklingAnalysis(eigValues,eigVector,showMode)
% PRINT RESULTS
fprintf('==================================================================================================================================== \n');
fprintf('BUCKLING ANALYSIS\n');
fprintf('CRITICAL LOAD RATIO\n');
for i = 1:showMode
    fprintf('Mode %d : %f\n',i,eigValues(i));
end
fprintf('\n');
fprintf(append('MODE SHAPE\n'));
for i=1:size(eigVector,1)
    for j = 1:showMode
        if abs(eigVector(i,j)) < 1E-6; eigVector(i,j) = 0; end
        fprintf('% 5.3f   ',eigVector(i,j));
    end
    fprintf('\n');
end
fprintf('==================================================================================================================================== \n');
% WRITE TO FILE
fid = fopen('BUCKLING ANALYSIS RESULTS.txt','wt');
fprintf(fid,'BUCKLING ANALYSIS\n');
fprintf(fid,'CRITICA LOAD RATIO\n');
for i = 1:showMode
    fprintf(fid,'MODE %d : %f\n',i,eigValues(i));
end
end
