function outChans = bad_chans(currSub,currSession,currBlock)
% BAD_CHANS: Retrieve cell array of bad channels for a particular file
% (subject/session/block combination).
%
% Usage:
% outChans = BAD_CHANS(currSub,currSession,currBlock)
%
% Inputs:
%   - currSub: string with subject ID of file (e.g. 'S01' or 'S18')
%   - currSession: string with tDCS code of file ('B' or 'D')
%   - currBlock: string with block of file ('pre', 'tDCS', or 'post')
%
% Outputs:
%   - outChans: cell-array of strings containing channels to be zeroed out.
%
% Called in preproc_zero_channels, preproc_interp_channels, preproc_interp_epochs, preproc_averef 
%
% See also PREPROC_ZERO_CHANNELS, PREPROC_INTERP_CHANNELS, PREPROC_INTERP_EPOCHS, PREPROC_AVEREF 

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

%% Session B, block pre

if strcmp(currSession, 'B')  && strcmp(currBlock, 'pre')
    
    chans = { ...
        [], ... % 1
        [], ... % 2
        [], ... % 3
        [], ... % 4
        [], ... % 5
        [], ... % 6
        [], ... % 7
        [], ... % 8
        [], ... % 9
        [], ... % 10
        [], ... % 11
        [], ... % 12
        [], ... % 13
        [], ... % 14
        [], ... % 15
        [], ... % 16
        [], ... % 17
        [], ... % 18
        [], ... % 19
        [], ... % 20
        [], ... % 21
        };
    
end

%% Session B, block tDCS

if strcmp(currSession, 'B')  && strcmp(currBlock, 'tDCS')
    
    chans = { ...
        [], ... % 1
        {'F6', 'AF7', 'FC1'}, ... % 2
        {'Fz', 'AF3'}, ... % 3
        [], ... % 4
        {'FC5'}, ... % 5
        {'C3'} ... % 6
        {'AF3'} ... % 7
        {'AF3', 'AF7'}, ... % 8
        {'FPz', 'AF7', 'FC5'}, ... % 9 FPz can be removed in next preproc run, was misspelled in blocked_chans
        {'AF3', 'FP1', 'C3', 'C5', 'AF7', 'F7'}, ... % 10
        {'FPz','AF4', 'AF7', 'FC5', 'FC1', 'AF8'} ... % 11
        {'F6', 'Fpz', 'AF7', 'AF3', 'FC5', 'F7', 'C3'} ... % 12
        {'FC5'}, ... % 13
        [], ... % 14
        {'C3', 'FC5'}, ... % 15
        {'Fpz', 'Fp1', 'AF7', 'F7', 'C3', 'FC5'}, ... % 16
        [], ... % 17
        {'Fp1', 'AFz', 'Fpz', 'AF4', 'AF7', 'F7', 'FC5', 'AF3', 'F1'}, ... % 18
        {'AF7'}, ... % 19
        [], ... % 20
        {'FC5', 'C3'}, ... % 21
        };
    
end

%% Session B, block post

if strcmp(currSession, 'B')  && strcmp(currBlock, 'post')
    
    chans = { ...
        [], ... % 1
        [], ... % 2
        [], ... % 3
        [], ... % 4
        [], ... % 5
        [], ... % 6
        [], ... % 7
        [], ... % 8
        [], ... % 9
        [], ... % 10
        [], ... % 11
        [], ... % 12
        [], ... % 13
        [], ... % 14
        [], ... % 15
        [], ... % 16
        [], ... % 17
        [], ... % 18
        [], ... % 19
        [], ... % 20
        [], ... % 21
        };
    
end

%% Session D, block pre

if strcmp(currSession, 'D')  && strcmp(currBlock, 'pre')
    
    chans = { ...
        [], ... % 1
        [], ... % 2
        [], ... % 3
        [], ... % 4
        [], ... % 5
        [], ... % 6
        [], ... % 7
        [], ... % 8
        [], ... % 9
        [], ... % 10
        [], ... % 11
        [], ... % 12
        [], ... % 13
        [], ... % 14
        [], ... % 15
        [], ... % 16
        [], ... % 17
        [], ... % 18
        [], ... % 19
        [], ... % 20
        [], ... % 21
        };
    
end

%% Session D, block tDCS

if strcmp(currSession, 'D')  && strcmp(currBlock, 'tDCS')
    
    chans = { ...
        {'FP1', 'FT7', 'FC5', 'AF7', 'AF4'}, ... % 1
        {'AFz', 'F5', 'F8'}, ... % 2
        {'FC1'}, ... % 3
        [], ... % 4
        {'Fpz', 'FP1', 'AF7'}, ... % 5
        {'Fpz'}, ... % 6
        {'AF3'}, ... % 7
        {'AF3', 'Fpz', 'F6'}, ... % 8
        {'AF7', 'F1', 'FC3', 'C3', 'F6'} ... % 9
        {'AF4', 'Fp1', 'AF7', 'F1'} ... % 10
        {'AF3', 'Fpz', 'F8'}, ... % 11
        {'AF7', 'FPz','AFz', 'F6', 'F8'} ... % 12
        {'AFz','Fpz', 'F6'} ... % 13
        [], ... % 14
        {'Fpz'} ... % 15
        [], ... % 16
        {'F7', 'AF7', 'F1', 'FC1', 'Fpz', 'F8', 'AF4'}, ... % 17
        {'F6', 'AF7', 'AF3', 'F7', 'FC1', 'AF4', 'FC1'}, ... % 18
        [], ... % 19
        [], ... % 20
        [], ... % 21
        };
    
end

%% Session D, block post

if strcmp(currSession, 'D')  && strcmp(currBlock, 'post')
    
    chans = { ...
        {'FP1', 'AF7'}, ... % 1
        [], ... % 2
        [], ... % 3
        [], ... % 4
        [], ... % 5
        [], ... % 6
        [], ... % 7
        [], ... % 8
        [], ... % 9
        [], ... % 10
        [], ... % 11
        [], ... % 12
        [], ... % 13
        [], ... % 14
        [], ... % 15
        [], ... % 16
        [], ... % 17
        [], ... % 18
        [], ... % 19
        [], ... % 20
        [], ... % 21
        };
    
end


%% Outputs

sub = strcmp(currSub, subjects);
outChans = chans{sub};