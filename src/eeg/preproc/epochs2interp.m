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
chans{3} = {'C6','C2'};
epochs{3} = [110 146];

% S04
chans{4} = {'P9','P9','TP7','P9','TP7','F7','FC6','F7','P9','P9'};
epochs{4} = [11 13 21 27 27 30 53 121 141 187];

% S05
chans{5} = {'PO7','PO7','FT8','T7','T7','PO7'};
epochs{5} = [7 28 29 36 58 129];

% S06
chans{6} = {'FC4','FC4','F7','FC6','FT8','FC4','FC4','T7','Fpz','FC4','F4','P4','P4','Fp1','T7','TP7','TP7'};
epochs{6} = [2 4 22 26 29 52 61 54 79 78 117 128 131 166 182 211 218];

% S07
chans{7} = {'O1','O1'};
epochs{7} = [26 27];

% S08
chans{8} = {'F8','T8','PO3','PO3','PO3','Iz','POz','FC6','F8','PO3','P9','P4'};
epochs{8} = [4 29 37 48 56 59 130 136 158 158 163 188];

% S09
chans{9} = {'P9','FC5','FC5'};
epochs{9} = [190 228 228];

% S10
chans{10} = {'FT8','FT8','FT8','FT8','FT8','FT8','FT8','FT8','FT8','F2','F2','F2','F2'};
epochs{10} = [16 37 55 66 77 85 95 107 117 121 124 148 149];

% S11
chans{11} = {'CP5','Fp1','T8','T8'};
epochs{11} = [6 41 127 130];

% S12
chans{12} = {'FC4','O1','FC4','C6','F4','FC4','C6','FC4','FC4','FC4','FC4'};
epochs{12} = [18 22 24 32 34 40 55 73 111 112 185];

% S13
chans{13} = {'CP2'};
epochs{13} = [96];

% S14
chans{14} = [];
epochs{14} = [];

% S15
chans{15} = {'CPz','Pz','Pz','FT8','P4','P9','PO7','Pz','P9','T7','FT7','CPz','C5'};
epochs{15} = [1 17 18 40 41 41 91 96 106 122 122 124 148]; 

% S16
chans{16} = {'C6','C6','C6','C6','C6','P9','T8','FC6'};
epochs{16} = [46 56 64 72 75 84 131 160];

% S17
chans{17} = {'FT7'};
epochs{17} = [4];

% S18
chans{18} = {'T8'};
epochs{18} = [86];

% S19
chans{19} = {'C5','C5','C5','C5','C5','C5','FC6','FT7','FT7','FT7','F7','FT7','P2','FT7','FT7','FT7','P2','FT7','FT7'};
epochs{19} = [1 2 3 4 5 6 3 56 60 71 73 91 100 101 103 159 166 180 182];

% S20
chans{20} = {'P4','FCz','PO8','PO8','PO3'};
epochs{20} = [39 59 109 186 198];

% S21
chans{21} = {'AF4','F6'};
epochs{21} = [16 131];

%%%%%%%%%%%%%
% Session D %
%%%%%%%%%%%%%

% S22
chans{22} = {'FT8', 'FC4', 'Iz', 'F7', 'F7', 'FT8', 'P3', 'F7', 'AFz', 'AFz'};
epochs{22} = [37 44 46 87 88 90 116 117 120 121];

% S23
chans{23} = {'TP8', 'FC6', 'AFz', 'C2', 'FT7', 'FT8', 'C2', 'CP3', 'FT7', 'FT7', 'FC2', 'C4', 'C4', 'FC2', 'F6', 'TP7', 'FT7', 'FT7'};
epochs{23} = [2 2 32 32 46 52 52 53 56 57 60 62 65 67 110 130 138 139];

% S24
chans{24} = {'Fpz', 'TP7', 'CP4', 'F4', 'FT7', 'P7', 'T7', 'TP7', 'TP7', 'P7', 'AF4'};
epochs{24} = [136 121 50 50 29 16 42 107 119 119 137];

% S25
chans{25} = [];
epochs{25} = [];

% S26
chans{26} = {'FT7', 'FT8'};
epochs{26} = [141 142];

% S27
chans{27} = {'TP8', 'TP8', 'TP8', 'P7', 'P2', 'F4', 'C3', 'Cz', 'P7', 'TP8', 'TP8'};
epochs{27} = [14 17 30 42 65 116 125 130 146 155 171];

