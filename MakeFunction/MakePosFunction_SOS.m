function [] = MakePosFunction_SOS(root,F,N,A,T,Fs,centPos,showplot)
% MakePosFunction_SOS: makes sum-of-sine position function
%   INPUTS:
%       root:       :   root directory to save position function file
%       F           :   frequency range vector [Hz]
%       N           :   # of frequencies
%       A           :   amplitude vector (+/-) [deg]
%       T           :   total time [s]
%       Fs          :   sampling Frequency [Hz]
%       centPos     :   pixel # at center of panel
%       showplot  	:   boolean (1= show pos vs time)
%       saveFunc  	:   boolean (1= save function to root)
%   OUTPUTS:
%       - 
%% DEBUGGING %%
%---------------------------------------------------------------------------------------------------------------------------------
% clear ; close all ; clc
% root        = 'Q:\Box Sync\Git\Arena\Functions\';
% F           = [0.1 8];
% N           = 10;
% % A           = 2*ones(N,1);
% A           = logspace((log(5)/log(10)),(log(1)/log(10)),N)';
% T           = 20;
% Fs          = 100;
% centPos     = 15;
% showplot    = 1;
%% Generate SOS Signal %%
%---------------------------------------------------------------------------------------------------------------------------------
tt = (0:1/Fs:T)';  % time vector [s]
% f = logspace((log(F(1))/log(10)),(log(F(2))/log(10)),N)'; % logarithmically spaced frequency vector [Hz]
f = linspace(F(1),F(2),N); % linearly spaced frequency vector [Hz]
f = 0.05*round(f/0.05); % round frequencies to prime harmonics [Hz]
Phase = deg2rad(randi(359,N,1)); % random initial phase [deg]

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
        xlim([0 F(2)+1])
    	legend('deg','panel')

    subplot(212) ; hold on ; box on
        ylabel('Phase (rad)')
        xlabel('Frequency (Hz)')
        plot(Fv1,Phase1,'k','LineWidth',2);
        plot(Fv2,Phase2,'b','LineWidth',1);
        xlim([0 F(2)+1])
        xticks(f)
        
        for kk = 1:N
           plot([f(kk) f(kk)],6*[-1 1] , '--r')
        end
end
%% Spectogram %%
%---------------------------------------------------------------------------------------------------------------------------------
if showplot
    figure (3) ; clf
    spectrogram(Func.deg,100,80,100,Fs,'yaxis')
    ylim([0 F(end)+1])
    xlim([0 T])
    rotate3d on
end
%% Save Fucntion %%
%---------------------------------------------------------------------------------------------------------------------------------
func  = (Func.panel/3.75) + centPos;
% Name file
strFreq = '';
for kk = 1:length(f)
   strFreq = [strFreq  num2str(f(kk)) '_'];
end
strFreq = strtrim(strFreq);
fname = sprintf(['position_function_SOS_fs_%1.1f_T_%1.1f_freq_' strFreq '.mat'],Fs,T);
save([ root fname], 'func');
end