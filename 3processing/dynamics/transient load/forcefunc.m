% -------------------------------------------------------------------------
% FORM FORCE VECTOR FROM FORCE PROFILE BY LINEAR INTERPOLATION AT EQUAL SPACE
% Truong Thanh Chung. Aug 2021.
% -------------------------------------------------------------------------
function [t,g] = forcefunc(forceProfile,dt)
np = size(forceProfile,1);
ti = forceProfile(1,1):dt:forceProfile(np,1);
g1 = interp1(forceProfile(:,1),forceProfile(:,2),ti');
t=ti;
g=g1';
