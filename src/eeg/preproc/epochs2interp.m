function [outChans, outEpochs] = epochs2interp(currSub,currSession,currBlock)
% EPOCHS2INTERP: Retrieve channels and single epochs on which these channels should be
% interpolated for a particular file (subject/session/block combination).
%
% Usage:
% [outChans, outEpochs] = EPOCHS2INTERP(currSub,currSession,currBlock)
%
% Inputs:
%   - currSub: string with subject ID of file (e.g. 'S01' or 'S18')
%   - currSession: string with tDCS code of file ('B' or 'D')
%   - currBlock: string with block of file ('pre', 'tDCS', or 'post')
%
% Outputs:
%   - outChans: cell-array of strings containing channels to be
%   interpolated. outChans should be as long as outEpochs, even when multiple epochs for
%   one electrode should be interpolated. For example: {'P2', 'Fz', 'P2'}.
%   - outEpochs: -outEpochs is a matching vector of trial indices, for example [1, 1, 3].
%   This will interpolate channels P2 and Fz on trial 1, and channel P2 on
%   trial 3.
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

% S01
chans{1} = {'FP9','P2','P2','P2','P2','P2','P2','P7','PO7','P9','P9','T7', 'FT8'};
epochs{1} = [11 11 114 140 148 175 176 27 28 33 71 79 76];

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

if strcmp(currSession, 'B') && strcmp(currBlock, 'tDCS') 

% S01
chans{1} = {'F8', 'F8', 'F8', 'F8', 'P2', 'P2', 'CP3' 'P2', 'P2', 'P2','P2', 'P2', 'P2', 'P2', 'P2'};
epochs{1} = [6 8 9 10 9 12 17 19 24 38 52 57 72 97 98];

% S02
chans{2} = [];
epochs{2} = [];

% S03
chans{3} = {'C3'};
epochs{3} = [11];

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
chans{7} = {'F8', 'F8'};
epochs{7} = [3 4];

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
chans{1} = {'P2', 'P2', 'P7', 'P7', 'P7', 'P7'};
epochs{1} = [126 125 146 180 181 182];

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
chans{1} = {'P2', 'P2', 'P10', 'T8', 'P10', 'P10', 'P8', 'P10', 'P10', 'P10', 'P10', 'P8', 'Iz', 'P10', 'P8', 'P10', 'P8', 'P2'};
epochs{1} = [42 43 63 64 89 102 102 106 107 117 128 128 129 137 137 141 141 175];

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
chans{1} = {'P10', 'P9', 'P10', 'P9', 'P10', 'P9', 'P8', 'FC4', 'CP4', 'P2' 'P2', 'P8', 'P10'};
epochs{1} = [57 57 61 61 68 68 68 86 91 107 131 138 138];

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

    assert(length(outChans) == length(outEpochs), 'Mismatch between channel and epoch list!')
end