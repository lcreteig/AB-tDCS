function outChans = bad_chans(currSub,currStimID,currBlock)
% BAD_CHANS: Retrieve cell array of bad channels for a particular file
% (subject/stimulation/block combination).
%
% Usage:
% outChans = BAD_CHANS(currSub,currStimID,currBlock)
%
% Inputs:
%   - currSub: string with subject ID of file (e.g. 'S01' or 'S18')
%   - currStimID: string with stimulation ID of session ('Y' or 'X')
%   - currBlock: string with block of file ('pre', 'tDCS', or 'post')
%
% Outputs:
%   - outChans: cell-array of strings containing channels to be zeroed out.
%
% Called in preproc_zero_channels, preproc_interp_channels, preproc_interp_epochs, preproc_averef 
%
% See also PREPROC_ZERO_CHANNELS, PREPROC_INTERP_CHANNELS, PREPROC_INTERP_EPOCHS, PREPROC_AVEREF 

%% Stimulation Y, block pre

if strcmp(currStimID, 'Y')  && strcmp(currBlock, 'pre')
    
    chans = { ...
        ...
        ... % SESSION B
        ...
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
        ...
        ... % SESSION D
        ...
        [], ... % 22
        [], ... % 23
        []     % 24

        };
    
end

%% Stimulation Y, block tDCS

if strcmp(currStimID, 'Y')  && strcmp(currBlock, 'tDCS')
    
    chans = { ...
        ...
        ... % SESSION B
        ...
        {'Fpz'}, ... % 1
        {'F6'}, ... % 2
        {'Fz', 'AF3'}, ... % 3
        [], ... % 4
        {'FC5'}, ... % 5
        {'C3'} ... % 6
        {'AF3'} ... % 7
        {'AF3', 'AF7'}, ... % 8
        {'AF7', 'FC5'}, ... % 9 
        {'AF3', 'Fp1', 'C3', 'C5', 'AF7', 'F7'}, ... % 10
        {'Fpz','AF4', 'AF7', 'FC5', 'FC1', 'AF8'} ... % 11
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
        ...
        ... % SESSION D
        ...
        [], ... % 22
        [], ... % 23
        []     % 24
        
        };
    
end

%% Stimulation Y, block post

if strcmp(currStimID, 'Y')  && strcmp(currBlock, 'post')
    
    chans = { ...
        ...
        ... % SESSION B
        ...
        {'Fpz','F7'}, ... % 1
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
        ...
        ... % SESSION D
        ...
        [], ... % 22
        [], ... % 23
        []      % 24
        
        };
    
end

%% Stimulation X, block pre

if strcmp(currStimID, 'X')  && strcmp(currBlock, 'pre')
    
    chans = { ...
        ...
        ... % SESSION D
        ...
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
        ...
        ... % SESSION I
        ...
        [], ... % 22
        [], ... % 23
        []      % 24
        
        };
    
end

%% Stimulation X, block tDCS

if strcmp(currStimID, 'X')  && strcmp(currBlock, 'tDCS')
    
    chans = { ...
        ...
        ... % SESSION D
        ...
        {'Fp1'}, ... % 1
        {'AFz', 'Fp1', 'AF7'}, ... % 2s
        {'FC1'}, ... % 3
        [], ... % 4s
        {'Fpz', 'Fp1', 'AF7'}, ... % 5
        {'Fpz'}, ... % 6
        {'AF3'}, ... % 7
        {'AF3', 'Fpz', 'F6'}, ... % 8
        {'AF7', 'F1', 'FC3', 'C3', 'F6'} ... % 9
        {'AF4', 'Fp1', 'AF7', 'F1'} ... % 10
        {'AF3', 'Fpz', 'F8'}, ... % 11
        {'AF7', 'Fpz','AFz', 'F6', 'F8'} ... % 12
        {'AFz','Fpz', 'F6'} ... % 13
        [], ... % 14
        {'Fpz'} ... % 15
        [], ... % 16
        {'F7', 'AF7', 'F1', 'FC1', 'Fpz', 'F8', 'AF4'}, ... % 17
        {'F6', 'AF7', 'AF3', 'F7', 'FC1', 'AF4', 'FC1'}, ... % 18
        [], ... % 19
        [], ... % 20
        [], ... % 21
        ...
        ... % SESSION I
        ...
        [], ... % 22
        [], ... % 23
        []      % 24
        
        };
    
end

%% Stimulation X, block post

if strcmp(currStimID, 'X')  && strcmp(currBlock, 'post')
    
    chans = { ...
        ...
        ... % SESSION D
        ...
        {'Fp1', 'AF7'}, ... % 1
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
        ...
        ... % SESSION I
        ...
        [], ... % 22
        [], ... % 23
        []      % 24
        
        };
    
end

%% Outputs

outChans = chans{str2double(currSub(2:end))};