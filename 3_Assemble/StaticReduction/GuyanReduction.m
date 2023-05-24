function [KR,MR,DR,T,Kss] = GuyanReduction(K,M,D,SlaveDofs)
%  Guyan reduction or Static reduction
%  with this method, the reduced model tries to reproduce
%  the natural freq.s of full model.
%
% K , M , D: Full order stiffness & Mass Matrices
% SlaveDofs : Dofs to be deattached from system
% KR, MR,Dr : Reduced stiffness & Mass Matrices
% T : Transformation Matrix
% Kss : Slave Stiffness Matrix
% 
% Example:
% k = [2 3 5;6 7 8;3 2 1];
% [kr,~,~,~,Tr,~] = GuyanReduction(k,k,k,1)
%
% 
% Keegan J. Moore
% University of Illinois at Urbana-Champaign
% 03/03/2017
% Inspired by http://www.mathworks.com/matlabcentral/fileexchange/12504-guyan-reduction

Dof = length(K(:,1));
SlaveDofs = sort(SlaveDofs);
index = 1:Dof;

index(SlaveDofs) = [];
for ii = 1:length(SlaveDofs)
    for ij = 1:length(SlaveDofs)
        Kss(ii,ij) = K(SlaveDofs(ii),SlaveDofs(ij));
    end
end

for ii = 1 : length(SlaveDofs)
    for ij = 1 : length(index)
        Ksm(ii,ij) =  K(SlaveDofs(ii),index(ij));
    end
end

P = - inv(Kss) * Ksm;
T = zeros(length(M),length(index));
T(SlaveDofs,:) = P;
T(index,:) = eye(length(index));
MR = T'*M*T;
KR = T'*K*T;
DR = T'*D*T;