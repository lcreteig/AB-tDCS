function EEG = preproc_reject_trials(EEG, fileDir, rawFile)
%PREPROC_REJECT_TRIALS: Removes trials previously marked for rejection and
%prints statistics on rejected trials.
%
% Usage: EEG = PREPROC_REJECT_TRIALS(EEG, fileDir, rawFile)
%
% Inputs:
%   - EEG: EEGlab structure with EEG data.
%   - fileDir: string with path to folder with processed eeg data
%   - rawFile: string containing name of this subject/session/block combination (raw data file)
%
% Outputs:
%   - EEG: EEGlab structure without trials marked for rejection
%
% Called in preprocess; calls pop_select
%
% See also POP_SELECT, PREPROCESS, PREPROC_CONFIG

if ~isempty(EEG.reject.rejmanual) % if rejected trials were marked by hand
    rejectedTrials = find(EEG.reject.rejmanual);
elseif isfield(EEG, 'rejectedTrials') && ~isempty(EEG.rejectedTrials)  % if not, look for a list of trials to remove in the EEG structure
    rejectedTrials = find(EEG.rejectedTrials);
elseif ~isempty(dir(fullfile(fileDir, [rawFile '_' 'rejectedtrials' '_' '*' '.txt']))) % if also not there, load the most recent text file from disk
    rejFile = dir(fullfile(fileDir, [rawFile '_' 'rejectedtrials' '_' '*' '.txt']));
    [~,i] = sort([rejFile.datenum]);
    rejectedTrials = load(fullfile(fileDir, rejFile(i(end)).name));
else
    rejectedTrials = [];
end

% If not already in the EEG structure, add info on rejected trial indices
if ~isfield(EEG, 'rejectedTrials') || isempty(EEG.rejectedTrials)
   EEG.rejectedTrials = zeros(1,EEG.trials);
   EEG.rejectedTrials(rejectedTrials) = 1;
end

if ~isempty(rejectedTrials)
    fprintf('Rejecting %i (%i%%) of %i trials in total.\n', numel(rejectedTrials))
    EEG = pop_select(EEG, 'notrial', rejectedTrials); %actually remove the marked trials
else
    warning('There seems to be no list of trials to reject for %s!. Moving on...', rawFile)
end
    