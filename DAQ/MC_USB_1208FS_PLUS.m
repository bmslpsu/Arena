function [s,devices] = MC_USB_1208FS_PLUS(rate,AI,AO)
%% MC_USB_1208FS_PLUS: creates DAQ session object
%   INPUTS:
%       rate     	:   aquisition rate
%       AI          :   analog input channel #'s
%       AO          :   analog output channel #'s
%   OUTPUTS:
%       s           :   session object
%       devices    	:   DAQ devices object
%

% AI = 0:2;
% AO = 1;
% rate = 2000;

daqreset

devices = daq.getDevices; % get DAQ ID
if isempty(devices)
    error('No DAQ detected')
else
    % disp('DAQ Initialized')
    % get(devices)
end
    
s = daq.createSession('mcc'); % create session

% Add analog input channels
ch.AI = addAnalogInputChannel(s, devices.ID, AI, 'Voltage');

% Assign AI channel names
chNames = {'Trigger_IN','Pat x-pos','Pat y-pos'};
for kk = 1:length(ch.AI)
    ch.AI(kk).Name = chNames{kk};
        % AI0 = AO_0: trigger
        % AI1 = DAC1: x-position of stimulus
        % AI2 = DAC2: y-position of stimulus
end

% Add analog output channels
ch.AO = addAnalogOutputChannel(s,devices.ID, AO, 'Voltage');
ch.AO.Name = 'Trigger_OUT';

% Setup Sampling
s.Rate = rate; % samples per second
s.IsContinuous = false;	% continuous data collection until stopped

fprintf('MC_USB_1208FS_PLUS: \n Rate: %i \n AI: %s \n AO: %s \n',...
    s.Rate,num2str(AI),num2str(AO))
end