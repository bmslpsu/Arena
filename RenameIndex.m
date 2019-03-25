function [] = RenameIndex(rootdir,newdir,flyoffset)
%% RenameIndex: loads in data from files, reorganizes data & renames/saves based on index (very specific to Asymmetry data)
%   INPUTS:
%       rootdir  	:   location of files to rename
%       newdir      :   where to save renamed files
%       flyoffset   :   where to start fly #
%   OUTPUTS:
%       -
%---------------------------------------------------------------------------------------------------------------------------------
% rootdir = 'H:\EXPERIMENTS\Experiment_Asymmetry_Control_Verification\HighContrast\0\';
% newdir = 'H:\EXPERIMENTS\Experiment_Asymmetry_Control\HighContrast\0';
% flyoffset = 23;
%---------------------------------------------------------------------------------------------------------------------------------
%%
[files, PATH] = uigetfile({'*.mat', 'files'},'Select files',rootdir,'MultiSelect','on');
if ischar(files)
    FILES{1} = files;
else
    FILES = files';
end
clear files

selpath = uigetdir(newdir,'Destination directory');

[D,I,N,~] = GetFileData(FILES);

for kk = 1:N{1,5}
    data = [];
    load([PATH FILES{kk}],'data','t_p')
    
    interval = (5000/1000);
    WBAdata = data(1:interval:end-1,:)';
    t_p = t_p(1:interval:end-1,:)';
    
    if D{kk,3}>1
        dir = 'CW';
    elseif D{kk,3}<1
        dir = 'CCW';
    end

    filename = sprintf(['fly_%1.0f_trial_%1.0f_%s_%s' '.mat'],I{kk,1}+flyoffset-1,I{kk,2},dir,num2str(D{kk,3}/3.75));

    save([selpath '\' filename],'WBAdata','t_p','-v7.3')
	disp(filename)
end
disp('DONE')
end