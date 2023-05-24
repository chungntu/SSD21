function [v,d] = sortNorm(v,d)
[~,ind] = sort(abs(d));
d = d(ind);
v = v(:,ind);

% Normalize eigenvectors
for i = 1:length(d)
    % Get maximum absolute value of current eigenvector
    [~,dof] = max(abs(v(:,i)));
    m = v(dof,i);
    
    % normalize eigenvector w.r.t. maximum value
    for j = 1:length(d)
        v(j,i) = v(j,i)/m;
    end
end
end