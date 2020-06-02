function [X,Y,Z] = arena_fig(pat)
%% arena: plots pattern in arena coordinate system
%   INPUTS:
%       root        :  folder.
%   OUTPUTS:
%       Vid         :   raw video data
%       VidTime     :   normalized video time
%       FlyState  	:   fly kinematic data
%       AI          :   analog input voltages
%       FILES    	:   filename listing
%

clear;close all;clc

pat = randi([0 7],32,96);
gs = unique(pat);
cmap = cell(length(gs),1);
for kk = 1:length(gs)
    cmap{kk} = [0 1 0]*(kk/length(gs));
end

h = size(pat,1);
w = size(pat,2);
r = (w/(2*pi))*[1 1]';
r = r(:); % Make sure r is a vector.
m = length(r); if m==1, r = [r;r]; m = 2; end
theta = linspace(0.5,2*pi-deg2rad(3.75),w);
x = r * cos(theta);
y = r * sin(theta);z = repmat((0:m-1)'/(m-1),1,w);

% [x,y,z] = cylinder(15.2789,96);
X = repmat(x,1,h);
Y = repmat(y,1,h);
Z = z;
for kk = 1:h-1
    Z = [Z , z+kk];
end

X = X(:);
Y = Y(:);
Z = Z(:);
S = 10*ones(length(X),1);

% figure (1) ; clf
% 
% scatter3(X,Y,Z,S,'g','filled')

figure (1) ; clf
% surf(X,Y,Z)
scatter3(X,Y,Z,S,'g','filled') ; hold on
rotate3d on
axis equal
%%

r = 1.05*r;
theta = linspace(0.5,2*pi-deg2rad(3.75),500);
x = r * cos(theta);
y = r * sin(theta);
z = repmat((0:m-1)'/(m-1),1,500);
X = repmat(x,1,h);
Y = repmat(y,1,h);
Z = z;
res = 10;
for kk = 1:res*(h-1)
    Z = [Z , z+kk];
end

X = X(:);
Y = Y(:);
Z = Z(:);
S = 10*ones(length(X),1);
scatter3(X,Y,Z,S,'k','filled') ; hold on







end