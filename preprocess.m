preprocOrig = preproc;
timeStamp = datestr(now, 'yyyy-mm-dd_HH-MM-SS'); % get present time and date, for tagging directories
stepNames = fieldnames(preproc);
pipeLine = stepNames(strncmp('do_', stepNames, length('do_'))); % get names of all preprocessing steps in structure

% loop over each file
for iSub = 1:length(paths.subs2process)
    for iSession = 1:length(paths.sessions2process)
        for iBlock = 1:length(paths.blocks2process)
            
            preproc = preprocOrig;
            loadFlag = false;
            
            % Check for matlab/eeglab incompatibility
            [~,matlabVersion] = version;
            matlabPath = regexp(path,pathsep,'split');
            if str2double(matlabVersion(end-3:end)) > 2010
                warning('preproc:MatlabVersion', 'You are using a version of matlab released after 2010, which might be too new to do the initial preprocessing!')
                if any(ismember(fullfile(paths.srcDir, paths.eeglabOld), matlabPath))
                    warning('preproc:EEGlabVersion', 'The version of EEGlab on the matlab path is too old for this version of matlab: removing from path...')
                    rmpath(genpath(fullfile(paths.srcDir, paths.eeglabOld)))
                end
                if ~any(ismember(fullfile(paths.srcDir, paths.eeglabNew), matlabPath))
                    addpath(genpath(fullfile(paths.srcDir, paths.eeglabNew)))
                end
            else
                if any(ismember(fullfile(paths.srcDir, paths.eeglabNew), matlabPath))
                    warning('preproc:EEGlabVersion', 'The version of EEGlab on the matlab path is too new for this version of matlab: removing...')
                    rmpath(genpath(fullfile(paths.srcDir, paths.eeglabNew)))
                end
                if ~any(ismember(fullfile(paths.srcDir, paths.eeglabOld), matlabPath))
                    addpath(genpath(fullfile(paths.srcDir, paths.eeglabOld)))
                end
            end
            
            %% 1. Import data
            step = 1;
            
            currSub = paths.subs2process{iSub};
            currSession = paths.sessions2process{iSession};
            currBlock = paths.blocks2process{iBlock};
            
            fileInfo = dir(fullfile(paths.rawDir, currSub, [currSub '_*' currSession '_' currBlock '.bdf']));
            rawFile = fileInfo.name(1:end-length('.bdf'));
            
            if preproc.(pipeLine{step}) % if this preprocessing step is flagged
                fprintf('    Importing data for subject "%s", session "%s", block "%s" ...\n', currSub, currSession, currBlock)
                EEG = pop_biosig(fullfile(paths.rawDir, currSub, [rawFile '.bdf'])); %import the data from biosemi .bdf files into EEGlab using the BioSig toolbox
                loadFlag = true;
                
                EEG.setname = [paths.expID ': raw'];
                EEG.filename = [rawFile '.bdf'];
                EEG.filepath = fullfile(paths.rawDir, currSub);
                EEG.subject = currSub;
                EEG.session = currSession;
                EEG.condition = currBlock;
            end
            
            %% 2. Re-reference
            step = 2; % mark that we're now at the next preprocessing step
            
            if preproc.(pipeLine{step})(1)
                
                fprintf('    Re-referencing...\n')
                
                [~,refChanIdx] = ismember(preproc.refChans, {EEG.chanlocs.labels}); % indices of reference channels (earlobes)
                [~,exclChanIdx] = ismember([preproc.heogChans preproc.veogChans], {EEG.chanlocs.labels}); % indices of channels to exclude from reference (eye channels)
                EEG = pop_reref(EEG, refChanIdx, 'keepref', 'on', 'exclude', exclChanIdx); % re-reference, keeping ref channels in the data set
                
                if preproc.(pipeLine{step})(2) % if EEG data should be saved to disk after this step
                    [saveDir, procFile] = prepSave(paths, rawFile, pipeLine, step, timeStamp); % build directory and file name
                    EEG.setname = [paths.expID ': ' pipeLine{step}(4:end)];
                    EEG.filename = [procFile '.mat'];
                    EEG.filepath = saveDir;
                    fprintf('    Saving file %s...\n', procFile);
                    save(fullfile(saveDir, procFile), 'EEG', 'paths', 'preproc', 'trig'); %save variables to disk
                end
            end
            
            %% 3. Bipolarize external channels
            step = 3;
            
            if preproc.(pipeLine{step})(1)
                
                if ~preproc.(pipeLine{step-1})(1) && ~loadFlag % if the previous processing step should not be redone, and no data has been loaded yet
                    [EEG, preproc] = loadEEG(paths, rawFile, preproc, step);
                    loadFlag = true;
                end
                
                fprintf('    Bipolarizing external channels...\n')
                
                % Get indices of channels to be bipolarized
                [~,heogIdx] = ismember(preproc.heogChans, {EEG.chanlocs.labels});
                [~,veogIdx] = ismember(preproc.veogChans, {EEG.chanlocs.labels});
                [~,refIdx] = ismember(preproc.earChans, {EEG.chanlocs.labels});
                
                % Horizontal EOG (HEOG)
                EEG.data(heogIdx(1),:) = EEG.data(heogIdx(1),:) - EEG.data(heogIdx(2),:); % change first channel's data into bipolar (subtraction of the two channels)
                EEG.chanlocs(heogIdx(1)).labels = 'HEOG'; % change label accordingly
                
                % Vertical EOG (VEOG)
                EEG.data(veogIdx(1),:) = EEG.data(veogIdx(1),:) - EEG.data(veogIdx(2),:);
                EEG.chanlocs(veogIdx(1)).labels = 'VEOG';
                
                % Reference channels (earlobes)
                EEG.data(refIdx(1),:) = EEG.data(refIdx(1),:) - EEG.data(refIdx(2),:);
                EEG.chanlocs(refIdx(1)).labels = 'EARREF';
                
                EEG = pop_select(EEG, 'nochannel', [heogIdx(2), veogIdx(2), refIdx(2)]); % remove the now redundant 2nd member of each pair from the dataset
                
                if preproc.(pipeLine{step})(2)
                    [saveDir, procFile] = prepSave(paths, rawFile, pipeLine, step, timeStamp);
                    EEG.setname = [paths.expID ': ' pipeLine{step}(4:end)];
                    EEG.filename = [procFile '.mat'];
                    EEG.filepath = saveDir;
                    fprintf('    Saving file %s...\n', procFile);
                    save(fullfile(saveDir, procFile), 'EEG', 'paths', 'preproc', 'trig');
                end
            end
            
            %% 4. Remove unused channels
            step = 4;
            
            if preproc.(pipeLine{step})(1)
                
                if ~preproc.(pipeLine{step-1})(1) && ~loadFlag
                    [EEG, preproc] = loadEEG(paths, rawFile, preproc, step);
                    loadFlag = true;
                end
                
                fprintf('    Removing unused channels...\n')
                
                EEG = pop_select(EEG,'nochannel',preproc.noChans); % remove the channels that were not used during recording
                
                if preproc.(pipeLine{step})(2)
                    [saveDir, procFile] = prepSave(paths, rawFile, pipeLine, step, timeStamp);
                    EEG.setname = [paths.expID ': ' pipeLine{step}(4:end)];
                    EEG.filename = [procFile '.mat'];
                    EEG.filepath = saveDir;
                    fprintf('    Saving file %s...\n', procFile);
                    save(fullfile(saveDir, procFile), 'EEG', 'paths', 'preproc', 'trig');
                end
            end
            
            %% 5. Channel info lookup
            step = 5;
            
            if preproc.(pipeLine{step})(1)
                
                if ~preproc.(pipeLine{step-1})(1) && ~loadFlag
                    [EEG, preproc] = loadEEG(paths, rawFile, preproc, step);
                    loadFlag = true;
                end
                
                fprintf('    Looking up channel info...\n')
                
                EEG=pop_chanedit(EEG,'lookup', preproc.channelInfo); % lookup information on channel location in cap
                
                if preproc.(pipeLine{step})(2)
                    [saveDir, procFile] = prepSave(paths, rawFile, pipeLine, step, timeStamp);
                    EEG.setname = [paths.expID ': ' pipeLine{step}(4:end)];
                    EEG.filename = [procFile '.mat'];
                    EEG.filepath = saveDir;
                    fprintf('    Saving file %s...\n', procFile);
                    save(fullfile(saveDir, procFile), 'EEG', 'paths', 'preproc', 'trig');
                end
            end
            
            %% 6. Filter
            step = 6;
            
            if preproc.(pipeLine{step})(1)
                
                if ~preproc.(pipeLine{step-1})(1) && ~loadFlag
                    [EEG, preproc] = loadEEG(paths, rawFile, preproc, step);
                    loadFlag = true;
                end
                
                fprintf('    High-pass filtering the data...\n')
                
                EEG = pop_eegfilt(EEG, preproc.highPass, []); % filter with low-cutoff at specified value (only high-pass, so no high cutoff)
                
                if preproc.(pipeLine{step})(2) % if EEG data should be saved to disk after this step
                    [saveDir, procFile] = prepSave(paths, rawFile, pipeLine, step, timeStamp);
                    EEG.setname = [paths.expID ': ' pipeLine{step}(4:end)];
                    EEG.filename = [procFile '.mat'];
                    EEG.filepath = saveDir;
                    fprintf('    Saving file %s...\n', procFile);
                    save(fullfile(saveDir, procFile), 'EEG', 'paths', 'preproc', 'trig');
                end
            end
            
            %% 7. Recode triggers
            step = 7;
            
            if preproc.(pipeLine{step})(1)
                
                if ~preproc.(pipeLine{step-1})(1) && ~loadFlag
                    [EEG, preproc] = loadEEG(paths, rawFile, preproc, step);
                    loadFlag = true;
                end
                
                fprintf('    Recoding marker values...\n')
                
                sessionIdx = strcmpi(currSession, trig.session);
                blockIdx = strcmpi(currBlock, trig.block);
                % find triggers to assign in condition labels
                trig_noblink_short = trig.conditions{strcmp([trig.tDCS{sessionIdx} '_' trig.block{blockIdx} '_' 'noblink_short'], trig.conditions(:,1)),2}; % get trigger corresponding to 'noblink_short' condition
                trig_noblink_long = trig.conditions{strcmp([trig.tDCS{sessionIdx} '_' trig.block{blockIdx} '_' 'noblink_long'], trig.conditions(:,1)),2}; % get trigger corresponding to 'noblink_long' condition 
                trig_blink_short = trig.conditions{strcmp([trig.tDCS{sessionIdx} '_' trig.block{blockIdx} '_' 'blink_short'], trig.conditions(:,1)),2}; % get trigger corresponding to 'blink_short' condition
                trig_blink_long = trig.conditions{strcmp([trig.tDCS{sessionIdx} '_' trig.block{blockIdx} '_' 'blink_long'], trig.conditions(:,1)),2}; % get trigger corresponding to 'blink_long' condition 
                
                T1idx = find([EEG.event.type] == trig.T1); % index of events representing T1 onset
                T1idxPad = [1 T1idx length([EEG.event.type])]; %include first and last of all events for looping
                
                missingTriggers = 1;
                for iEvent = 2:length(T1idxPad)-1 % for every T1
                    
                    lagMrks = [EEG.event(T1idxPad(iEvent-1):T1idxPad(iEvent)).type]; % find markers between current and previous T1 (or beginning of 1st trial)
                    lagIdx = T1idxPad(iEvent-1) + find(lagMrks == trig.streamLag3 | lagMrks == trig.streamLag8) -1; % from these, find the marker signalling stream onset
                    
                    ansMrks = [EEG.event(T1idxPad(iEvent):T1idxPad(iEvent+1)).type]; % find markers between current and next T1 (or end of last trial)
                    T1ansIdx = T1idxPad(iEvent) + find(ansMrks == trig.T2QT1corr)-1; % from these, find the marker signalling T1 was answered correctly
                    T2ansIdx = T1idxPad(iEvent) + find(ansMrks == trig.itiT2err | ansMrks == trig.itiT2corr)-1; % also find the marker signalling T2 answer
                    
                    % if any of these markers are missing (e.g. due to a conflict on the parallel port):
                    % not enough information to analyze current trial, so skip
                    if any([isempty(lagIdx) isempty(T2ansIdx) isempty(T1ansIdx)])
                        if isempty(lagIdx) || isempty(T2ansIdx)
                            missingTriggers = missingTriggers +1;
                        end
                        continue % also skip if T1 was answered incorrectly
                    else % get the stream onset and T2 marker values
                        lag = EEG.event(lagIdx).type;
                        T2ans = EEG.event(T2ansIdx).type;
                    end
                    
                    if T2ans == trig.itiT2corr && lag == trig.streamLag3 % if on present T1 correct trial: T2 correct, lag 3
                        EEG.event(T1idxPad(iEvent)).type = trig_noblink_short; % assign matching trigger to T1 onset
                    elseif T2ans == trig.itiT2corr && lag == trig.streamLag8 % if on present T1 correct trial: T2 correct, lag 8
                        EEG.event(T1idxPad(iEvent)).type = trig_noblink_long;
                    elseif T2ans == trig.itiT2err && lag == trig.streamLag3 % if on present T1 correct trial: T2 incorrect, lag 3
                        EEG.event(T1idxPad(iEvent)).type = trig_blink_short;
                    elseif T2ans == trig.itiT2err && lag == trig.streamLag8 % if on present T1 correct trial: T2 incorrect, lag 8
                        EEG.event(T1idxPad(iEvent)).type = trig_blink_long;
                    end
                end
                
                fprintf(['Total number of trials: %i\n'...
                    'Trials missing one or more triggers: %i\n' ...
                    'T1 correct trials: %i\n' ...
                    'noblink_short trials: %i\n' ...
                    'noblink_long trials: %i\n' ...
                    'blink_short trials: %i\n' ...
                    'noblink_long trials: %i\n'], length(T1idx), missingTriggers, length(T1idx) - missingTriggers - sum([EEG.event.type] == trig.T1), ...
                    sum([EEG.event.type] == trig_noblink_short), sum([EEG.event.type] == trig_noblink_long), ...
                    sum([EEG.event.type] == trig_blink_short), sum([EEG.event.type] == trig_blink_long))
                
                if preproc.(pipeLine{step})(2) % if EEG data should be saved to disk after this step
                    [saveDir, procFile] = prepSave(paths, rawFile, pipeLine, step, timeStamp);
                    EEG.setname = [paths.expID ': ' pipeLine{step}(4:end)];
                    EEG.filename = [procFile '.mat'];
                    EEG.filepath = saveDir;
                    fprintf('    Saving file %s...\n', procFile);
                    save(fullfile(saveDir, procFile), 'EEG', 'paths', 'preproc', 'trig');
                end
            end
            
            %% 8. Set channels to zero
            step = 8;
            
            if preproc.(pipeLine{step})(1)
                
                 if ~preproc.(pipeLine{step-1})(1) && ~loadFlag
                    [EEG, preproc] = loadEEG(paths, rawFile, preproc, step);
                    loadFlag = true;
                 end
                 
                fprintf('    Setting bad channels to zero...\n')
                
                chansZero = blocked_chans(currSub, currSession); % get names of channels to zero
                chansZeroIdx = ismember({EEG.chanlocs.labels}, chansZero); % find indices in chanlocs structure
                EEG.data(chansZeroIdx, :) = 0; % set all samples on these channels to zero
                 
                 if preproc.(pipeLine{step})(2)
                     [saveDir, procFile] = prepSave(paths, rawFile, pipeLine, step, timeStamp);
                     EEG.setname = [paths.expID ': ' pipeLine{step}(4:end)];
                     EEG.filename = [procFile '.mat'];
                     EEG.filepath = saveDir;
                     fprintf('    Saving file %s...\n', procFile);
                     save(fullfile(saveDir, procFile), 'EEG', 'paths', 'preproc', 'trig');
                 end
                 
            end
            
            %% 9. Epoch
            step = 9;
            
            if preproc.(pipeLine{step})(1)
                
                if ~preproc.(pipeLine{step-1})(1) && ~loadFlag
                    [EEG, preproc] = loadEEG(paths, rawFile, preproc, step);
                    loadFlag = true;
                end
                
                fprintf('    Epoching the data...\n')
                
                EEG = pop_epoch(EEG, preproc.zeroMarkers, preproc.epochTime1); % cut epochs using specified time zero and boundaries
                
                if preproc.(pipeLine{step})(2) % if EEG data should be saved to disk after this step
                    [saveDir, procFile] = prepSave(paths, rawFile, pipeLine, step, timeStamp);
                    EEG.setname = [paths.expID ': ' pipeLine{step}(4:end)];
                    EEG.filename = [procFile '.mat'];
                    EEG.filepath = saveDir;
                    fprintf('    Saving file %s...\n', procFile);
                    save(fullfile(saveDir, procFile), 'EEG', 'paths', 'preproc', 'trig');
                end
            end
            
            %% 10. Baseline
            step = 10;
            
            if preproc.(pipeLine{step})(1)
                
                if ~preproc.(pipeLine{step-1})(1) && ~loadFlag
                    [EEG, preproc] = loadEEG(paths, rawFile, preproc, step);
                    loadFlag = true;
                end
                
                fprintf('    Performing baseline correction ...\n')
                
                EEG = pop_rmbase(EEG, preproc.baseTime); % subtract average of baseline period from the epoch
                
                if preproc.(pipeLine{step})(2) % if EEG data should be saved to disk after this step
                    [saveDir, procFile] = prepSave(paths, rawFile, pipeLine, step, timeStamp);
                    EEG.setname = [paths.expID ': ' pipeLine{step}(4:end)];
                    EEG.filename = [procFile '.mat'];
                    EEG.filepath = saveDir;
                    fprintf('    Saving file %s...\n', procFile);
                    save(fullfile(saveDir, procFile), 'EEG', 'paths', 'preproc', 'trig');
                end
            end
            
            %% 11. Reject trials
            step = 11;
            
            if preproc.(pipeLine{step})(1)
                
                if ~preproc.(pipeLine{step-1})(1) && ~loadFlag
                    [EEG, preproc] = loadEEG(paths, rawFile, preproc, step);
                    loadFlag = true;
                end
                
                eeglab redraw
                msg_handle = msgbox(sprintf('Reject trials manually using the EEGlab graphical user interface.\nPress "Update marks" when done; the script will then resume.'), 'Trial rejection');
                uiwait(msg_handle)
                pop_eegplot(EEG,1,1,0);  % plot the data, set to mark trials for rejection (not actually remove them just yet!
                uiwait
                
                % The rejmanual subfield will be reset after removing trials, but we want to keep the info!
                % So make a back-up both in the EEG structure and as a text file
                if ~isempty(EEG.reject.rejmanual)
                    EEG.rejectedTrials = EEG.reject.rejmanual;
                    rejectedTrials = find(EEG.reject.rejmanual);
                    dlmwrite(fullfile(paths.procDir, [rawFile '_' 'rejectedtrials' '_' timeStamp '.txt']), rejectedTrials, 'delimiter', '\t')
                end

                if preproc.(pipeLine{step})(2)
                    [saveDir, procFile] = prepSave(paths, rawFile, pipeLine, step, timeStamp);
                    EEG.setname = [paths.expID ': ' pipeLine{step}(4:end)];
                    EEG.filename = [procFile '.mat'];
                    EEG.filepath = saveDir;
                    fprintf('    Saving file %s...\n', procFile);
                    save(fullfile(saveDir, procFile), 'EEG', 'paths', 'preproc', 'trig');
                end
                
            end
            
           %% 12. Mark bad channels
           step = 12;
            
            if preproc.(pipeLine{step})(1)
                
                 if ~preproc.(pipeLine{step-1})(1) && ~loadFlag
                    [EEG, preproc] = loadEEG(paths, rawFile, preproc, step);
                    loadFlag = true;
                 end
                    
                chansBad = bad_chans(currSub, currSession, currBlock); % get names of channels to zero
                if ~isempty(chansBad)
                    fprintf('    Setting additional bad channels to zero...\n')
                    chansBadIdx = ismember({EEG.chanlocs.labels}, chansBad); % find indices in chanlocs structure
                    EEG.data(chansBadIdx, :) = 0; % set all samples on these channels to zero
                end
                 
                 if preproc.(pipeLine{step})(2)
                     [saveDir, procFile] = prepSave(paths, rawFile, pipeLine, step, timeStamp);
                     EEG.setname = [paths.expID ': ' pipeLine{step}(4:end)];
                     EEG.filename = [procFile '.mat'];
                     EEG.filepath = saveDir;
                     fprintf('    Saving file %s...\n', procFile);
                     save(fullfile(saveDir, procFile), 'EEG', 'paths', 'preproc', 'trig');
                 end
                 
            end
            
            
            %% 13. Interpolate channels (all epochs)
            step = 13;
            
            if preproc.(pipeLine{step})(1)
                
                if ~preproc.(pipeLine{step-1})(1) && ~loadFlag
                    [EEG, preproc] = loadEEG(paths, rawFile, preproc, step);
                    loadFlag = true;
                end
                
                interpChans = chans2interp(currSub, currSession, currBlock);
                if ~isempty(interpChans)
                    fprintf('    Interpolating channels...\n')
                    
                    interpChanIdx = find(ismember({EEG.chanlocs.labels}, interpChans));
                    
                     % exclude external channels from interpolation
                    exclInterpChanIdx = find(ismember({EEG.chanlocs.labels}, {'HEOG', 'VEOG', 'EARREF'}));
                    
                    % exclude blocked channels from interpolation
                    chansZero = blocked_chans(currSub, currSession);
                    chansZeroIdx = find(ismember({EEG.chanlocs.labels}, chansZero)); 
                    
                    % exclude otherwise bad channels from interpolation
                    chansBad = bad_chans(currSub, currSession, currBlock);
                    if ~isempty(chansBad)
                        chansBadIdx = find(ismember({EEG.chanlocs.labels}, chansBad)); 
                    else
                        chansBadIdx = [];
                    end
                    
                    inChans = interpChanIdx;
                    exclChans = [exclInterpChanIdx chansZeroIdx chansBadIdx];
                    
                    if isempty(intersect(inChans, exclChans))
                        EEG = eeg_interp_excl(EEG, inChans, exclChans);
                    else
                        error('At least one channel is both specified as "to-be interpolated" and "to-be excluded from interpolation"!')
                    end
                    
                    if preproc.(pipeLine{step})(2)
                        [saveDir, procFile] = prepSave(paths, rawFile, pipeLine, step, timeStamp);
                        EEG.setname = [paths.expID ': ' pipeLine{step}(4:end)];
                        EEG.filename = [procFile '.mat'];
                        EEG.filepath = saveDir;
                        fprintf('    Saving file %s...\n', procFile);
                        save(fullfile(saveDir, procFile), 'EEG', 'paths', 'preproc', 'trig');
                    end
                end
            end
                 
            %% 14. Interpolate channels (single epochs) 
            step = 14;
            
            if preproc.(pipeLine{step})(1)
                
                if ~preproc.(pipeLine{step-1})(1) && ~loadFlag
                    [EEG, preproc] = loadEEG(paths, rawFile, preproc, step);
                    loadFlag = true;
                end
                
                [interpEpochChans, interpEpochs] = epochs2interp(currSub, currSession, currBlock);
                if ~isempty(interpEpochs)
                    fprintf('    Interpolating epochs...\n')
                    
                    interpEpochChanIdx = find(ismember({EEG.chanlocs.labels}, interpEpochChans));
                    
                    % exclude external channels from interpolation
                    exclInterpChanIdx = find(ismember({EEG.chanlocs.labels}, {'HEOG', 'VEOG', 'EARREF'})); 
                    
                    % exclude already interpolated channels from interpolation
                    interpChans = chans2interp(currSub, currSession, currBlock);
                    if ~isempty(interpChans)
                        interpChanIdx = find(ismember({EEG.chanlocs.labels}, interpChans)); 
                    else
                        interpChanIdx = [];
                    end
                    
                    % exclude blocked channels from interpolation
                    chansZero = blocked_chans(currSub, currSession);
                    chansZeroIdx = find(ismember({EEG.chanlocs.labels}, chansZero)); 
                    
                    % exclude otherwise bad channels from interpolation
                    chansBad = bad_chans(currSub, currSession, currBlock);
                    if ~isempty(chansBad)
                        chansBadIdx = find(ismember({EEG.chanlocs.labels}, chansBad)); 
                    else
                        chansBadIdx = [];
                    end
                    
                    inChans = interpEpochChanIdx;
                    exclChans = [exclInterpChanIdx interpChanIdx chansZeroIdx chansBadIdx];
                    
                    if isempty(intersect(inChans, exclChans))
                        EEG = eeg_interp_trials(EEG, inChans, 'spherical', interpEpochs, exclChans);
                    else
                        error('At least one channel is both specified as "to-be interpolated" and "to-be excluded from interpolation"!')
                    end
                    
                    if preproc.(pipeLine{step})(2)
                        [saveDir, procFile] = prepSave(paths, rawFile, pipeLine, step, timeStamp);
                        EEG.setname = [paths.expID ': ' pipeLine{step}(4:end)];
                        EEG.filename = [procFile '.mat'];
                        EEG.filepath = saveDir;
                        fprintf('    Saving file %s...\n', procFile);
                        save(fullfile(saveDir, procFile), 'EEG', 'paths', 'preproc', 'trig');
                    end
                end
            end
            
            %% 15. Remove rejected trials 
            step = 15;
            
            if preproc.(pipeLine{step})(1)
                
                if ~preproc.(pipeLine{step-1})(1) && ~loadFlag
                    [EEG, preproc] = loadEEG(paths, rawFile, preproc, step);
                    loadFlag = true;
                end
                
                if ~isempty(EEG.reject.rejmanual) % if rejected trials were marked by hand
                    rejectedTrials = find(EEG.reject.rejmanual);
                elseif isfield(EEG, 'rejectedTrials') && ~isempty(EEG.rejectedTrials)  % if not, look for a list of trials to remove in the EEG structure
                    rejectedTrials = find(EEG.rejectedTrials);
                elseif ~isempty(dir(fullfile(paths.procDir, [rawFile '_' 'rejectedtrials' '_' '*' '.txt']))) % if also not there, load the most recent text file from disk
                    rejFile = dir(fullfile(paths.procDir, [rawFile '_' 'rejectedtrials' '_' '*' '.txt']));
                    [~,i] = sort([rejFile.datenum]);
                    rejectedTrials = load(fullfile(paths.procDir, rejFile(i(end)).name));
                else % if nothing works
                    error('Could not find list of trials to reject!')
                end
                
                % Calculate and print trial rejection counts
                trig_noblink_short = trig.conditions{strcmp([trig.tDCS{sessionIdx} '_' trig.block{blockIdx} '_' 'noblink_short'], trig.conditions(:,1)),2}; % get trigger corresponding to 'noblink_short' condition
                trig_noblink_long = trig.conditions{strcmp([trig.tDCS{sessionIdx} '_' trig.block{blockIdx} '_' 'noblink_long'], trig.conditions(:,1)),2}; % get trigger corresponding to 'noblink_long' condition 
                trig_blink_short = trig.conditions{strcmp([trig.tDCS{sessionIdx} '_' trig.block{blockIdx} '_' 'blink_short'], trig.conditions(:,1)),2}; % get trigger corresponding to 'blink_short' condition
                trig_blink_long = trig.conditions{strcmp([trig.tDCS{sessionIdx} '_' trig.block{blockIdx} '_' 'blink_long'], trig.conditions(:,1)),2}; % get trigger corresponding to 'blink_long' condition 
                noblink_short_idx = zeros(1,EEG.trials);
                noblink_long_idx= zeros(1,EEG.trials);
                blink_short_idx = zeros(1,EEG.trials);
                blink_long_idx = zeros(1,EEG.trials);
                for iTrial = 1:EEG.trials
                    epochEvents = [EEG.epoch(iTrial).eventtype{:}];
                    if ismember(trig_noblink_short, epochEvents)
                        noblink_short_idx(iTrial) = 1;
                    elseif ismember(trig_noblink_long, epochEvents)
                        noblink_long_idx(iTrial) = 1;
                    elseif ismember(trig_blink_short, epochEvents)
                        blink_short_idx(iTrial) = 1;
                    elseif ismember(trig_blink_long, epochEvents)
                        blink_long_idx(iTrial) = 1;
                    end
                end
                
                fprintf(['Rejecting %i (%i%%) of %i trials in total.\n'...
                    'Rejecting %i noblink_short trials, which leaves %i trials.\n' ...
                    'Rejecting %i noblink_long trials, which leaves %i trials.\n' ...
                    'Rejecting %i blink_short trials, which leaves %i trials.\n' ...
                    'Rejecting %i blink_long trials, which leaves %i trials.\n'], ...
                    numel(rejectedTrials), round(numel(rejectedTrials) / EEG.trials *100), EEG.trials, ...
                    numel(intersect(find(noblink_short_idx), rejectedTrials)), numel(find(noblink_short_idx)) - numel(intersect(find(noblink_short_idx), rejectedTrials)), ...
                    numel(intersect(find(noblink_long_idx), rejectedTrials)), numel(find(noblink_long_idx)) - numel(intersect(find(noblink_long_idx), rejectedTrials)), ...
                    numel(intersect(find(blink_short_idx), rejectedTrials)), numel(find(blink_short_idx)) - numel(intersect(find(blink_short_idx), rejectedTrials)), ...
                    numel(intersect(find(blink_long_idx), rejectedTrials)), numel(find(blink_long_idx)) - numel(intersect(find(blink_long_idx), rejectedTrials)) )
                    
                EEG = pop_select(EEG, 'notrial', rejectedTrials);
                
                if preproc.(pipeLine{step})(2)
                    [saveDir, procFile] = prepSave(paths, rawFile, pipeLine, step, timeStamp);
                    EEG.setname = [paths.expID ': ' pipeLine{step}(4:end)];
                    EEG.filename = [procFile '.mat'];
                    EEG.filepath = saveDir;
                    fprintf('    Saving file %s...\n', procFile);
                    save(fullfile(saveDir, procFile), 'EEG', 'paths', 'preproc', 'trig');
                end
            end
            
            %% 16. Average reference
            step = 16;
            
            if preproc.(pipeLine{step})(1)
                
                if ~preproc.(pipeLine{step-1})(1) && ~loadFlag
                    [EEG, preproc] = loadEEG(paths, rawFile, preproc, step);
                    loadFlag = true;
                end
                
                  fprintf('    Re-referencing to common average...\n')
                
                % exclude external channels from average reference
                extChanIdx = find(ismember({EEG.chanlocs.labels}, {'HEOG', 'VEOG', 'EARREF'})); 
                % exclude blocked channels from average reference
                chansZero = blocked_chans(currSub, currSession);
                chansZeroIdx = find(ismember({EEG.chanlocs.labels}, chansZero));
                % exclude otherwise bad channels from interpolation
                chansBad = bad_chans(currSub, currSession, currBlock);
                if ~isempty(chansBad)
                    chansBadIdx = find(ismember({EEG.chanlocs.labels}, chansBad));
                else
                    chansBadIdx = [];
                end
                
                EEG = pop_reref(EEG, [], 'exclude', [extChanIdx chansZeroIdx chansBadIdx]);
                
                if preproc.(pipeLine{step})(2)
                    [saveDir, procFile] = prepSave(paths, rawFile, pipeLine, step, timeStamp);
                    EEG.setname = [paths.expID ': ' pipeLine{step}(4:end)];
                    EEG.filename = [procFile '.mat'];
                    EEG.filepath = saveDir;
                    fprintf('    Saving file %s...\n', procFile);
                    save(fullfile(saveDir, procFile), 'EEG', 'paths', 'preproc', 'trig');
                end
            end
             
            %% 17. Independent components analysis
            step = 17;
            
            if preproc.(pipeLine{step})(1)
                
                if ~preproc.(pipeLine{step-1})(1) && ~loadFlag
                    [EEG, preproc] = loadEEG(paths, rawFile, preproc, step);
                    loadFlag = true;
                end
                
                fprintf('    Running independent component analysis...\n')
                
                if strcmp(preproc.icaType, 'jader')
                    EEG = pop_runica(EEG,'icatype','jader','dataset',1,'options',{40}); % run ICA
                elseif strcmp(preproc.icaType, 'runica')
                    EEG=pop_runica(EEG,'icatype','runica','dataset',1,'options',{'extended',1});
                else
                    error('Unrecognized ICA type option "%s"!', preproc.icaType)
                end
                
                if preproc.(pipeLine{step})(2)
                    [saveDir, procFile] = prepSave(paths, rawFile, pipeLine, step, timeStamp);
                    EEG.setname = [paths.expID ': ' pipeLine{step}(4:end)];
                    EEG.filename = [procFile '.mat'];
                    EEG.filepath = saveDir;
                    fprintf('    Saving file %s...\n', procFile);
                    save(fullfile(saveDir, procFile), 'EEG', 'paths', 'preproc', 'trig');
                end
            end
            
           %% 18. Plot independent components
           step = 18;
           
            if preproc.(pipeLine{step})(1)
                
                if ~preproc.(pipeLine{step-1})(1) && ~loadFlag
                    [EEG, preproc] = loadEEG(paths, rawFile, preproc, step);
                    loadFlag = true;
                end
                
                msg_handle = msgbox(sprintf('Mark components for rejection using the EEGlab graphical user interface.\nClose the two windows when done; the script will then resume.'), 'Component rejection');
                uiwait(msg_handle)
                pop_eegplot(EEG, 0, 1, 0); % plot the component timecourses
                pop_selectcomps(EEG, 1:30); % plot the topographical maps of the first 30 components
                uiwait
                
                if ~isempty(EEG.reject.gcompreject)
                    EEG.rejectedICs = EEG.reject.gcompreject;
                    rejectedICs = find(EEG.reject.gcompreject);
                    dlmwrite(fullfile(paths.procDir, [rawFile '_' 'rejectedICs' '_' timeStamp '.txt']), rejectedICs, 'delimiter', '\t')
                end
                
                if preproc.(pipeLine{step})(2)
                    [saveDir, procFile] = prepSave(paths, rawFile, pipeLine, step, timeStamp);
                    EEG.setname = [paths.expID ': ' pipeLine{step}(4:end)];
                    EEG.filename = [procFile '.mat'];
                    EEG.filepath = saveDir;
                    fprintf('    Saving file %s...\n', procFile);
                    save(fullfile(saveDir, procFile), 'EEG', 'paths', 'preproc', 'trig');
                end
                
            end
            
            %% 19. Remove independent components
            step = 19;
            
            if preproc.(pipeLine{step})(1)
                
                if ~preproc.(pipeLine{step-1})(1) && ~loadFlag
                    [EEG, preproc] = loadEEG(paths, rawFile, preproc, step);
                    loadFlag = true;
                end
                
                fprintf('    Removing independent components...\n')
                
                if ~isempty(EEG.reject.gcompreject) % if rejected components were marked by hand
                    rejectedICs = find(EEG.reject.gcompreject);
                elseif isfield(EEG, 'rejectedICs') && ~isempty(EEG.rejectedICs)  % if not, look for a list of components to remove in the EEG structure
                    rejectedICs = find(EEG.rejectedICs);
                elseif ~isempty(dir(fullfile(paths.procDir, [rawFile '_' 'rejectedICs' '_' '*' '.txt']))) % if also not there, load the most recent text file from disk
                    rejICfile = dir(fullfile(paths.procDir, [rawFile '_' 'rejectedICs' '_' '*' '.txt']));
                    [~,i] = sort([rejICfile.datenum]);
                    rejectedICs = load(fullfile(paths.procDir, rejICfile(i(end)).name));
                else % if nothing works
                    error('Could not find list of components to reject!')
                end

                EEG = pop_subcomp(EEG, rejectedICs);
                
                if preproc.(pipeLine{step})(2)
                    [saveDir, procFile] = prepSave(paths, rawFile, pipeLine, step, timeStamp);
                    EEG.setname = [paths.expID ': ' pipeLine{step}(4:end)];
                    EEG.filename = [procFile '.mat'];
                    EEG.filepath = saveDir;
                    fprintf('    Saving file %s...\n', procFile);
                    save(fullfile(saveDir, procFile), 'EEG', 'paths', 'preproc', 'trig');
                end
            end
            
            %% 20. Remove bipolar channels
            step = 20;
            
            if preproc.(pipeLine{step})(1)
                
                if ~preproc.(pipeLine{step-1})(1) && ~loadFlag
                    [EEG, preproc] = loadEEG(paths, rawFile, preproc, step);
                    loadFlag = true;
                end
                
                fprintf('    Removing bipolars...\n')
                
                EEG = pop_select(EEG, 'nochannel', {'HEOG', 'VEOG', 'EARREF'});
                
                if preproc.(pipeLine{step})(2)
                    [saveDir, procFile] = prepSave(paths, rawFile, pipeLine, step, timeStamp);
                    EEG.setname = [paths.expID ': ' pipeLine{step}(4:end)];
                    EEG.filename = [procFile '.mat'];
                    EEG.filepath = saveDir;
                    fprintf('    Saving file %s...\n', procFile);
                    save(fullfile(saveDir, procFile), 'EEG', 'paths', 'preproc', 'trig');
                end
            end
            
           %% 21. Laplacian
           step = 21;
           
           if preproc.(pipeLine{step})(1)
               
               if ~preproc.(pipeLine{step-1})(1) && ~loadFlag
                   [EEG, preproc] = loadEEG(paths, rawFile, preproc, step);
                   loadFlag = true;
               end
               
               fprintf('    Applying surface Laplacian...\n')
               
               % assumes externals have been removed (should zero'd out
               % channels be excluded too?!)
               EEG.data = laplacian_perrinX(EEG.data,[EEG.chanlocs.X],[EEG.chanlocs.Y],[EEG.chanlocs.Z]);
               
               if preproc.(pipeLine{step})(2)
                   [saveDir, procFile] = prepSave(paths, rawFile, pipeLine, step, timeStamp);
                   EEG.setname = [paths.expID ': ' pipeLine{step}(4:end)];
                   EEG.filename = [procFile '.mat'];
                   EEG.filepath = saveDir;
                   fprintf('    Saving file %s...\n', procFile);
                   save(fullfile(saveDir, procFile), 'EEG', 'paths', 'preproc', 'trig');
               end
           end
           
           %% 22. Separate into conditions
           step = 22;
           
           if preproc.(pipeLine{step})
               
               if ~preproc.(pipeLine{step-1})(1) && ~loadFlag
                   [EEG, preproc] = loadEEG(paths, rawFile, preproc, step);
                   loadFlag = true;
               end
               
               fprintf('    Separating into conditions...\n')
               
               sessionIdx = strcmpi(currSession, trig.session);
               blockIdx = strcmpi(currBlock, trig.block);
               condition_labels = cell(4,2);
               % Extract part of full condition matrix that is relevant for this session/block combination (e.g. the 4 "anodal, pre" conditions)
               condition_labels(1,:) = trig.conditions(strcmp([trig.tDCS{sessionIdx} '_' trig.block{blockIdx} '_' 'noblink_short'], trig.conditions(:,1)),:);
               condition_labels(2,:) = trig.conditions(strcmp([trig.tDCS{sessionIdx} '_' trig.block{blockIdx} '_' 'noblink_long'], trig.conditions(:,1)),:);
               condition_labels(3,:) = trig.conditions(strcmp([trig.tDCS{sessionIdx} '_' trig.block{blockIdx} '_' 'blink_short'], trig.conditions(:,1)),:);
               condition_labels(4,:) = trig.conditions(strcmp([trig.tDCS{sessionIdx} '_' trig.block{blockIdx} '_' 'blink_long'], trig.conditions(:,1)),:);
               
               % Always save data to disk
               [saveDir, procFile] = prepSave(paths, rawFile, pipeLine, step, timeStamp);
               ALLEEG=EEG;
               for iCond = 1:size(condition_labels,1)
                   ALLEEG(iCond) = pop_epoch(EEG,condition_labels(iCond,2), preproc.epochTime2, 'newname', [paths.expID ': ' condition_labels{iCond,1}]);
                   ALLEEG(iCond).filename = [procFile '.mat'];
                   ALLEEG(iCond).filepath = saveDir;
               end
               
               fprintf('    Saving file %s...\n', procFile);
               save(fullfile(saveDir, procFile), 'ALLEEG', 'paths', 'preproc', 'trig', 'condition_labels');
           end
  
            
        end
    end
end