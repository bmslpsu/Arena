function [] = plot_pattern_cylinder(pattern)
%% plot_pattern_cylinder: takes pattern and displays on cylinder
%
% 
% USAGE:
%
%
clearvars -except pattern

[pattern] = MakePattern_SpatFreq(30,[],10);

ypos = 1;
xpos = 1;

gap_width = 10*12;

ypixel = 8*pattern.y_panel; % # of x pixels around display
xpixel = pattern.x_panel; % # of y-pixel around display
R = 2 * 96 / (2*pi); % radius of display [pixels]

% Get pattern image
pat_image = pattern.Pats(:,:,xpos,ypos);
if pattern.row_compression
    pat_image = repmat(pat_image,8,1);
end
% pat_image = ones(ypixel,xpixel);
pat_image = [pat_image ; pat_image(1,:)];
gs = 2^pattern.gs_val;
cmap = [zeros(gs,1), (0:(gs-1))' , zeros(gs,1)];

% Create cylinder
xc = nan(ypixel,xpixel);
yc = nan(ypixel,xpixel);
zc = nan(ypixel,xpixel);
for r = 1:ypixel+1
    for c = 1:xpixel
        theta   = (c-1)*(360 / (pattern.x_panel + gap_width));
        xc(r,c) = -R*(cosd(theta));
        yc(r,c) =  R*(sind(theta));
        zc(r,c) = r - 1;
    end
end

fig = figure;
set(fig, 'Color', 'w', 'Units', 'inches')
ax = subplot(1,1,1); cla
hs = surf(xc, yc, zc, pat_image, 'EdgeColor', 'none', ...
    'FaceAlpha', 0.5, 'LineStyle', 'none', 'FaceColor', 'interp');

hold on
% hs = surf(xc(1:2,:), yc(1:2,:), 0*ones(size(xc(1:2,:))), 0*ones(size(xc(1:2,:))), 'LineWidth', 3);
% hs = surf(xc(1:2,:), yc(1:2,:), 32*ones(size(xc(1:2,:))), 0*ones(size(xc(1:2,:))), 'LineWidth', 3);

view(-66,12.5)
% alpha 0.5
colormap(cmap)
axis equal
axis off

end

