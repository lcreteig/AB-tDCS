function data = extractBehavData(files)

for iSub=1:length(files)
    
        ABdat=importdata(files{iSub}); % read text data
        
        if iSub == 1 % on first subject
        varNames = ABdat.textdata(1,:); % get column headers
        %initialize data structure
        data = struct('lag', zeros(length(files),length(ABdat.data)), ...
            'T1acc', zeros(length(files),length(ABdat.data)), 'T2acc', zeros(length(files),length(ABdat.data)), ...
            'T1isT2', zeros(length(files),length(ABdat.data)), 'T2isT1', zeros(length(files),length(ABdat.data)));
        end
        
        data.lag(iSub,:) = str2double(ABdat.textdata(2:end,strcmp('lag', varNames))); % store lag of each trial
        data.T1acc(iSub,:) = ABdat.data(:,1); % store T1 accuracy of each trial
        data.T2acc(iSub,:) = ABdat.data(:,2); % store T2 accuracy of each trial
           
 for iTrial=2:length(ABdat.textdata) % for each trial
     
     T1real = ABdat.textdata(iTrial, strcmp('T1letter', varNames)); %get actual T1 identity
     T1ans = ABdat.textdata(iTrial, strcmp('T1resp', varNames)); %get T1 response of subject
     T2real = ABdat.textdata(iTrial, strcmp('T12letter', varNames)); %get actual T2 identity
     T2ans = ABdat.textdata(iTrial, strcmp('T2resp', varNames)); %T2 response of subject
     
     if strcmp(T1ans, T2real) % If the identity of T2 was reported as T1
         data.T1isT2(iSub,iTrial) = 1; % mark trial
     end
     
     if strcmp(T2ans, T1real)  % If the identity of T2 was reported as T1
         data.T2isT1(iSub,iTrial) = 1; % mark trial
     end
         
 	end
 end
