function EEG = preproc_reject_comps(EEG, fileDir, rawFile)
%PREPROC_REJECT_COMPS: Subtract previously specified independent components
%from the data.
%
% Usage: EEG = PREPROC_REJECT_COMPS(EEG, fileDir, rawFile)
%
% Inputs:
%   - EEG: EEGlab structure with EEG data.
%   - fileDir: string with path to folder with processed eeg data
%   - rawFile: string containing name of this subject/session/block combination (raw data file)
%
% Outputs:
%   - EEG: EEGlab structure containing data where IC activity has been
%   removed.
%
% Called in preprocess; calls pop_subcomp
%
% See also POP_SUBCOMP, PREPROCESS, PREPROC_CONFIG

if ~isempty(EEG.reject.gcompreject) % if rejected components were marked by hand
    rejectedICs = find(EEG.reject.gcompreject);
elseif isfield(EEG, 'rejectedICs') && ~isempty(EEG.rejectedICs)  % if not, look for a list of components to remove in the EEG structure
    rejectedICs = find(EEG.rejectedICs);
elseif ~isempty(dir(fullfile(fileDir, [rawFile '_' 'rejectedICs' '_' '*' '.txt']))) % if also not there, load the most recent text file from disk
    rejICfile = dir(fullfile(fileDir, [rawFile '_' 'rejectedICs' '_' '*' '.txt']));
    [~,i] = sort([rejICfile.datenum]);
    rejectedICs = load(fullfile(fileDir, rejICfile(i(end)).name));
else % if nothing works
    error('Could not find list of components to reject!')
end

% If not already in the EEG structure, add info on rejected components
if ~isfield(EEG, 'rejectedICs') || isempty(EEG.rejectedICs)
    EEG.rejectedICs = zeros(1,size(EEG.icaweights,1));
    EEG.rejectedICs(rejectedICs) = 1;
end

EEG = pop_subcomp(EEG, rejectedICs); %subtract activity of marked components from the data