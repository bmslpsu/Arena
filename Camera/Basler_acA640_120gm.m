function [VID,SRC] = Basler_acA640_120gm(FPS,nFrame)
%% Basler_acA640_120gm: creates video input object with specififed camera settings
%   INPUTS:
%       FPS         :   frame rate
%       nframe    	:   ftotal frames to log
%   OUTPUTS:
%       VID         :   video object
%       SRC         :   source image stream object
%---------------------------------------------------------------------------------------------------------------------------------
imaqreset

% Create video object
adaptorName = 'gige';
deviceID = 1;
vidFormat = 'Mono8';
VID = videoinput(adaptorName, deviceID, vidFormat);

if ~nargin % defaults
    FPS = 100;
    nFrame = 1;
    trig_mode = 'off';
elseif nargin==1 % set FPS
    nFrame = 1;
	trig_mode = 'off';
elseif nargin==2 % with trigger
 	trig_mode = 'on';
    triggerconfig(VID, 'hardware','DeviceSpecific','DeviceSpecific')
end

% Set vid parameters
VID.ErrorFcn =  @imaqcallback;
VID.LoggingMode = 'memory';
VID.FrameGrabInterval = 1;
VID.FramesPerTrigger = 1;
VID.TriggerRepeat = nFrame - 1;

ROI.x = 500;
ROI.y = 250;
ROI.xoff = (round(659 - ROI.x)/2);
ROI.yoff = (round(494 - ROI.y)/2);
VID.ROIPosition = [ROI.xoff ROI.yoff ROI.x ROI.y];

% Set video source parameters
SRC = get(VID, 'Source');
% SRC.AcquisitionFrameRateAbs = FPS;
SRC.AcquisitionFrameRateEnable = 'False';
SRC.Gamma = 0.386367797851563;
SRC.GainRaw = 600;
SRC.ExposureTimeAbs = 0.9*(1/FPS)*1e6;
% SRC.ExposureTimeRaw = 0.9*(1/FPS)*1e6;

% Configure Trigger
SRC.TriggerMode = trig_mode;
SRC.LineSelector = 'Line1';
SRC.TriggerActivation = 'RisingEdge';
SRC.TriggerSelector = 'FrameStart';
% SRC.ExposureMode = 'Timed';

fprintf('Basler_acA640_120gm: \n FPS: %i \n Exposure Time: %i \n Gain: %i \n Trigger: %s \n',...
    SRC.AcquisitionFrameRateAbs,SRC.ExposureTimeAbs,SRC.GainRaw,SRC.TriggerMode)
end