function [] = Montage_VidPat(rootdir)
%% MakePosFunction_Chirp: makes chirp position function
%   INPUTS:
%       root:       :   root directory to save position function file
%
%   OUTPUTS:
%       - 
%---------------------------------------------------------------------------------------------------------------------------------

%% Setup Directories %%
%---------------------------------------------------------------------------------------------------------------------------------
clear ; clc ; close all
rootdir = 'C:\Users\boc5244\Box Sync\TEST\';
root.daq = rootdir;
root.pat = [root.daq 'Pattern\'];
root.vid = [root.daq 'Vid\'];
root.ang = [root.vid 'Angles\'];

% Select angle file
[FILE.ang, PATH.ang] = uigetfile({'*.mat', 'DAQ-files'}, ...
    'Select ANGLE file', root.ang, 'MultiSelect','off');
% Select pattern file
[FILE.pat, PATH.pat] = uigetfile({'*.mat', 'DAQ-files'}, ...
    'Select PATTERN file', root.pat, 'MultiSelect','off');

data = [];
load([root.pat FILE.pat],'pattern')
load([root.daq FILE.ang],'data','t_p')
load([root.vid FILE.ang],'vidData','t_v')
data = data';
%%
Circ = (1:1:96)';
V = pattern.Pats(1,:,1,5)'; % get first row of pattern x-channel for specified constant y-channel position, treat all rows as equal
vid = squeeze(vidData); % get rid of singleton dimesnion if neccesary
[yP,xP,nFrame] = size(vid); % get size of video
pDiff = xP-yP;
Border = 100; % border in pixels for montage
B = zeros(yP+pDiff+Border,xP+Border,nFrame); % background for montage
VID = B;
[yAll,xAll,~] = size(VID); % get size of video
center = [round(yAll/2) , round(xAll/2)];
radius = floor(yAll/2.2);
PanelRaw = round((96/10)*data(:,2));
PanelPos = PanelRaw(1:round(length(PanelRaw)/nFrame):end);
PanelDeg = 3.75*PanelPos;

PatDeg = 3.75*Circ;
PatPos = radius*[sin(PatDeg) , -cos(PatDeg)];
PatDisp = round(center - PatPos);
PatDisp(:,3) = V;

for kk = 1:length(PatDisp)
    y =	PatDisp(kk,1);
    x = PatDisp(kk,2);
    val = PatDisp(kk,3);
    
    VID(y,x,1) = val;
    VID(y+1,x,1) = val;
    VID(y,x+1,1) = val;
    VID(y-1,x,1) = val;
    VID(y,x-1,1) = val;
    VID(y+1,x+1,1) = val;
 	VID(y-1,x-1,1) = val;
   	VID(y+1,x-1,1) = val;
 	VID(y-1,x+1,1) = val;

end
TEST = VID(:,:,1);
imshow(TEST);
%%

imagesc(V)
















end