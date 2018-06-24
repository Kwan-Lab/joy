function plot_joy( dat, range )
% % plot_joy %
%PURPOSE:   Plot dF/F for all the cells in one imaging session
%           (in the style of Joy Division - Unknown Pleasures)
%AUTHORS:   AC Kwan 171217
%
%INPUT ARGUMENTS
%   dat
%       t:          time of image frames [time x 1]
%       dFF:        fluoresecence signals [time x cells]
%       resp:       1 if animal made a response during that image frame [time x 1]
%   range:          range of image frame to use

%% Set up figure

nCells = size(dat.dFF,2);  %number of cells

spacing = 0.2;      % spacing between traces
frameWidth = 120;   % how many time bins on the screen at once

%a filter to emphasize signal in the middle and set edges to zero
scale_win = [zeros(frameWidth/4,1); tukeywin(frameWidth/2); zeros(frameWidth/4,1)];
scale_win = 0.2 + scale_win;    %even edges have some fluctuations

%range for y-axis
ymin = -spacing;
ymax = spacing*nCells+1.5;

%% initialize video

myVideo = VideoWriter('joy.avi');
myVideo.FrameRate = 20;  % Default 30
myVideo.Quality = 75;    % Default 75
open(myVideo);

figure('rend','painters','pos',[10 10 600 900]);

%for each image frame
for j = range(1):range(end)
    
    %plot fluorescence
    for k = 1:nCells
        
        level = spacing*(nCells-k);          %y-offset for this cell
        
        y = round(dat.dFF(j:j+frameWidth-1,k),15);  %smooth the fluorescence signal
        y = y.* scale_win;      %multiply by center filter
        y = y + level;          %move trace to y-offset
        
        if k == 1
            hold off;
        end
        area(dat.t(j:j+frameWidth-1), max(y,level), level, 'EdgeColor', 'none', 'FaceColor', [0 0 0]);
        plot(dat.t(j:j+frameWidth-1), y,'-','LineWidth',2,'Color',[1 1 1]);
        if k == 1
            hold on;
        end
    end
    
    %plot red line if mouse made a response
    stem(dat.t(j:j+frameWidth-1), dat.resp(j:j+frameWidth-1) * ymax, 'r','LineWidth',2,'Marker','none');
    
    %set axes limits
    xlim([dat.t(j) dat.t(j+frameWidth-1)]);
    ylim([ymin ymax]);
    
    %get rid of the axes
    set(gca,'color',[0 0 0]);
    set(gca,'xtick',[]);
    set(gca,'xcolor',[0 0 0]);
    set(gca,'ytick',[]);
    set(gca,'ycolor',[0 0 0]);
    
    pause(0.001);
    
    %capture current frame for movie making
    F = getframe(gcf);
    writeVideo(myVideo,F);
    disp(['Frame ' int2str(j) '...']);
    
end

close(myVideo);
close;

end
