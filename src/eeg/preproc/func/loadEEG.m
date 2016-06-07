function [EEG, preprocNew] = loadEEG(fileDir, rawFile, preprocNew, step)
%LOADEEG: Loads EEG data from a previous pre-processing step.
%
% Usage: [EEG, preprocNew] = LOADEEG(paths, rawFile, preprocNew, step)
%
% Inputs:
%   - fileDir: string with path to folder with processed eeg data
%   - rawFile: string containing name of this subject/session/block combination (raw data file)
%   - preprocNew: structure with preprocessing parameters
%   - step: number of current preprocessing step
%
% Outputs:
%   - EEG: EEGlab structure that was previously saved
%   - preprocNew: updated with preprocessing steps that will now be
%   executed.
%
% Called in preprocess
%
% See also PREPROCESS, PREPROC_CONFIG

stepNames = fieldnames(preprocNew);
pipeLine = stepNames(strncmp('do_', stepNames, length('do_'))); % get names of all preprocessing steps in structure
pipeReverse = pipeLine(step-1:-1:1); % work downward from first specified preprocessing step

for iStep = 1:length(pipeReverse)
    stepName = pipeReverse{iStep}(4:end); % get name of preprocessing step
    procFile = [rawFile '_' stepName]; % file name of to be loaded data
    
    loadDir = fullfile(fileDir, stepName); % directory containing to be loaded data
    
    if exist(fullfile(loadDir, [procFile '.set']), 'file') % if data are stored in EEGlab format
        fprintf('    Loading data from file %s ...\n', procFile)
        EEG = pop_loadset('filename', [procFile '.set'], 'filepath', loadDir);
        break
    elseif exist(fullfile(loadDir, [procFile '.mat']), 'file') % if data are stored as regular .mat files
        fprintf('    Loading data from file %s ...\n', procFile)
        load(fullfile(loadDir, [procFile '.mat'])); % load the EEG structure and auxilliary variabiales ("preproc")
        
        if exist('preproc', 'var')
            for iPipe = 1:length(pipeReverse) % for each step
                if isfield(preproc, pipeReverse{iPipe}) && preproc.(pipeReverse{iPipe})(1) % if it was performed in loaded data
                    preprocNew.(pipeReverse{iPipe}) = preproc.(pipeReverse{iPipe}); % mark the step also in the new data
                end
            end
        end
        
        break
    end
    
end

if iStep == length(pipeReverse)
    error('preproc:noData','No data from any previous preprocessing step found for %s!', rawFile)
end


end