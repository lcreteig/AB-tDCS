function [outChans, subjects, sessions] = blocked_chans(varargin)
% Retrieve cell array of left-out channels, either for all
% subjects/sessions or a particular pair.
% Usage:
% [outChans, subjects, sessions] = blocked_chans
% outChans = blocked_chans('S01', 'B')

%% Data session B

chans(:,1) = { ...
    {'AF3', 'F1', 'F3', 'F5', 'FC3', 'Fp2', 'AF8'}, ... %1
    {'AF3', 'F1', 'F3', 'F5', 'FC3', 'Fp2', 'AF8', 'F8'}, ... % 2
    {'F1', 'F3', 'FC1', 'FC3', 'Fp2', 'AF8'}, ... % 3
    {'AF3', 'F1', 'F3', 'F5', 'FC3', 'FC1', 'FPz', 'Fp2', 'AF8'}, ... % 4
    {'AF3', 'F1', 'F3', 'F5', 'FC1', 'FC3', 'AF8', 'Fp2'}, ... % 5
    {'AF3', 'F1', 'F3', 'F5', 'FC1', 'FC3', 'Fp2', 'AF4', 'AF8', 'F8'}, ... % 6
    {'F1', 'F3', 'F5', 'FC1', 'FC3', 'Fp2', 'AF8'}, ... % 7
    {'F1', 'F3', 'F5', 'FC1', 'FC3', 'AF8', 'Fp2', 'AF4'}, ... % 8
    {'F1', 'F3', 'F5', 'FC1', 'FC3', 'AF3', 'Fp2', 'FPz', 'AF8', 'F8'}, ... % 9
    {'AF8', 'FPz', 'Fp2', 'F3', 'F5', 'FC3', 'FC5'}, ... % 10
    {'AF3', 'F1', 'F3', 'F5', 'FC3', 'AF8', 'Fp2'}, ... % 11
    {'Fp2', 'AF4', 'AF8', 'F8', 'F1', 'F3', 'F5', 'FC1', 'FC3'}, ... % 12
    {'AF3', 'F3', 'F5', 'FC1', 'FC3', 'Fp2', 'AF8'}, ... % 13
    {'AF3', 'F1', 'F3', 'F5', 'FC1', 'FC3', 'AF8', 'Fp2'}, ... % 14
    {'AF3', 'F1', 'F3', 'F5', 'FC1', 'FC3', 'FPz', 'Fp2', 'AF8'}, ... % 15
    {'AF3', 'F1', 'F3', 'F5', 'FC1', 'FC3', 'C1', 'Fp2', 'AF4', 'AF8', 'F6','F8'}, ... % 16
    {'FPz', 'AFz', 'AF3', 'F1', 'F3', 'F5', 'FC1', 'FC3', 'AF4', 'Fp2', 'AF8', 'F6'}, ... % 17
    {'F3', 'F5', 'FC1', 'FC3', 'Fp2', 'AF8'}, ... % 18
    {'AF3', 'F1', 'F3', 'F5', 'FC1', 'FC3', 'Fp2', 'AF4', 'AF8', 'F6', 'F8'}, ... % 19
    {'F3', 'F5', 'FC1', 'FC3', 'C3', 'FPz', 'Fp2', 'AF4', 'AF8'}, ... % 20
    {'AF3', 'F1', 'F3', 'F5', 'FC1', 'FC3', 'Fp2', 'AF8'}, ... % 21
    };

%% Data session D

chans(:,2) = { ...
    {'AF3', 'F1', 'F3', 'F5', 'F7', 'FC3', 'FPz', 'Fp2', 'AF8'}, ... % 1
    {'AF3', 'F1', 'F3', 'Fp2', 'AF8'}, ... % 2
    {'AF7', 'AF3', 'F1', 'F3', 'F5', 'FC3', 'Fp2', 'AF8'}, ... % 3
    {'AF3', 'F3', 'F5', 'FC3', 'Fp2', 'AF8', 'F8'}, ... % 4
    {'AF3', 'F1', 'F3', 'F5', 'FC1', 'FC3', 'AF8', 'Fp2', 'F8'}, ... % 5
    {'AF3', 'F1', 'F3', 'F5', 'FC1', 'FC3', 'Fp2', 'AF4', 'AF8', 'F8'}, ... % 6
    {'F1', 'F3', 'F5', 'FC1', 'FC3', 'C3', 'Fp2', 'AF8', 'AF4'}, ... % 7
    {'F1', 'F3', 'F5', 'FC1', 'FC3', 'AF8', 'Fp2', 'AF4', 'F8'}, ... % 8
    {'F3', 'F5', 'FC3', 'FC5', 'AF3', 'AFz', 'Fp2', 'FPz', 'AF8', 'AF4'}, ... % 9
    {'F3', 'F5', 'FC3', 'FC5', 'AFz', 'AF3', 'Fp2', 'FPz', 'AF8', 'F8'}, ... % 10
    {'F1', 'F3', 'F5', 'FC1', 'FC3', 'AF4', 'AF8', 'Fp2'}, ... % 11
    {'AF3', 'F1', 'F3', 'F5', 'FC1', 'FC3', 'Fp2', 'AF4', 'AF8'}, ... % 12
    {'AF3', 'F1', 'F3', 'F5', 'FC1', 'FC3', 'Fp2', 'AF4', 'AF8', 'F8'}, ... % 13
    {[]}, ... % 14
    {'AF3', 'F1', 'F3', 'F5', 'FC1', 'FC3', 'Fp2', 'AF8', 'AF4', 'F6', 'F8'}, ... % 15
    {'AF3', 'F1', 'F3', 'F5', 'FC1', 'FC3', 'C3', 'Fp2', 'AF4', 'AF8', 'FT8', 'F6', 'F8'}, ... % 16
    {'AF3', 'F3', 'F5', 'FC3', 'FC5', 'Fp2', 'AF8'}, ... % 17
    {'F3', 'F5', 'FC3', 'FC5', 'FPz', 'Fp2', 'AF8'}, ... % 18
    {'AF3', 'F1', 'F3', 'F5', 'FC1', 'FC3', 'FPz', 'Fp2', 'AFz', 'AF4', 'AF8', 'F8'}, ... % 19
    {'AF3', 'F1', 'F3', 'F5', 'FC1', 'FC3', 'C1', 'Fp2', 'AF8'}, ... % 20
    {'AF3', 'F3', 'F5', 'FC1', 'FC3', 'Fp2', 'AF4', 'AF8'}, ... % 21
    };

%% Indices

subjects = {'S01'
            'S02'
            'S03'
            'S04'
            'S05'
            'S06'
            'S07'
            'S08'
            'S09'
            'S10'
            'S11'
            'S12'
            'S13'
            'S14'
            'S15'
            'S16'
            'S17'
            'S18'
            'S19'
            'S20'
            'S21'
         };
     
sessions = {'B', 'D'};

%% Outputs

if nargin == 2
    sub = strcmp(varargin{1}, subjects);
    sess = strcmp(varargin{2}, sessions);
    outChans = chans{sub, sess};
elseif nargin == 0
    outChans = chans;
else 
    error(['Incorrect amount of input arguments. ' ... 
        'Either specify none to retrieve channel info of all subjects/sessions, or specify a subject-session pair ' ...
        '(e.g. blocked_chans(''S01'', ''B'')) to retrieve left out channels for these files.'])
end