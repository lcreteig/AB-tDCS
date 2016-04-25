function [preproc, paths, trig] = preproc_config(subjects, sessions, blocks, sendMail)
%PREPROC_CONFIG: Defines preprocessing parameters, settings, file locations, etc.
% Call this function first, and then run the main preprocessing script
% (preprocess.m)
%
% Usage:
% [preproc, paths, trig] = PREPROC_CONFIG(subjects, sessions, blocks, sendMail)
%
% Inputs:
%
% -subjects     string (e.g. 'S01') or cell array of strings (e.g. {'S01',
%               'S02'}) containing name(s) of subject(s) to be preprocessed.
%
% -sessions     string (e.g. 'B') or cell array of strings ({'B',
%               'D'}) containing name()s of session(s) to be preprocessed.
%
% -blocks       string (e.g. 'pre') or cell array of string (e.g.
%               {'pre','tDCS','post'}) containing name(s) of blocks(s) to 
%               be preprocessed.
%
% -sendMail     either false or true, to send an e-mail when preprocessing
%               script finished (see lib/mail_from_matlab.m)
%
% Outputs:
%
% -preproc      structure with preprocessing parameters.
%
% -paths        structure with file/script names and paths
%
% -trigs        structure containing info on conditions and EEG triggers.
%
% See also PREPROCESS

% subjects = {'S01', 'S02', 'S04', 'S05', 'S06', 'S07', 'S08',
% 'S09', 'S10','S11', 'S12', 'S13', 'S15', 'S16', 'S17', 'S18', 'S19', 'S20',
% 'S21'};
%
% sessions = {'B', 'D'};
%
% blocks = {'pre','tDCS','post'};
%
% Exceptions handled:
% S11, B, tDCS: modified preproc_reref and preproc_bipolar to use only
% EXG3, as EXG4 was bad.

%% Pipeline

% Lists all pre-processing steps in the order they will be carried out
% First element: if true, perform this step. 2nd element: if true, write EEG data to disk afterwards

preproc.do_importdata = 1;         % 1. import the data from the bdf files into EEGlab
preproc.do_cutdata = [0 0];        % 2. select segment of continuous data to keep
preproc.do_detrend = [1 0];        % 3. remove the DC component from each channel
preproc.do_buffer = [1 0];         % 4. splice some mirrored data to either end, to accomodate filter edge artefacts
preproc.do_reref = [1 0];          % 5. re-reference the data to earlobes
preproc.do_bipolar = [0 0];        % 6. bipolarize external channels (subtract pairs from each other, e.g. both HEOG channels)
preproc.do_removechans = [1 0];    % 7. remove unused channels from data set
preproc.do_chanlookup = [0 0];     % 8. import standard channel locations
preproc.do_filter = [0 1];         % 9. high-pass filter the data

preproc.do_recodeTrigs = [0 0];    % 10. recode original marker values to more meaningful ones for analysis
preproc.do_zerochans = [0 0];      % 11. set all values at unused channels (blocked by tDCS electrodes) to zero
preproc.do_epoch = [0 0];          % 12. split continous data into small epochs for trial rejection (not yet separated per condition)
preproc.do_baseline = [0 0];       % 13. subtract a (pre-stimulus) baseline from each epoch

preproc.do_trialrej = [1 0];       % 14. manually identify trials for rejection and save trial indices
preproc.do_badchans = [0 0];       % 15. zero-out additional bad channels (that should not be interpolated) after data inspection
preproc.do_interpchans = [0 0];    % 16. interpolate all points of channels
preproc.do_interpepochs = [0 0];   % 17. interpolate channel on a single epoch
preproc.do_removetrials = [0 0];   % 18. remove trials previously identified for rejection (if they exist)
preproc.do_averef = [0 0];         % 19. re-reference the data to the common average
preproc.do_ica = [0 1];            % 20. run independent component analysis

preproc.do_plotIC = [0 1];         % 21. plot results of independent component analyis and save component indices
preproc.do_removeIC = [0 0];       % 22. subtract marked components from the data
preproc.do_removebipolars = [0 0]; % 23. drop bipolars from the dataset, leaving only the leave scalp channels
preproc.do_laplacian = [0 0];      % 24. apply scalp laplacian
preproc.do_conditions = 0;         % 25. re-epoch into separate conditions

