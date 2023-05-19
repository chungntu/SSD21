function [SIG_main] = FEM_3_stressMainBRICK(in_data, SIGsys) 

% -------------------------------------------------------------------------

fj = size(in_data.EL,1);
SIG_main = zeros(size(in_data.ND,1),3);

for i=1:fj
    if in_data.EL(i,2)==6
        for m=1:8
            node_m = find(in_data.ND(:,1)==in_data.EL(i,m+2));
        
            SIGlocal = SIGsys(node_m,1:6);
            SIG = [ SIGlocal(1) SIGlocal(4) SIGlocal(6);
                SIGlocal(4) SIGlocal(2) SIGlocal(5);
                SIGlocal(6) SIGlocal(5) SIGlocal(3)];
            [V,D] = eig(SIG); % D - principal values 
            D = diag(D);
            SIG_main(node_m,1:3) =  D';
        end
    end;
end;

