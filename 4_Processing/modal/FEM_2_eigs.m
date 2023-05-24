%--------------------------------------------------------------------------
% SOLVE EIGEN VALUE PROBLEM
% Truong Thanh Chung. Aug 2021.
%--------------------------------------------------------------------------
function [eigVector,eigValues] = FEM_2_eigs(Kgl,Mgl,modeN)
opts.maxit  = 270;
opts.tol    = 1E-3;
[eigVector_,eigValues_] = eigs(Mgl\Kgl,modeN,'SM',opts);
eigValues_  = sqrt(real(eigValues_));
eig_V       = diag(eigValues_);
eigVector_  = real(eigVector_);
D           = size(eigVector_,1);
NOM         = 0;
DIN         = realmax;
S           = 0;
for i = 1:modeN
    for k = 1:modeN
        if abs(eig_V(k))>=abs(NOM)
            if abs(eig_V(k))<abs(DIN)
                NOM = eig_V(k); S=k;
            end
        end
    end
    eigValues(i) = NOM; DIN = NOM;
    for p = 1:D
        eigVector(p,i) = eigVector_(p,S);
    end
    NOM = 0;
end
write2file(eigValues,eigVector)
end

function write2file(eigValues,eigVector)
% PRINT RESULTS
fprintf('==================================================================================================================================== \n');
idx = 1;
fprintf('MODAL ANALYSIS (FULL MODEL)\n');
fprintf('PERIOD [sec] : FREQUENCY [rad/s]\n');
for i = length(eigValues):-1:1
    fprintf('# %d: T = %5.6f [sec] : %5.6f [rad/s] \n', idx, ...
        2*pi/eigValues(i), eigValues(i));
    idx = idx + 1;
end
fprintf('\n');
fprintf(append('MODE SHAPE\n'));
for i=1:size(eigVector,1)
    for j = 1:size(eigVector,2)
        if abs(eigVector(i,j)) < 1E-6; eigVector(i,j) = 0; end
        fprintf('% 5.3f   ',eigVector(i,j));
    end
    fprintf('\n');
end
end
