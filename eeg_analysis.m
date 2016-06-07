clear all, close all

%% Config
% subjects = {'S01', 'S02', 'S03', 'S04', 'S05', 'S06', 'S07', 'S08', ...
% 'S09', 'S10','S11', 'S12', 'S13', 'S15', 'S16', 'S17', 'S18', 'S19', 'S20', ...
% 'S21'};
subjects = 'S02';
sessions = 'B';
%sessions = {'B','D'};
% blocks = {'pre','tDCS','post'};
blocks = 'post';
eeglabVersion = 'eeglab13_5_4b'; % either 'eeglab8_0_3_5b' for MATLAB r2010b or 'eeglab13_5_4b' for r2012b and r2015a.
sendMail = false;

%% Setup
paths.srcDir = fullfile('src', 'eeg', 'preproc'); % directory containing all preprocessing code for the project
addpath(paths.srcDir);

[preproc, paths, trig] = preproc_config(subjects, sessions, blocks, eeglabVersion, sendMail);

%% Preprocess

preprocess;

%% Inspect ERPs after preprocessing

addpath(fullfile('src','eeg'));
plotERPs(subjects, sessions, blocks); % N.B.: must be a single subject/session/block