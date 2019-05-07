function [] = pattern_spherical_3D(pattern,func)
%% pattern_spherical_3D:
%   INPUTS:
%       root    : root directory
%   OUTPUTS:
%       -
%---------------------------------------------------------------------------------------------------------------------------------
clear;close all;clc
Fs = 50;
pattern.gs_val = 2;
maxInt = 2^(pattern.gs_val) - 1;
intvals = 0:maxInt;
nintvals = intvals/max(intvals);

n = 40;
r = 16;
pmap = randi([0 maxInt],n,n);
% pmap = eye(n);
cmap = zeros(length(intvals),3);
for kk = 1:length(intvals)
    cmap(kk,2) = nintvals(kk);
end

[X,Y,Z] = sphere(n);





FIG = figure (1);
FIG.Color = 'w';
h = surf(r*X,r*Y,r*Z,pmap); hold on
ax = gca;
h.EdgeColor = 'none';
rotate3d on
axis square
colormap(cmap)
grid on
xlabel('X')
ylabel('Y')
zlabel('Z')
% alpha 0.5
direction = [0 0 1];
for kk = 1:10000
    rotate(h,direction,1)
    pause(0.01)
end



%%
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