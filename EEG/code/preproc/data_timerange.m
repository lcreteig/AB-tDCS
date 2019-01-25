function outTime = data_timerange(currSub, currStimID)
% DATA_TIMERANGE: Retrieve time before end of ramp-down for a particular file
% (subject/session combination; only in 'tDCS' block).
%
% Usage:
% outTime = DATA_TIMERANGE(currSub,currStimID)
%
% Inputs:
%   - currSub: string with subject ID of file (e.g. 'S01' or 'S18')
%   - currStimID: string with stimulation ID of session ('Y' or 'X')
%
% Outputs:
%   - outTime: single number with time in seconds before the ramp-down
%   artifact, or empty if the end of the ramp-down was not recorded.
%
% Called in preproc_segment_data
%
% See also PREPROC_SEGMENT_DATA 

%% Session Y

if strcmp(currStimID, 'Y')
    timeEnd = { ...
        ...
        ... % SESSION B
        ...
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
        ...
        ... % SESSION D
        ...
        1163, ... % 22
        1200, ... % 23
        1169, ... % 24
        [], ... % 25
        1206, ... % 26
        1204, ... %27
        1214, ... % 28
        [], ... % 29
        1215, ... % 30
        [], ... % 31
        1206, ... % 32
        1216, ... % 33
        1187, ... % 34
        1194, ... % 35
        1204, ... % 36
        1176, ... % 37
        [], ... % 38
        1210, ... % 39
        1225, ... % 40
        1209, ... % 41
        [], ... % 42
        [], ... % 43
        1231, ... % 44
        1210, ... % 45
        [], ... % 46
        1216, ... % 47
        1199, ... % 48
        1127 % 49
        };  
end

%% Session X

if strcmp(currStimID, 'X')
    timeEnd = { ...
        ...
        ... % SESSION D
        ...
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
        ...
        ... % SESSION I
        ...
        1212, ... % 22
        1206, ... % 23
        1201, ... % 24
        [], ... % 25
        1203, ... % 26
        1207, ... % 27
        1187, ... % 28
        [], ... % 29
        1177, ... % 30
        [], ... % 31
        1219, ... % 32
        1216, ... % 33
        1200, ... % 34
        1211, ... % 35
        1217, ... % 36
        1202, ... % 37
        [], ... % 38
        1210, ... % 39
        1209, ... % 40
        1210, ... % 41
        [], ... % 42
        [], ... % 43
        1211, ... % 44
        1207, ... % 45
        [], ... % 46
        1235, ... % 47
        1227, ... % 48
        1198 % 49
        };    
end

%% Outputs

outTime = timeEnd{str2double(currSub(2:end))};