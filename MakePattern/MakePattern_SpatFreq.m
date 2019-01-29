function [] = MakePattern_SpatFreq(freq)
%---------------------------------------------------------------------------------------------------------------------------------
% MakePattern_SpatFreq: makes pattern with two channels
% Channel-X: changes spatial frequency
% Channel-Y: rotates ground
%   INPUTS:
%       freq: row vector containing spatial frequencies in degress
%   OUTPUTS:
%
%---------------------------------------------------------------------------------------------------------------------------------
%%
%---------------------------------------------------------------------------------------------------------------------------------
pattern.x_num = 96;             % There are 96 pixel around the display (12x8) 
pattern.y_num = length(freq); 	% # of spatial frequencies
pattern.num_panels = 48;        % This is the number of unique Panel IDs required.
pattern.gs_val = 4;             % This pattern will use 8 intensity levels
pattern.row_compression = 1;    % Columns are symmetric





barwidth = zeroes();
for kk = 1:pattern.y_num
   barwidth(kk) = pattern.x_num*(freq(kk)/360)
end








end

