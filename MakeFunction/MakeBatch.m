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
root        = 'C:\BC\Git\Arena\Functions\';
F           = [0.1 8];
N           = 10;
a1        	= 5;
a2          = 1;
A           = logspace((log(a1)/log(10)),(log(a2)/log(10)),N)';
T           = 20;
Fs          = 200;
centPos     = 15;
showplot    = true;

MakePosFunction_SOS(root,F,N,A,T,Fs,centPos,showplot)
end
