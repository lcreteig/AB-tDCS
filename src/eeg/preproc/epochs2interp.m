function [outChans, outEpochs] = epochs2interp(currSub,currSession,currBlock)
% Retrieve channels and single epochs on which these channels should be
% interpolated for a particular file (subject/session/block combination).
% Usage:
% [outChans, outEpochs] = epochs2interp(currSub,currSession,currBlock)
% 
% -outChans should be as long as outEpochs, even when multiple epochs for
% one electrode should be interpolated. For example: {'P2', 'Fz', 'P2'}.
% -outEpochs is a matching vector of trial indices, for example [1, 1, 3].
% This will interpolate channels P2 and Fz on trial 1, and channel P2 on
% trial 3.
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

% S01
chans{1} = [];
epochs{1} = [];

% S02
chans{2} = [];
epochs{2} = [];

% S03
chans{3} = [];
epochs{3} = [];

% S04
chans{4} = [];
epochs{4} = [];

% S05
chans{5} = [];
epochs{5} = [];

% S06
chans{6} = [];
epochs{6} = [];

% S07
chans{7} = [];
epochs{7} = [];

% S08
chans{8} = [];
epochs{8} = [];

% S09
chans{9} = [];
epochs{9} = [];

% S10
chans{10} = [];
epochs{10} = [];

% S11
chans{11} = [];
epochs{11} = [];

% S12
chans{12} = [];
epochs{12} = [];

% S13
chans{13} = [];
epochs{13} = [];

% S14
chans{14} = [];
epochs{14} = [];

% S15
chans{15} = [];
epochs{15} = [];

% S16
chans{16} = [];
epochs{16} = [];

% S17
chans{17} = [];
epochs{17} = [];

% S18
chans{18} = [];
epochs{18} = [];

% S19
chans{19} = [];
epochs{19} = [];

% S20
chans{20} = [];
epochs{20} = [];

% S21
chans{21} = [];
epochs{21} = [];

end

%% Session B, block tDCS

if strcmp(currSession, 'B')  && strcmp(currBlock, 'tDCS') 

% S01
chans{1} = [];
epochs{1} = [];

% S02
chans{2} = [];
epochs{2} = [];

% S03
chans{3} = [];
epochs{3} = [];

% S04
chans{4} = [];
epochs{4} = [];

% S05
chans{5} = [];
epochs{5} = [];

% S06
chans{6} = [];
epochs{6} = [];

% S07
chans{7} = [];
epochs{7} = [];

% S08
chans{8} = [];
epochs{8} = [];

% S09
chans{9} = [];
epochs{9} = [];

% S10
chans{10} = [];
epochs{10} = [];

% S11
chans{11} = [];
epochs{11} = [];

% S12
chans{12} = [];
epochs{12} = [];

% S13
chans{13} = [];
epochs{13} = [];

% S14
chans{14} = [];
epochs{14} = [];

% S15
chans{15} = [];
epochs{15} = [];

% S16
chans{16} = [];
epochs{16} = [];

% S17
chans{17} = [];
epochs{17} = [];

% S18
chans{18} = [];
epochs{18} = [];

% S19
chans{19} = [];
epochs{19} = [];

% S20
chans{20} = [];
epochs{20} = [];

% S21
chans{21} = [];
epochs{21} = [];

end

%% Session B, block post

if strcmp(currSession, 'B')  && strcmp(currBlock, 'post') 

% S01
chans{1} = [];
epochs{1} = [];

% S02
chans{2} = [];
epochs{2} = [];

% S03
chans{3} = [];
epochs{3} = [];

% S04
chans{4} = [];
epochs{4} = [];

% S05
chans{5} = [];
epochs{5} = [];

% S06
chans{6} = [];
epochs{6} = [];

% S07
chans{7} = [];
epochs{7} = [];

% S08
chans{8} = [];
epochs{8} = [];

% S09
chans{9} = [];
epochs{9} = [];

% S10
chans{10} = [];
epochs{10} = [];

% S11
chans{11} = [];
epochs{11} = [];

% S12
chans{12} = [];
epochs{12} = [];

% S13
chans{13} = [];
epochs{13} = [];

% S14
chans{14} = [];
epochs{14} = [];

% S15
chans{15} = [];
epochs{15} = [];

% S16
chans{16} = [];
epochs{16} = [];

% S17
chans{17} = [];
epochs{17} = [];

