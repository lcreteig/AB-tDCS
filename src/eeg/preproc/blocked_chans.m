function [outChans, stimulation] = blocked_chans(varargin)
% BLOCKED_CHANS: Retrieve cell array of left-out channels, either for all
% subjects/sessions (no inputs) or a particular pair (2 inputs).
%
% Usage:
% [outChans, stimulation] = BLOCKED_CHANS()
% [outChans, stimulation] = BLOCKED_CHANS(currSub, currStimID)
%
% Inputs:
%   - currSub: string with subject ID of file (e.g. 'S01' or 'S18')
%   - currStimID: string with stimulation ID of session ('Y' or 'X')
%
% Outputs:
%   - outChans: cell-array of strings containing channels to be zeroed out.
%   Either one row for a specific subject/session, or a subjects X sessions
%   cell array when no inputs are given.
%   - stimulation: cell-array of strings with all stimulation IDs
%
% Called in preproc_zero_channels, preproc_interp_channels, preproc_interp_epochs, preproc_averef 
%
% See also PREPROC_ZERO_CHANNELS, PREPROC_INTERP_CHANNELS, PREPROC_INTERP_EPOCHS, PREPROC_AVEREF 

%% Data stimulation Y

chans(:,1) = { ...
    ...
    ... % SESSION B
    ...
    {'AF3', 'F1', 'F3', 'F5', 'FC3', 'Fp2', 'AF8'}, ... %1
    {'AF3', 'F1', 'F3', 'F5', 'FC3', 'Fp2', 'AF8', 'F8'}, ... % 2
    {'F1', 'F3', 'FC1', 'FC3', 'Fp2', 'AF8'}, ... % 3
    {'AF3', 'F1', 'F3', 'F5', 'FC3', 'FC1', 'Fpz', 'Fp2', 'AF8'}, ... % 4
    {'AF3', 'F1', 'F3', 'F5', 'FC1', 'FC3', 'AF8', 'Fp2'}, ... % 5
    {'AF3', 'F1', 'F3', 'F5', 'FC1', 'FC3', 'Fp2', 'AF4', 'AF8', 'F8'}, ... % 6
    {'F1', 'F3', 'F5', 'FC1', 'FC3', 'Fp2', 'AF8'}, ... % 7
    {'AF3', 'F1', 'F3', 'F5', 'FC1', 'FC3', 'AF8', 'Fp2', 'AF4'}, ... % 8
    {'F1', 'F3', 'F5', 'FC1', 'FC3', 'AF3', 'Fp2', 'Fpz', 'AF8', 'F8'}, ... % 9
    {'AF8', 'Fpz', 'Fp2', 'F3', 'F5', 'FC3', 'FC5'}, ... % 10
    {'AF3', 'F1', 'F3', 'F5', 'FC3', 'AF8', 'Fp2'}, ... % 11
    {'Fp2', 'AF4', 'AF8', 'F8', 'F1', 'F3', 'F5', 'FC1', 'FC3'}, ... % 12
    {'AF3', 'F3', 'F5', 'FC1', 'FC3', 'Fp2', 'AF8'}, ... % 13
    {[]}, ... % 14
    {'AF3', 'F1', 'F3', 'F5', 'FC1', 'FC3', 'Fpz', 'Fp2', 'AF8'}, ... % 15
    {'AF3', 'F1', 'F3', 'F5', 'FC1', 'FC3', 'C1', 'Fp2', 'AF4', 'AF8', 'F6','F8'}, ... % 16
    {'Fpz', 'AFz', 'AF3', 'F1', 'F3', 'F5', 'FC1', 'FC3', 'AF4', 'Fp2', 'AF8', 'F6'}, ... % 17
    {'F3', 'F5', 'FC1', 'FC3', 'Fp2', 'AF8'}, ... % 18
    {'AF3', 'F1', 'F3', 'F5', 'FC1', 'FC3', 'Fp2', 'AF4', 'AF8', 'F6', 'F8'}, ... % 19
    {'F3', 'F5', 'FC1', 'FC3', 'C3', 'Fpz', 'Fp2', 'AF4', 'AF8'}, ... % 20
    {'AF3', 'F1', 'F3', 'F5', 'FC1', 'FC3', 'Fp2', 'AF8'}, ... % 21
    ...
    ... % SESSION D
    ...
    [], ... % 22
    [], ... % 23
    []     % 24
    
    };

