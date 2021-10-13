%--------------------------------------------------------------------------
% DRAW SCALE BAR
% Truong Thanh Chung. Aug 2021.
%--------------------------------------------------------------------------
function plotScaleBar(scaleFactor,magnitude,cor)
hold on
barLength   = magnitude*scaleFactor;
x           = cor(1);
y           = cor(2);
plot([x - barLength/2,x+barLength/2],[y,y],'k','linewidth',2);
text((magnitude*1.1)*scaleFactor+x,y,sprintf('%0.5g ', magnitude));
hold off;
