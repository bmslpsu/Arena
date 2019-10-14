function [func,deg,tt] = MakePosFunction_Sine(Freq,A,T,off,Fs,root,debug)
%% MakePosFunction_Sine: make position function for a sinusodial stimulus
%   INPUTS:
%       Freq      	:   frequency [Hz]
%       A           :   amplitude [deg]
%       T           :   time [s]
%       off       	:   offset [panel#]
%       Fs        	:   sample rate [Hz]
%       root       	:   root folder to save function
%       debug    	:   show plot boolean
%   OUTPUTS:
%       func    	:   position function [panel#]
%       deg         :   position function [deg#]
%       tt      	:   time vector [s]
%---------------------------------------------------------------------------------------------------------------------------------
tt      = linspace(0,T,T*Fs)';   % time [s]
pos     = A*sin(2*pi*Freq*tt);	% position [deg]
func    = deg2panel(pos) + 1 + off; % panel position [panel#]

wrap = true;
if wrap
    func = wrapTo2Pi(deg2rad(3.75*func));
    func = rad2deg(func)/3.75;
end
func = uint8(func);

deg = 3.75*func; % panel position [deg]

fname = ['position_function_Sinusoid_Freq_' num2str(Freq) '_Amp_' num2str(A) '_Fs_' num2str(Fs) '.mat']; % filename

if nargin>=6
    save(fullfile(root,fname), 'func')
    if nargin==7
        if debug
            figure ; clf ; hold on
            plot(tt,pos,'LineWidth',2)
            plot(tt,deg,'LineWidth',2)
            xlabel('Time (s)')
            ylabel(['Position (' char(176) ')'])
            legend('Raw','Panel')
            hold off
        end
    end
end
end