%% Inputs

if ~iscell(subjects)
    subjects = {subjects}; % list of all subjects to process
end
if ~iscell(sessions)
    sessions = {sessions}; % list of all subjects to process
end
if ~iscell(blocks)
    blocks = {blocks}; % list of all subjects to process
end

paths.subs2process = subjects; % list of all subjects to process
paths.sessions2process = sessions; % list of all sessions to process
paths.blocks2process = blocks; % list of all blocks to process
paths.sendMail = sendMail; % send e-mail when preprocessing script finishes or crashes

%% paths

%assumes running from master project directory

if ispc
        drive = 'Z:'; % default prefix for PCs
    else
        drive = '/Volumes/students$/'; % default prefix for macs
end

%directories for storing EEG data
paths.rawDir = fullfile(drive, 'reteig students', 'AB_tDCS-EEG', 'data', 'EEG results', 'raw'); % raw (completely unprocessed) data - each subject has all files in its own folder
paths.procDir = fullfile('data', 'main', 'processed'); % processed eeg data

paths.srcDir = fullfile('src', 'eeg', 'preproc'); % directory containing all preprocessing code for the project
paths.libDir = fullfile(paths.srcDir, 'lib');
paths.funcDir = fullfile(paths.srcDir, 'func');
paths.eeglabOld = 'eeglab8_0_3_5b'; %old version of eeglab, used for loading data (which can fail in newer versions) and on old matlab versions
paths.eeglabNew = 'eeglab13_4_4b'; % new version of eeglab, to use with new versions of matlab

paths.expID = 'AB-tDCS-EEG';
paths.sessionID = {'B','D'}; % indicator for stimulation type: B = Anodal, D = Cathodal
paths.blockID = {'pre','tDCS','post'}; % indicator for block (20 minutes): pre, during ("tDCS"), or post-tDCS 

% Add folders to matlab path
addpath(paths.funcDir); % add preprocessing code for project
addpath(paths.libDir); % add general preprocessing code

%% Triggers

trig.startEEG = '254'; % start EEG recording, start of block after a break

trig.preFix = '10'; % pre-stream fixation cross (1500 ms)

% stream onset (15 letters, 91.66 ms each = 1375 ms in total)
trig.streamLag3 = '23'; % lag 3 trial
trig.streamLag8 = '28'; % lag 8 trial

trig.T1 = '31'; % T1 (91.66 ms)
trig.T2 = '32'; % T2 (91.66 ms)

trig.postFix = '40'; % post-stream fixation cross (1000 ms)

% Questions (self-paced)
trig.T1Q = '50'; % T1 question
trig.T2QT1err = '60'; % T2 question | T1 question answered incorrectly
trig.T2QT1corr = '61'; % T2 question | T1 question answered correctly

% ITI (250 ms, followed by preFix)
trig.itiT2err = '70'; % Inter-trial interval onset | T2 question answered incorrectly
trig.itiT2corr = '71'; % Inter-trial interval onset | T2 question answered correctly

trig.pauseEEG = '255'; % Pause EEG recording (task finished)

%% 1. Import data

%% 2. Cut out data segment

% For some subjects, the artifact created when the ramp-down stops was also
% recorded. Because this is a sharp DC-offset, it can lead to long-lasting 
% filter artefacts. In this step, only the segment from the start of the 
% task untill the end of the ramp-down is kept. This excludes both the period
% before end of the ramp-up and after end of the ramp-down, to prevent such 
% artefacts. Also, these trials technically do not belong to the 'tDCS' 
% block, as the participants were not stimulated at the time.

%% 3. Remove the DC offset from each channel

% When importing BioSemi data, most channels will not be in display range,
% because the DC offset is also encoded. High-pass filtering brings them to
% some degree, but not every channel. Also, there might be a risk that such
% offsets can produce filtering artifacts, especially in this study where
% DC is also manipulated by tDCS. So in this step the mean of the entire
% time course is simply subtracted from each channel.

