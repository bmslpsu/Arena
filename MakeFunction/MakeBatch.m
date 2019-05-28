function [] = MakeBatch()
%% MakeBatch: 
%   INPUTS:
%       -
%   OUTPUTS:
%       - 

%% Make Chirp Functions
%---------------------------------------------------------------------------------------------------------------------------------
clear ; close all ; clc
root        = 'C:\BC\Git\Arena\Functions\';
FI          = 0.1;
FE          = 12;
A           = 3.75*[2 3 4 5];
T           = 20;
Fs          = 200;
centPos     = 15;
rmp         = 1;
method      = 'Logarithmic';
showplot    = true;

for kk = 1:length(A)
   MakePosFunction_Chirp(root,FI,FE,A(kk),T,Fs,centPos,rmp,method,showplot)
   pause(0.5)
   close all
end

%% Make SOS Functions
%---------------------------------------------------------------------------------------------------------------------------------
clear ; close all ; clc
root        = 'C:\Users\boc5244\Documents\GitHub\Arena\Functions\';
% F           = [1.3 2.5 4.7 7.0 11.3 14]';
F           = [1 9.6];
N           = length(F);
N           = 5;
% F = logspace((log(F(1))/log(10)),(log(F(2))/log(10)),N)'; % logarithmically spaced frequency vector [Hz]
F = linspace(F(1),F(2),N)'; % linearly spaced frequency vector [Hz]
F = 0.1*round(F/0.1); % round frequencies to prime harmonics [Hz]
a1        	= 11.25;
a2          = 3.75;
A           = logspace((log(a1)/log(10)),(log(a2)/log(10)),N)';
A           = [9;5;3;2;1];
% A           = 100./(2*pi*F);
% A           = [11.25 3.75 3.75 3.75 3.75];
T           = 20;
Fs          = 200;
centPos     = 15;
showplot    = true;

vel = 2*pi*F.*A
%%
func = MakePosFunction_SOS(F,A,T,Fs,centPos,showplot,root);

tt = (0:(1/Fs):T)';
figure ; hold on
dv = [0;diff(func.deg)./diff(tt)];
plot(tt,dv)
end
