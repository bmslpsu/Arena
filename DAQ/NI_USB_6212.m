function [s,devices] = NI_USB_6212(rate,AI,AO)
%% NI_USB_6212: creates DAQ session object
%   INPUTS:
%       rate     	:   aquisition rate
%       AI          :   analog input channel #'s
%       AO          :   analog output channel #'s
%   OUTPUTS:
%       s           :   session object
%       devices    	:   DAQ devices object
%---------------------------------------------------------------------------------------------------------------------------------
daqreset

devices = daq.getDevices; % get DAQ ID
s = daq.createSession('ni'); % create session

% Add analog input channels
ch.AI = addAnalogInputChannel(s,devices.ID, AI, 'Voltage');

% Assign AI channel names
chNames = {'Trigger','Pat x-pos','Pat y-pos','L-WBA','R-WBA','WB-Freq'};
for kk = 1:length(ch.AI)
    ch.AI(kk).Name = chNames{AI(kk)};
        % AI1 = AO_0: trigger
        % AI2 = DAC1: x-position of stimulus
        % AI3 = DAC2: y-position of stimulus
        % AI4 = L: left wing beat amplitude
        % AI5 = R: right wing beat amplitude
        % AI6 = FREQ: frequency
end

% Add analog output channels
ch.AO = addAnalogOutputChannel(s,devices.ID, AO, 'Voltage');
ch.AO.Name = 'Trigger';

% Setup Sampling
s.Rate = rate; % samples per second
s.IsContinuous = false;	% continuous data collection until stopped

fprintf('NI_USB_6212: \n Rate: %i \n AI: %s \n AO: %s \n',...
    s.Rate,num2str(AI),num2str(AO))
end