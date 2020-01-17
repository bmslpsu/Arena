function [] = Arena_TriWave(patID,gain,period,time)
%% Arena_TriWave: triangle wave motion
%       patID      	:   CL pattern ID
%       gain        :   arena gain
%       period      :   period o f triangle wave [s]
%       time        :   time to run [s]
%   OUTPUTS:
%       -
%

cycles = round(time/period);

n_pause = 0.2;

disp('rest');
Panel_com('stop'); pause(n_pause)
Panel_com('set_pattern_id', patID);pause(n_pause)  	% set pattern
Panel_com('set_mode',mode); pause(n_pause)       	% closed loop tracking [xpos,ypos] (NOTE: 0=open, 1=closed)
Panel_com('set_position',[1 7]); pause(n_pause) 	% set starting position (xpos,ypos)
Panel_com('set_funcX_freq', 50); pause(n_pause)  	% X update rate
Panel_com('set_funcY_freq', 50); pause(n_pause)   	% Y update rate

Panel_com('start');    
for kk = 1:cycles
    Panel_com('send_gain_bias',[gain,0,0,0]); pause(n_pause)  	% [xgain,xoffset,ygain,yoffset]
    pause(period/2)
    Panel_com('send_gain_bias',[-gain,0,0,0]); pause(n_pause)  	% [xgain,xoffset,ygain,yoffset]
    pause(period/2)
end

end