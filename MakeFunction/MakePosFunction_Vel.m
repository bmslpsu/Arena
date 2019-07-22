function [func,deg,tt] = MakePosFunction_Vel(vel,T,Fs,wrap,root,debug)
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
tt      = linspace(0,T,T*Fs);   % time [s]
pos     = vel*tt;               % position [deg]
func    = deg2panel(pos) + 1;	% panel position starting from 1 [panel#]

if wrap
    func = wrapTo2Pi(deg2rad(3.75*func));
    func = rad2deg(func)/3.75;
end

deg     = 3.75*func;            % panel position [deg]

fname = ['position_function_Ramp_vel_' num2str(vel) '.mat']; % filename

if nargin>=5
    save(fullfile(root,fname), 'func')
    if nargin==6
        if debug
            figure (1) ; clf ; hold on
            plot(tt,pos,'LineWidth',2)
            plot(tt,deg,'LineWidth',2)
            xlabel('Time (s)')
            ylabel(['Position (' char(176) ')'])
            legend('Raw','Panel')
        end
    end
end
end