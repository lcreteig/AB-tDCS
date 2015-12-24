function outTime = data_timerange(currSub, currSession)
% DATA_TIMERANGE: Retrieve time before end of ramp-down for a particular file
% (subject/session combination; only in 'tDCS' block).
%
% Usage:
% outTime = DATA_TIMERANGE(currSub,currSession)
%
% Inputs:
%   - currSub: string with subject ID of file (e.g. 'S01' or 'S18')
%   - currSession: string with tDCS code of file ('B' or 'D')
%
% Outputs:
%   - outTime: single number with time in seconds before the ramp-down
%   artifact, or empty if the end of the ramp-down was not recorded.
%
% Called in preproc_segment_data
%
% See also PREPROC_SEGMENT_DATA 

%% Indices

subjects = {
    'S01'
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

%% Session B

if strcmp(currSession, 'B')
    timeEnd = { ...
        1492, ... % 1 
        1418, ... % 2 
        1182, ... % 3 
        1476, ... % 4 
        1528, ... % 5 
        1181, ... % 6
        1353, ... % 7
        1473, ... % 8
        1189, ... % 9
        1390, ... % 10
        1210, ... % 11
        1700, ... % 12 
        1217, ... % 13
        [], ... % 14
        1227, ... % 15
        1202, ... % 16
        1401, ... % 17
        1395, ... % 18
        1381, ... % 19
        1220, ... % 20
        1387, ... % 21
        };  
end

%% Session D

if strcmp(currSession, 'D')
    timeEnd = { ...
        1304, ... % 1
        1215, ... % 2
        1432, ... % 3
        1450, ... % 4 
        1486, ... % 5 
        1179, ... % 6
        1172, ... % 7
        1205, ... % 8
        1394, ... % 9
        1188, ... % 10
        1351, ... % 11
        1389, ... % 12
        1427, ... % 13
        [], ... % 14
        1385, ... % 15
        1327, ... % 16
        1175, ... % 17
        1420, ... % 18
        1411, ... % 19
        1223, ... % 20
        1490, ... % 21 [0 1136]
        };  
end

%% Outputs

sub = strcmp(currSub, subjects);
outTime = timeEnd{sub};