%% 4. Add buffers to either end of channel data

% Filtering creates edge artefacts at the start and end points of the
% data. Because for most subjects the recording starts right as the subject
% starts the task, these edge artefacts might leak into the first few
% trials. Therefore, here we add mirrored segments of data to each end, to
% eliminate the edge right before the task starts, and to serve serve as 
% buffers to accomodate the edge artefacts.

preproc.bufferLength = 30; % mirror this many seconds from the beginning/end of the data, and splice to the beginning/end.

%% 5. Re-reference

preproc.refChans = {'EXG3','EXG4'}; % names of reference channels (earlobes)

%% 6. Bipolarize external channels

preproc.veogChans = {'EXG1', 'EXG2'}; % names of vertical EOG channels (above and below left eye)
preproc.veogLabel = 'VEOG'; % name of new bipolar channel
preproc.earChans = {'EXG3', 'EXG4'};
preproc.earLabel = 'EARREF';
preproc.heogChans = {'EXG5', 'EXG6'}; % names of horizontal EOG channels (next to outer canthi)
preproc.heogLabel = 'HEOG';

%% 7. Remove unused channels

preproc.noChans = {'EXG7', 'EXG8'}; % channels where no data was recorded

%% 8. Channel info lookup

preproc.channelInfo = 'standard-10-5-cap385.elp'; % file with locations of channels in cap

%% 9. Filter

preproc.highPass = 0.1; %cut-off for highpass filter in Hz

%% 10. Recode triggers

% Specify modifications for trigger codes. These numbers will be appended
% to the T1 trigger code ('31'). So for example, the T1 trigger for a trial
% in the:
% -anodal session ('1')
% -post-tDCS block ('3')
% -no-blink condition ('1')
% -lag 8 condition ('8')
% will be 311318; this condition is labelled 'anodal_post_nonblink_long'

trig.session = paths.sessionID;
trig.tDCS = {'anodal', 'cathodal'};
trig.tDCScode = {'1', '2'};

trig.block = paths.blockID;
trig.blockCode = {'1', '2', '3'};

trig.T2correct = {'noblink', 'blink'};
trig.T2correctCode = {'1', '0'};

trig.lag = {'short', 'long'};
trig.lagCode = {'3', '8'};

trig.conditions = cell(prod([numel(trig.lag) numel(trig.T2correct) numel(trig.block) numel(trig.session)] ),2);
iCond = 1;
for iSession = 1:length(trig.session)
    for iBlock = 1:length(trig.block)
        for iBlink = 1:length(trig.T2correct)
            for iLag = 1:length(trig.lag)
                trig.conditions{iCond,1} = [trig.tDCS{iSession} '_' trig.block{iBlock} '_' trig.T2correct{iBlink} '_' trig.lag{iLag}]; % specify full condition label
                trig.conditions{iCond,2} = [trig.T1 trig.tDCScode{iSession} trig.blockCode{iBlock} trig.T2correctCode{iBlink} trig.lagCode{iLag}]; % specify full trigger
                iCond = iCond + 1;
            end
        end
    end
end

% trig.conditions{1,:}=
%     'anodal_pre_noblink_short'
%     'anodal_pre_noblink_long'
%     'anodal_pre_blink_short'
%     'anodal_pre_blink_long'
%     'anodal_tDCS_noblink_short'
%     'anodal_tDCS_noblink_long'
%     'anodal_tDCS_blink_short'
%     'anodal_tDCS_blink_long'
%     'anodal_post_noblink_short'
%     'anodal_post_noblink_long'
%     'anodal_post_blink_short'
%     'anodal_post_blink_long'
%     'cathodal_pre_noblink_short'
%     'cathodal_pre_noblink_long'
%     'cathodal_pre_blink_short'
%     'cathodal_pre_blink_long'
%     'cathodal_tDCS_noblink_short'
%     'cathodal_tDCS_noblink_long'
%     'cathodal_tDCS_blink_short'
%     'cathodal_tDCS_blink_long'
%     'cathodal_post_noblink_short'
%     'cathodal_post_noblink_long'
%     'cathodal_post_blink_short'
%     'cathodal_post_blink_long' 
%     };

