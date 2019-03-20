function [] = MakePosFunction_Chirp(root,FI,FE,A,T,Fs,centPos,rmp,method,showplot)
%% MakePosFunction_Chirp: makes chirp position function
%   INPUTS:
%       root:       :   root directory to save position function file
%       FI          :   start frequency [Hz]
%       FE          :   end frequency [Hz]
%       A           :   amplitude (+/-) [deg]
%       T           :   total time [s]
%       Fs          :   sampling Frequency [Hz]
%       centPos     :   pixel # at center of panel
%       rmp         :   (1 = ramp up , -1 = ramp down)
%       method      :   linear, logarithmic, etc. (see chirp.m)
%       showplot  	:   boolean (1 = show pos vs time)
%       saveFunc  	:   boolean (1 = save function to root)
%   OUTPUTS:
%       - 
%% DEBUGGING %%
%---------------------------------------------------------------------------------------------------------------------------------
% clear ; close all ; clc
% root        = 'C:\BC\Git\Arena\Functions\';
% FI          = 0.1;
% FE          = 12;
% A           = 15;
% T           = 20;
% Fs          = 200;
% centPos     = 15;
% rmp         = 1;
% method      = 'Logarithmic';
% showplot    = 1;
%% Generate Chirp Signal %%
%---------------------------------------------------------------------------------------------------------------------------------
tt = (0:1/Fs:T)';  % time vector [s]
Func.deg = A*chirp(tt,FI,T,FE,method); % chirp signal [deg]
% phi = 0;
% instPhi = T/log(FE/FI)*(FI*(FE/FI).^(tt/T)-FI);
% Func.deg = A*cos(2*pi * (instPhi + phi/360)); % chirp signal [deg]

if rmp==1
elseif rmp==-1
    Func.deg = flipud(Func.deg); % change direction to ramp down
else
    error('rmp must be 1 or -1')
end

Func.panel = 3.75*round(Func.deg/3.75); % convert to setps [deg]
% Chirp Position Plot
if showplot
    figure ; clf ; hold on ; box on ; title('Chirp Position')
        plot(tt,Func.deg,'k','LineWidth',1)
        plot(tt,Func.panel,'b','LineWidth',1)
        xlabel('Time (s)')
        legend('deg','panel')
end
%% Generate FFT %%
%---------------------------------------------------------------------------------------------------------------------------------
if showplot
    figure ; clf
    [Fv1, Mag1 , Phase1] = FFT(tt,Func.deg);
    [Fv2, Mag2 , Phase2] = FFT(tt,Func.panel);
    
    subplot(211) ; hold on ; box on
        ylabel('Magnitude (deg)')
        xlabel('Frequency (Hz)')
        plot(Fv1,Mag1,'k','LineWidth',2);
        plot(Fv2,Mag2,'b','LineWidth',1);
      	plot([FE FE],[0 max(Mag1)],'--r')
        plot([FI FI],[0 max(Mag1)],'--r')
        xlim([0 FE+0.1*FE])
    	legend('deg','panel','limits')

    subplot(212) ; hold on ; box on
        ylabel('Phase (rad)')
        xlabel('Frequency (Hz)')
        plot(Fv1,Phase1,'k','LineWidth',2);
        plot(Fv2,Phase2,'b','LineWidth',1);
      	plot([FE FE],[min(Phase1) max(Phase1)],'--r')
    	plot([FI FI],[min(Phase1) max(Phase1)],'--r')
        xlim([0 FE+0.1*FE])
end
%% Spectogram %%
%---------------------------------------------------------------------------------------------------------------------------------
if showplot
    figure (3) ; clf
    spectrogram(Func.deg,100,80,100,Fs,'yaxis')
    ylim([0 FE+1])
    xlim([0 T])
    rotate3d on
end
%% Save Fucntion %%
%---------------------------------------------------------------------------------------------------------------------------------
func  = (Func.panel/3.75) + centPos; % convert to panel adress
fname = sprintf('position_function_Chirp_%s_amp_%1.1f_freq_%1.1f_%1.1f_fs_%i_T_%1.1f.mat',method,A,FI,FE,Fs,T);
save([root fname], 'func');
end

%% FUNCTION:    FFT
function [Fv, Mag , Phase] = FFT(t,x)
%---------------------------------------------------------------------------------------------------------------------------------
% FFT: Transforms time domian data to frequency domain
    % INPUTS:
        % t: time data
        % x: pos/vel data
	% OUTPUTS
        % Fv: frequency vector
        % Mag: magniude of fft
        % Phase: phase of fft
%---------------------------------------------------------------------------------------------------------------------------------      
    Fs = 1/(mean(diff(t)));                 % Sampling frequency [Hz]
    L = length(t);                          % Length of signal
    Fn = Fs/2;                           	% Nyquist Frequency
    fts = fft(x)/L;                        	% Normalised Fourier Transform
    Fv = (linspace(0, 1, fix(L/2)+1)*Fn)';  % Frequency Vector
    Iv = 1:length(Fv);                  	% Index Vector
    
    Mag = abs(fts(Iv))*2;                   % Magnitude
    Phase = (angle(fts(Iv)));               % Phase
%---------------------------------------------------------------------------------------------------------------------------------
end