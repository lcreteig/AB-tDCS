paths.srcDir = fullfile('src', 'eeg', 'preproc'); % directory containing all preprocessing code for the project
addpath(paths.srcDir);

% subjects = {'S01', 'S02', 'S03', 'S04', 'S05', 'S06', 'S07', 'S08', ...
% 'S09', 'S10','S11', 'S12', 'S13', 'S15', 'S16', 'S17', 'S18', 'S19', 'S20', ...
% 'S21'};
% sessions = {'B', 'D'};
% blocks = {'pre','tDCS','post'};
subjects = 'S01';
sessions = 'B';
blocks = 'tDCS';
eeglabVersion = 'eeglab13_5_4b'; % either 'eeglab8_0_3_5b' for MATLAB r2010b or 'eeglab13_5_4b' for r2012b and r2015a.
sendMail = false;

[preproc, paths, trig] = preproc_config(subjects, sessions, blocks, eeglabVersion, sendMail);
preprocess;

% TO DO:

% Exclude zero'd channels (and reference?) from ICA?
% Cut smaller epochs for ICA, mirror and splice after ICA. OR: run ICA on smaller epochs; import weights in larger??
% plot 35 components
% SASICA?

% double path somewhere (local Rekenbeest?)
% Newest eeglab: subtract 61440 from each event
% Recode triggers before cutting data in tDCS step
% Make eeglab_version a variable, and let the script behave differently for
% old and new? (instead of checkVersion function). eeglab13_5_4b works on MATLAB 2015a and 2012b! 
