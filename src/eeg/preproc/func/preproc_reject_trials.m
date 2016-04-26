function EEG = preproc_reject_trials(EEG, trig, fileDir, rawFile, currSession, currBlock)
%PREPROC_REJECT_TRIALS: Removes trials previously marked for rejection and
%prints statistics on rejected trials.
%
% Usage: EEG = PREPROC_REJECT_TRIALS(EEG, trig, fileDir, rawFile, currSession, currBlock)
%
% Inputs:
%   - EEG: EEGlab structure with EEG data.
%   - trig: structure containing original event markers (see preproc_config.m)
%   - fileDir: string with path to folder with processed eeg data
%   - rawFile: string containing name of this subject/session/block combination (raw data file)
%   - currSession: string with tDCS code of file ('B' or 'D')
%   - currBlock: string with block of file ('pre', 'tDCS', or 'post')
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
else % if nothing works
    error('Could not find list of trials to reject!')
end

sessionIdx = strcmpi(currSession, trig.session);
blockIdx = strcmpi(currBlock, trig.block);

% Calculate and print trial rejection counts
trig_noblink_short = trig.conditions{strcmp([trig.tDCS{sessionIdx} '_' trig.block{blockIdx} '_' 'noblink_short'], trig.conditions(:,1)),2}; % get trigger corresponding to 'noblink_short' condition
trig_noblink_long = trig.conditions{strcmp([trig.tDCS{sessionIdx} '_' trig.block{blockIdx} '_' 'noblink_long'], trig.conditions(:,1)),2}; % get trigger corresponding to 'noblink_long' condition
trig_blink_short = trig.conditions{strcmp([trig.tDCS{sessionIdx} '_' trig.block{blockIdx} '_' 'blink_short'], trig.conditions(:,1)),2}; % get trigger corresponding to 'blink_short' condition
trig_blink_long = trig.conditions{strcmp([trig.tDCS{sessionIdx} '_' trig.block{blockIdx} '_' 'blink_long'], trig.conditions(:,1)),2}; % get trigger corresponding to 'blink_long' condition

noblink_short_idx = zeros(1,EEG.trials);
noblink_long_idx= zeros(1,EEG.trials);
blink_short_idx = zeros(1,EEG.trials);
blink_long_idx = zeros(1,EEG.trials);
for iTrial = 1:EEG.trials
    epochEvents = EEG.epoch(iTrial).eventtype(:); % get all markers in this epoch
    if ismember(trig_noblink_short, epochEvents) % if one of these is the noblink_short marker
        noblink_short_idx(iTrial) = 1; % add to index list
    elseif ismember(trig_noblink_long, epochEvents)
        noblink_long_idx(iTrial) = 1;
    elseif ismember(trig_blink_short, epochEvents)
        blink_short_idx(iTrial) = 1;
    elseif ismember(trig_blink_long, epochEvents)
        blink_long_idx(iTrial) = 1;
    end
end

fprintf(['Rejecting %i (%i%%) of %i trials in total.\n'...
    'Rejecting %i noblink_short trials, which leaves %i trials.\n' ...
    'Rejecting %i noblink_long trials, which leaves %i trials.\n' ...
    'Rejecting %i blink_short trials, which leaves %i trials.\n' ...
    'Rejecting %i blink_long trials, which leaves %i trials.\n'], ...
    numel(rejectedTrials), round(numel(rejectedTrials) / EEG.trials *100), EEG.trials, ...
    numel(intersect(find(noblink_short_idx), rejectedTrials)), numel(find(noblink_short_idx)) - numel(intersect(find(noblink_short_idx), rejectedTrials)), ...
    numel(intersect(find(noblink_long_idx), rejectedTrials)), numel(find(noblink_long_idx)) - numel(intersect(find(noblink_long_idx), rejectedTrials)), ...
    numel(intersect(find(blink_short_idx), rejectedTrials)), numel(find(blink_short_idx)) - numel(intersect(find(blink_short_idx), rejectedTrials)), ...
    numel(intersect(find(blink_long_idx), rejectedTrials)), numel(find(blink_long_idx)) - numel(intersect(find(blink_long_idx), rejectedTrials)) )

% If not already in the EEG structure, add info on rejected trial indices
if ~isfield(EEG, 'rejectedTrials') || isempty(EEG.rejectedTrials)
   EEG.rejectedTrials = zeros(1:EEG.trials);
   EEG.rejectedTrials(rejectedTrials) = 1;
end

EEG = pop_select(EEG, 'notrial', rejectedTrials); %actually remove the marked trials