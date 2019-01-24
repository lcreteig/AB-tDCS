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
    {'Fpz', 'Fp2', 'AF8', 'AF3', 'F1', 'F3', 'F5', 'FC3'}, ... % 22
    {'F1','F3','F5','FC3','Fp2','AF8'}, ... % 23
    {'AF3', 'F3', 'F5', 'FC3', 'F8', 'AF8', 'Fp2'}, ...     % 24
    {[]}, ... % 25
    {'AF3', 'F1', 'F3', 'F5', 'FC3', 'FC5', 'Fp2', 'AF8', 'F8'}, ... % 26
    {'F3', 'F5', 'AF3', 'F1', 'FC1', 'FC3', 'AF8', 'Fp2', 'AF4', 'Fpz'}, ... % 27
    {'AF3', 'F1', 'F3', 'F5', 'FC5', 'FC3', 'FC1', 'Fp2', 'AF8'}, ... % 28
    {'F6', 'Fp2', 'AF4', 'AF8','F1', 'F3', 'F5', 'AF3', 'AF7', 'FC3', 'FC5'}, ... % 29
    {'AF3', 'AF7', 'F1', 'F3', 'F5', 'FC1', 'FC3', 'FC5', 'AFz', 'AF4', 'AF8', 'Fpz', 'Fp2', 'F8'}, ... % 30
    {'F1', 'F3', 'F5', 'FC3', 'FC5', 'C3', 'C5', 'Fp2', 'AF8'}, ... % 31
    {'AF3', 'AF7', 'F1', 'F3', 'F5', 'FC1', 'FC3', 'FC5', 'AF8', 'Fp2', 'Fpz'}, ... % 32
    {'AF3', 'AF7', 'F3', 'F5', 'FC5', 'FC3', 'AF8', 'Fp2'}, ... % 33
    {'AF7', 'AF3', 'F1', 'F3', 'F5', 'FC5', 'FC3', 'FC1', 'Fp2', 'AF4', 'AF8', 'F6', 'F8'}, ... % 34
    {'AF3', 'AF7', 'F1', 'F3', 'F5', 'FC5', 'FC3', 'FC1', 'Fpz', 'Fp2', 'AF4', 'AF8'}, ... % 35
    {'AF3', 'AF7', 'F3', 'F5', 'FC5', 'FC3', 'Fpz', 'Fp2', 'AF4', 'AF8', 'F8'}, ... % 36
    {'AF3', 'AF7', 'F1', 'F3', 'F5', 'FC5', 'FC3', 'FC1', 'AF4', 'AF8', 'Fp2', 'F6', 'F8'}, ... % 37
    {'AF3', 'F1', 'F3', 'FC3', 'FC1', 'AFz', 'Fpz', 'Fp2', 'AF8', 'AF4'}, ... % 38
    {'AF3', 'AF7', 'F3', 'F5', 'F7', 'FC5', 'FC3', 'Fpz', 'Fp2', 'AF4', 'AF8', 'F8'}, ... % 39
    {'AF3', 'F1', 'F3', 'F5', 'FC5', 'FC3', 'FC1', 'Fp2', 'AF8', 'F8'}, ... % 40
    {'F1', 'F3', 'F5', 'FC5', 'FC3', 'Fpz', 'Fp2', 'AF8'}, ... %41
    {[]}, ... % 42
    {[]}, ... %43
    {'AF3', 'F1', 'F3', 'F5', 'FC5', 'FC3', 'Fp2', 'AF8', 'F8'}, ... % 44
    {'AF3', 'F1', 'F3', 'F5', 'FC3', 'FC1', 'Fp2', 'AF8'}, ... % 45
    {'AF3', 'F1', 'F3', 'F5', 'FC5', 'FC7', 'FC1', 'Fp2', 'AF4', 'AF8', 'F8'}, ... % 46
    {'AF7', 'F1', 'F3', 'F5', 'FC5', 'FC3', 'Fp2', 'AF8'}, ... % 47
    {'AF7', 'F3', 'F5', 'FC5', 'FC3', 'Fp2', 'AF8'}, ... % 48
    {'AF3', 'F1', 'F3', 'F5', 'FC3', 'FC1', 'Fp2', 'AF8', 'F8'} % 49
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
    {'Fpz', 'Fp2', 'AF8', 'AF3', 'F1', 'F3', 'F5', 'FC3', 'FC5', 'C3'}, ... % 22
    {'F5', 'F3', 'FC3', 'Fp2', 'AF8', 'AF7', 'FC5'}, ... % 23
    {'AF3', 'F3', 'F5', 'FC3', 'F8' 'AF8', 'Fp2'}, ... % 24
    {'AF3', 'F1', 'F3', 'F5', 'FC1', 'FC3', 'Fp2', 'AF8'}, ... % 25
    {'AF3', 'F1', 'F3', 'F5', 'FC3', 'FC5', 'C5', 'Fpz', 'Fp2', 'AF8', 'AF4', 'F6', 'AFz'}, ... % 26
    {'F3', 'F5', 'AF3', 'F1', 'FC1', 'FC3', 'AF8', 'Fp2', 'AF4'}, ... % 27
    {'AF3', 'F1', 'F3', 'F5', 'FC3', 'Fp2', 'AF8'}, ... % 28
    {[]}, ... % 29
    {'F1', 'F3', 'F5', 'FC3', 'FC5', 'Fpz', 'Fp2', 'AF8'}, ... % 30
    {[]}, ... % 31
    {'AF3', 'F1', 'F3', 'F5', 'FC3', 'FC1', 'AF8', 'Fp2', 'Fpz'}, ... % 32
    {'AF3', 'AF7', 'F1', 'F3', 'F5', 'FC5', 'FC3', 'Fp2', 'AF8', 'F8'}, ... % 33
    {'AF3', 'F1', 'F3', 'F5', 'FC5', 'FC3', 'FC1', 'Fp2', 'AF4', 'AF8', 'F6', 'F8'}, ... % 34
    {'AF3', 'AF7', 'F1', 'F3', 'F5', 'FC5', 'FC3', 'FC1', 'Fp2', 'AF4', 'AF8', 'F8'}, ... % 35
    {'AF3', 'AF7', 'F1', 'F3', 'F5', 'FC5', 'FC3', 'FC1', 'Fpz', 'Fp2', 'AF4', 'AF8'}, ... % 36
    {'AF3', 'F1', 'F3', 'F5', 'FC5', 'FC3', 'FC1', 'AF4', 'AF8', 'Fp2', 'F6', 'F8'}, ... % 37
    {[]}, ... % 38
    {'AF3', 'AF7', 'F1', 'F3', 'F5', 'FC5', 'FC3', 'FC1', 'AF4', 'AF8', 'Fp2', 'F6', 'F8'}, ... % 39
    {'AF3', 'AF7', 'F1', 'F3', 'F5', 'FC5', 'FC3', 'FC1', 'Fp2', 'AF8', 'F8'}, ... % 40
    {'F1', 'F3', 'F5', 'FC5', 'FC3', 'Fp2', 'AF8'}, ... % 41
    {[]}, ... % 42
    {'AF3', 'F1', 'F3', 'F5', 'FC3', 'FC1', 'Fp2', 'AF8'}, ... % 43
    {'AF3', 'AF7', 'F1', 'F3', 'F5', 'FC5', 'FC3', 'FC1', 'Fp2', 'AF8'}, ... % 44
    {'AF3', 'AF7', 'F1', 'F3', 'F5', 'FC5', 'FC3', 'FC1', 'Fp2', 'AF8'}, ... % 45
    {[]}, ... % 46
    {'AF3', 'AF7', 'F1', 'F3', 'F5', 'FC5', 'FC3', 'Fp2', 'AF8'}, ... % 47
    {'AF3', 'AF7', 'F3', 'F5', 'FC5', 'FC3', 'Fp2', 'AF8'}, ... % 48
    {'AF7', 'AF3', 'F1', 'F3', 'F5', 'FC3', 'FC1', 'Fp2', 'AF4', 'AF8', 'F8'} % 49
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