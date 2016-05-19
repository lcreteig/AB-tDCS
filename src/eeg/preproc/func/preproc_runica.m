function EEG = preproc_runica(EEG, preproc, currSub, currSession, currBlock)
% PREPROC_RUNICA: Run independent component analysis on EEG data.
%
% Usage: EEG = PREPROC_RUNICA(EEG, preproc, currSub, currSession, currBlock)
%
% Inputs:
%   - EEG: EEGlab structure with EEG data.
%   - preproc: structure with preprocessing parameters
%   - currSub: string with subject ID of file (e.g. 'S01' or 'S18')
%   - currSession: string with tDCS code of file ('B' or 'D')
%   - currBlock: string with block of file ('pre', 'tDCS', or 'post')
%
% Outputs:
%   - EEG: EEGlab structure with independent components in addition to
%   channel data.
%
% Called in preprocess; calls pop_runica, pop_rmbase
%
% See also POP_RUNICA, POP_RMBASE, PREPROCESS, PREPROC_CONFIG,

% Exclude zero'd-out channels from ICA
chansZero = blocked_chans(currSub, currSession); % blocked channels
chansBad = bad_chans(currSub, currSession, currBlock); % otherwise bad channels

% Create list of all channels to include in the ICA
chansICA = setdiff({EEG.chanlocs.labels}, [chansZero chansBad preproc.earLabel]); % also exclude reference channels
chansICAidx = find(ismember({EEG.chanlocs.labels}, chansICA));
assert(length([chansZero chansBad preproc.earLabel]) == length({EEG.chanlocs.labels}) - length(chansICAidx), 'At least one channel is not recognized!');

if preproc.icaBaseline
    EEG = pop_rmbase(EEG, []);
end

if strcmp(preproc.icaType, 'jader')
    EEG = pop_runica(EEG, 'icatype', 'jader', 'dataset', 1, 'options', {40}, 'chanind', chansICAidx);
elseif strcmp(preproc.icaType, 'runica')
    EEG=pop_runica(EEG, 'icatype', 'runica', 'dataset', 1, 'options', {'extended',1}, 'chanind', chansICAidx);
else
    error('Unrecognized ICA type option "%s"!', preproc.icaType)
end

EEG.icaact = []; % delete the ICA activation matrix. It takes up a lot of
%disk space, and only takes seconds to recompute using the saved ICA
%weights.