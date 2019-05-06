function [] = pattern3D(pattern,func)
%% pattern3D:
%   INPUTS:
%       root    : root directory
%   OUTPUTS:
%       -
%---------------------------------------------------------------------------------------------------------------------------------
% Let user load files if no input is specified
% root = 'Q:\Box Sync\Git\Arena\';
% if ~nargin % no pattern or function input
%     [FILE.pat , PATH.pat ] = uigetfile({'*', 'files'}, 'Select pattern file',root, 'MultiSelect','off');
% 	[FILE.func, PATH.func] = uigetfile({'*', 'files'}, 'Select function file',root, 'MultiSelect','off');
%     load(fullfile(PATH.pat ,FILE.pat ),'pattern')
%     load(fullfile(PATH.func,FILE.func),'func')
% elseif nargin==1  % no function input
% 	[FILE.func, PATH.func] = uigetfile({'*', 'files'}, 'Select function file',root, 'MultiSelect','off');
%     load(fullfile(PATH.func,FILE.func),'func')
% end

off = 8;
Fs = 50;
[pattern] = MakePattern_SpatFreq(30);
% [pattern] = MakePattern_InterpolatedMotion( '', 30 , 5, false , false );
% [pattern] = MakePattern_FourierBar(8,'',false,false);
[func] = MakePosFunction_Chirp('',1,10,18.75,20,Fs,40,1,'Logarithmic',false);
pmap = pattern.Pats(:,1:(pattern.x_panel-off),1,1);
pmap = repmat(pmap,8,1);

[x,y,z] = xyzcoordinate(pattern.x_panel,8*pattern.y_panel,off);

intvals = 0:2^(pattern.gs_val) - 1;
nintvals = intvals/max(intvals);

cmap = zeros(length(intvals),3);
for kk = 1:length(intvals)
    cmap(kk,2) = nintvals(kk);
end

figure (1); set(gcf,'Color','w')
clf
for kk = 1:length(func)
    intn = repmat(pattern.Pats(:,1:(pattern.x_panel-off),func(kk)),8,1);
    surf(x,y,z,intn); hold on
    plot3(mean(mean(x)),mean(mean(y)),mean(mean(z)),'*r')
    colormap(cmap)
    hold on
    set(gca,'Color','w')
    grid off
    axis off
%     shading interp
    rotate3d on
    view(68,41)
    pause (1/Fs);
    clf;
end

end
%---------------------------------------------------------------------------------------------------------------------------------
function [x,y,z] = xyzcoordinate(xp,yp,off)  % Calculate the xyz coordinate of a 32*96 matrix to form a cylinder
    x = zeros(yp,xp-off);
    y = zeros(yp,xp-off);
    z = zeros(yp,xp-off);
    for row = 1:yp
        for column = 1:(xp-off)
            degree =(column-1)*3.75;                        % Calculate the degree between each column
            x(row,column)= (xp/(2*pi))*(cosd(degree));      % calculate X-axis of each pixel
            y(row,column)=(xp/(2*pi))*(sind(degree));       % calculate Y-axis of each pixel
            z(row,column)= row-yp/2;                      	% calculate Z-axis of each pixel
        end
    end
end