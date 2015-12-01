function EEG = preproc_interp_channels(EEG, preproc, currSub, currSession, currBlock)
%PREPROC_INTERP_CHANNELS: Interpolates specified channels in their entirety
%(i.e. over all epochs). Channels are specified in chans2interp.m
%
% Usage: EEG = PREPROC_INTERP_CHANNELS(EEG, preproc, currSub, currSession, currBlock)
%
% Inputs:
%   - EEG: EEGlab structure with EEG data.
%   - preproc: structure with preprocessing parameters
%   - currSub: string with subject ID of file (e.g. 'S01' or 'S18')
%   - currSession: string with tDCS code of file ('B' or 'D')
%   - currBlock: string with block of file ('pre', 'tDCS', or 'post')
%
% Outputs:
%   - EEG: EEGlab structure with interpolated channels
%
% Called in preprocess; calls chans2interp, blocked_chans, bad_chans and
% eeg_interp_excl
%
% See also CHANS2INTERP, BLOCKED_CHANS, BAD_CHANS, EEG_INTERP_EXCL, PREPROCESS, PREPROC_CONFIG

interpChans = chans2interp(currSub, currSession, currBlock); % get names of channels that are marked for interpolation
interpChanIdx = find(ismember({EEG.chanlocs.labels}, interpChans));

% exclude external channels from interpolation
exclInterpChanIdx = find(ismember({EEG.chanlocs.labels}, {preproc.heogLabel, preproc.veogLabel, preproc.earLabel}));

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

inChans = interpChanIdx;
exclChans = [exclInterpChanIdx chansZeroIdx chansBadIdx];

if isempty(intersect(inChans, exclChans))
    EEG = eeg_interp_excl(EEG, inChans, exclChans);
else
    error('At least one channel is both specified as "to be interpolated" and "to be excluded from interpolation"!')
end
