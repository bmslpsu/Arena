function [func,deg,tt] = MakePosFunction_Vel(vel,T,Fs,wrap,res,debug,root)
%% MakePosFunction_Vel: make position function for a ramp stimulus
%   INPUTS:
%       vel         :   velocity [deg/s]
%       T           :   time [s]
%       Fs        	:   sample rate [Hz]
%       wrap    	:   boolean to wrap function to 360 deg
%       root       	:   root folder to save function
%       debug    	:   show plot boolean
%   OUTPUTS:
%       func    	:   position function [panel#]
%       deg         :   position function [deg#]
%       tt      	:   time vector [s]
%---------------------------------------------------------------------------------------------------------------------------------
% tt      = (0:(1/Fs):T)';        % time [s]
tt      = linspace(0,T,T*Fs); % time [s]
pos     = vel*tt; % position [deg]
% pos     = rad2deg(wrapTo2Pi(deg2rad(pos)));
func    = deg2panel(pos,res) + 1; % panel position starting from 1 [panel#]

if nargin<5
    res = 3.75;
end

if wrap
    func = wrapTo2Pi(deg2rad(res*func));
    func = rad2deg(func)/res;
end

deg = res*func; % panel position [deg]

fname = ['position_function_Ramp_vel_' num2str(vel) '.mat']; % filename

if nargin>=6
    if debug
        fig(1) = figure; cla ; hold on
        fig(1).Name = 'Position Function';
        plot(tt,pos,'LineWidth',2)
        plot(tt,deg,'LineWidth',2)
        xlabel('Time (s)')
        ylabel(['Position (' char(176) ')'])
        legend('Raw','Panel')
        hold off
    end
    if nargin==7
        save(fullfile(root,fname), 'func')
    end
end
end