% S28
chans{28} = {'AF7', 'AF7', 'AF7', 'AF7', 'AF7', 'AF7', 'AF7'};
epochs{28} = [18 19 20 28 29 63 188];

% S29
chans{29} = [];
epochs{29} = [];

% S30
chans{30} = {'P10', 'P10', 'P10', 'P10', 'F2', 'T8'};
epochs{30} = [7 17 44 46 55 179];

% S31
chans{31} = [];
epochs{31} = [];

% S32
chans{32} = {'F7', 'FT7', 'FT7', 'P7', 'P9', 'P7', 'P7', 'FT7', 'FT7', 'FT7', 'FT7', 'FT7', 'FT7', 'FT7' 'AFz'};
epochs{32} = [61 61 62 15 29 71 79 80 117 118 119 120 121 157 195];

% S33
chans{33} = {'P7', 'TP8', 'F7', 'TP8', 'TP8', 'Fp1'};
epochs{33} = [10 45 48 51 80 74];

% S34
chans{34} = {'T7', 'FT8', 'P5', 'P5', 'P9', 'FT8', 'P5', 'FT8', 'P5', 'P5', 'T7', 'P5', 'P5', 'P5', 'P9', 'P5', 'P5'};
epochs{34} = [1 1 11 14 20 21 26 33 73 80 92 113 124 134 159 196 222];

% S35
chans{35} = {'F6'};
epochs{35} = [69];

% S36
chans{36} = {'T7'};
epochs{36} = [23];

% S37
chans{37} = {'FT7', 'FT8', 'FC2'};
epochs{37} = [173 173 176];

% S38
chans{38} = [];
epochs{38} = [];

% S39
chans{39} = {'C1', 'Iz', 'P5', 'C1', 'C1', 'Iz', 'P5', 'P5'};
epochs{39} = [2 38 55 52 55 83 108 111];

% S40
chans{40} = [];
epochs{40} = [];

% S41
chans{41} = {'C2', 'F4', 'C4'};
epochs{41} = [132 143 172];

% S42
chans{42} = [];
epochs{42} = [];

% S43
chans{43} = [];
epochs{43} = [];

% S44
chans{44} = {'CP2', 'FC6', 'P9'};
epochs{44} = [5 90 151];

% S45
chans{45} = [];
epochs{45} = [];

% S46
chans{46} = [];
epochs{46} = [];

% S47
chans{47} = {'Oz', 'AF3', 'Oz', 'C3'};
epochs{47} = [10 10 64 97];

% S48
chans{48} = {'F8', 'PO3', 'PO3', 'F6', 'AF4', 'P7', 'P7', 'Fp1', 'P7', 'P3'};
epochs{48} = [24 49 53 56 88 97 118 118 122 139];

% S49
chans{49} = {'TP8', 'T7', 'TP8', 'TP8'};
epochs{49} = [2 57 73 74];

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
chans{2} = {'C6','Fp1','AF7','Fp1','AF7','Fp1','AF7','Fp1','AF7','Fp1','AF7','Fp1','AF7','Fp1','AF7'};
epochs{2} = [151 187 187 188 188 189 189 190 190 191 191 192 192 193 193];

% S03
chans{3} = {'C3'};
epochs{3} = [11];

% S04
chans{4} = {'AF4'};
epochs{4} = [51];

% S05
chans{5} = {'Fpz','FC6','TP8','FC6','FT7','FT7','TP8','TP8','FT7','Fpz','AF4','FT8'};
epochs{5} = [12 12 21 27 36 65 61 84 98 161 161 179];

% S06
chans{6} = {'TP7','TP7','F6','Fpz','TP7','Fpz','F4','F6','Fpz','TP7','F6','F6','Fpz','TP7','F6'};
epochs{6} = [36 47 74 164 168 182 195 195 209 209 209 210 210 212 217];

% S07
chans{7} = {'F6','F6','F6','F6','Fpz','FC5','F8'};
epochs{7} = [2 4 5 34 41 47 57];

% S08
chans{8} = {'Oz','P4','T8','PO3','P4','O2','P4','P4','P4','O2','PO4','P5','P4','FC6','O2'};
epochs{8} = [11 18 53 69 74 78 86 97 103 128 128 141 163 165 166];

