% move functions into lib dir, call overall from master ("eeg_analysis")
try
preprocOrig = preproc; % structure with preprocessing parameters for this run
timeStamp = datestr(now, 'yyyy-mm-dd_HH-MM-SS'); % get present time and date, for tagging directories
stepNames = fieldnames(preproc);
pipeLine = stepNames(strncmp('do_', stepNames, length('do_'))); % get names of all preprocessing steps in structure

% loop over each file
for iSub = 1:length(paths.subs2process)
    for iSession = 1:length(paths.sessions2process)
        for iBlock = 1:length(paths.blocks2process)
            
            preproc = preprocOrig; % new loop iteration; use original preprocessing parameter structure
            loadFlag = false; % new loop iteration; no file loaded yet
            
            % Check for matlab/eeglab incompatibility
            checkVersion(fullfile(paths.srcDir, paths.eeglabNew), fullfile(paths.srcDir, paths.eeglabOld));
            
            %% 1. Import data
            step = 1; % counter: increases by one at every preprocessing step
            
            currSub = paths.subs2process{iSub};
            currSession = paths.sessions2process{iSession};
            currBlock = paths.blocks2process{iBlock};
            fprintf('    Processing data from subject "%s", session "%s", block "%s" ...\n', currSub, currSession, currBlock)
            
            fileInfo = dir(fullfile(paths.rawDir, currSub, [currSub '_*' currSession '_' currBlock '.bdf']));
            rawFile = fileInfo.name(1:end-length('.bdf'));
            
            if preproc.(pipeLine{step}) % if this preprocessing step is flagged (i.e. it should be performed)
                
                %PROCESS
                fprintf('    Importing file %s...\n', rawFile)
                EEG = pop_biosig(fullfile(paths.rawDir, currSub, [rawFile '.bdf'])); %import the data from biosemi .bdf files into EEGlab using the BioSig toolbox
                loadFlag = true; % remember that a file has now been loaded
                
                %encode metadata into EEG structure
                EEG.setname = [paths.expID ': raw'];
                EEG.filename = [rawFile '.bdf'];
                EEG.filepath = fullfile(paths.rawDir, currSub);
                EEG.subject = currSub;
                EEG.session = currSession;
                EEG.condition = currBlock;
            end
            
            %% 2. Cut out data segment
            step = 2;
            
             if preproc.(pipeLine{step})(1)
                
                %PROCESS
                fprintf('    Selecting continuous data segment...\n')
                % cut-out segment of data before end of ramp-up and after end of ramp-down
                EEG = preproc_segment_data(EEG, trig, currSub, currBlock, currSession);
                
                %SAVE
                if preproc.(pipeLine{step})(2) % if EEG data should be saved to disk after this step
                    [saveDir, procFile, EEG] = prepSave(EEG, paths, rawFile, pipeLine, step, timeStamp); % build directory and file name
                    fprintf('    Saving file %s...\n', procFile);
                    save(fullfile(saveDir, procFile), 'EEG', 'paths', 'preproc', 'trig'); %save variables to disk
                end
            end
            
            %% 3. Re-reference
            step = 3; % mark that we're now at the next preprocessing step
            
            if preproc.(pipeLine{step})(1)
                
                %PROCESS
                fprintf('    Re-referencing...\n')
                % re-reference, keeping ref channels in the data set, excluding other externals
                EEG = preproc_reref(EEG, preproc.refChans, [preproc.heogChans preproc.veogChans]); 
                
                %SAVE
                if preproc.(pipeLine{step})(2) 
                    [saveDir, procFile, EEG] = prepSave(EEG, paths, rawFile, pipeLine, step, timeStamp);
                    fprintf('    Saving file %s...\n', procFile);
                    save(fullfile(saveDir, procFile), 'EEG', 'paths', 'preproc', 'trig');
                end
            end
            
            %% 4. Bipolarize external channels
            step = 4;
            
            if preproc.(pipeLine{step})(1)
                
                %LOAD
                if ~preproc.(pipeLine{step-1})(1) && ~loadFlag % if the previous processing step should not be redone, and no data has been loaded yet
                    [EEG, preproc] = loadEEG(paths.procDir, rawFile, preproc, step);
                    loadFlag = true;
                end
                
                %PROCESS
                fprintf('    Bipolarizing external channels...\n')
                % Make external channels into bipolars (subtract)
                EEG = preproc_bipolar(EEG, preproc.heogChans, preproc.heogLabel, preproc.veogChans, preproc.veogLabel, ...
                    preproc.earChans, preproc.earLabel); 
                
                %SAVE
                if preproc.(pipeLine{step})(2)
                    [saveDir, procFile, EEG] = prepSave(EEG, paths, rawFile, pipeLine, step, timeStamp);
                    fprintf('    Saving file %s...\n', procFile);
                    save(fullfile(saveDir, procFile), 'EEG', 'paths', 'preproc', 'trig');
                end
            end
            
            %% 5. Remove unused channels
            step = 5;
            
            if preproc.(pipeLine{step})(1)
                
                %LOAD
                if ~preproc.(pipeLine{step-1})(1) && ~loadFlag
                    [EEG, preproc] = loadEEG(paths.procDir, rawFile, preproc, step);
                    loadFlag = true;
                end
                
                %PROCESS
                fprintf('    Removing unused channels...\n')
                EEG = pop_select(EEG, 'nochannel', preproc.noChans); % remove the channels that were not used during recording
                
                %SAVE
                if preproc.(pipeLine{step})(2)
                    [saveDir, procFile, EEG] = prepSave(EEG, paths, rawFile, pipeLine, step, timeStamp);
                    fprintf('    Saving file %s...\n', procFile);
                    save(fullfile(saveDir, procFile), 'EEG', 'paths', 'preproc', 'trig');
                end
            end
            
            %% 6. Channel info lookup
            step = 6;
            
            if preproc.(pipeLine{step})(1)
                
                %LOAD
                if ~preproc.(pipeLine{step-1})(1) && ~loadFlag
                    [EEG, preproc] = loadEEG(paths.procDir, rawFile, preproc, step);
                    loadFlag = true;
                end
                
                %PROCESS
                fprintf('    Looking up channel info...\n')
                EEG = pop_chanedit(EEG, 'lookup', preproc.channelInfo); % lookup information on channel location in cap
                
                %SAVE
                if preproc.(pipeLine{step})(2)
                    [saveDir, procFile, EEG] = prepSave(EEG, paths, rawFile, pipeLine, step, timeStamp);
                    fprintf('    Saving file %s...\n', procFile);
                    save(fullfile(saveDir, procFile), 'EEG', 'paths', 'preproc', 'trig');
                end
            end
            
            %% 7. Filter
            step = 7;
            
            if preproc.(pipeLine{step})(1)
                
                %LOAD
                if ~preproc.(pipeLine{step-1})(1) && ~loadFlag
                    [EEG, preproc] = loadEEG(paths.procDir, rawFile, preproc, step);
                    loadFlag = true;
                end
                
                %PROCESS
                fprintf('    High-pass filtering the data...\n')
                EEG = pop_eegfilt(EEG, preproc.highPass, []); % filter with low-cutoff at specified value (only high-pass, so no high cutoff)
                
                %SAVE
                if preproc.(pipeLine{step})(2)
                    [saveDir, procFile, EEG] = prepSave(EEG, paths, rawFile, pipeLine, step, timeStamp);
                    fprintf('    Saving file %s...\n', procFile);
                    save(fullfile(saveDir, procFile), 'EEG', 'paths', 'preproc', 'trig');
                end
            end
            
            %% 8. Recode triggers
            step = 8;
            
            if preproc.(pipeLine{step})(1)
                
                %LOAD
                if ~preproc.(pipeLine{step-1})(1) && ~loadFlag
                    [EEG, preproc] = loadEEG(paths.procDir, rawFile, preproc, step);
                    loadFlag = true;
                end
                
                %PROCESS
                fprintf('    Recoding marker values...\n')
                % recode event markers / EEG triggers for analysis
                EEG = preproc_recode_triggers(EEG, trig, currSession, currBlock); 
                
                %SAVE
                if preproc.(pipeLine{step})(2)
                    [saveDir, procFile, EEG] = prepSave(EEG, paths, rawFile, pipeLine, step, timeStamp);
                    fprintf('    Saving file %s...\n', procFile);
                    save(fullfile(saveDir, procFile), 'EEG', 'paths', 'preproc', 'trig');
                end
            end
            
            %% 9. Set channels to zero
            step = 9;
            
            if preproc.(pipeLine{step})(1)
                 
                 %LOAD
                 if ~preproc.(pipeLine{step-1})(1) && ~loadFlag
                    [EEG, preproc] = loadEEG(paths.procDir, rawFile, preproc, step);
                    loadFlag = true;
                 end
                
                %PROCESS
                fprintf('    Setting bad channels to zero...\n')
                EEG = preproc_zero_channels(EEG, currSub, currSession, currBlock, 1); %zero-out data from specified channels
                 
                %SAVE
                if preproc.(pipeLine{step})(2)
                    [saveDir, procFile, EEG] = prepSave(EEG, paths, rawFile, pipeLine, step, timeStamp);
                    fprintf('    Saving file %s...\n', procFile);
                    save(fullfile(saveDir, procFile), 'EEG', 'paths', 'preproc', 'trig');
                end
            end
            
            %% 10. Epoch
            step = 10;
            
            if preproc.(pipeLine{step})(1)
                
                %LOAD
                if ~preproc.(pipeLine{step-1})(1) && ~loadFlag
                    [EEG, preproc] = loadEEG(paths.procDir, rawFile, preproc, step);
                    loadFlag = true;
                end
                
                %PROCESS
                fprintf('    Epoching the data...\n')
                EEG = pop_epoch(EEG, preproc.zeroMarkers, preproc.epochTime1); % cut epochs using specified time zero and boundaries
                
                %SAVE
                if preproc.(pipeLine{step})(2)
                    [saveDir, procFile, EEG] = prepSave(EEG, paths, rawFile, pipeLine, step, timeStamp);
                    fprintf('    Saving file %s...\n', procFile);
                    save(fullfile(saveDir, procFile), 'EEG', 'paths', 'preproc', 'trig');
                end
            end
            
            %% 11. Baseline
            step = 11;
            
            if preproc.(pipeLine{step})(1)
                
                %LOAD
                if ~preproc.(pipeLine{step-1})(1) && ~loadFlag
                    [EEG, preproc] = loadEEG(paths.procDir, rawFile, preproc, step);
                    loadFlag = true;
                end
                
                %PROCESS
                fprintf('    Performing baseline correction ...\n')
                EEG = pop_rmbase(EEG, preproc.baseTime); % subtract average of baseline period from the epoch
                
                %SAVE
                if preproc.(pipeLine{step})(2)
                    [saveDir, procFile, EEG] = prepSave(EEG, paths, rawFile, pipeLine, step, timeStamp);
                    fprintf('    Saving file %s...\n', procFile);
                    save(fullfile(saveDir, procFile), 'EEG', 'paths', 'preproc', 'trig');
                end
            end
            
            %% 12. Reject trials
            step = 12;
            
            if preproc.(pipeLine{step})(1)
                
                %LOAD
                if ~preproc.(pipeLine{step-1})(1) && ~loadFlag
                    [EEG, preproc] = loadEEG(paths.procDir, rawFile, preproc, step);
                    loadFlag = true;
                end
                
                %PROCESS
                eeglab redraw
                msg_handle = msgbox(sprintf('Reject trials manually using the EEGlab graphical user interface.\nPress "Update marks" when done; the script will then resume.'), 'Trial rejection');
                uiwait(msg_handle)
                pop_eegplot(EEG,1,1,0);  % plot the data, set to mark trials for rejection (not actually remove them just yet!)
                uiwait
                
                % The rejmanual subfield will be reset after removing trials, but we want to keep the info!
                % So make a back-up both in the EEG structure and as a text file
                if ~isempty(EEG.reject.rejmanual)
                    EEG.rejectedTrials = EEG.reject.rejmanual;
                    rejectedTrials = find(EEG.reject.rejmanual);
                    dlmwrite(fullfile(paths.procDir, [rawFile '_' 'rejectedtrials' '_' timeStamp '.txt']), rejectedTrials, 'delimiter', '\t')
                end

                %SAVE
                if preproc.(pipeLine{step})(2)
                    [saveDir, procFile, EEG] = prepSave(EEG, paths, rawFile, pipeLine, step, timeStamp);
                    fprintf('    Saving file %s...\n', procFile);
                    save(fullfile(saveDir, procFile), 'EEG', 'paths', 'preproc', 'trig');
                end
                
            end
            
           %% 13. Mark bad channels
           step = 13;
            
            if preproc.(pipeLine{step})(1)
                
                 %LOAD
                 if ~preproc.(pipeLine{step-1})(1) && ~loadFlag
                    [EEG, preproc] = loadEEG(paths.procDir, rawFile, preproc, step);
                    loadFlag = true;
                 end
                    
                %PROCESS
                fprintf('    Setting additional bad channels to zero...\n')
                % zero-out data from specified channels
                EEG = preproc_zero_channels(EEG, currSub, currSession, currBlock, 2);
                
                %SAVE
                if preproc.(pipeLine{step})(2)
                    [saveDir, procFile, EEG] = prepSave(EEG, paths, rawFile, pipeLine, step, timeStamp);
                    fprintf('    Saving file %s...\n', procFile);
                    save(fullfile(saveDir, procFile), 'EEG', 'paths', 'preproc', 'trig');
                end 
            end

            %% 14. Interpolate channels (all epochs)
            step = 14;
            
            if preproc.(pipeLine{step})(1)
                
                %LOAD
                if ~preproc.(pipeLine{step-1})(1) && ~loadFlag
                    [EEG, preproc] = loadEEG(paths.procDir, rawFile, preproc, step);
                    loadFlag = true;
                end
                
                %PROCESS
                interpChans = chans2interp(currSub, currSession, currBlock);
                if ~isempty(interpChans)
                    fprintf('    Interpolating channels...\n')
                    % interpolate all timepoints of specified channels
                    EEG = preproc_interp_channels(EEG, preproc, currSub, currSession, currBlock); 
                end
                
                %SAVE
                if preproc.(pipeLine{step})(2)
                    [saveDir, procFile, EEG] = prepSave(EEG, paths, rawFile, pipeLine, step, timeStamp);
                    fprintf('    Saving file %s...\n', procFile);
                    save(fullfile(saveDir, procFile), 'EEG', 'paths', 'preproc', 'trig');
                end
            end
                 
            %% 15. Interpolate channels (single epochs) 
            step = 15;
            
            if preproc.(pipeLine{step})(1)
                
                %LOAD
                if ~preproc.(pipeLine{step-1})(1) && ~loadFlag
                    [EEG, preproc] = loadEEG(paths.procDir, rawFile, preproc, step);
                    loadFlag = true;
                end
                
                % PROCESS
                interpEpochChans = epochs2interp(currSub, currSession, currBlock);
                if ~isempty(interpEpochChans)
                    fprintf('    Interpolating epochs...\n')
                    % interpolate specified channels only on specified epochs
                    EEG = preproc_interp_epochs(EEG, preproc, currSub, currSession, currBlock); 
                end
                
                %SAVE
                if preproc.(pipeLine{step})(2)
                    [saveDir, procFile, EEG] = prepSave(EEG, paths, rawFile, pipeLine, step, timeStamp);
                    fprintf('    Saving file %s...\n', procFile);
                    save(fullfile(saveDir, procFile), 'EEG', 'paths', 'preproc', 'trig');
                end
            end
            
            %% 16. Remove rejected trials 
            step = 16;
            
            if preproc.(pipeLine{step})(1)
                
                %LOAD
                if ~preproc.(pipeLine{step-1})(1) && ~loadFlag
                    [EEG, preproc] = loadEEG(paths.procDir, rawFile, preproc, step);
                    loadFlag = true;
                end
                
                %PROCESS
                EEG = preproc_reject_trials(EEG, trig, paths.procDir, rawFile, currSession, currBlock); % remove trials marked for rejection
                
                %SAVE
                if preproc.(pipeLine{step})(2)
                    [saveDir, procFile, EEG] = prepSave(EEG, paths, rawFile, pipeLine, step, timeStamp);
                    fprintf('    Saving file %s...\n', procFile);
                    save(fullfile(saveDir, procFile), 'EEG', 'paths', 'preproc', 'trig');
                end
            end
            
            %% 17. Average reference
            step = 17;
            
            if preproc.(pipeLine{step})(1)
                
                %LOAD
                if ~preproc.(pipeLine{step-1})(1) && ~loadFlag
                    [EEG, preproc] = loadEEG(paths.procDir, rawFile, preproc, step);
                    loadFlag = true;
                end
                
                %PROCESS
                fprintf('    Re-referencing to common average...\n')
                %re-reference to common average
                EEG = preproc_averef(EEG, preproc, currSub, currSession, currBlock); 
                
                %SAVE
                if preproc.(pipeLine{step})(2)
                    [saveDir, procFile, EEG] = prepSave(EEG, paths, rawFile, pipeLine, step, timeStamp);
                    fprintf('    Saving file %s...\n', procFile);
                    save(fullfile(saveDir, procFile), 'EEG', 'paths', 'preproc', 'trig');
                end
            end
             
            %% 18. Independent components analysis
            step = 18;
            
            if preproc.(pipeLine{step})(1)
                
                %LOAD
                if ~preproc.(pipeLine{step-1})(1) && ~loadFlag
                    [EEG, preproc] = loadEEG(paths.procDir, rawFile, preproc, step);
                    loadFlag = true;
                end
                
                %PROCESS
                fprintf('    Running independent component analysis...\n')
                EEG = preproc_runica(EEG, preproc.icaType);
                
                %SAVE
                if preproc.(pipeLine{step})(2)
                    [saveDir, procFile, EEG] = prepSave(EEG, paths, rawFile, pipeLine, step, timeStamp);
                    fprintf('    Saving file %s...\n', procFile);
                    save(fullfile(saveDir, procFile), 'EEG', 'paths', 'preproc', 'trig');
                end
            end
            
           %% 19. Plot independent components
           step = 19;
           
            if preproc.(pipeLine{step})(1)
                
                %LOAD
                if ~preproc.(pipeLine{step-1})(1) && ~loadFlag
                    [EEG, preproc] = loadEEG(paths.procDir, rawFile, preproc, step);
                    loadFlag = true;
                end
                
                %PROCESS
                eeglab redraw
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
                
                %SAVE
                if preproc.(pipeLine{step})(2)
                    [saveDir, procFile, EEG] = prepSave(EEG, paths, rawFile, pipeLine, step, timeStamp);
                    fprintf('    Saving file %s...\n', procFile);
                    save(fullfile(saveDir, procFile), 'EEG', 'paths', 'preproc', 'trig');
                end
                
            end
            
            %% 20. Remove independent components
            step = 20;
            
            if preproc.(pipeLine{step})(1)
                
                %LOAD
                if ~preproc.(pipeLine{step-1})(1) && ~loadFlag
                    [EEG, preproc] = loadEEG(paths.procDir, rawFile, preproc, step);
                    loadFlag = true;
                end
                
                %PROCESS
                fprintf('    Removing independent components...\n')
                %Subtract marked ICA components from the data
                EEG = preproc_reject_comps(EEG, paths.procDir, rawFile);
                
                %SAVE
                if preproc.(pipeLine{step})(2)
                    [saveDir, procFile, EEG] = prepSave(EEG, paths, rawFile, pipeLine, step, timeStamp);
                    fprintf('    Saving file %s...\n', procFile);
                    save(fullfile(saveDir, procFile), 'EEG', 'paths', 'preproc', 'trig');
                end
            end
            
            %% 21. Remove bipolar channels
            step = 21;
            
            if preproc.(pipeLine{step})(1)
                
                %LOAD
                if ~preproc.(pipeLine{step-1})(1) && ~loadFlag
                    [EEG, preproc] = loadEEG(paths.procDir, rawFile, preproc, step);
                    loadFlag = true;
                end
                
                %PROCESS
                fprintf('    Removing bipolars...\n')
                EEG = pop_select(EEG, 'nochannel', {preproc.heogLabel, preproc.veogLabel, preproc.earLabel}); %remove bipolar channels
                
                %SAVE
                if preproc.(pipeLine{step})(2)
                    [saveDir, procFile, EEG] = prepSave(EEG, paths, rawFile, pipeLine, step, timeStamp);
                    fprintf('    Saving file %s...\n', procFile);
                    save(fullfile(saveDir, procFile), 'EEG', 'paths', 'preproc', 'trig');
                end
            end
            
           %% 22. Laplacian
           step = 22;
           
           if preproc.(pipeLine{step})(1)
               
               %LOAD
               if ~preproc.(pipeLine{step-1})(1) && ~loadFlag
                   [EEG, preproc] = loadEEG(paths.procDir, rawFile, preproc, step);
                   loadFlag = true;
               end
               
               %PROCESS
               fprintf('    Applying surface Laplacian...\n')
               % assumes externals have been removed (should zero'd out
               % channels be excluded too?!)
               EEG.data = laplacian_perrinX(EEG.data,[EEG.chanlocs.X],[EEG.chanlocs.Y],[EEG.chanlocs.Z]);
               
               %SAVE
               if preproc.(pipeLine{step})(2)
                   [saveDir, procFile, EEG] = prepSave(EEG, paths, rawFile, pipeLine, step, timeStamp);
                   fprintf('    Saving file %s...\n', procFile);
                   save(fullfile(saveDir, procFile), 'EEG', 'paths', 'preproc', 'trig');
               end
           end
           
           %% 23. Separate into conditions
           step = 23;
           
           if preproc.(pipeLine{step})
               
               %LOAD
               if ~preproc.(pipeLine{step-1})(1) && ~loadFlag
                   [EEG, preproc] = loadEEG(paths.procDir, rawFile, preproc, step);
                   loadFlag = true;
               end
               
               %PROCESS
               fprintf('    Separating into conditions...\n')
               [ALLEEG, conditionLabels] = preproc_conditions(EEG, currSession, currBlock, trig, preproc.epochTime2); %re-epoch data into separate EEG structures

               % Always save data to disk
               [saveDir, procFile, EEG] = prepSave(EEG, paths, rawFile, pipeLine, step, timeStamp);
               for iCond = 1:size(conditionLabels,1)
                   ALLEEG(iCond).setname = [paths.expID ': ' conditionLabels(iCond,1)];
                   ALLEEG(iCond).filename = [procFile '.mat'];
                   ALLEEG(iCond).filepath = saveDir;
               end
               fprintf('    Saving file %s...\n', procFile);
               save(fullfile(saveDir, procFile), 'ALLEEG', 'paths', 'preproc', 'trig', 'conditionLabels');
           end
                    
        end
    end
end

if paths.sendMail
    mail_from_matlab(sprintf('Preprocessing script finished!\n Final preprocessed file was: "%s"', procFile))
end

catch err
    if paths.sendMail
        mail_from_matlab(sprintf('Preprocessing script crashed with the following error:\n%s', err.message))
    end
    rethrow(err)
end