function [check] = nested_trial_check(rootdir,thresh)
%% nested_trial_check: checks how many trials correspond to fly-category combinations
%   INPUTS:
%       rootdir  	:   location of files to rename
%       thresh      :   minimum # of trials
%   OUTPUTS:
%       -
%---------------------------------------------------------------------------------------------------------------------------------
% rootdir = 'H:\EXPERIMENTS\Experiment_Asymmetry_Control\LowContrast\';
% thresh = 3;
%---------------------------------------------------------------------------------------------------------------------------------
%%
[files, ~] = uigetfile({'*.mat', 'files'},'Select files',rootdir,'MultiSelect','on');
if ischar(files)
    FILES{1} = files;
else
    FILES = files';
end
clear files

[~,I,N,~] = GetFileData(FILES);

V = nan(N{1,1},N{1,3}); % fly-catg array
for kk = 1:N{1,1}
    for jj = 1:N{1,3}
        idx = (I{:,1}==kk) & (I{:,3}==jj); % check category for one fly
        count = sum(idx); % trialks per category
        V(kk,jj) = count; % store in array
    end
end

check = 0;
for kk = 1:N{1,1}
    if all(V(kk,:)>=thresh) % count how many flies pass trial threshold
        check = check + 1;
    end
end
disp('3++')
disp(check)

disp('DONE')
end