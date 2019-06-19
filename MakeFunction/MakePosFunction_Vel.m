function [func,deg,tt] = MakePosFunction_Vel(vel,T,Fs,root,debug)
%% MakePosFunction_Vel: make position function for a ramp stimulus
%   INPUTS:
%       vel         :   velocity [deg/s]
%       T           :   time [s]
%       Fs        	:   sample rate [Hz]
%       root       	:   root folder to save function
%       debug    	:   show plot boolean
%   OUTPUTS:
%       func    	:   position function [panel#]
%       deg         :   position function [deg#]
%       tt      	:   time vector [s]
%---------------------------------------------------------------------------------------------------------------------------------
tt      = (0:(1/Fs):T)';        % time [s]
pos     = vel*tt;               % position [deg]
func    = deg2panel(pos) + 1;	% panel position starting from 1 [panel#]
deg     = 3.75*func;            % panel position [deg]

fname = ['position_function_Ramp_vel_' num2str(vel) '.mat']; % filename

if nargin>=4
    save(fullfile(root,fname), 'func')
    if nargin==5
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