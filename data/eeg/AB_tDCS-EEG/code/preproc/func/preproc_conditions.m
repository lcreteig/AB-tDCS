function [ALLEEG, conditionLabels] = preproc_conditions(EEG, currStimID, currBlock, trig, epochTime)
%PREPROC_CONDITIONS: Re-epoch data; place into separate EEG structures -
%one for each condition.
%
% Usage: [ALLEEG, conditionLabels] = PREPROC_CONDITIONS(EEG, currStimID, currBlock, trig, epochTime)
%
% Inputs:
%   - EEG: EEGlab structure with EEG data
%   - currStimID: string with stimulation ID of session ('Y' or 'X')
%   - currBlock: string with block of file ('pre', 'tDCS', or 'post')
%   - trig: structure containing original event markers (see preproc_config.m)
%   - epochTime: 2-element vector with boundaries of new epoch, relative to
%   a given event marker [e.g. -1 2.5]
%
% Outputs:
%   - ALLEEG: Array of multiple structures of EEG data.
%   - conditionLabels: #conditions X 2 cell array. First column holds
%   strings with condition descriptor, 2nd column holds the triggers
%   identifying the condition (epochs are cut around these triggers).
%
% Called in preprocess; calls pop_epoch
%
% See also POP_EPOCH, PREPROCESS, PREPROC_CONFIG

sessionIdx = strcmpi(currStimID, trig.session);
blockIdx = strcmpi(currBlock, trig.block);
currFile = [trig.session{sessionIdx} '_' trig.block{blockIdx}];

% Extract only the relevant condition labels and triggers (e.g. the "Y, pre" conditions)
conditionLabels = trig.conditions(strncmp(currFile, trig.conditions(:,1), length(currFile)),:);

ALLEEG=EEG;
for iCond = 1:size(conditionLabels,1)
    ALLEEG(iCond).setname = conditionLabels{iCond,1};
    fprintf('   Working on condition %s...\n', conditionLabels{iCond,1});
    try
        ALLEEG(iCond) = pop_epoch(EEG,conditionLabels(iCond,2), epochTime, 'newname', conditionLabels{iCond,1});
    catch % prevent crash in case there are conditions with 0 trials (can happen for T1 errors / blinks in the long lag)
    end
end