%% Data stimulation X

chans(:,2) = { ...
    ...
    ... % SESSION D
    ...
    {'AF3', 'F1', 'F3', 'F5', 'F7', 'FC3', 'Fpz', 'Fp2', 'AF8'}, ... % 1
    {'AF3', 'F1', 'F3', 'Fp2', 'AF8'}, ... % 2
    {'AF7', 'AF3', 'F1', 'F3', 'F5', 'FC3', 'Fp2', 'AF8'}, ... % 3
    {'AF3', 'F3', 'F5', 'FC3', 'Fp2', 'AF8', 'F8'}, ... % 4
    {'AF3', 'F1', 'F3', 'F5', 'FC1', 'FC3', 'AF8', 'Fp2', 'F8'}, ... % 5
    {'AF3', 'F1', 'F3', 'F5', 'FC1', 'FC3', 'Fpz', 'Fp2', 'AF4', 'AF8', 'F8'}, ... % 6
    {'F1', 'F3', 'F5', 'FC1', 'FC3', 'C3', 'Fp2', 'AF8', 'AF4'}, ... % 7
    {'F1', 'F3', 'F5', 'FC1', 'FC3', 'AF8', 'Fp2', 'AF4', 'F8'}, ... % 8
    {'F3', 'F5', 'FC3', 'FC5', 'AF3', 'AF7', 'Fp2', 'Fpz', 'AF8', 'AF4'}, ... % 9
    {'F3', 'F5', 'FC3', 'FC5', 'AF7', 'AF3', 'Fp2', 'Fpz', 'AF8', 'F8'}, ... % 10
    {'F1', 'F3', 'F5', 'FC1', 'FC3', 'AF4', 'AF8', 'Fp2'}, ... % 11
    {'AF3', 'F1', 'F3', 'F5', 'FC1', 'FC3', 'Fp2', 'AF4', 'AF8'}, ... % 12
    {'AF3', 'F1', 'F3', 'F5', 'FC1', 'FC3', 'Fp2', 'AF4', 'AF8', 'F8'}, ... % 13
    {[]}, ... % 14
    {'AF3', 'F1', 'F3', 'F5', 'FC1', 'FC3', 'Fp2', 'AF8', 'AF4', 'F6', 'F8'}, ... % 15
    {'AF3', 'F1', 'F3', 'F5', 'FC1', 'FC3', 'C3', 'Fp2', 'AF4', 'AF8', 'FT8', 'F6', 'F8'}, ... % 16
    {'AF3', 'F3', 'F5', 'FC3', 'FC5', 'Fp2', 'AF8'}, ... % 17
    {'F3', 'F5', 'FC3', 'FC5', 'Fpz', 'Fp2', 'AF8'}, ... % 18
    {'AF3', 'F1', 'F3', 'F5', 'FC1', 'FC3', 'Fpz', 'Fp2', 'AFz', 'AF4', 'AF8', 'F8'}, ... % 19
    {'AF3', 'F1', 'F3', 'F5', 'FC1', 'FC3', 'C1', 'Fp2', 'AF8'}, ... % 20
    {'AF3', 'F3', 'F5', 'FC1', 'FC3', 'Fp2', 'AF4', 'AF8'}, ... % 21
    ...
    ... % SESSION I
    ...
    [], ... % 22
    [], ... % 23
    []     % 24
    
    };

%% Indices
     
stimulation = {'Y', 'X'};

%% Outputs

if nargin == 2
    stim = strcmp(varargin{2}, stimulation);
    outChans = chans{str2double(varargin{1}(2:end)), stim};
elseif nargin == 0
    outChans = chans;
else 
    error(['Incorrect amount of input arguments. ' ... 
        'Either specify none to retrieve channel info of all subjects/sessions, or specify a subject-stimulation pair ' ...
        '(e.g. blocked_chans(''S01'', ''X'')) to retrieve left out channels for these files.'])
end