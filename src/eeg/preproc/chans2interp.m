function outChans = chans2interp(currSub,currSession,currBlock)
% Retrieve cell array of channels to be interpolated for a particular file
% (subject/session/block combination).
% Usage:
% outChans = chans2interp(currSub,currSession,currBlock)

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
        {'POz', 'O2'}, ... % 1
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