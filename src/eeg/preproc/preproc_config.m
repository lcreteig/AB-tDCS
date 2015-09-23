%TO DO:
%-set channels to zero before trial rej
%-single epoch interpolation
%-epoch structure

%-automated trial rejection

%% Workflow

paths.subs2process = {'S12'}; % list of all subjects to process
paths.sessions2process = {'B'}; % list of all sessions to process
paths.blocks2process = {'pre'}; % list of all blocks to process

% Lists all pre-processing steps in the order they will be carried out
% First element: if true, perform this step. 2nd element: if true, write EEG data to disk afterwards

preproc.do_importdata = 0; % 1. import the data from the bdf files into EEGlab
preproc.do_reref = [0 0]; % 2. re-reference the data to mastoids
preproc.do_bipolar = [0 0]; % 3. bipolarize external channels (subtract pairs from each other, e.g. both HEOG channels)
preproc.do_removechans = [0 0]; % 4. remove unused channels from data set
preproc.do_chanlookup = [0 0]; % 5. import standard channel locations
preproc.do_filter = [0 1]; % 6. high-pass filter the data

preproc.do_recodeTrigs = [1 0]; % 7. recode original marker values to more meaningful ones for analysis
preproc.do_epoch = [0 0]; % 8. split continous data into epochs (not yet separated per condition)
preproc.do_baseline = [0 0]; % 9. subtract a (pre-stimulus) baseline from each epoch

preproc.do_trialrej = [0 0]; % 10. manually identify trials for rejection and save trial indices to file
preproc.do_removetrials = [0 0]; % 11. remove trials previously identified for rejection (if they exist)
preproc.do_markbadchans = [0 0]; % 12. set all values at bad channels to zero
preproc.do_interpchans = [0 0]; % 13. interpolate (subset of) bad channels
preproc.do_averef = [0 0]; % 14. re-reference the data to the common average
preproc.do_ica = [0 1]; % 15. run independent component preproc

preproc.do_removeIC = [0 0]; % 16. subtract marked components from the data
preproc.do_laplacian = [0 0]; % 17. apply scalp laplacian
preproc.do_conditions = [0 1]; % 18. re-epoch into separate conditions

%% paths

%assumes running from master project directory

if ispc
        drive = 'Z:'; % default prefix for PCs
    else
        drive = '/Volumes/students$/'; % % default prefix for macs
end

%directories for storing EEG data
paths.rawDir = fullfile(drive, 'reteig students', 'AB_tDCS-EEG', 'data', 'EEG results', 'raw'); % raw (completely unprocessed) data - each subject has all files in its own folder
paths.procDir = fullfile('data', 'main', 'processed'); % processed eeg data

paths.srcDir = fullfile('src', 'eeg', 'preproc'); % directory containing all preprocessing code for the project
paths.eeglabOld = 'eeglab8_0_3_5b'; %old version of eeglab, used for loading data (which can fail in newer versions) and on old matlab versions
paths.eeglabNew = 'eeglab13_4_4b'; % new version of eeglab, to use with new versions of matlab

paths.expID = 'AB-tDCS-EEG';
paths.sessionID = {'B','D'}; % indicator for stimulation type: B = Anodal, D = Cathodal
paths.blockID = {'pre','tDCS','post'}; % indicator for block (20 minutes): pre, during ("tDCS"), or post-tDCS 

% Add folders to matlab path
addpath(paths.srcDir); % add preprocessing code for project

%% Triggers

trig.startEEG = 254; % start EEG recording, start of block after a break

trig.preFix = 10; % pre-stream fixation cross (1500 ms)

% stream onset (15 letters, 91.66 ms each = 1375 ms in total)
trig.streamLag3 = 23; % lag 3 trial
trig.streamLag8 = 28; % lag 8 trial

trig.T1 = 31; % T1 (91.66 ms)
trig.T2 = 32; % T2 (91.66 ms)

trig.postFix = 40; % post-stream fixation cross (1000 ms)

% Questions (self-paced)
trig.T1Q = 50; % T1 question
trig.T2QT1err = 60; % T2 question | T1 question answered incorrectly
trig.T2QT1corr = 61; % T2 question | T1 question answered correctly

% ITI (250 ms, followed by preFix)
trig.itiT2err = 70; % Inter-trial interval onset | T2 question answered incorrectly
trig.itiT2corr = 71; % Inter-trial interval onset | T2 question answered correctly

trig.pauseEEG = 255; % Pause EEG recording (task finished)

%% Re-reference

preproc.refChans = {'EXG3','EXG4'}; % names of reference channels (earlobes)

%% Channel info lookup

preproc.channelInfo = 'standard-10-5-cap385.elp'; % file with locations of channels in cap

%% Bipolarize external channels

preproc.veogChans = {'EXG1', 'EXG2'}; % names of vertical EOG channels (above and below left eye)
preproc.earChans = {'EXG3', 'EXG4'};
preproc.heogChans = {'EXG5', 'EXG6'}; % names of horizontal EOG channels (next to outer canthi)

%% Remove unused channels

preproc.noChans = {'EXG7', 'EXG8'}; % channels where no data was recorded

%% Filter

preproc.highPass = 0.1; %cut-off for highpass filter in Hz

%% Epoch

preproc.zeroMarkers = {trig.streamLag3, trig.streamLag8}; % markers for time 0 in the epoch (onset of stream in attentional blink task)
preproc.epochTime= [-1.25 1.375+1]; % relative to time 0, cut epochs from some period before (-1.25) to end (stream + post-stream fixation = 2.375)

%% Baseline

preproc.baseTime = [-200 0]; % time range in ms to use for baseline subtraction, relative to time 0 of the epoch

%% Recode triggers

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
                trig.conditions{iCond,2} = str2double([num2str(trig.T1) trig.tDCScode{iSession} trig.blockCode{iBlock} trig.T2correctCode{iBlink} trig.lagCode{iLag}]); % specify full trigger
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

%% Reject trials

%% Mark bad channels

%% Interpolate channels

%% Average reference

%% ICA

%% Laplacian

%% Separate into conditions
