% -------------------------------------------------------------------------
% ANIMATE TIME HISTORY ANALYSIS
% Truong Thanh Chung. Aug 2021.
% -------------------------------------------------------------------------
function animateTimeHistory(inData,model,x,t)
deltaT = t(2) - t(1);
dof = size(model.Mgl,1);
[lab,frame] = getScale(inData);
deN = 2*max(max(x));
D = zeros(dof,size(x,2));
epxilon =1E-5; jj= 1;
for ii=1:size(inData.MASS,1)
    if inData.MASS(ii,2)>epxilon
        D(3*ii-2,:) = x(jj,:); jj = jj+1;
    end
    if inData.MASS(ii,3)>epxilon
        D(3*ii-1,:) = x(jj,:); jj = jj+1;
    end
    if inData.MASS(ii,4)>epxilon
        D(3*ii,:) = x(jj,:); jj = jj+1;
    end
end
h = figure();
axis equal; axis off; axis(frame); hold on;
frameIndex =0;
for ii = 1:10:size(x,2)
    frameIndex = frameIndex+1;
    if ishandle(h)
        plotTimeHistory2(inData,lab,(D(:,ii))',deN,frame,dof)
        text(0.2,0.2,['t = ' num2str((ii-1)*deltaT),' s']);
        pause(0.2)
        drawnow;
        thisFrame = getframe(gca);
        % Write this frame out to a new video file.
        myMovie(frameIndex) = thisFrame;
        hold off
    else
        break
    end
end
% REPLAY ANIMATION
hFigure = figure;
%     title(append('Replay Animation ','Mode ', num2str(showMode)),'FontSize', 12)
axis off;
movie(myMovie);
close(hFigure);
% if opt.saveAnimation
baseFileName = 'Vibration';
folder = pwd;
fullFileName = fullfile(folder, baseFileName);
% Create a video writer object with that file name.
% Determine the format the user specified:
[~, ~, ext] = fileparts(fullFileName);
switch lower(ext)
    case '.jp2'
        profile = 'Archival';
    case '.mp4'
        profile = 'MPEG-4';
    otherwise
        % Either avi or some other invalid extension.
        profile = 'Uncompressed AVI';
end
writerObj = VideoWriter(fullFileName, profile);
open(writerObj);
% Write out all the frames.
numberOfFrames = length(myMovie);
for frameNumber = 1 : numberOfFrames
    writeVideo(writerObj, myMovie(frameNumber));
end
close(writerObj);

