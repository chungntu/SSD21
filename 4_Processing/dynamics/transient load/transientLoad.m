% -------------------------------------------------------------------------
% DEFINE TRANSIENT LOAD
% Truong Thanh Chung. Apr 2023.
% -------------------------------------------------------------------------
function [t,f] = transientLoad(model,dt,T,startTime,lengthTimeForce,nodeNo)
totalDOFs = size(model.Mgl,1);
% TRIANGULAR HAT PULSE
% forceProfile = [0 0; startTime 0; startTime+lengthTimeForce/2  1; startTime+lengthTimeForce 0; T 0];
% RECTANGULAR PULSE
% forceProfile = [0 0; startTime-dt 0; startTime 1; startTime+lengthTimeForce  1; startTime+lengthTimeForce+dt 0; T 0];
% EXPLOSIVE TRIANGULAR PULSE
forceProfile = [0 0; startTime-dt 0; startTime 1; startTime+lengthTimeForce  0; T 0];
[t,g] = forcefunc(forceProfile,dt);
figure; plot(t,g/10); axis equal
f = zeros(totalDOFs, length(g));
f(nodeNo,:) = 1000*g;
