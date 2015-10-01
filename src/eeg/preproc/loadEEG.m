function [EEG, preprocNew] = loadEEG(paths, rawFile, preprocNew, step)

stepNames = fieldnames(preprocNew);
pipeLine = stepNames(strncmp('do_', stepNames, length('do_'))); % get names of all preprocessing steps in structure
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
        load(fullfile(loadDir, [procFile '.mat'])); % load the EEG structure and auxilliary variabiales ("preproc")
        
        if exist('preproc', 'var')
            for iPipe = 1:length(pipeLine) % for each step
                if isfield(preproc, pipeLine{iPipe}) && preproc.(pipeLine{iPipe})(1) % if it was performed in loaded data
                preprocNew.(pipeLine{iPipe}) = preproc.(pipeLine{iPipe}); % mark the step also in the new data
                end
            end
        end
        
    end
    break
end

if iStep == length(pipeReverse)
    error('preproc:noData','No data from any previous preprocessing step found for %s!', rawFile)
end


end