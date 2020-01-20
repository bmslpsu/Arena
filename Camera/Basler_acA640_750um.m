function [VID,SRC] = Basler_acA640_750um(FPS,Gain,nFrame)
%% Basler_acA640_750um: creates video input object with specififed camera settings
%   INPUTS:
%       FPS         :   frame rate
%       nframe    	:   ftotal frames to log
%       Gain    	:   gain raw
%   OUTPUTS:
%       VID         :   video object
%       SRC         :   source image stream object
%

imaqreset

% Create video object
adaptorName = 'gentl';
deviceID = 1;
vidFormat = 'Mono8';
VID = videoinput(adaptorName, deviceID, vidFormat);

if ~nargin % defaults
    FPS = 100;
    nFrame = 1;
    trig_mode = 'off';
    Gain = 10;
elseif nargin==1 % set FPS
    Gain = 10;
    nFrame = 1;
  	trig_mode = 'off';
elseif nargin==2 % with trigger
    nFrame = 1;
    trig_mode = 'off';
elseif nargin==3
 	trig_mode = 'on';
    triggerconfig(VID, 'hardware','DeviceSpecific','DeviceSpecific')
end

% Set vid parameters
VID.ErrorFcn = @imaqcallback;
VID.LoggingMode = 'memory';
VID.FrameGrabInterval = 1;
VID.FramesPerTrigger = 1;
VID.TriggerRepeat = nFrame - 1;

ROI.x = 512;
ROI.y = 512;
ROI.xoff = (round(672 - ROI.x)/2);
ROI.yoff = (round(512 - ROI.y)/2);
VID.ROIPosition = [ROI.xoff ROI.yoff ROI.x ROI.y];

% Set video source parameters
SRC = get(VID, 'Source');
% SRC.CenterX = 'True';
% SRC.CenterY = 'True';
% SRC.AcquisitionFrameRateEnable = 'False';
% SRC.AcquisitionFrameRate = FPS;
% SRC.ExposureTime = (1/FPS)*10^(6);
% SRC.ExposureTime = 9000;
SRC.Gamma = 0.6199951171875;
SRC.Gain = Gain;
SRC.BlackLevel = 0;

% Configure Trigger
SRC.TriggerMode = trig_mode;
SRC.LineSelector = 'Line1';
SRC.TriggerActivation = 'RisingEdge';
SRC.TriggerSelector = 'FrameStart';
% SRC.ExposureMode = 'Timed';
SRC.ExposureMode = 'TriggerWidth';

fprintf('Basler_acA640_750um: \n FPS: %i \n Frame Rate: %i \n Gain: %i \n Trigger: %s \n',...
    SRC.AcquisitionFrameRate,SRC.ResultingFrameRate,SRC.Gain,SRC.TriggerMode)
if strcmp(trig_mode,'on')
    fprintf(' Frames: %i \n',VID.TriggerRepeat + 1)    
end

end