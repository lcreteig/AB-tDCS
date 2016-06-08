function [outChans, outEpochs] = epochs2interp(currSub,currStimID,currBlock)
% EPOCHS2INTERP: Retrieve channels and single epochs on which these channels should be
% interpolated for a particular file (subject/stimulation/block combination).
%
% Usage:
% [outChans, outEpochs] = EPOCHS2INTERP(currSub,currStimID,currBlock)
%
% Inputs:
%   - currSub: string with subject ID of file (e.g. 'S01' or 'S18')
%   - currStimID: string with stimulation ID of session ('Y' or 'X')
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
     
%% Stimulation Y, block pre

if strcmp(currStimID, 'Y')  && strcmp(currBlock, 'pre') 

%%%%%%%%%%%%%
% Session B %
%%%%%%%%%%%%%
    
% S01
chans{1} = {'PO7','PO7','FT8','T7','P2','P2','P2','P2'};
epochs{1} = [28 33 78 79 136 140 175 176];

% S02
chans{2} = {'PO8','PO8','F6','F6','F6','P9','Cz','FT8','P9','P9'};
epochs{2} = [11 16 33 34 39 76 136 147 13 14];

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

%%%%%%%%%%%%%
% Session D %
%%%%%%%%%%%%%

% S22
chans{22} = [];
epochs{22} = [];

% S23
chans{23} = [];
epochs{23} = [];

% S24
chans{24} = [];
epochs{24} = [];

end

%% Stimulation Y, block tDCS

if strcmp(currStimID, 'Y') && strcmp(currBlock, 'tDCS')
    
%%%%%%%%%%%%%
% Session B %
%%%%%%%%%%%%%

% S01
chans{1} = {'FT8','FT8','FT8','P2','P2','P2','P2','F8'};
epochs{1} = [8 9 10 24 56 72 131 152];

% S02
chans{2} = {'C6','Fp1','AF7','Fp1','AF7','Fp1','AF7','Fp1','AF7','Fp1','AF7','Fp1','AF7','Fp1','AF7','FC1','FC1'};
epochs{2} = [151 187 187 188 188 189 189 190 190 191 191 192 192 193 193 192 193];

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

%%%%%%%%%%%%%
% Session D %
%%%%%%%%%%%%%

% S22
chans{22} = [];
epochs{22} = [];

% S23
chans{23} = [];
epochs{23} = [];

% S24
chans{24} = [];
epochs{24} = [];

end

%% Stimulation Y, block post

if strcmp(currStimID, 'Y')  && strcmp(currBlock, 'post') 

%%%%%%%%%%%%%
% Session B %
%%%%%%%%%%%%%    
    
% S01
chans{1} = {'P2'};
epochs{1} = 21;

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

%%%%%%%%%%%%%
% Session D %
%%%%%%%%%%%%%

% S22
chans{22} = [];
epochs{22} = [];

% S23
chans{23} = [];
epochs{23} = [];

% S24
chans{24} = [];
epochs{24} = [];

end

%% Stimulation X, block pre

if strcmp(currStimID, 'X')  && strcmp(currBlock, 'pre') 

%%%%%%%%%%%%%
% Session D %
%%%%%%%%%%%%%     
    
% S01
chans{1} = {'TP7', 'P2', 'P10', 'FC6', 'P10', 'CP4'};
epochs{1} = [3 9 11 42 50 169];

% S02
chans{2} = {'TP8','PO3','PO3','O1','O1','TP8','TP8','PO3','PO3','FT8','O1'};
epochs{2} = [7 29 32 69 80 90 106 106 108 146 184];

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

%%%%%%%%%%%%%
% Session I %
%%%%%%%%%%%%%

% S22
chans{22} = [];
epochs{22} = [];

% S23
chans{23} = [];
epochs{23} = [];

% S24
chans{24} = [];
epochs{24} = [];

end

%% Stimulation X, block tDCS

if strcmp(currStimID, 'X')  && strcmp(currBlock, 'tDCS') 

%%%%%%%%%%%%%
% Session D %
%%%%%%%%%%%%%     
    
% S01
chans{1} = {'P10','P10','P9','FC4','FC5','FC5','CP4','P2','P10','P10','P4','FC5','FT8','AF7','AF7','AF7','AF7','AF7','AF4','AF4','AF4','AF4'};
epochs{1} = [54 57 57 86 91 92 91 107 138 141 152 158 177 184 186 187 188 189 186 187 188 189];

% S02
chans{2} = {'O1','F5','F8','F5','F8','F5','F8'};
epochs{2} = [88 150 150 151 151 152 152];

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

%%%%%%%%%%%%%
% Session I %
%%%%%%%%%%%%%

% S22
chans{22} = [];
epochs{22} = [];

% S23
chans{23} = [];
epochs{23} = [];

% S24
chans{24} = [];
epochs{24} = [];

end

%% Stimulation X, block post

if strcmp(currStimID, 'X')  && strcmp(currBlock, 'post') 

%%%%%%%%%%%%%
% Session D %
%%%%%%%%%%%%%     
    
% S01
chans{1} = {'AF4', 'FC4'};
epochs{1} = [1 122];

% S02
chans{2} = {'F8','F5','F5','P8','P8','P8','P6','Fpz'};
epochs{2} = [1 13 14 18 26 44 67 96];

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

%%%%%%%%%%%%%
% Session I %
%%%%%%%%%%%%%

% S22
chans{22} = [];
epochs{22} = [];

% S23
chans{23} = [];
epochs{23} = [];

% S24
chans{24} = [];
epochs{24} = [];

end

%% Outputs

    outChans = chans{str2double(currSub(2:end))};
    outEpochs = epochs{str2double(currSub(2:end))};

    assert(length(outChans) == length(outEpochs), 'Mismatch between channel and epoch list!')
end