% S09
chans{9} = [];
epochs{9} = [];

% S10
chans{10} = {'FT7','F1','FT7'};
epochs{10} = [20 153 153];

% S11
chans{11} = {'CP3','CP3','CP3'};
epochs{11} = [63 64 65];

% S12
chans{12} = {'P9','P9','P9','FC4','P9','P9','FC4','FT8','CP4','FC4'};
epochs{12} = [8 9 20 28 32 68 111 118 140 145];

% S13
chans{13} = {'F8','F8','Fp1','C3'};
epochs{13} = [117 118 182 222];

% S14
chans{14} = [];
epochs{14} = [];

% S15
chans{15} = {'CPz','Pz','P9','CPz','C5','P9','Fp1','Fp1','Fp1','Fp1','CPz','C5'};
epochs{15} = [19 19 23 42 61 82 107 108 109 127 127 135];

% S16
chans{16} = {'T8','C4'};
epochs{16} = [11 94];

% S17
chans{17} = [];
epochs{17} = [];

% S18
chans{18} = [];
epochs{18} = [];

% S19
chans{19} = {'C5','FT7','FT7','FT7','FT7','C5','FT7','FT7','C5','C5','C5'};
epochs{19} = [2 11 34 35 36 31 78 79 124 125 158];

% S20
chans{20} = {'P4','Pz','F6','F6'};
epochs{20} = [12 31 160 161];

% S21
chans{21} = {'FT7','F8','F8'};
epochs{21} = [104 191 195];

%%%%%%%%%%%%%
% Session D %
%%%%%%%%%%%%%

% S22
chans{22} = {'AF7', 'AF7', 'F6', 'FT8'};
epochs{22} = [12 14 81 81];

% S23
chans{23} = [];
epochs{23} = [];

% S24
chans{24} = {'P7', 'F2', 'Fpz', 'AF4'};
epochs{24} = [9 19 144 144];

% S25
chans{25} = [];
epochs{25} = [];

% S26
chans{26} = {'FC1', 'FC1', 'FC1'};
epochs{26} = [136 137 138];

% S27
chans{27} = {'F8'};
epochs{27} = [35];

% S28
chans{28} = [];
epochs{28} = [];

% S29
chans{29} = [];
epochs{29} = [];

% S30
chans{30} = {'P2'};
epochs{30} = [121];

% S31
chans{31} = [];
epochs{31} = [];

% S32
chans{32} = {'FT7', 'FT7', 'FT7', 'P9', 'P9'};
epochs{32} = [21 22 35 79 80];

% S33
chans{33} = {'F8'};
epochs{33} = [46];

% S34
chans{34} = {'F2', 'F4', 'F4', 'F4', 'F4', 'T7', 'F4', 'F4', 'F4', 'P5', 'FT7', 'F7', 'P9', 'F4', 'F4'};
epochs{34} = [20 20 41 51 52 52 68 69 92 112 140 140 149 167 180];

% S35
chans{35} = {'TP8'};
epochs{35} = [51];

% S36
chans{36} = [];
epochs{36} = [];

% S37
chans{37} = [];
epochs{37} = [];

% S38
chans{38} = [];
epochs{38} = [];

% S39
chans{39} = {'FT8'};
epochs{39} = [57];

% S40
chans{40} = [];
epochs{40} = [];

% S41
chans{41} = {'FT7'};
epochs{41} = [74];

% S42
chans{42} = [];
epochs{42} = [];

% S43
chans{43} = [];
epochs{43} = [];

% S44
chans{44} = {'FC6', 'FC6'};
epochs{44} = [8 22];

% S45
chans{45} = {'Fpz'};
epochs{45} = [170];

% S46
chans{46} = [];
epochs{46} = [];

% S47
chans{47} = [];
epochs{47} = [];

% S48
chans{48} = {'F4', 'F4', 'F4', 'P7'};
epochs{48} = [103 104 108 160];

% S49
chans{49} = [];
epochs{49} = [];

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
chans{4} = {'CP2', 'P10', 'TP7', 'F7', 'F7'};
epochs{4} = [44 63 79 172 173];

% S05
chans{5} = {'Fp1','AF7','Fp1','AF7','Fp1','AF7','Fp1','AF7','Fp1','AF7','PO7','PO7','FT8','PO7'};
epochs{5} = [3 3 4 4 5 5 11 11 13 13 41 51 96 97];

