function EEG = preproc_interp_epochs(EEG, preproc, currSub, currStimID, currBlock)
%PREPROC_INTERP_EPOCHS: Interpolates specified channels only on specified
%epochs. Channels and epoch numbers are specified in epochs2interp.m
%
% Usage: EEG = PREPROC_INTERP_EPOCHS(EEG, preproc, currSub, currStimID, currBlock)
%
% Inputs:
%   - EEG: EEGlab structure with EEG data.
%   - preproc: structure with preprocessing parameters
%   - currSub: string with subject ID of file (e.g. 'S01' or 'S18')
%   - currStimID: string with stimulation ID of session ('Y' or 'X')
%   - currBlock: string with block of file ('pre', 'tDCS', or 'post')
%
% Outputs:
%   - EEG: EEGlab structure with interpolated epochs
%
% Called in preprocess; calls epochs2interp, chans2interp, blocked_chans, 
% bad_chans and eeg_interp_trials
%
% See also EPOCHS2INTERP, CHANS2INTERP, BLOCKED_CHANS, BAD_CHANS, EEG_INTERP_TRIALS, PREPROCESS, PREPROC_CONFIG

% find channels and trial numbers on which these should be interpolated
[interpEpochChans, interpEpochs] = epochs2interp(currSub, currStimID, currBlock);
[~,interpEpochChanIdx] = ismember(interpEpochChans,{EEG.chanlocs.labels});
assert(all(interpEpochChanIdx), 'At least one channel is not recognized!');

% exclude external channels from interpolation
exclInterpChanIdx = find(ismember({EEG.chanlocs.labels}, {preproc.heogLabel, preproc.veogLabel, preproc.earLabel}));

% exclude already interpolated channels from interpolation
interpChans = chans2interp(currSub, currStimID, currBlock);
if ~isempty(interpChans)
    interpChanIdx = find(ismember({EEG.chanlocs.labels}, interpChans));
    assert(length(interpChans) == length(interpChanIdx), 'At least one channel is not recognized!');
else
    interpChanIdx = [];
end

% exclude blocked channels from interpolation
chansZero = blocked_chans(currSub, currStimID);
chansZeroIdx = find(ismember({EEG.chanlocs.labels}, chansZero));
assert(length(chansZero) == length(chansZeroIdx), 'At least one channel is not recognized!');

% exclude otherwise bad channels from interpolation
chansBad = bad_chans(currSub, currStimID, currBlock);
if ~isempty(chansBad)
    chansBadIdx = find(ismember({EEG.chanlocs.labels}, chansBad));
    assert(length(chansBad) == length(chansBadIdx), 'At least one channel is not recognized!');
else
    chansBadIdx = [];
end

inChans = interpEpochChanIdx;
exclChans = [exclInterpChanIdx interpChanIdx chansZeroIdx chansBadIdx];

if isempty(intersect(inChans, exclChans))
    EEG = eeg_interp_epochs(EEG, inChans, interpEpochs, exclChans);
else
    error('At least one channel is both specified as "to-be interpolated" and "to-be excluded from interpolation"!')
end