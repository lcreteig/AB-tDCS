function EEG = preproc_segment_data(EEG, trig, currSub, currBlock, currSession)
%PREPROC_SEGMENT_DATA: Cut out the portion of continuous data before start
%of the ramp-up and after end of the ramp-down in the tDCS block.
%
% Usage: EEG = PREPROC_SEGMENT_DATA(EEG, trig, currSub, currBlock, currSession)
%
% Inputs:
%   - EEG: EEGlab structure with EEG data.
%   - trig: structure containing original event markers (see preproc_config.m)
%   - currSub: string with subject ID of file (e.g. 'S01' or 'S18')
%   - currSession: string with tDCS code of file ('B' or 'D')
%   - currBlock: string with block of file ('pre', 'tDCS', or 'post')
%
% Outputs:
%   - EEG: EEGlab structure with portion of data removed
%
% Called in preprocess; calls pop_select, data_timerange
%
% See also POP_SELECT, DATA_TIMERANGE, PREPROCESS, PREPROC_CONFIG

if strcmp(currBlock, 'tDCS')
    
    endTime = data_timerange(currSub, currSession); % get time before the ramp-down artifact
    
    if ~isempty(endTime) % if there was a ramp-down artifact present
        startTrig = find([EEG.event.type] == str2double(trig.startEEG), 1); % find event corresponding to start of the task
        startTime = (EEG.event(startTrig).latency - 1)/EEG.srate; % convert index to seconds
        EEG = pop_select(EEG, 'time', [startTime-10*(1/EEG.srate) endTime]); % keep data segment from start till specified end, discard rest
    end
end
