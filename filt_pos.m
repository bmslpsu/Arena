function [FigPosN, FigPos] = filt_pos(posData, Vel, Direction)
% Filter position data

% DAQ sampling rate
Ds = 1000;
% filter data
Fc = 3.*Vel; % signal is at 10, 20, or 30fps
[b, a] = butter(2, Fc/(Ds/2),'low');
posDataFilt = filtfilt(b, a, posData);

% clean up posdata

% find where jumps from 5 to 0V are
dpos = abs(diff(posData));
dpos(dpos < 1) = 0;
[pks, pind] = findpeaks(dpos, 'MINPEAKHEIGHT', 1);

% make sure that display didn't freeze for entire trial
if ~isempty(pind) == 1
    
    dpos = abs(diff(posDataFilt));
    [pks, sind] = findpeaks(dpos, 'MINPEAKHEIGHT', 0.0015*Vel/10, 'MINPEAKDISTANCE', round(Ds.*(1/Vel/2)));
    
    mm = 1;
    % save first position
    FigPos = nan(length(posDataFilt),1);
    FigPos(1:sind(1)) = mean(posDataFilt(2:(Ds*0.1)+1));
    
    % clean-up position data
    for kk = 1:length(sind)-1
        
        if abs(pind(mm)-sind(kk)) <= round(Ds.*(1/Vel/2)) % if current peak close to transition
            
            if Direction == 1 % clockwise
                
                FigPos(sind(kk):sind(kk+1)) = 5/96; % at transition, force to zero
                
            elseif Direction == -1 % counterclockwise
                
                FigPos(sind(kk):sind(kk+1)) = 5; % at transition, force to 5V
                
            end
            
            
            if mm < length(pind)
                
                mm = mm + 1;
                
            else
                
                mm = length(pind);
                
            end
            
        else
            
            if Direction == 1 %clockwise
                
                FigPos(sind(kk):sind(kk+1)) = FigPos(sind(kk)-1) + 5/96; % add step
                
            elseif Direction == -1 %counterclockwise
                
                FigPos(sind(kk):sind(kk+1)) = FigPos(sind(kk)-1) - 5/96; % substract step
                
            end
            
            
        end
        
        
    end
    
    % add end
    FigPos(sind(kk+1):end) = FigPos(sind(kk));
    
    % convert V to angle
    v2s = 96/5; % 96 positions over 5V
    % s = 3.75;    % 3.75 deg per step
    FigPos = FigPos .* v2s;  % convert to steps
    
    % CLEAN UP
    dposN = abs(diff(FigPos));
    [pks, ssind] = findpeaks(dposN, 'MINPEAKHEIGHT', .1*Vel/10, 'MINPEAKDISTANCE', round(Ds.*(1/Vel/2)));
    FigPosN = nan(length(FigPos),1);
    
    % save first position, dont allow 0
    if FigPos(1) < 1
        
        FigPosN(1:ssind(1)) = 1;
        
    else
        
        FigPosN(1:ssind(1)) = round(FigPos(1));
        
    end
    
    % for each step
    for kk = 1:length(ssind)-1
        
        if Direction == 1 %clockwise
            
            FigPosN(ssind(kk):ssind(kk+1)) = FigPosN(ssind(kk)-1) + 1; % add step
            
            if FigPosN(ssind(kk)) >= 96
                
                FigPosN(ssind(kk):ssind(kk+1)) = 1;
                
            end
            
        elseif Direction == -1 %counterclockwise
            
            FigPosN(ssind(kk):ssind(kk+1)) = FigPosN(ssind(kk)-1) - 1; % substract step
            
            if FigPosN(ssind(kk)) < 1
                
                FigPosN(ssind(kk):ssind(kk+1)) = 96;
                
            end
            
        end
        
    end
    
    % add end
    FigPosN(ssind(kk+1):end) = FigPosN(ssind(kk));
    
end