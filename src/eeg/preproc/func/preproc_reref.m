function EEG = preproc_reref(EEG, refChans, exclChans)
% PREPROC_REREF: Re-reference EEG data to specified reference channels.
%
% Usage: EEG = PREPROC_REREF(EEG, refChans, exclChans)
%
% Inputs:
%   - EEG: EEGlab structure with EEG data.
%   - refChans: cell array of strings with names of channels to re-reference
%     too (e.g. "{'EXG3','EXG4'}").
%   - exclChans: cell array of strings with names of channels to exclude
%     from re-referencing (e.g. {'EXG1', 'EXG2', 'EXG5', 'EXG6'}).
%
% Outputs:
%   - EEG: EEGlab structure with re-referenced EEG data.
%
% Called in preprocess; calls pop_reref.
%
% See also PREPROCESS, PREPROC_CONFIG, POP_REREF

if strcmp(EEG.subject, 'S11') && strcmp(EEG.session, 'B') && strcmp(EEG.condition, 'tDCS') % for this file, EXG3 was bad, so use only 1 channel as a reference
    [~,refChanIdx] = find(strcmp('EXG4', {EEG.chanlocs.labels})); 
else
    [~,refChanIdx] = ismember(refChans, {EEG.chanlocs.labels}); % indices of reference channels (earlobes)
end

EEG.data = double(EEG.data);
[~,exclChanIdx] = ismember(exclChans, {EEG.chanlocs.labels}); % indices of channels to exclude from reference (eye channels)
EEG = pop_reref(EEG, refChanIdx, 'keepref', 'on', 'exclude', exclChanIdx); % re-reference, keeping ref channels in the data set
EEG.data = single(EEG.data);