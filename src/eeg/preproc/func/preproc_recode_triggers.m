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

% force event markers to be strings in all cases (only in tDCS blocks they are strings by default, 
% due to 'boundary' events inserted by selection of subset of the continous data).
for i = 1:length({EEG.event.type})
    if ~ischar(EEG.event(i).type)
        EEG.event(i).type = num2str(EEG.event(i).type);
    end
end

T1idx = find(strcmp(trig.T1, {EEG.event.type})); % find all indices of T1 markers
T1idxPad = [1 T1idx length({EEG.event.type})]; %include first and last of all events for looping

missingTriggers = 1;
for iEvent = 2:length(T1idxPad)-1 % for every T1
    
    lagMrks = {EEG.event(T1idxPad(iEvent-1):T1idxPad(iEvent)).type}; % get all markers between current T1 and previous T1 (or data start)
    lagIdx = T1idxPad(iEvent-1) + find(strcmp(trig.streamLag3, lagMrks) | strcmp(trig.streamLag8, lagMrks)) -1; % from these, find the marker signalling stream onset
    
    ansMrks = {EEG.event(T1idxPad(iEvent):T1idxPad(iEvent+1)).type}; % get all markers between current and next T1 (or data end)
    T1ansIdx = T1idxPad(iEvent) + find(strcmp(trig.T2QT1corr, ansMrks))-1; % from these, find the marker signalling T1 was answered correctly
    T2ansIdx = T1idxPad(iEvent) + find(strcmp(trig.itiT2err, ansMrks) | strcmp(trig.itiT2corr, ansMrks))-1; % also find the marker signalling T2 answer
    
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

    if strcmp(T2ans, trig.itiT2corr) && strcmp(lag, trig.streamLag3) % if on present T1 correct trial: T2 correct, lag 3
        EEG.event(T1idxPad(iEvent)).type = trig_noblink_short; % assign matching trigger to T1 onset
    elseif strcmp(T2ans, trig.itiT2corr) && strcmp(lag, trig.streamLag8) % if on present T1 correct trial: T2 correct, lag 8
        EEG.event(T1idxPad(iEvent)).type = trig_noblink_long;
    elseif strcmp(T2ans, trig.itiT2err) && strcmp(lag, trig.streamLag3) % if on present T1 correct trial: T2 incorrect, lag 3
        EEG.event(T1idxPad(iEvent)).type = trig_blink_short;
    elseif strcmp(T2ans, trig.itiT2err) && strcmp(lag, trig.streamLag8) % if on present T1 correct trial: T2 incorrect, lag 8
        EEG.event(T1idxPad(iEvent)).type = trig_blink_long;
    end
end

fprintf(['Total number of trials: %i\n'...
    'Trials missing one or more triggers: %i\n' ...
    'T1 correct trials: %i\n' ...
    'noblink_short trials: %i\n' ...
    'noblink_long trials: %i\n' ...
    'blink_short trials: %i\n' ...
    'noblink_long trials: %i\n'], length(T1idx), missingTriggers, length(T1idx) - missingTriggers - sum(strcmp(trig.T1, {EEG.event.type})), ...
    sum(strcmp(trig_noblink_short, {EEG.event.type})), sum(strcmp(trig_noblink_long, {EEG.event.type})), ...
    sum(strcmp(trig_blink_short, {EEG.event.type} )), sum(strcmp(trig_blink_long, {EEG.event.type})))