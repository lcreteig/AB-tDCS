function [saveDir, procFile, EEG] = prepSave(EEG,paths, rawFile, pipeLine, step, timeStamp)

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