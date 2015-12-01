function EEG = preproc_interp_epochs(EEG, preproc, currSub, currSession, currBlock)
%PREPROC_INTERP_EPOCHS: Interpolates specified channels only on specified
%epochs. Channels and epoch numbers are specified in epochs2interp.m
%
% Usage: EEG = PREPROC_INTERP_EPOCHS(EEG, preproc, currSub, currSession, currBlock)
%
% Inputs:
%   - EEG: EEGlab structure with EEG data.
%   - preproc: structure with preprocessing parameters
%   - currSub: string with subject ID of file (e.g. 'S01' or 'S18')
%   - currSession: string with tDCS code of file ('B' or 'D')
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
[interpEpochChans, interpEpochs] = epochs2interp(currSub, currSession, currBlock);
interpEpochChanIdx = find(ismember({EEG.chanlocs.labels}, interpEpochChans));

% exclude external channels from interpolation
exclInterpChanIdx = find(ismember({EEG.chanlocs.labels}, {preproc.heogLabel, preproc.veogLabel, preproc.earLabel}));

% exclude already interpolated channels from interpolation
interpChans = chans2interp(currSub, currSession, currBlock);
if ~isempty(interpChans)
    interpChanIdx = find(ismember({EEG.chanlocs.labels}, interpChans));
else
    interpChanIdx = [];
end

% exclude blocked channels from interpolation
chansZero = blocked_chans(currSub, currSession);
chansZeroIdx = find(ismember({EEG.chanlocs.labels}, chansZero));

% exclude otherwise bad channels from interpolation
chansBad = bad_chans(currSub, currSession, currBlock);
if ~isempty(chansBad)
    chansBadIdx = find(ismember({EEG.chanlocs.labels}, chansBad));
else
    chansBadIdx = [];
end

inChans = interpEpochChanIdx;
exclChans = [exclInterpChanIdx interpChanIdx chansZeroIdx chansBadIdx];

if isempty(intersect(inChans, exclChans))
    EEG = eeg_interp_trials(EEG, inChans, 'spherical', interpEpochs, exclChans);
else
    error('At least one channel is both specified as "to-be interpolated" and "to-be excluded from interpolation"!')
end