% S06
chans{6} = {'C3','C3','C3','Fp1','TP7','AF7','Fp1','AF7','Fp1','Fpz','AF7','Fp1','TP7','Oz'};
epochs{6} = [1 25 86 112 129 156 157 195 195 195 201 201 233 233];

% S07
chans{7} = {'FT8','FT8','TP8'};
epochs{7} = [48 94 158];

% S08
chans{8} = {'CP3','T8','POz','O2','PO3','P4','Oz','POz','Pz','Iz','PO3','C4','O2','T8','T8','P4'};
epochs{8} = [58 96 97 98 116 116 140 144 158 158 159 163 165 182 183 212];

% S09
chans{9} = [];
epochs{9} = [];

% S10
chans{10} = {'F2','Fp1'};
epochs{10} = [42 53];

% S11
chans{11} = [];
epochs{11} = [];

% S12
chans{12} = {'AF7','FC6','F4','FCz','FCz','FCz','FCz'};
epochs{12} = [6 22 80 76 79 81 87];

% S13
chans{13} = [];
epochs{13} = [];

% S14
chans{14} = [];
epochs{14} = [];

% S15
chans{15} = {'F8','F6','AF4','C3','FC5','C5','F8','F6','AF4','C3','FC5','F8','F6','AF4','C5','F2','F8','F6','AF4','C3','FC5','C5','CPz','FT8','C5'};
epochs{15} = [6 6 6 6 6 11 12 12 12 12 12 15 15 15 22 24 35 35 35 35 35 57 89 113 137];

% S16
chans{16} = {'F7','F7','TP8','TP8','C2','T8','FC6','FC6'};
epochs{16} = [32 49 47 52 90 144 186 187];

% S17
chans{17} = {'CPz','CPz','CPz'};
epochs{17} = [31 116 117];

% S18
chans{18} = {'AFz','AFz','AF4','AFz','AF4','Fp1','F6','AFz','AFz','Fp1','AFz','Fp1','AF4','Fpz','Fp1'};
epochs{18} = [25 26 47 85 85 85 85 86 90 90 145 145 145 145 148];

% S19
chans{19} = {'FT7','FT7','FT7','FT7'};
epochs{19} = [159 188 189 197];

% S20
chans{20} = [];
epochs{20} = [];

% S21
chans{21} = {'FC5','C3'};
epochs{21} = [1 1];

%%%%%%%%%%%%%
% Session D %
%%%%%%%%%%%%%

% S22
chans{22} = {'T7'};
epochs{22} = [2];

% S23
chans{23} = {'T8', 'FC2', 'FC2', 'FC2'};
epochs{23} = [9 134 135 136];

% S24
chans{24} = {'C5'};
epochs{24} = [139];

% S25
chans{25} = [];
epochs{25} = [];

% S26
chans{26} = {'FC2'};
epochs{26} = [80];

% S27
chans{27} = {'FC5', 'FC5', 'FT8', 'P4'};
epochs{27} = [67 68 117 166];

% S28
chans{28} = {'AF7', 'AF7', 'AF7', 'FT8', 'FT8', 'FT8'};
epochs{28} = [2 5 6 182 183 184];

% S29
chans{29} = [];
epochs{29} = [];

% S30
chans{30} = {'FT8', 'FT8', 'FT8', 'FT8', 'FT8', 'FT8', 'FT8', 'Iz', 'FT8', 'FT8'};
epochs{30} = [1 64 65 76 77 78 79 77 178 195];

% S31
chans{31} = [];
epochs{31} = [];

% S32
% note: P9 pure noise in trials 1-39, then fixed by re-geling
P9rep = cell(1,39);
P9rep(:) = {'P9'};

chans{32} = {P9rep{:}, 'C3', 'FT7', 'P7', 'P7'};
epochs{32} = [1:39 16 118 157 204];

% S33
chans{33} = {'P7', 'PO7', 'TP8', 'P7', 'TP8'};
epochs{33} = [7 47 107 118 139];

% S34
chans{34} = {'Cz', 'F4', 'F4', 'P9', 'P9', 'T7', 'F4', 'F4', 'P9', 'F4'};
epochs{34} = [54 74 75 74 91 110 111 112 163 234];

