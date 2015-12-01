function EEG = preproc_runica(EEG, icaType)
% PREPROC_RUNICA: Run independent component analysis on EEG data.
%
% Usage: EEG = PREPROC_RUNICA(EEG, icaType)
%
% Inputs:
%   - EEG: EEGlab structure with EEG data.
%   - icaType: Either 'jader' (faster) or 'runica' (extended)
%
% Outputs:
%   - EEG: EEGlab structure with independent components in addition to
%   channel data.
%
% Called in preprocess; calls pop_runica.
%
% See also POP_RUNICA, PREPROCESS, PREPROC_CONFIG,

if strcmp(icaType, 'jader')
    EEG = pop_runica(EEG,'icatype','jader','dataset',1,'options',{40});
elseif strcmp(icaType, 'runica')
    EEG=pop_runica(EEG,'icatype','runica','dataset',1,'options',{'extended',1});
else
    error('Unrecognized ICA type option "%s"!', icaType)
end

EEG.icaact = []; % delete the ICA activation matrix. It takes up a lot of
%disk space, and only takes seconds to recompute using the saved ICA
%weights.