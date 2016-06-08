function outChans = chans2interp(currSub,currStimID,currBlock)
% CHANS2INTERP: Retrieve cell array of channels to be interpolated for a particular file
% (subject/stimulation/block combination).
%
% Usage:
% outChans = CHANS2INTERP(currSub,currStimID,currBlock)
%
% Inputs:
%   - currSub: string with subject ID of file (e.g. 'S01' or 'S18')
%   - currStimID: string with stimulation ID of session ('Y' or 'X')
%   - currBlock: string with block of file ('pre', 'tDCS', or 'post')
%
% Outputs:
%   - outChans: cell-array of strings containing channels to be
%   interpolated.
%
% Called in preproc_interp_channels, preproc_interp_epochs, preprocess
%
% See also PREPROC_INTERP_CHANNELS, PREPROC_INTERP_EPOCHS, PREPROCESS

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
        {'PO4'}, ... % 18
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

%% Stimulation Y, block post

if strcmp(currStimID, 'Y')  && strcmp(currBlock, 'post')
    
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

%% Outputs

outChans = chans{str2double(currSub(2:end))};