% S35
chans{35} = {'TP8', 'TP8', 'TP8'};
epochs{35} = [60 98 183];

% S36
chans{36} = [];
epochs{36} = [];

% S37
chans{37} = {'FT8', 'FT7'};
epochs{37} = [103 103];

% S38
chans{38} = [];
epochs{38} = [];

% S39
chans{39} = {'P5', 'POz'};
epochs{39} = [35 72];

% S40
chans{40} = {'FC6', 'FC6'};
epochs{40} = [68 69];

% S41
chans{41} = {'FC1', 'AF7', 'P9', 'F8', 'F8', 'F8'};
epochs{41} = [1 1 10 147 148 151];

% S42
chans{42} = [];
epochs{42} = [];

% S43
chans{43} = [];
epochs{43} = [];

% S44
chans{44} = [];
epochs{44} = [];

% S45
chans{45} = [];
epochs{45} = [];

% S46
chans{46} = [];
epochs{46} = [];

% S47
chans{47} = [];
epochs{47} = [];

% S48
chans{48} = {'PO3', 'F4'};
epochs{48} = [114 169];

% S49
chans{49} = [];
epochs{49} = [];

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
chans{4} = {'T8','T8','T8','T8','P3','P3','P3','P3','P3','P3','P3','P3','P3','P3','P3'};
epochs{4} = [77 87 89 90 189 190 191 192 193 194 195 196 197 198 199];

% S05
chans{5} = {'Oz','Fp1','Fp1'};
epochs{5} = [11 25 176];

% S06
chans{6} = {'TP7','FC6','TP7'};
epochs{6} = [105 168 186];

% S07
chans{7} = {'FT7', 'FT7', 'P5'};
epochs{7} = [196 198 197];

% S08
chans{8} = {'FC4','FC4','FC6','FC6'};
epochs{8} = [91 199 199 209];

% S09
chans{9} = [];
epochs{9} = [];

% S10
chans{10} = {'FT8','CP1'};
epochs{10} = [157 159];

% S11
chans{11} = [];
epochs{11} = [];

% S12
chans{12} = {'POz','POz','Iz','Iz','FC4','POz','PO4','POz','FC6','POz','FC6','F4','POz','FC6','FC6','F4'};
epochs{12} = [20 36 51 52 71 85 82 96 103 108 137 144 147 153 154 193];

% S13
chans{13} = {'T7','T7','T7'};
epochs{13} = [14 15 169];

% S14
chans{14} = [];
epochs{14} = [];

% S15
chans{15} = {'PO7','PO7','FT7','FT7','FT8','T8','FT7','FT8','P7','FT8','FT8','Iz','T8','FC2'};
epochs{15} = [3 4 12 50 50 50 51 51 52 52 56 100 125 177];

% S16
chans{16} = {'FC6','T8','FT7','T8','C4','C4'};
epochs{16} = [11 31 46 75 88 109];

% S17
chans{17} = {'PO7','PO7','F7','FT7','P4'};
epochs{17} = [72 92 138 138 200];

% S18
chans{18} = {'T8','FC6','FC6','FC6','FC6','FC6','FC6','FC6','P7','F8'};
epochs{18} = [9 81 82 83 84 85 86 87 86 121];

% S19
chans{19} = [];
epochs{19} = [];

% S20
chans{20} = {'O1','FT7','Fpz','PO3'};
epochs{20} = [25 27 31 104];

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
chans{23} = {'TP7', 'TP7'};
epochs{23} = [24 79];

% S24
chans{24} = {'F7', 'F7', 'F7', 'F7', 'F7', 'F7', 'F7', 'F7'};
epochs{24} = [23 33 44 57 71 75 101 151];

% S25
chans{25} = [];
epochs{25} = [];

% S26
chans{26} = {'P7'};
epochs{26} = [45];

% S27
chans{27} = {'FT8', 'T7', 'FT8', 'FT8', 'FT8', 'FT8', 'PO3'};
epochs{27} = [1 38 100 140 179, 181 183];

% S28
chans{28} = {'Fpz', 'AF7'};
epochs{28} = [108 108];

% S29
chans{29} = [];
epochs{29} = [];

% S30
chans{30} = {'F4', 'FT8', 'F4', 'F4', 'FT8'};
epochs{30} = [1 9 31 40 122];

