function checkVersion(eeglabNew, eeglabOld)
% CHECKVERSION: Check for matlab/eeglab incompatibility. Older versions of eeglab might
% not run on newer versions of matlab. Newer versions of eeglab have
% their own problems with importing bdf data, reading out the trigger
% values in the data, and running (newer eeglabs) and/or plotting (older
% eeglabs) ICA.
%
% Therefore, some preprocessing steps will have to be carried out with
% older eeglab versions, while for others newer versions are also OK. This
% function informs the user of possible incompatibilities between eeglab
% and matlab versions, and makes sure only the right version of eeglab is
% on the matlab path.
%
% Usage: CHECKVERSION(eeglabNew, eeglabOld)
%
% Inputs:
%
% -eeglabNew: string: full path to newest version of eeglab (e.g. 'C:\toolbox\eeglab13_4_4b').
% -eeglabOld: string: full path to oldest version of eeglab.

[~,matlabVersion] = version; % get release data of this matlab version
matlabPath = regexp(path,pathsep,'split'); % get directories currently on the path
if str2double(matlabVersion(end-3:end)) > 2010
    warning('preproc:MatlabVersion', 'You are using a version of matlab released after 2010, which might be too new to do the initial preprocessing!')
    if any(ismember(eeglabOld, matlabPath))
        warning('preproc:EEGlabVersion', 'The version of EEGlab on the matlab path is too old for this version of matlab: removing from path...')
        rmpath(genpath(eeglabOld))
    end
    if ~any(ismember(eeglabNew, matlabPath))
        addpath(genpath(eeglabNew))
    end
else
    if any(ismember(eeglabNew, matlabPath))
        warning('preproc:EEGlabVersion', 'The version of EEGlab on the matlab path is too new for this version of matlab: removing...')
        rmpath(genpath(eeglabNew))
    end
    if ~any(ismember(eeglabOld, matlabPath))
        addpath(genpath(eeglabOld))
    end
end