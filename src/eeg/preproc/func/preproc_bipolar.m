function EEG = preproc_bipolar(EEG, heogChans, heogLabel, veogChans, veogLabel, earChans, earLabel)
% PREPROC_BIPOLAR: Make pairs of external channels into one bipolar channel, 
% by subtracting the two members of a pair
%
% Usage: EEG = PREPROC_BIPOLAR(EEG, heogChans, heogLabel, veogChans, veogLabel, earChans, earLabel)
%
% Inputs:
%   - EEG: EEGlab structure with EEG data.
%   - heogChans: cell array of strings with names of horizontal EOG channels
%     (e.g. {'EXG5', 'EXG6'})
%   - heogLabel: string with name of new horizontal EOG bipolar (e.g. 'HEOG')
%   - veogChans: cell array of strings with names of vertical EOG channels
%     (e.g. {'EXG1', 'EXG2'})
%   - veogLabel: string with name of new vertical EOG bipolar (e.g. 'VEOG')%
%   - earChans: cell array of strings with names of earlobe channels
%     (e.g. {'EXG3', 'EXG4'})
%   - heogLabel: string with name of new ear bipolar (e.g. 'EARREF')
%
% Outputs:
%   - EEG: EEGlab structure containing the bipolar channels instead of the
%     original pairs
%
% Called in preprocess; calls pop_select
%
% See also PREPROCESS, PREPROC_CONFIG, POP_SELECT

% Get indices of channels to be bipolarized
[~,heogIdx] = ismember(heogChans, {EEG.chanlocs.labels});
[~,veogIdx] = ismember(veogChans, {EEG.chanlocs.labels});
[~,refIdx] = ismember(earChans, {EEG.chanlocs.labels});

% Horizontal EOG (HEOG)
EEG.data(heogIdx(1),:) = EEG.data(heogIdx(1),:) - EEG.data(heogIdx(2),:); % change first channel's data into bipolar (subtraction of the two channels)
EEG.chanlocs(heogIdx(1)).labels = heogLabel; % change label accordingly

% Vertical EOG (VEOG)
EEG.data(veogIdx(1),:) = EEG.data(veogIdx(1),:) - EEG.data(veogIdx(2),:);
EEG.chanlocs(veogIdx(1)).labels = veogLabel;

% Reference channels (earlobes)
EEG.data(refIdx(1),:) = EEG.data(refIdx(1),:) - EEG.data(refIdx(2),:);
EEG.chanlocs(refIdx(1)).labels = earLabel;

EEG = pop_select(EEG, 'nochannel', [heogIdx(2), veogIdx(2), refIdx(2)]); % remove the now redundant 2nd member of each pair from the dataset