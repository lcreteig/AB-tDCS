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
currFile = [trig.tDCS{sessionIdx} '_' trig.block{blockIdx}];

% Extract only the relevant condition labels and triggers (e.g. the "anodal, pre" conditions)
conditionLabels = trig.conditions(strncmp(currFile, trig.conditions(:,1), length(currFile)),:);

% force event markers to be strings in all cases (only in tDCS blocks they are strings by default, 
% due to 'boundary' events inserted by selection of subset of the continous data).
for i = 1:length({EEG.event.type})
    if ~ischar(EEG.event(i).type)
        EEG.event(i).type = num2str(EEG.event(i).type);
    end
end

T1idx = find(strcmp(trig.T1, {EEG.event.type})); % find all indices of T1 markers
T1idxPad = [1 T1idx length({EEG.event.type})]; %include first and last of all events for looping

missingTriggers = 0;
for iEvent = 2:length(T1idxPad)-1 % for every T1
    
    lagMrks = {EEG.event(T1idxPad(iEvent-1):T1idxPad(iEvent)).type}; % get all markers between current T1 and previous T1 (or data start)
    lagIdx = T1idxPad(iEvent-1) + find(strcmp(trig.streamLag3, lagMrks) | strcmp(trig.streamLag8, lagMrks)) -1; % from these, find the marker signalling stream onset
    
    ansMrks = {EEG.event(T1idxPad(iEvent):T1idxPad(iEvent+1)).type}; % get all markers between current and next T1 (or data end)
    T1ansIdx = T1idxPad(iEvent) + find(strcmp(trig.T2QT1corr, ansMrks) | strcmp(trig.T2QT1err, ansMrks)) -1; % from these, find the marker signalling T1 answer
    T2ansIdx = T1idxPad(iEvent) + find(strcmp(trig.itiT2corr, ansMrks) | strcmp(trig.itiT2err, ansMrks)) -1; % T2 answer
    
    % if any of these markers are missing (e.g. due to a conflict on the parallel port):
    % not enough information to analyze current trial, so skip
    if any([isempty(lagIdx) isempty(T2ansIdx) isempty(T1ansIdx)])
        missingTriggers = missingTriggers +1;
        continue
    else % get the stream onset, T1 and T2 marker values
        lag = EEG.event(lagIdx).type;
        T1ans = EEG.event(T1ansIdx).type;
        T2ans = EEG.event(T2ansIdx).type;  
    end
    
    % lag 3, T1 correct, T2 correct - NOBLINK
    if strcmp(lag, trig.streamLag3) && strcmp(T1ans, trig.T2QT1corr) && strcmp(T2ans, trig.itiT2corr)
         EEG.event(T1idxPad(iEvent)).type = conditionLabels{strcmp([currFile '_' 'short_T1corr_T2corr'], conditionLabels(:,1)) ,2};
    % lag 3, T1 correct, T2 error - BLINK
    elseif  strcmp(lag, trig.streamLag3) && strcmp(T1ans, trig.T2QT1corr) && strcmp(T2ans, trig.itiT2err)
          EEG.event(T1idxPad(iEvent)).type = conditionLabels{strcmp([currFile '_' 'short_T1corr_T2err'], conditionLabels(:,1)) ,2};
    % lag 3, T1 error, T2 correct
    elseif  strcmp(lag, trig.streamLag3) && strcmp(T1ans, trig.T2QT1err) && strcmp(T2ans, trig.itiT2corr)
          EEG.event(T1idxPad(iEvent)).type = conditionLabels{strcmp([currFile '_' 'short_T1err_T2corr'], conditionLabels(:,1)) ,2};
    % lag 3, T1 error, T2 error
    elseif  strcmp(lag, trig.streamLag3) && strcmp(T1ans, trig.T2QT1err) && strcmp(T2ans, trig.itiT2err)
          EEG.event(T1idxPad(iEvent)).type = conditionLabels{strcmp([currFile '_' 'short_T1err_T2err'], conditionLabels(:,1)) ,2};
    % lag 8, T1 correct, T2 correct - NOBLINK
    elseif  strcmp(lag, trig.streamLag8) && strcmp(T1ans, trig.T2QT1corr) && strcmp(T2ans, trig.itiT2corr)
          EEG.event(T1idxPad(iEvent)).type = conditionLabels{strcmp([currFile '_' 'long_T1corr_T2corr'], conditionLabels(:,1)) ,2};
    % lag 8, T1 correct, T2 error - BLINK
    elseif  strcmp(lag, trig.streamLag8) && strcmp(T1ans, trig.T2QT1corr) && strcmp(T2ans, trig.itiT2err)
          EEG.event(T1idxPad(iEvent)).type = conditionLabels{strcmp([currFile '_' 'long_T1corr_T2err'], conditionLabels(:,1)) ,2};
    % lag 8, T1 error, T2 correct
    elseif  strcmp(lag, trig.streamLag8) && strcmp(T1ans, trig.T2QT1err) && strcmp(T2ans, trig.itiT2corr)
          EEG.event(T1idxPad(iEvent)).type = conditionLabels{strcmp([currFile '_' 'long_T1err_T2corr'], conditionLabels(:,1)) ,2};
    % lag 8, T1 error, T2 error
    elseif  strcmp(lag, trig.streamLag8) && strcmp(T1ans, trig.T2QT1err) && strcmp(T2ans, trig.itiT2err)
          EEG.event(T1idxPad(iEvent)).type = conditionLabels{strcmp([currFile '_' 'long_T1err_T2err'], conditionLabels(:,1)) ,2};
    end
    
    % Events during ramp-down:
    if strcmp(currBlock, 'tDCS')
        trigTime = (EEG.event(T1idxPad(iEvent)).latency-1)/EEG.srate; % time trigger occurs in seconds
        % if this is during the ramp-down (which lasts for 60 seconds)
        if trigTime > (EEG.event(end).latency-1)/EEG.srate - 60 %  the final trigger in the dataset should be just before ramp-down end (cut out of data in previous step)
            EEG.event(T1idxPad(iEvent)).type = [EEG.event(T1idxPad(iEvent)).type trig.rampdownCode]; % append value to trigger
        end
    end
    
end

fprintf(['Total number of trials: %i\n'...
    'Trials missing one or more triggers: %i\n' ...
    'T1 correct trials: %i\n'], ...
    length(T1idx), missingTriggers, sum(strcmp(trig.T2QT1corr, {EEG.event.type})));