%% 11. Set channels to zero

% Some channels were not recorded from, because their holders in the cap 
% were blocked by the tDCS electrode pads. They are mostly flat lines, but
% every so often the electrode tips will touch something and record major
% voltage deflections, so it is neccessary to zero them out.
%
% See blocked_chans.m for a list of channels.

%% 12. Epoch

preproc.zeroMarkers = {trig.streamLag3, trig.streamLag8}; % markers for time 0 in the epoch (onset of stream in attentional blink task)
preproc.epochTime1= [-1.75 1.375+1]; % relative to time 0, cut epochs from start of fixation (-1.75) to end (stream + post-stream fixation = 2.375)

%% 13. Baseline

preproc.baseTime = [-200 0]; % time range in ms to use for baseline subtraction, relative to time 0 of the epoch

%% 14. Reject trials
 
% Plots the data so epochs can be marked for rejection: they are not
% actually removed untill later!
%
% N.B. Write the data to disk in this step to save info on rejected
% trials in the EEG structure! Regardless, a text file will always be
% written to disk containing the rejected trials.

%% 15. Mark bad channels

% After inspection of individual data files, additional channels might have
% to be zeroed out (e.g. those that went out of range due to tDCS. These
% should be channels that are really 'missing' in that sense, and should
% thus not be interpolated, or included in interpolation of other channels!
%
% See bad_chans.m for a list of channels.

%% 16. Interpolate channels (all epochs)

% Uses a modified version of the standard "eeg_interp" called
% "eeg_interp_excl" to interpolate channels. This adds the option of
% excluding "bad" channels from being used in the interpolation of the
% "to-be-interpolated channels". Channels that should be excluded are pure 
% noise channels, e.g. that were not plugged in  due to tDCS electrodes, 
% (initial zeroed-out channels, step 8) or went out of range during tDCS 
% (later zeroed-out channels, step 12).

% See chans2interp.m for a list of channels.

%% 17. Interpolate channels (single epochs)

% Sometimes only a single channel acts out on a single epoch, in which case 
% it would be a shame to throw away the epoch or interpolate the channel.
% "eeg_interp_trials.m" is a modification of the EEGLAB interpolate
% function that can interpolate a channel only on a given epoch.
%
% See epochs2interp.m for a list of channels and epochs.

%% 18. Remove rejected trials

% At this point trials marked for rejection in step 11 will actually be
% removed,(which changes the trial indices!).

%% 19. Average reference

% Re-reference to the average of all electrodes (excluding externals, and
% possibly other ones that were zero'd out / marked as bad).

%% 20. Independent components analysis

preproc.icaType = 'runica'; % either 'runica' to run the most standard ICA algorithm,
% or 'jader' to run a faster version (which first uses PCA).

%% 21. Plot independent components

% Inspect the ICA results, which you can either do as part of the
% preprocessing pipeline, or manually when saving files to disk after the
% ICA.
%
% N.B. Write the data to disk in this step to save info on rejected
% components in the EEG structure! Regardless, a text file will always be
% written to disk containing the rejected components.

%% 22. Remove independent components

% At this point only will the independent components be subtracted from the
% data.

%% 23. Remove bipolar channels

% Drop the ear reference, vertical EOG and horizontal EOG channels, leaving
% only the scalp channels for analysis.

%% 24. Laplacian

% Apply a spatial filter (surface Laplacian) to reduce low-frequency
% spatial features in the data (which are likely due to volume conduction),
% thereby highlighting local features of the data. Typically not done for
% ERPs (especially "broad" ones such as the P3, which may be attenuated by
% the laplacian), but a good idea otherwise.

%% 25. Separate into conditions

%Re-epoch with T1 as time zero, leaving only those trials that were
%re-coded earlier (only the 4 blink/lag combinations).

% Start: before T1 onset (5th letter), there are 4 letters of 91.66 ms each + the fixation period, which equals about 2 seconds (2.1167).
% End: after T1 onset, there are 11 letters (including T1 itself) + 1 second fixation period, equalling about 2 seconds (2.0083).
preproc.epochTime2= [-1.75-0.250 2];
