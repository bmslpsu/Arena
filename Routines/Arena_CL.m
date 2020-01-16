function [] = Arena_CL(patID,channel,gain)
%% Arena_CL: creates video input object with specififed camera settings
%   INPUTS:
%       patID      	:   CL pattern ID
%       channel    	:   x or y
%       time        :   rest time [s]
%       gain        :   arena gain
%   OUTPUTS:
%       -
%

if nargin==3
    gain = -15; % default gain
end

if strcmp(channel,'x') || strcmp(channel,'X')
    mode = [1 0];
    GAIN = [gain,0,0,0];
elseif strcmp(channel,'y') || strcmp(channel,'Y')
	mode = [0 1];
  	GAIN = [0,gain,0,0];
elseif strcmp(channel,'xy') || strcmp(channel,'yx') || strcmp(channel,'XY') || strcmp(channel,'YX')
    mode = [1 1];
    if length(gain)==1
        GAIN = [gain,gain,0,0];
    elseif length(gain)==2
       	GAIN = [gain(1),gain(2),0,0];
    else
        error('Error: gain must be of length 1 or 2')
    end        
else
    error('Error: channel must be "x", "y", or "xy" ')
end

n_pause = 0.2;

disp('rest');
Panel_com('stop'); pause(n_pause)
Panel_com('set_pattern_id', patID);pause(n_pause)      	% set pattern
Panel_com('set_mode',mode); pause(n_pause)             	% closed loop tracking [xpos,ypos] (NOTE: 0=open, 1=closed)
Panel_com('set_position',[1 1]); pause(n_pause)        	% set starting position (xpos,ypos)
Panel_com('set_posfunc_id',[1,0]); pause(n_pause)     	% no position function for x-channel
Panel_com('set_funcX_freq', 50); pause(n_pause)       	% X update rate
Panel_com('set_funcY_freq', 50); pause(n_pause)        	% Y update rate
Panel_com('send_gain_bias',GAIN); pause(n_pause)      	% [xgain,xoffset,ygain,yoffset]
Panel_com('start');                                    	% start closed-loop rest
end