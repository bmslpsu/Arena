function [] = MakePosFunction_SOS(root,F,N,A,T,Fs,centPos,showplot,saveFunc)
% MakePosFunction_SOS: makes sum-of-sine position function
%   INPUTS:
%       root:       :   root directory to save position function file
%       F           :   frequency range vector [Hz]
%       N           :   # of frequencies
%       A           :   amplitude (+/-) [deg]
%       T           :   total time [s]
%       Fs          :   sampling Frequency [Hz]
%       centPos     :   pixel # at cneter of panel
%       showplot  	:   boolean (1 = show pos vs time)
%       saveFunc  	:   boolean (1 = save function to root)
%   OUTPUTS:
%       - 
%% DEBUGGING %%
%---------------------------------------------------------------------------------------------------------------------------------
% clear ; close all ; clc
% root        = 'Q:\Box Sync\Research\Redundant Control\Head Frequency Response\Arena Functions\Chirp\';
% F           = [0.1 12];
% N           = 15;
% A           = 2*ones(N,1);
% T           = 20;
% Fs          = 100;
% centPos     = 14;
% showplot    = 1;
%% Generate Chirp Signal %%
%---------------------------------------------------------------------------------------------------------------------------------
tt = (0:1/Fs:T)';  % time vector [s]
% f = logspace((log(F(1))/log(10)),(log(F(2))/log(10)),N)'; % frequency vector [Hz]
f = linspace(F(1),F(2),N); % frequency vector [Hz]
f = 0.05*round(f/0.05); % round frequencies to prime harmonics
Phase = deg2rad(randi(359,N,1)); % phase [deg]

X = zeros(length(tt),1);
for kk = 1:N
   X = X + A(kk)*sin(2*pi*f(kk)*tt + Phase(kk)); 
end

Func.deg = X; % sum-of-sine [deg]

Func.panel = 3.75*round(Func.deg/3.75); % convert deg to panel position
% SOS Position Plot
if showplot
    figure ; clf ; hold on ; box on ; title('SOS Position')
        plot(tt,Func.deg,'k','LineWidth',1)
        plot(tt,Func.panel,'b','LineWidth',2)
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
        xlim([0 F(2)+1])
    	legend('deg','panel')

    subplot(212) ; hold on ; box on
        ylabel('Phase (rad)')
        xlabel('Frequency (Hz)')
        plot(Fv1,Phase1,'k','LineWidth',2);
        plot(Fv2,Phase2,'b','LineWidth',1);
        xlim([0 F(2)+1])
end

%% Save Fucntion %%
%---------------------------------------------------------------------------------------------------------------------------------
if saveFunc
    func  = Func.panel + centPos;
	% Name file
    strFreq = '';
    for kk = 1:length(f)
       strFreq = [strFreq  num2str(f(kk)) '_'];
    end
    strFreq = strtrim(strFreq);
    fname = sprintf(['position_function_SOS_T_%1.1f_freq_' strFreq '.mat'],T);
    save([ root fname], 'func');
end
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