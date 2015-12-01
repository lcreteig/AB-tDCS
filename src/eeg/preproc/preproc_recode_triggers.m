function EEG = preproc_recode_triggers(EEG, trig, currSession, currBlock)
%PREPROC_RECODE_TRIGGERS: Recode original experiment markers into more
%meaningful values, which can be used to separate trials into conditions
%for further analysis. Code is mostly particular to the AB_tDCS-EEG project
%and will have to be largely rewritten for other studies.
%
% Usage: EEG = PREPROC_RECODE_TRIGGERS(EEG, trig, currSession, currBlock)
%
% Inputs:
%   - EEG: EEGlab structure with EEG data.
%   - trig: structure containing original event markers (see preproc_config.m)
%   - currSession: string with tDCS code of file ('B' or 'D')
%   - currBlock: string with block of file ('pre', 'tDCS', or 'post')
%
% Outputs:
%   - EEG: EEGlab structure containing the recoded event markers.
%
% Called in preprocess.
%
% See also PREPROCESS, PREPROC_CONFIG

sessionIdx = strcmpi(currSession, trig.session);
blockIdx = strcmpi(currBlock, trig.block);
% find triggers to assign in condition labels
trig_noblink_short = trig.conditions{strcmp([trig.tDCS{sessionIdx} '_' trig.block{blockIdx} '_' 'noblink_short'], trig.conditions(:,1)),2}; % get trigger corresponding to 'noblink_short' condition
trig_noblink_long = trig.conditions{strcmp([trig.tDCS{sessionIdx} '_' trig.block{blockIdx} '_' 'noblink_long'], trig.conditions(:,1)),2}; % get trigger corresponding to 'noblink_long' condition
trig_blink_short = trig.conditions{strcmp([trig.tDCS{sessionIdx} '_' trig.block{blockIdx} '_' 'blink_short'], trig.conditions(:,1)),2}; % get trigger corresponding to 'blink_short' condition
trig_blink_long = trig.conditions{strcmp([trig.tDCS{sessionIdx} '_' trig.block{blockIdx} '_' 'blink_long'], trig.conditions(:,1)),2}; % get trigger corresponding to 'blink_long' condition

T1idx = find([EEG.event.type] == trig.T1); % index of events representing T1 onset
T1idxPad = [1 T1idx length([EEG.event.type])]; %include first and last of all events for looping

missingTriggers = 1;
for iEvent = 2:length(T1idxPad)-1 % for every T1
    
    lagMrks = [EEG.event(T1idxPad(iEvent-1):T1idxPad(iEvent)).type]; % find markers between current and previous T1 (or beginning of 1st trial)
    lagIdx = T1idxPad(iEvent-1) + find(lagMrks == trig.streamLag3 | lagMrks == trig.streamLag8) -1; % from these, find the marker signalling stream onset
    
    ansMrks = [EEG.event(T1idxPad(iEvent):T1idxPad(iEvent+1)).type]; % find markers between current and next T1 (or end of last trial)
    T1ansIdx = T1idxPad(iEvent) + find(ansMrks == trig.T2QT1corr)-1; % from these, find the marker signalling T1 was answered correctly
    T2ansIdx = T1idxPad(iEvent) + find(ansMrks == trig.itiT2err | ansMrks == trig.itiT2corr)-1; % also find the marker signalling T2 answer
    
    % if any of these markers are missing (e.g. due to a conflict on the parallel port):
    % not enough information to analyze current trial, so skip
    if any([isempty(lagIdx) isempty(T2ansIdx) isempty(T1ansIdx)])
        if isempty(lagIdx) || isempty(T2ansIdx)
            missingTriggers = missingTriggers +1;
        end
        continue % also skip if T1 was answered incorrectly
    else % get the stream onset and T2 marker values
        lag = EEG.event(lagIdx).type;
        T2ans = EEG.event(T2ansIdx).type;
    end
    
    if T2ans == trig.itiT2corr && lag == trig.streamLag3 % if on present T1 correct trial: T2 correct, lag 3
        EEG.event(T1idxPad(iEvent)).type = trig_noblink_short; % assign matching trigger to T1 onset
    elseif T2ans == trig.itiT2corr && lag == trig.streamLag8 % if on present T1 correct trial: T2 correct, lag 8
        EEG.event(T1idxPad(iEvent)).type = trig_noblink_long;
    elseif T2ans == trig.itiT2err && lag == trig.streamLag3 % if on present T1 correct trial: T2 incorrect, lag 3
        EEG.event(T1idxPad(iEvent)).type = trig_blink_short;
    elseif T2ans == trig.itiT2err && lag == trig.streamLag8 % if on present T1 correct trial: T2 incorrect, lag 8
        EEG.event(T1idxPad(iEvent)).type = trig_blink_long;
    end
end

fprintf(['Total number of trials: %i\n'...
    'Trials missing one or more triggers: %i\n' ...
    'T1 correct trials: %i\n' ...
    'noblink_short trials: %i\n' ...
    'noblink_long trials: %i\n' ...
    'blink_short trials: %i\n' ...
    'noblink_long trials: %i\n'], length(T1idx), missingTriggers, length(T1idx) - missingTriggers - sum([EEG.event.type] == trig.T1), ...
    sum([EEG.event.type] == trig_noblink_short), sum([EEG.event.type] == trig_noblink_long), ...
    sum([EEG.event.type] == trig_blink_short), sum([EEG.event.type] == trig_blink_long))
