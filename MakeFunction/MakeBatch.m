function [] = MakeBatch()
%% MakeBatch: 
%   INPUTS:
%       -
%   OUTPUTS:
%       - 

%% Make Chirp Functions
%---------------------------------------------------------------------------------------------------------------------------------
clear ; close all ; clc
root        = 'C:\Users\boc5244\Documents\GitHub\Arena\Functions\';
FI          = 0.1;
FE          = 12;
A           = 3.75*[2 3 4 5];
T           = 20;
Fs          = 100;
centPos     = 15;
rmp         = 1;
method      = 'Logarithmic';
showplot    = 1;


for kk = 1:length(A)
   MakePosFunction_Chirp(root,FI,FE,A(kk),T,Fs,centPos,rmp,method,showplot)
   pause
   close all
end

end