% S18
chans{18} = [];
epochs{18} = [];

% S19
chans{19} = [];
epochs{19} = [];

% S20
chans{20} = [];
epochs{20} = [];

% S21
chans{21} = [];
epochs{21} = [];

end

%% Session D, block pre

if strcmp(currSession, 'D')  && strcmp(currBlock, 'pre') 

% S01
chans{1} = [];
epochs{1} = [];

% S02
chans{2} = [];
epochs{2} = [];

% S03
chans{3} = [];
epochs{3} = [];

% S04
chans{4} = [];
epochs{4} = [];

% S05
chans{5} = [];
epochs{5} = [];

% S06
chans{6} = [];
epochs{6} = [];

% S07
chans{7} = [];
epochs{7} = [];

% S08
chans{8} = [];
epochs{8} = [];

% S09
chans{9} = [];
epochs{9} = [];

% S10
chans{10} = [];
epochs{10} = [];

% S11
chans{11} = [];
epochs{11} = [];

% S12
chans{12} = [];
epochs{12} = [];

% S13
chans{13} = [];
epochs{13} = [];

% S14
chans{14} = [];
epochs{14} = [];

% S15
chans{15} = [];
epochs{15} = [];

% S16
chans{16} = [];
epochs{16} = [];

% S17
chans{17} = [];
epochs{17} = [];

% S18
chans{18} = [];
epochs{18} = [];

% S19
chans{19} = [];
epochs{19} = [];

% S20
chans{20} = [];
epochs{20} = [];

% S21
chans{21} = [];
epochs{21} = [];

end

%% Session D, block tDCS

if strcmp(currSession, 'D')  && strcmp(currBlock, 'tDCS') 

% S01
chans{1} = [];
epochs{1} = [];

% S02
chans{2} = [];
epochs{2} = [];

% S03
chans{3} = [];
epochs{3} = [];

% S04
chans{4} = [];
epochs{4} = [];

% S05
chans{5} = [];
epochs{5} = [];

% S06
chans{6} = [];
epochs{6} = [];

% S07
chans{7} = [];
epochs{7} = [];

% S08
chans{8} = [];
epochs{8} = [];

% S09
chans{9} = [];
epochs{9} = [];

% S10
chans{10} = [];
epochs{10} = [];

% S11
chans{11} = [];
epochs{11} = [];

% S12
chans{12} = [];
epochs{12} = [];

% S13
chans{13} = [];
epochs{13} = [];

% S14
chans{14} = [];
epochs{14} = [];

% S15
chans{15} = [];
epochs{15} = [];

% S16
chans{16} = [];
epochs{16} = [];

% S17
chans{17} = [];
epochs{17} = [];

% S18
chans{18} = [];
epochs{18} = [];

% S19
chans{19} = [];
epochs{19} = [];

% S20
chans{20} = [];
epochs{20} = [];

% S21
chans{21} = [];
epochs{21} = [];

end

%% Session D, block post

if strcmp(currSession, 'D')  && strcmp(currBlock, 'post') 

% S01
chans{1} = [];
epochs{1} = [];

% S02
chans{2} = [];
epochs{2} = [];

% S03
chans{3} = [];
epochs{3} = [];

% S04
chans{4} = [];
epochs{4} = [];

% S05
chans{5} = [];
epochs{5} = [];

% S06
chans{6} = [];
epochs{6} = [];

% S07
chans{7} = [];
epochs{7} = [];

% S08
chans{8} = [];
epochs{8} = [];

% S09
chans{9} = [];
epochs{9} = [];

% S10
chans{10} = [];
epochs{10} = [];

% S11
chans{11} = [];
epochs{11} = [];

% S12
chans{12} = [];
epochs{12} = [];

% S13
chans{13} = [];
epochs{13} = [];

% S14
chans{14} = [];
epochs{14} = [];

% S15
chans{15} = [];
epochs{15} = [];

% S16
chans{16} = [];
epochs{16} = [];

% S17
chans{17} = [];
epochs{17} = [];

% S18
chans{18} = [];
epochs{18} = [];

% S19
chans{19} = [];
epochs{19} = [];

% S20
chans{20} = [];
epochs{20} = [];

% S21
chans{21} = [];
epochs{21} = [];

end

%% Outputs

    sub = strcmp(currSub, subjects);
    outChans = chans{sub};
    outEpochs = epochs{sub};

end