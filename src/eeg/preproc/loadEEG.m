function EEG = loadEEG(paths, rawFile, pipeLine, step)

pipeReverse = pipeLine(step-1:-1:1); % work downward from first specified preprocessing step

for iStep = 1:length(pipeReverse)
    stepName = pipeReverse{iStep}(4:end); % get name of preprocessing step
    procFile = [rawFile '_' stepName]; % file name of to be loaded data
    
    loadDir = fullfile(paths.procDir, stepName); % directory containing to be loaded data
    
    if exist(fullfile(loadDir, [procFile '.set']), 'file') % if data are stored in EEGlab format
        fprintf('    Loading data from file %s ...\n', procFile)
        EEG = pop_loadset('filename', [procFile '.set'], 'filepath', loadDir);
        break
    elseif exist(fullfile(loadDir, [procFile '.mat']), 'file') % if data are stored as regular .mat files
        fprintf('    Loading data from file %s ...\n', procFile)
        load(fullfile(loadDir, [procFile '.mat']), 'EEG'); % load (only) the EEG structure
        break
    end
    
    if iStep == length(pipeReverse)
        error('preproc:noData','No data from any previous preprocessing step found for %s!', rawFile)
    end
   
    
end