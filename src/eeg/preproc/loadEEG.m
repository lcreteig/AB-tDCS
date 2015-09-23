function EEG = loadEEG(paths, rawFile, pipeLine)

pipeReverse = pipeLine(end:-1:1); % work downward from most recent preprocessing step

for iStep = 1:length(pipeReverse)
    stepName = pipeReverse{iStep}(4:end); % get name of preprocessing step
    procFile = [rawFile '_' stepName]; % file name of to be loaded data
    
    loadDir = fullfile(paths.procDir, stepName); % directory containing to be loaded data
    % if no directory for this step, skip to next one, or throw error if there is no next one
    if ~exist(loadDir, 'dir')
        if iStep == length(pipeReverse)
            error('preproc:noExisting', 'No directories with data from any previous preprocessing step found!')
        end
        continue
    end
    
    if exist(fullfile(loadDir, [procFile '.set']), 'file') % if data are stored in EEGlab format
        fprintf('    Loading data from "%s" step...\n', stepName)
        EEG = pop_loadset('filename', [procFile '.set'], 'filepath', loadDir);
        break
    elseif exist(fullfile(loadDir, [procFile '.mat']), 'file') % if data are stored as regular .mat files
        fprintf('    Loading data from %s step...\n', stepName)
        load(fullfile(loadDir, [procFile '.mat']), 'EEG'); % load (only) the EEG structure
        break
    else
        error('preproc:loadExisting', 'Could not find file %s, so unable to start preprocessing from this step!', procFile)
    end
    
end