% S31
chans{31} = [];
epochs{31} = [];

% S32
chans{32} = {'P9', 'F4', 'F4', 'P9', 'P9', 'P9', 'T7', 'P9', 'P9', 'P9', 'F4', 'T7', 'P9', 'FT8', 'FT8', 'P9', 'P9', 'F4', 'F4', 'F4', 'F4', 'F4', 'FT8', 'FT8', 'F4', 'F4', 'F4', 'FT8', 'FT8'};
epochs{32} = [5 11 13 22 27 32 34 36 45 47 118 119 141 145 154 157 160 167 184 182 187 188 189 191 192 194 195 199 201];

% S33
chans{33} = [];
epochs{33} = [];

% S34
chans{34} = {'P9', 'P9', 'P9', 'P9', 'P9', 'FT8', 'FT8'};
epochs{34} = [61 62 63 98 111 120 135];

% S35
chans{35} = {'FC6', 'F2'};
epochs{35} = [119 133];

% S36
% note: T8 pure noise in trials 1-39, then fixed by re-geling
T8rep = cell(1,39);
T8rep(:) = {'T8'};

chans{36} = {T8rep{:}, 'F8'};
epochs{36} = [1:39 93];

% S37
chans{37} = [];
epochs{37} = [];

% S38
chans{38} = [];
epochs{38} = [];

% S39
chans{39} = {'C3', 'C3', 'C3','Iz', 'Iz'};
epochs{39} = [4 11 96 157 159];

% S40
chans{40} = [];
epochs{40} = [];

% S41
chans{41} = {'FC4', 'P7', 'Oz'};
epochs{41} = [33 84 84];

% S42
chans{42} = [];
epochs{42} = [];

% S43
chans{43} = [];
epochs{43} = [];

% S44
chans{44} = [];
epochs{44} = [];

% S45
chans{45} = {'FC4', 'FC4'};
epochs{45} = [23 26];

% S46
chans{46} = [];
epochs{46} = [];

% S47
chans{47} = {'FT8', 'F4', 'P1'};
epochs{47} = [26 32 108];

% S48
chans{48} = {'F8'};
epochs{48} = [154];

% S49
chans{49} = [];
epochs{49} = [];

end

%% Stimulation X, block tDCS

if strcmp(currStimID, 'X')  && strcmp(currBlock, 'tDCS') 

%%%%%%%%%%%%%
% Session D %
%%%%%%%%%%%%%     
    
% S01
chans{1} = {'P10','P10','P9','FC4','FC5','FC5','CP4','P2','P10','P10','P4','FC5','FT8'};
epochs{1} = [54 57 57 86 91 92 91 107 138 141 152 158 177];

% S02
chans{2} = {'O1'};
epochs{2} = [88];

% S03
chans{3} = [];
epochs{3} = [];

% S04
chans{4} = {'FT8', 'Oz'};
epochs{4} = [144 194];

% S05
chans{5} = {'F6','FC4','FT8'};
epochs{5} = [17 54 105];

% S06
chans{6} = {'TP7','TP7'};
epochs{6} = [14 19];

% S07
chans{7} = {'F8','F6'};
epochs{7} = [143 170];

% S08
chans{8} = {'FC4','C4','C4','TP8'};
epochs{8} = [27 27 61 91];

% S09
chans{9} = {'P6','P6','C4'};
epochs{9} = [14 26 132];

% S10
chans{10} = {'FC2','FC2'};
epochs{10} = [14 24];

% S11
chans{11} = {'AFz','AFz','AFz'};
epochs{11} = [52 53 54];

% S12
chans{12} = {'TP8','C2','Iz','PO4','CP2','F4','TP8'};
epochs{12} = [46 59 62 63 105 175 188];

% S13
chans{13} = {'FT8','T7','FT8','FT8','C1','C3','C3','FT8','C5','FT8','C3','C3','C3'};
epochs{13} = [8 44 64 72 118 118 120 143 160 194 201 208 209];

% S14
chans{14} = [];
epochs{14} = [];

% S15
chans{15} = {'FT8','FC2','CP2','FT8','P10','FT8','CP1','FC6'};
epochs{15} = [46 53 59 61 82 105 103 141];

% S16
chans{16} = {'F4','CP6','FC6','FC4','C2','FC4','P9','FC6','T8'};
epochs{16} = [41 52 66 67 73 76 103 141 159];

