function [VID,SRC] = Basler_acA640_750um(nFrame)
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
    nFrame = 1;
    trig_mode = 'off';
elseif nargin==1
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
% SRC.AcquisitionFrameRateEnable = 'False';
% SRC.AcquisitionFrameRate = 200;
SRC.ExposureTime = 9500;
SRC.Gamma = 0.6199951171875;
SRC.Gain = 12.009207563363388;
SRC.BlackLevel = 0;

% Configure Trigger
SRC.TriggerMode = trig_mode;
if strcmp(SRC.TriggerMode,'on')
    SRC.LineSelector = 'Line1';
    SRC.TriggerActivation = 'RisingEdge';
    SRC.TriggerSelector = 'FrameStart';
    SRC.ExposureMode = 'TriggerWidth';
elseif strcmp(SRC.TriggerMode,'Off')
    SRC.ExposureMode = 'Timed';
    SRC.ExposureTime = 9500;
end

fprintf('Basler_acA640_750um: \n')
if strcmp(trig_mode,'on')
    fprintf(' Frames: %i \n',VID.TriggerRepeat + 1)    
end

end