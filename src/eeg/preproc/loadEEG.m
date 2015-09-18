function EEG = loadEEG(paths, rawFile, pipeLine, step)

stepName = pipeLine{step-1}(4:end); % get name of previous preprocessing step
procFile = [rawFile '_' stepName]; % append to base file name

loadDir = fullfile(paths.procDir, stepName);
    if exist(fullfile(loadDir, [procFile '.set']), 'file') % if data are stored in EEGlab format
        fprintf('    Loading data from previous step...\n')
        EEG = pop_loadset('filename', [procFile '.set'], 'filepath', loadDir);
    elseif exist(fullfile(loadDir, [procFile '.mat']), 'file') % if data are stored as regular .mat files
        fprintf('    Loading data from previous step...\n')
        load(fullfile(loaddir, [procFile '.mat']), 'EEG');
    else
        error('preproc:loadExisting', 'Could not find file %s, so unable to start preprocessing from this step!', procFile)
    end