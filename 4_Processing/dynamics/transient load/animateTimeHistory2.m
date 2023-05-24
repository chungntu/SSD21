% -------------------------------------------------------------------------
% ANIMATE TIME HISTORY ANALYSIS
% Truong Thanh Chung. Aug 2021.
% -------------------------------------------------------------------------
function animateTimeHistory2(inData,model,D,t,zeta)
deltaT = t(2) - t(1);
dof = size(model.Mgl,1);
[lab,frame] = getScale(inData);
deN = 2*max(max(D));
h = figure();
axis equal; axis off; axis(frame); hold on;
frameIndex =0;
for ii = 1:10:size(D,2)
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

baseFileName = append('Vibration',num2str(zeta));
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

