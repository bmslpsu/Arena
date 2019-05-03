function [] = pattern3D()
%% pattern3D:
%   INPUTS:
%       root    : root directory
%   OUTPUTS:
%       -
%---------------------------------------------------------------------------------------------------------------------------------
[pattern]   = MakePattern_SpatFreq(30);
Fs = 50;
[func]      = MakePosFunction_Chirp('',1,10,18.75,20,Fs,40,1,'Logarithmic',false);
PAT = pattern.Pats;
pmap = pattern.Pats(:,1:(96-8),1,1);
pmap = repmat(pmap,8,1);
%---------------------------------------------------------------------------------------------------------------------------------

[x,y,z]=xyzcoordinate(96,32,8);

intvals = 0:2^(pattern.gs_val) - 1;
nintvals = intvals/max(intvals);

cmap = zeros(length(intvals),3);
for kk = 1:length(intvals)
    cmap(kk,3) = nintvals(kk);
end

figure (1); set(gcf,'Color','w')
clf
for kk = 1:length(func)
%     intn = circshift(pmap,kk,2);
    intn = circshift(pmap,func(kk),2);
    surf(x,y,z,intn); hold on
%     plot3(mean(mean(x)),mean(mean(y)),mean(mean(z)),'*r')
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

