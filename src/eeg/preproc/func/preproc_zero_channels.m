function EEG = preproc_zero_channels(EEG, currSub, currStimID, currBlock, stage)
%PREPROC_ZERO_CHANNELS: Sets values of all samples in channels that were
%not recorded from to zero.
%
% Usage: EEG = PREPROC_ZERO_CHANNELS(EEG, currSub, currStimID, currBlock, stage)
%
% Inputs:
%   - EEG: EEGlab structure with EEG data.
%   - currSub: string with subject ID of file (e.g. 'S01' or 'S18')
%   - currStimID: string with stimulation ID of session ('Y' or 'X')
%   - currBlock: string with block of file ('pre', 'tDCS', or 'post')
%   - Stage: either 1 (for known bad channels - because no data was 
%     recorded for example) or 2 (for channels marked as bad after data
%     inspection).
%
% Outputs:
%   - EEG: EEGlab structure with zero'd out data for specified channels.
%
% Called in preprocess; calls either blocked_chans or bad_chans
%
% See also BLOCKED_CHANS, BAD_CHANS, PREPROCESS, PREPROC_CONFIG

if stage == 1
    chansZero = blocked_chans(currSub, currStimID); % get names of channels to zero
elseif stage == 2
    chansZero = bad_chans(currSub, currStimID, currBlock); % get names of channels to zero
end

if ~isempty(chansZero)
    chansZeroIdx = ismember({EEG.chanlocs.labels}, chansZero); % find indices in chanlocs structure
    assert(length(chansZero) == sum(chansZeroIdx), 'At least one channel is not recognized!');
    EEG.data(chansZeroIdx, :) = 0; % set all samples on these channels to zero
end