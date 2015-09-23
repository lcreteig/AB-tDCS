
timeStamp = datestr(now, 'yyyy-mm-dd_HH-MM-SS'); % get present time and date, for tagging directories
stepNames = fieldnames(preproc);
pipeLine = stepNames(strncmp('do_', stepNames, length('do_'))); % get names of all preprocessing steps in structure

% loop over each file
for iSub = 1:length(paths.subs2process)
    for iSession = 1:length(paths.sessions2process)
        for iBlock = 1:length(paths.blocks2process)
            
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
            
            if preproc.(pipeLine{step}) % if this processing step is flagged
                fprintf('    Importing data for subject "%s", session "%s", block "%s" ...\n', currSub, currSession, currBlock)
                EEG = pop_biosig(fullfile(paths.rawDir, currSub, [rawFile '.bdf'])); %import the data from biosemi .bdf files into EEGlab using the BioSig toolbox
                EEG.setname = [paths.expID ': raw'];
                EEG.filename = [rawFile '.bdf'];
                EEG.filepath = fullfile(paths.rawDir, currSub);
                EEG.subject = currSub;
                EEG.session = currSession;
                EEG.condition = currBlock;
            end
            
            %% 2. Re-reference
            step = step+1; % mark that we're now at the next preprocessing step
            
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
            step = step+1;
            
            if preproc.(pipeLine{step})(1)
                
                if ~preproc.(pipeLine{step-1})(1) % if the previous processing step should not be redone
                    EEG = loadEEG(paths, rawFile, pipeLine);
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
            step = step+1;
            
            if preproc.(pipeLine{step})(1)
                
                if ~preproc.(pipeLine{step-1})(1)
                    EEG = loadEEG(paths, rawFile, pipeLine);
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
            step = step+1;
            
            if preproc.(pipeLine{step})(1)
                
                if ~preproc.(pipeLine{step-1})(1)
                    EEG = loadEEG(paths, rawFile, pipeLine);
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
            step = step+1;
            
            if preproc.(pipeLine{step})(1)
                
                if ~preproc.(pipeLine{step-1})(1)
                    EEG = loadEEG(paths, rawFile, pipeLine);
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
            
            %% Recode triggers
            step = step+1;
            
            if preproc.(pipeLine{step})(1)
                
                if ~preproc.(pipeLine{step-1})(1)
                    EEG = loadEEG(paths, rawFile, pipeLine);
                end
                
                fprintf('    Recoding marker values...\n')
                
                sessionIdx = strcmpi(currSession, trig.session);
                blockIdx = strcmpi(currBlock, trig.block);
                % find triggers to assign in condition labels
                trig_noblink_short = trig.conditions{strcmp([trig.tDCS{sessionIdx} '_' trig.block{blockIdx} '_' 'noblink_short'], trig.conditions(:,1)),2}; % find index of 'noblink_short' condition label
                trig_noblink_long = trig.conditions{strcmp([trig.tDCS{sessionIdx} '_' trig.block{blockIdx} '_' 'noblink_long'], trig.conditions(:,1)),2}; % find index of 'noblink_long' condition label
                trig_blink_short = trig.conditions{strcmp([trig.tDCS{sessionIdx} '_' trig.block{blockIdx} '_' 'blink_short'], trig.conditions(:,1)),2}; % find index of 'blink_short' condition label
                trig_blink_long = trig.conditions{strcmp([trig.tDCS{sessionIdx} '_' trig.block{blockIdx} '_' 'blink_long'], trig.conditions(:,1)),2}; % find index of 'blink_long' condition label
                
                T1idx = find([EEG.event.type] == trig.T1); % index of events representing T1 onset
                T1idxPad = [1 T1idx length([EEG.event.type])]; %include first and last of all events for looping
                
                for iEvent = 2:length(T1idxPad)-1 % for every T1
                    
                    lagMrks = [EEG.event(T1idxPad(iEvent-1):T1idxPad(iEvent)).type]; % find markers between current and previous T1 (or beginning of 1st trial)
                    lagIdx = T1idxPad(iEvent-1) + find(lagMrks == trig.streamLag3 | lagMrks == trig.streamLag8) -1; % from these, find the marker signalling stream onset
                    
                    ansMrks = [EEG.event(T1idxPad(iEvent):T1idxPad(iEvent+1)).type]; % find markers between current and next T1 (or end of last trial)
                    T1ansIdx = T1idxPad(iEvent) + find(ansMrks == trig.T2QT1corr)-1; % from these, find the marker signalling T1 was answered correctly
                    T2ansIdx = T1idxPad(iEvent) + find(ansMrks == trig.itiT2err | ansMrks == trig.itiT2corr)-1; % also find the marker signalling T2 answer
                    
                    % if any of these markers are missing (e.g. due to a conflict on the parallel port): 
                    % not enough information to analyze current trial, so skip
                    if isempty(lagIdx) || isempty(T1ansIdx) || isempty(T2ansIdx)
                        continue
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
                    'T1 correct trials: %i\n' ...
                    'noblink_short trials: %i\n' ...
                    'noblink_long trials: %i\n' ...
                    'blink_short trials: %i\n' ...
                    'noblink_long trials: %i\n'], length(T1idx), length(T1idx) - sum([EEG.event.type] == trig.T1), ...
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
            
            %% Epoch
            step = step+1;
            
            if preproc.(pipeLine{step})(1)
                
                if ~preproc.(pipeLine{step-1})(1)
                    EEG = loadEEG(paths, rawFile, pipeLine);
                end
                
                fprintf('    Epoching the data...\n')
                
                EEG = pop_epoch(EEG, preproc.zeroMarkers, preproc.epochTime); % cut epochs using specified time zero and boundaries
                
                if preproc.(pipeLine{step})(2) % if EEG data should be saved to disk after this step
                    [saveDir, procFile] = prepSave(paths, rawFile, pipeLine, step, timeStamp);
                    EEG.setname = [paths.expID ': ' pipeLine{step}(4:end)];
                    EEG.filename = [procFile '.mat'];
                    EEG.filepath = saveDir;
                    fprintf('    Saving file %s...\n', procFile);
                    save(fullfile(saveDir, procFile), 'EEG', 'paths', 'preproc', 'trig');
                end
            end
            
            %% Baseline
            step = step+1;
            
            if preproc.(pipeLine{step})(1)
                
                if ~preproc.(pipeLine{step-1})(1)
                    EEG = loadEEG(paths, rawFile, pipeLine);
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
            
            %% Reject trials
            step = step+1;
            
            if preproc.(pipeLine{step})(1)
                
                eeglab redraw
                pop_eegplot(EEG, 1, 1, 0);
                
                rejectedTrials=EEG.reject.rejmanual;
            end
            
        end
    end
end