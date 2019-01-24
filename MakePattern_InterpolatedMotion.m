function [] = MakePattern_InterpolatedMotion( root, spatFreq , Steps, playPat , savePat )
% MakePattern_InterpolatedMotion_V0: creates pattern for controller V3 using varying contrasts to create apparent motion of the 
% stimulus
    % INPUTS:
        % root      :	folder to save pattern
        % spatFreq  :	specify spatial frequency [deg] (must me in increments of 7.5: 7.5,15,22.5,30, ...)
        % Steps     :	transition steps per cycle (also gain factor for arena panels)
        % playPat   :   boolean to play pattern (1 is on, 0 is off): if any other number >>> playback at that frequency 
        % savePat   :   boolean to save pattern (1 is on, 0 is off)
  	% OUTPUTS:
        % -
%---------------------------------------------------------------------------------------------------------------------------------
%   This program creates one structure ('pattern').  The relevant components of
%   this structure are as follows:
%
%       pattern  -  the parent structure
%               .x_num          -   xpos limits
%                                   by convention, xpos relates to translation and
%                                   rotations of a static pattern
%               .y_num          -   ypos limits
%                                   by convention, ypos relates to non-length
%                                   conserving transformations
%               .x_panels       -   number of panels in x direction
%               .y_panels       -   number of panels in y directions
%               .num_panels     -   number of panels in array
%                                   (.x_panels*.y_panels)
%               .panel_size     -   '0' gives default 8x8, '1' allows user specific
%               .gs_val         -   gray scale value (1-4)
%               .Pats           -   data for the panels...a 4D array where
%                                   (x_panels*x_size,y_panels*y_size,xpos,ypos)
%               .Panel_map      -   a 2x2 array specifying the location of the
%                                   named panels indexed from '1'
%               .BitMapIndex	-   output generated by executing
%                                   'process_panel_map(pattern);'
%               .data           -   output generated by executing
%                                   'make_pattern_vector(pattern);'
%% DEBUGGING %%
% ONLY UNCOMMENT & RUN THIS SECTION IF DEBUGGING %
%---------------------------------------------------------------------------------------------------------------------------------
%     root = 'C:\';
%     spatFreq = 30;
%     Steps = 1;
%     playPat = 1;
%     savePat = 0;
%% Setup Parameters %%
%---------------------------------------------------------------------------------------------------------------------------------
pattern.num_panels = 48;        % # panels in arena
pattern.gs_val = 4;             % grey-scale #: 4 = 0:15
pattern.row_compression = 1;    % condense columns  = ON
pattern.x_num = 96;             % # x-frames

pixelX = pattern.x_num;                         % # X pixels
pixelY = pattern.num_panels/(pattern.x_num/8);  % # Y pixels

Int.High = 15; % high intensity value (0-15)
Int.Low = 0;   % low intensity value (0-15)

Period = (spatFreq/360)*pixelX; % full period for spatial frequency [# pixels]
repeat = pixelX/Period; % if this value is an integer, then this spatial frequency is valid

if (floor(Period) == Period) && (floor(repeat) == repeat) % make sure spatial frequency is valid
    disp('Valid Spatial Frequency')
else
    error('ERROR: spatial frequency unattainable!')
end

pattern.y_num = Steps*Period;	% # y-frames

if (pattern.y_num <= pattern.x_num) && (Steps>0) % make sure # steps is valid
    disp('Valid # of Steps')
else
    error('ERROR: # of steps unattainable!')
end
%% Make Pattern Matrix %%
%---------------------------------------------------------------------------------------------------------------------------------
Pats = zeros(pixelY, pixelX, pattern.x_num, pattern.y_num); % preallocate pattern matrix

val = (pixelX*Steps)/pattern.y_num; % # repeat

InitPat = repmat([Int.Low*ones(pixelY,Steps*(Period/2)), ... % matrix to average
    Int.High*ones(pixelY,Steps*(Period/2))], 1,val);

% Assign x-channel frames
temp_Pats(:,:,1) = InitPat;
for j = 2:pattern.x_num
    temp_Pats(:,:,j) = ShiftMatrix(temp_Pats(:,:,j - 1), 1,'r','y');       
end

% Make first set of expansion pats
for j = 1:pattern.y_num
    for i = 1:pattern.x_num
        Pats(:,i,1,j) = round(sum(temp_Pats(:,((i*Steps)-(Steps-1)):i*Steps,j),2)./Steps);
    end
end    

for j = 1:pattern.y_num
    for i = 2:pattern.x_num
        Pats(:,:,i,j) = ShiftMatrix(Pats(:,:,i-1,j), 1, 'r', 'y'); 
    end
end

for j = 1:pattern.y_num   % shifts pattern so it is centered
    for i = 1:pattern.x_num
        Pats(:,:,i,j) = ShiftMatrix(Pats(:,:,i,j), 3, 'l', 'y'); 
    end
end
%% Play Pattern %%
%---------------------------------------------------------------------------------------------------------------------------------
if playPat
    h = figure (1) ; clf % pattern window
    tic           
    for jj = 1:10 % how many time to loop pattern
        for kk = 1:size(Pats,4) % play y-channel
            imagesc(Pats(:,:, 1, kk)) % display frame
            if 1==playPat % 
                pause % user clicks to move to next frame
            else      
                pause(1/playPat) % automatic frame rate
            end
        end
    end
    toc
    close(h)
end
%% Save Pattern %%
%---------------------------------------------------------------------------------------------------------------------------------
if savePat
    pattern.Pats = Pats; % store pattern data
    pattern.Panel_map = [12 8 4 11 7 3 10 6 2  9 5 1;...  % store arena panel layout
                         24 20 16 23 19 15 22 18 14 21 17 13;...
                         36 32 28 35 31 27 34 30 26 33 29 25;...
                         48 44 40 47 43 39 46 42 38 45 41 37];
    pattern.BitMapIndex = process_panel_map(pattern);
    pattern.data = make_pattern_vector(pattern);
    str = [root '\Pattern_InterpolatedMotion_SpatFreq_' num2str(spatFreq) '_Steps_' num2str(Steps) '_48Pan.mat'];
    save(str, 'pattern');
end
disp('DONE')
end