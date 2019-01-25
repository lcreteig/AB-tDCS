% script used to convert the data from sourcedata (in Biosemi .bdf format) and
% create the BIDS-compliant (BrainVision format) EEG data in the sub*- folders,
% along with all the the .json and .tsv sidecar/metadata files in those folders.

%% inputs
clear
tmp = pwd;
dir_bids = fullfile(tmp, '..'); % top-level directory is below current (as this script is in "code")

task = 'attentionalblink'; % for in file names

restoredefaultpath
addpath(fullfile(dir_bids, 'code', 'preproc')) % file with not-plugged-in channels (blocked_chans.m)
addpath(fullfile(dir_bids, 'code', 'fieldtrip-20190115')) % toolbox with data2bids (and dependencies)
ft_defaults

%% Write BIDS

% assumes sub-folder 'sourcedata' exists in dir_bids with *.bdf files in a
% folder for each subject
sourcedata = fullfile(dir_bids, 'sourcedata');
sub_list = dir(fullfile(sourcedata, 'S*')); % each subject's folder must start with capital S
sub_list = {sub_list.name};

for iSub=7%1:numel(sub_list) % for each subject folder

    subID = str2double(sub_list{iSub}(2:end)); % strip "S" from name; this should be the subject number

    % make new dir with zero-padded subject number
    new_sub_folder = sprintf('sub-%02d', subID);
    if ~exist(fullfile(dir_bids, new_sub_folder), 'dir')
        mkdir(dir_bids, new_sub_folder)
    end

    % list all raw BioSemi data files for each subject
    % each file will be a session_id{iSess}
    f_info = dir(fullfile(sourcedata, sub_list{iSub}, '*.bdf'));

    session_id = cell(numel(f_info),1);
    session_order = cell(numel(f_info),1);
    acq_time = cell(numel(f_info),1);

    for iSess = 1:numel(f_info) % for each session

        % split file name to get info for building new file names
        dat_str = strsplit(f_info(iSess).name(1:end-4),'_');
        tDCS_info = dat_str{2}(2); % code which tDCS polarity was applied
        block_info = dat_str{3}; % 'pre', 'tDCS', or 'post' file

        % fieldtrip crashes when trying to read data from this session;
        % seems something is with the trigger channel
        if strcmp(f_info(iSess).name(1:end-4), 'S07_2D_post')
            continue
        end

        % translate tDCS codes
        tDCS = [];
        if subID <= 21 % for subjects S01-S21, the following codes were used
            switch tDCS_info
                case 'B'
                    tDCS = 'anodal';
                case 'D'
                    tDCS = 'cathodal';
            end
        else % for subject S22 and onwards, the codes were different
            switch tDCS_info
                case 'I'
                    tDCS = 'cathodal';
                case 'D'
                    tDCS = 'anodal';
            end
        end

        session_id{iSess} = [tDCS block_info]; % session_id info for new files / folders
        session_order{iSess} = dat_str{2}(1); % whether it was the first or second session
        acq_time{iSess} = datestr(f_info(iSess).datenum, 'yyyy-mm-ddTHH:MM:SS'); %file timestamp

        % make new dir with session info, and eeg subfolder
        new_ses_folder = fullfile(['ses-' session_id{iSess}], 'eeg');
        if ~exist(fullfile(dir_bids, new_sub_folder, new_ses_folder), 'dir')
            mkdir(fullfile(dir_bids, new_sub_folder), new_ses_folder)
        end

        % configure bids writing
        cfg = [];

        % Files
        cfg.dataset                        = fullfile(sourcedata, sub_list{iSub}, f_info(iSess).name); % input source data
        cfg.outputfile                     = fullfile(dir_bids, new_sub_folder, new_ses_folder, sprintf('sub-%02d_ses-%s_task-%s_eeg.vhdr', subID, session_id{iSess}, task)); % BIDS data (BrainVision format)
        cfg.eeg.writesidecar               = 'replace';
        cfg.channels.writesidecar          = 'replace';
        cfg.events.writesidecar            = 'replace';
        % cfg.presentationfile

        % Institution
        cfg.InstitutionName                = 'University of Amsterdam';
        cfg.InstitutionalDepartmentName    = 'Department of Psychology';
        cfg.InstitutionAddress             = 'Nieuwe Achtergracht 129B; 1018 WS, Amsterdam, The Netherlands';

        % task
        cfg.TaskName                       = 'Attentional blink'; % provide the long rescription of the task
        cfg.CogAtlasID                     = 'http://www.cognitiveatlas.org/task/id/trm_551f06a08dcc4/'; % page on attentional blink

        % Device
        cfg.Manufacturer                   = 'Biosemi';
        cfg.ManufacturersModelName         = 'ActiveTwo';
        cfg.SoftwareVersions               = 'ActiView version 7.05';

        % EEG
        cfg.eeg.EEGPlacementScheme         = '10-20';
        cfg.eeg.PowerLineFrequency         = 50; % recorded in EU
        cfg.eeg.EEGReference               = 'CMS, placed in CMS slot of Biosemi cap';
        cfg.eeg.EEGGround                  = 'DRL, placed in DRL slot of Biosemi cap';
        cfg.eeg.EOGChannelCount            = 4; % 2 HEOG (EXG5, EXG6), 2 VEOG (EXG1, EXG2) % FIXME data2bids will always overwrite this with header info from data file (which is 0)
        cfg.eeg.MiscChannelCount           = 4; % 2 earlobes for re-referencing (EXG3, EXG4), 2 empty (EXG7, EXG8) % FIXME data2bids will always overwrite this with header info from data file (which is 9)
        cfg.eeg.TriggerChannelCount        = 1; % Status channel % FIXME data2bids will always overwrite this with header info from data file (which is 0)
        cfg.eeg.CapManufacturer            = 'Biosemi';
        cfg.eeg.CapModelName               = 'CAP 64 10/20';
        cfg.eeg.SoftwareFilters            = 'n/a';
        cfg.eeg.RecordingType              = 'continuous';
        if strcmp(block_info, 'tDCS')
        cfg.eeg.SubjectArtefactDescription = '1 mA transcranial Direct Current Stimulation; 7x5 mm electrode on F3, 7x5 mm electrode on right forehead (FP2)';
        end

        % Channels
        % cfg.channels.type                =  % FIXME data2bids will always overwrite this with header info from data file (which says "misc" for all external (EXG) channels), so had to manually change chantype in channels.tsv
        % cfg.channels.description         =  % FIXME data2bids does not currently write channel description columns, so had to manually add info on EXG channels to channels.tsv
        % cfg.channels.status              =  % FIXME data2bids does not currently write channel status columns, so had to manually add "status" (good/bad) to channels.tsv, adding the blocked chans
        % cfg.channels.status_description  =  % FIXME data2bids does not currently write channel status columns, so had to manually add "status_description" to channels.tsv, adding the blocked chans

        cfg = data2bids(cfg); % WRITE BIDS

        % Manually modify channel tsv files
        chan_tsv = fullfile(dir_bids, new_sub_folder, new_ses_folder, sprintf('sub-%02d_ses-%s_task-%s_channels.tsv', subID, session_id{iSess}, task)); % file written to disk
        chan_table = readtable(chan_tsv, 'Delimiter', 'tab', 'FileType', 'text'); % read back in

        ext_chan_idx = ismember(chan_table.name, {'EXG1','EXG2','EXG3','EXG4','EXG5','EXG6','EXG7','EXG8','Status'}); % idx of external / trigger channels
        chan_table(ext_chan_idx,'type') = {'eog', 'eog', 'misc', 'misc', 'eog', 'eog', 'misc', 'misc', 'trig'}'; % correct type
        chan_table(ext_chan_idx,'units') = {'uV', 'uV', 'uV', 'uV', 'uV', 'uV', 'uV', 'uV', 'unknown'}'; % correct unit

        % add description column
        % fill new column with standard cells
        description = cell(height(chan_table),1);
        description(:) = {'EEG channel'};
        % correct entries for external channels
        description(ext_chan_idx) = {'above left eyebrow (VEOG1)', 'below left eye (VEOG2)', 'left earlobe (for re-referencing)','right earlobe (for re-referencing)', 'left outer canthus (HEOG1)', 'right outer canthus (HEOG2)', 'empty (not plugged in)', 'empty (not plugged in)', 'triggers'}';
        chan_table.description = description; % add to table

        % add status column
        % fill new column with standard cells
        status = cell(height(chan_table),1);
        status(:) = {'good'};
        currStim = [];
        if strcmp(tDCS, 'anodal')
            currStim = 'Y'; % this was coded to enable blind analysis
        elseif strcmp(tDCS, 'cathodal')
            currStim = 'X'; % this was coded to enable blind analysis
        end
        badchans = blocked_chans(sub_list{iSub}, currStim); % get names of channels that were not plugged in
        bad_chan_idx = ismember(chan_table.name, badchans); % index in tsv
        status(bad_chan_idx) = {'bad'};  % correct entries for bad channels
        chan_table.status = status; % add to table

        % add status_description column
        % fill new column with standard cells
        status_description = cell(height(chan_table),1);
        status_description(:) = {'n/a'};
        % correct entries for bad channels
        status_description(bad_chan_idx) = {'channel not plugged into cap; slot was blocked by tDCS electrode on scalp'};
        chan_table.status_description = status_description; % add to table

        writetable(chan_table, chan_tsv, 'Delimiter', 'tab', 'FileType', 'text'); % write updated tsv

    end % for each session

    % write _sessions.tsv
    sessions_table = table(session_id, session_order, acq_time);
    sessions_tsv = fullfile(dir_bids, new_sub_folder, sprintf('sub-%02d_sessions.tsv', subID));
    writetable(sessions_table, sessions_tsv, 'Delimiter', 'tab', 'FileType', 'text'); % write updated tsv
end % for each subject
