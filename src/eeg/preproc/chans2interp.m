function outChans = chans2interp(currSub,currSession,currBlock)
% CHANS2INTERP: Retrieve cell array of channels to be interpolated for a particular file
% (subject/session/block combination).
%
% Usage:
% outChans = CHANS2INTERP(currSub,currSession,currBlock)
%
% Inputs:
%   - currSub: string with subject ID of file (e.g. 'S01' or 'S18')
%   - currSession: string with tDCS code of file ('B' or 'D')
%   - currBlock: string with block of file ('pre', 'tDCS', or 'post')
%
% Outputs:
%   - outChans: cell-array of strings containing channels to be
%   interpolated.
%
% Called in preproc_interp_channels, preproc_interp_epochs, preprocess
%
% See also PREPROC_INTERP_CHANNELS, PREPROC_INTERP_EPOCHS, PREPROCESS

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
        {'FPz'}, ... % 1
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
        {'FPz', 'FT8', 'F6'}, ... % 1
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
        {'PO4'}, ... % 18
        [], ... % 19
        [], ... % 20
        [], ... % 21
        };
    
end

%% Session B, block post

if strcmp(currSession, 'B')  && strcmp(currBlock, 'post')
    
    chans = { ...
        {'FPz', 'F7',}, ... % 1
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
        {'PO4'}, ... % 19
        [], ... % 20
        [], ... % 21
        };
    
end

%% Session D, block post

if strcmp(currSession, 'D')  && strcmp(currBlock, 'post')
    
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


%% Outputs

sub = strcmp(currSub, subjects);
outChans = chans{sub};