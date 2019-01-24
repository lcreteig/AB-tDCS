function EEG = preproc_averef(EEG, preproc, currSub, currStimID, currBlock)
% PREPROC_AVEREF: Re-reference to the average of all (good) scalp channels.
%
% Usage: EEG = PREPROC_AVEREF(EEG, preproc, currSub, currStimID, currBlock)
%
% Inputs:
% Inputs:
%   - EEG: EEGlab structure with EEG data.
%   - preproc: structure with preprocessing parameters
%   - currSub: string with subject ID of file (e.g. 'S01' or 'S18')
%   - currStimID: string with stimulation ID of session ('Y' or 'X')
%   - currBlock: string with block of file ('pre', 'tDCS', or 'post')
%
% Outputs:
%   - EEG: EEGlab structure with re-referenced EEG data.
%
% Called in preprocess; calls blocked_chans, bad_chans, pop_reref.
%
% See also BLOCKED_CHANS, BAD_CHANS, POP_REREF, PREPROCESS, PREPROC_CONFIG

% exclude external channels from average reference
extChanIdx = find(ismember({EEG.chanlocs.labels}, {preproc.heogLabel, preproc.veogLabel, preproc.earLabel}));

% exclude blocked channels from average reference
chansZero = blocked_chans(currSub, currStimID);
chansZeroIdx = find(ismember({EEG.chanlocs.labels}, chansZero));

% exclude otherwise bad channels from average reference
chansBad = bad_chans(currSub, currStimID, currBlock);
if ~isempty(chansBad)
    chansBadIdx = find(ismember({EEG.chanlocs.labels}, chansBad));
else
    chansBadIdx = [];
end

EEG = pop_reref(EEG, [], 'exclude', [extChanIdx chansZeroIdx chansBadIdx]); %re-reference to common average