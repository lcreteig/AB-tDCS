function [saveDir, procFile, EEG] = prepSave(EEG, paths, rawFile, pipeLine, step, timeStamp)
%PREPSAVE: Build filenames and directories for to-be saved EEG data
%
% Usage: [saveDir, procFile, EEG] = PREPSAVE(EEG, paths, rawFile, pipeLine, step, timeStamp)
%
% Inputs:
%   - EEG: EEGlab structure that was previously saved
%   - paths: structure with file/script names and paths
%   - rawFile: string containing name of this subject/session/block combination (raw data file)
%   - pipeLine: cell array of strings with names of all preprocessing steps
%   - step: number of current preprocessing step
%   - timeStamp: string with time the preprocessing script started
%
% Outputs:
%   - saveDir: string with directory EEG data should be saved in.
%   - procFile: string with file name of to-be saved EEG data
%   - EEG: EEGlab structure with updated metadata
%
% Called in preprocess
%
% See also PREPROCESS, PREPROC_CONFIG

stepName = pipeLine{step}(4:end); % get name of current preprocessing step
procFile = [rawFile '_' stepName]; % append to base file name

% if no directory for this preprocessing step exists, make it
if ~isdir(fullfile(paths.procDir, stepName))
    mkdir(paths.procDir, stepName)
end

% if no file with this exact name already exists, good to go
if isempty(dir(fullfile(paths.procDir, stepName, [procFile '.*'])))
    saveDir = fullfile(paths.procDir, stepName);
else % if it does exist, throw warning, and save in new directory
    warning('preproc:fileExists', 'File "%s" in directory "%s" already exists! Storing new files in a subdirectory with start time of the script as its name.', procFile, stepName)
    mkdir(paths.procDir, fullfile(stepName, timeStamp))
    saveDir = fullfile(paths.procDir, stepName, timeStamp);
end

% store metadata in EEG structure
EEG.setname = [paths.expID ': ' pipeLine{step}(4:end)];
EEG.filename = [procFile '.mat'];
EEG.filepath = saveDir;