function [ALLEEG, conditionLabels] = preproc_conditions(EEG, currSession, currBlock, trig, epochTime)
%PREPROC_CONDITIONS: Re-epoch data; place into separate EEG structures -
%one for each condition.
%
% Usage: [ALLEEG, conditionLabels] = PREPROC_CONDITIONS(EEG, currSession, currBlock, trig, epochTime)
%
% Inputs:
%   - EEG: EEGlab structure with EEG data
%   - currSession: string with tDCS code of file ('B' or 'D')
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

sessionIdx = strcmpi(currSession, trig.session);
blockIdx = strcmpi(currBlock, trig.block);
conditionLabels = cell(4,2);
% Extract part of full condition matrix that is relevant for this session/block combination (e.g. the 4 "anodal, pre" conditions)
conditionLabels(1,:) = trig.conditions(strcmp([trig.tDCS{sessionIdx} '_' trig.block{blockIdx} '_' 'noblink_short'], trig.conditions(:,1)),:);
conditionLabels(2,:) = trig.conditions(strcmp([trig.tDCS{sessionIdx} '_' trig.block{blockIdx} '_' 'noblink_long'], trig.conditions(:,1)),:);
conditionLabels(3,:) = trig.conditions(strcmp([trig.tDCS{sessionIdx} '_' trig.block{blockIdx} '_' 'blink_short'], trig.conditions(:,1)),:);
conditionLabels(4,:) = trig.conditions(strcmp([trig.tDCS{sessionIdx} '_' trig.block{blockIdx} '_' 'blink_long'], trig.conditions(:,1)),:);

ALLEEG=EEG;
for iCond = 1:size(conditionLabels,1)
    try
        ALLEEG(iCond) = pop_epoch(EEG,conditionLabels(iCond,2), epochTime);
    catch % prevent crash in case there are conditions with 0 trials (can happen for blink_long)
    end
end