% S17
chans{17} = {'P5'};
epochs{17} = [79];

% S18
chans{18} = {'F4','F4','F4','F4','F8','F8','F8','F4','F4'};
epochs{18} = [90 88 55 107 173 186 189 196 198];

% S19
chans{19} = [];
epochs{19} = [];

% S20
chans{20} = {'FT7'};
epochs{20} = [15];

% S21
chans{21} = {'F8','CP5','C5','Iz'};
epochs{21} = [69 69 116 118];

%%%%%%%%%%%%%
% Session I %
%%%%%%%%%%%%%

% S22
chans{22} = {'AF4', 'Fp1', 'AF4'};
epochs{22} = [1 128 158];

% S23
chans{23} = {'F8', 'F8', 'FC1', 'F8'};
epochs{23} = [78 80 197 210];

% S24
chans{24} = {'F7', 'P7'};
epochs{24} = [107 115];

% S25
chans{25} = [];
epochs{25} = [];

% S26
chans{26} = {'F8'};
epochs{26} = [127];

% S27
chans{27} = {'P8', 'F7', 'F6', 'F6', 'FT8', 'FC6', 'FT8'};
epochs{27} = [10 11 31 32 40 56 156];

% S28
chans{28} = [];
epochs{28} = [];

% S29
chans{29} = [];
epochs{29} = [];

% S30
chans{30} = {'T8'};
epochs{30} = [68];

% S31
chans{31} = [];
epochs{31} = [];

% S32
chans{32} = [];
epochs{32} = [];

% S33
chans{33} = [];
epochs{33} = [];

% S34
chans{34} = {'FT8', 'FT8', 'FT8', 'P9', 'P9', 'P9', 'P9', 'FT8', 'FT8'};
epochs{34} = [13 25 26 28 42 56 134 171 172];

% S35
chans{35} = {'F2', 'F2', 'F2'};
epochs{35} = [4 36 83];

% S36
chans{36} = {'F7', 'F7', 'F7', 'F7', 'FC4', 'P10'};
epochs{36} = [23 33 46 96 121 123];

% S37
chans{37} = [];
epochs{37} = [];

% S38
chans{38} = [];
epochs{38} = [];

% S39
chans{39} = {'F7', 'Iz', 'Iz', 'Iz'};
epochs{39} = [44 92 106 118];

% S40
chans{40} = [];
epochs{40} = [];

% S41
chans{41} = {'FT8', 'AF7', 'Fpz'};
epochs{41} = [61 98 98];

% S42
chans{42} = [];
epochs{42} = [];

% S43
chans{43} = [];
epochs{43} = [];

% S44
chans{44} = {'Fz'};
epochs{44} = [84];

% S45
chans{45} = [];
epochs{45} = [];

% S46
chans{46} = [];
epochs{46} = [];

% S47
chans{47} = {'Cz', 'Cz', 'Cz', 'F6', 'F7'};
epochs{47} = [19 21 29 47 87];

% S48
chans{48} = {'P10', 'PO8'};
epochs{48} = [79 79];

% S49
chans{49} = [];
epochs{49} = [];

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
chans{4} = {'F4', 'O2', 'FT8', 'Iz'};
epochs{4} = [7 22 171 192];

% S05
chans{5} = {'F7','FT7','Fpz','Fpz','CP5'};
epochs{5} = [16 16 16 47 56];

% S06
chans{6} = {'AF7','Fp1','FT7','AF7','AF7','AF7','AF7','FT7','AF7'};
epochs{6} = [17 19 26 35 49 74 83 92 157];

% S07
chans{7} = {'AF3', 'AF3'};
epochs{7} = [37 38];

% S08
chans{8} = [];
epochs{8} = [];

% S09
chans{9} = {'C3','F1','FC1','F6','F6','C3'};
epochs{9} = [3 89 89 117 118 119];

% S10
chans{10} = {'T7','C4'};
epochs{10} = [1 155];

% S11
chans{11} = [];
epochs{11} = [];

% S12
chans{12} = {'F4','T7','FC6','Fpz','F6','F8','FC6','F4','PO8','Fpz','F6','F8','F4','F4','FC6','FC6'};
epochs{12} = [24 45 52 57 57 57 66 86 92 117 117 117 134 167 186 187];

