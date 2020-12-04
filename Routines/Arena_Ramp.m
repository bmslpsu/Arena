function [] = Arena_Ramp(patID,gain)
%% Arena_TriWave: constant velocity motion
%   INPUT:
%       patID      	:   CL pattern ID
%       gain        :   arena gain
%   OUTPUT:
%       -
%

% Pick random direction
dir = 0;
while dir==0
    dir = randi([-1,1],1);
end

n_pause = 0.2;

disp('rest');
Panel_com('stop'); pause(n_pause)
Panel_com('set_pattern_id', patID);pause(n_pause)  	% set pattern
Panel_com('set_mode',[0 0]); pause(n_pause)        	% closed loop tracking [xpos,ypos] (NOTE: 0=open, 1=closed)
Panel_com('set_position',[1 6]); pause(n_pause) 	% set starting position (xpos,ypos)
Panel_com('set_funcX_freq', 50); pause(n_pause)  	% X update rate
Panel_com('set_funcY_freq', 50); pause(n_pause)   	% Y update rate
Panel_com('send_gain_bias',dir*[gain,0,0,0]); pause(n_pause) % [xgain,xoffset,ygain,yoffset]
Panel_com('start')

end