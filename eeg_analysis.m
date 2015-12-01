paths.srcDir = fullfile('src', 'eeg', 'preproc'); % directory containing all preprocessing code for the project
addpath(paths.srcDir);

subjects = 'S11';
sessions = 'B';
blocks = 'tDCS';
sendMail = false;
[preproc, paths, trig] = preproc_config(subjects, sessions, blocks, sendMail);
preprocess;