% S13
chans{13} = [];
epochs{13} = [];

% S14
chans{14} = [];
epochs{14} = [];

% S15
chans{15} = {'F7','F7','F7','Oz','POz','CP1','FC6'};
epochs{15} = [2 3 4 16 28 53 66];

% S16
chans{16} = {'Fpz','C2','Oz','T8','FC6','FC4','P10','FC6','FC6','F2'};
epochs{16} = [1 16 21 31 84 100 118 122 134 167];

% S17
chans{17} = {'Fpz','AF4','F8','Fpz','AF4','F8','CPz','CPz','CPz','AFz','PO7','AFz','AFz'};
epochs{17} = [5 5 5 11 11 11 66 67 68 133 137 191 196];

% S18
chans{18} = {'F1','F6','F6','F6'};
epochs{18} = [31 31 54 55];

% S19
chans{19} = [];
epochs{19} = [];

% S20
chans{20} = {'Fpz','AF7','Fpz','Fpz','AF7','Fpz','Cz','Cz','Cz'};
epochs{20} = [1 1 2 41 41 141 203 205 207];

% S21
chans{21} = [];
epochs{21} = [];

%%%%%%%%%%%%%
% Session I %
%%%%%%%%%%%%%

% S22
chans{22} = {'T7', 'T8', 'T7', 'T8', 'TP8', 'TP8', 'TP8', 'TP8', 'TP8', 'TP8'};
epochs{22} = [1 1 2 2 42 50 51 78 94 101];

% S23
chans{23} = {'T7'};
epochs{23} = [169];

% S24
chans{24} = {'Fpz', 'P7', 'P7', 'Iz', 'Fp1', 'F7'};
epochs{24} = [45 88 93 97 123 148];

% S25
chans{25} = [];
epochs{25} = [];

% S26
chans{26} = [];
epochs{26} = [];

% S27
chans{27} = {'F8', 'FC6', 'O1', 'O1'};
epochs{27} = [2 48 136 137];

% S28
chans{28} = [];
epochs{28} = [];

% S29
chans{29} = [];
epochs{29} = [];

% S30
chans{30} = {'AF7', 'AF3', 'FC1'};
epochs{30} = [201 201 201];

% S31
chans{31} = [];
epochs{31} = [];

% S32
chans{32} = {'FC5', 'FT8', 'P10', 'F8', 'P10', 'O1', 'O1'};
epochs{32} = [1 32 32 40 71 170 172];

% S33
chans{33} = [];
epochs{33} = [];

% S34
chans{34} = {'FT8', 'P9', 'P9', 'FT8', 'FT8', 'FT8', 'FT8'};
epochs{34} = [7 12 18 21 34 35 135];

% S35
chans{35} = [];
epochs{35} = [];

% S36
chans{36} = {'F7', 'F7'};
epochs{36} = [78 103];

% S37
chans{37} = [];
epochs{37} = [];

% S38
chans{38} = [];
epochs{38} = [];

% S39
chans{39} = {'T8', 'T8', 'T8', 'CP6', 'CP6', 'T8', 'CP6', 'T8', 'PO8', 'PO8', 'T8', 'CP6'};
epochs{39} = [1 3 4 5 6 9 21 21 39 40 157 158];

% S40
chans{40} = [];
epochs{40} = [];

% S41
chans{41} = {'FC4', 'FT8'};
epochs{41} = [72 125];

% S42
chans{42} = [];
epochs{42} = [];

% S43
chans{43} = [];
epochs{43} = [];

% S44
chans{44} = [];
epochs{44} = [];

% S45
chans{45} = {'F8', 'F8', 'F8'};
epochs{45} = [7 138 220];

% S46
chans{46} = [];
epochs{46} = [];

% S47
chans{47} = {'AF4', 'Fpz', 'F8'};
epochs{47} = [38 105 105];

% S48
chans{48} = {'F2', 'F2'};
epochs{48} = [51 54];

% S49
chans{49} = {'P9', 'FT8' 'Iz'};
epochs{49} = [52 55 118];

end

%% Outputs

    outChans = chans{str2double(currSub(2:end))};
    outEpochs = epochs{str2double(currSub(2:end))};

    assert(length(outChans) == length(outEpochs), 'Mismatch between channel and epoch list!')
end