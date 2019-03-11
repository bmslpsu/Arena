function [MOV] = Montage_VidPat(rootdir,rootpat,export)
%% MakePosFunction_Chirp: makes chirp position function
%   INPUTS:
%       rootdir     : directory containing DAQ,VID,ANGLE files
%       rootpat     : directory containing PATTERN files
%       export      : boolean (1=export video to images)
%   OUTPUTS:
%       - 
%---------------------------------------------------------------------------------------------------------------------------------
% Example Input %
% clear ; clc ; close all
% export = true;
% rootdir = 'H:\EXPERIMENTS\Experiment_Sinusoid\18.75\';
% rootpat = 'Q:\Box Sync\Git\Arena\Patterns\';
%---------------------------------------------------------------------------------------------------------------------------------
% Set directories
root.pat    = rootpat; % pattern location
root.daq    = rootdir; % position location (DAQ file)
root.vid    = [root.daq 'Vid\']; % video location
root.head   = [root.vid 'Angles\']; % head angles location

% Select angle file
[FILE.ang, ~] = uigetfile({'*.mat', 'DAQ-files'}, ...
    'Select ANGLE file', root.head, 'MultiSelect','off');
% Select pattern file
[FILE.pat, ~] = uigetfile({'*.mat', 'DAQ-files'}, ...
    'Select PATTERN file', root.pat, 'MultiSelect','off');

% Load data
disp('Loading Data...')
data = [];
load([root.pat FILE.pat],'pattern') % load pattern
load([root.daq FILE.ang],'data','t_p') % load pattern position
load([root.vid FILE.ang],'vidData','t_v') % load video
load([root.head FILE.ang],'hAngles','hCenter') % load angles
disp('DONE')

[~,dirName,~] = fileparts([root.head FILE.ang]); % get file name
root.mov = [root.daq 'Movie\'];
root.image = [root.daq 'Movie\' dirName];
mkdir(root.image) % create directory for export images

% Get video, pattern, position, & angles data 
Fly.vid = squeeze(vidData); % raw trial video data
Fly.time = t_v; % video time
Fly.Fs = round(1/mean(diff(Fly.time)));
[Fly.xP,Fly.yP,nFrame] = size(Fly.vid ); % get size of video
center = [round(Fly.yP/2) , round(Fly.xP/2)+55]; % center point for pattern & fly
radius.center = floor(max([Fly.yP Fly.xP])/1.45); % radius of pattern
radius.width = 10; % radius display width
rin  = radius.center - radius.width;
rout = radius.center + radius.width;
x1 = center(1);
y1 = center(2);
sA = 3.75 * pi/180; % angle pixel subtends
Pat.pos = round((96/10)*(data(:,2)-mean(0))); % pattern position
Pat.time = t_p; % pattern time
Pat.int = interp1(Pat.time, Pat.pos, Fly.time, 'nearest'); % interpolate pattern to match fly video

if exist('hCenter','var')~=1 % get head rotation point if not found
    figure ; clf ; hold ; title('Select head rotation point, press space when done')
    imshow(Fly.vid(:,:,1))
    hp = impoint();
    pause
    hCenter = getPosition(hp);
end

% Create structure to store frames
MOV(1:nFrame) = struct('cdata', [], 'colormap',[]);

% Create video object
VID = VideoWriter([root.mov dirName '.avi'],'Uncompressed AVI');
VID.FrameRate = Fly.Fs;
open(VID)

FIG = figure ; clf % main figure window for display & export
set(gcf, 'color', 'k');
set(FIG, 'Renderer','OpenGL');
set(FIG, 'Position',[100, 100, 16*40, 16*50]);
subplot(12,1,1:8) ; cla ; hold on; axis square % for fly & pattern vid
subplot(12,1,9:10)  ; cla ; hold on ; h1 = animatedline('Color','g','LineWidth',2); % for pattern angle
subplot(12,1,11:12) ; cla ; hold on ; h2 = animatedline('Color','b','LineWidth',2); % for head angle
pp = 1;
for jj = 1:nFrame % for each frame    
	pat = pattern.Pats(1,:,round(Pat.int(jj)),4); % top row of pattern
	patS = circshift(pat,[0 15]); % shift pattern to fly reference frame
    
    I = find(patS~=0);
    theta = (I.*3.75) .* (2*pi/360); % lit pixels
    theta_ALL = deg2rad(3.75*(1:96));

	Frame = Fly.vid(:,:,jj); % current raw frame
    DISP = Frame; % video frame to display
    
    % Display fly video
    subplot(12,1,1:8) ; cla ; hold on; axis square
    imshow(DISP); hold on
    hTipX = hCenter(1) + 300*sind(hAngles(jj));
    hTipY = hCenter(2) - 300*cosd(hAngles(jj));
    plot([hCenter(1),hTipX],[hCenter(2),hTipY],'-b','LineWidth',2)
    plot(hCenter(1),hCenter(2),'oc','MarkerSize',2)
    plot(x1,y1,'r.','MarkerSize',1) % display center point

    % Make pattern ring
    for kk = 1:length(theta_ALL)
        xin = x1 + rin*cos(theta_ALL(kk));
        xout = x1 + rout*cos(theta_ALL(kk));
        xinN = x1 + rin*cos(theta_ALL(kk) + sA);
        xoutN = x1 + rout*cos(theta_ALL(kk) + sA);
        yin = y1 + rin*sin(theta_ALL(kk));
        yout = y1 + rout*sin(theta_ALL(kk));
        yinN = y1 + rin*sin(theta_ALL(kk) + sA);
        youtN = y1 + rout*sin(theta_ALL(kk) + sA);
        
        if sum(ismember(theta, theta_ALL(kk))) == 1 % if lit
            patch([xout, xoutN, xinN, xin], [yout, youtN,yinN, yin],'g','linestyle','none',...
                'FaceAlpha',pat(kk)*(1/(2^(pattern.gs_val)-1)));
        else % if dark
            patch([xout, xoutN, xinN, xin], [yout, youtN,yinN, yin],'k','linestyle','none');
        end
    end
    
    % Pattern plot
 	subplot(12,1,9:10) ; hold on ; set(gca, 'color', 'w')
 	ylabel('Display ($^{\circ}$)','Interpreter','latex','Color','w','FontSize',12);
    xlim([0 round(Fly.time(end))])
    ylim([-20 20])
 	set(gca,'ycolor','w');
    set(gca,'xcolor','k');
    set(gca,'YTick',[-20 0 20])
    set(gca,'XTick',0:1:round(Fly.time(end)))
    addpoints(h1,t_v(jj),3.75*Pat.int(jj) - 3.75*mean(Pat.int))
    drawnow
    
    % Head plot
    subplot(12,1,11:12) ; hold on ; set(gca, 'color', 'w')
	ylabel('Head ($^{\circ}$)','Interpreter','latex','Color','w','FontSize',12)
  	xlabel('Time (s)','Interpreter','latex','Color','w','FontSize',12)    
    xlim([0 round(Fly.time(end))])
    ylim([-20 20])
 	set(gca,'ycolor','w');
 	set(gca,'xcolor','w');
    set(gca,'YTick',[-20 0 20])
    set(gca,'XTick',0:1:round(Fly.time(end)))
    addpoints(h2,t_v(jj),hAngles(jj) - mean(hAngles))
    drawnow
    
    % Store frame
    MOV(pp) = getframe(FIG);
    
    if export
        % Export frame to image
        filename = sprintf('image%04d.jpg', pp);
        export_fig(gcf, [root.image '\' filename], '-q95','-nocrop');
        % Write frame to .avi
        writeVideo(VID,getframe(FIG));
    end

    pp = pp + 1;
end

if export
    close(VID) % close .avi
    Fs = Fly.Fs;
	save([root.mov dirName '.mat'],'MOV','Fs','-v7.3','-nocompression') % save movie as .mat file
end

end