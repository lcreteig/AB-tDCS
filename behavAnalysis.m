% Quick script to find out whether / how often T1+T2 identities tend to be
% swapped

%% Setup
addpath(fullfile(pwd,'src')) % add source code for analysis to matlab path

%% Load data
fileInfo = dir([fullfile(pwd,'data', 'pilot') filesep '*.txt']); % get info on text files to load
files2load = cell(length(fileInfo),1);
for iFile = 1:length(fileInfo)
    files2load{iFile} = fullfile(fullfile(pwd,'data', 'pilot'), fileInfo(iFile).name); % convert file names from relative to full path
end

%% Extract info from raw data

data = extractBehavData(files2load);

lags = unique(data.lag);
for iLag = 1:length(lags)
    for iSub = 1:length(files2load)
        trialsPerLag = (length(data.T1acc) / numel(lags));
        trialIdx = data.lag(iSub,:) == lags(iLag) & logical(data.T1acc(iSub,:)); % trials on which T1 was accurately reported for this subject and lag
        T1acc(iSub,iLag) = sum(data.T1acc(iSub,trialIdx)) / trialsPerLag; % calculate proportion T1 correct
        T2ifT1acc(iSub, iLag) = sum(data.T2acc(iSub, trialIdx & logical(data.T2acc(iSub,:)))) / trialsPerLag ; % calculate proportion T2 correct given T1 correct
        swap(iSub, iLag) = sum(data.swap(iSub, data.lag(iSub,:) == lags(iLag))) / trialsPerLag;
        T1isT2(iSub, iLag) = sum(data.T1isT2(iSub, data.lag(iSub,:) == lags(iLag))) / trialsPerLag;
        T2isT1(iSub, iLag) = sum(data.T2isT1(iSub, data.lag(iSub,:) == lags(iLag))) / trialsPerLag;
    end
end

%% Plot T1 accuracy

figure('color', 'w')
hold on
title('T1 accuracy', 'fontSize', 16)
plot(lags,T1acc, 'color', [0.7 0.7 0.7]) % plot single subject data
plot(lags,mean(T1acc)', '-Ok', 'lineWidth', 3) % plot average
ylim([0 1])

set(gca, 'xTick', lags)
xlabel('lag', 'fontSize', 14)
ylabel('proportion correct', 'fontSize', 14)

%% Plot T2|T1 accuracy

figure('color', 'w')
hold on
title('T2|T1 accuracy', 'fontSize', 16)
plot(lags,T2ifT1acc, 'color', [0.7 0.7 0.7]) % plot single subject data
plot(lags,mean(T2ifT1acc)', '-Ok', 'lineWidth', 3) % plot average
ylim([0 1])

set(gca, 'xTick', lags)
xlabel('lag', 'fontSize', 14)
ylabel('proportion correct', 'fontSize', 14)

%% Plot proportion T2 and T1 swapped

figure('color', 'w')
hold on
title('T1 and T2 swapped', 'fontSize', 16)
plot(lags,swap, 'color', [0.7 0.7 0.7]) % plot single subject data
plot(lags,mean(swap)', '-Ok', 'lineWidth', 3) % plot average
ylim([0 1])

set(gca, 'xTick', lags)
xlabel('lag', 'fontSize', 14)
ylabel('proportion of trials', 'fontSize', 14)

%% Plot proportion T2 identity reported as T1

figure('color', 'w')
hold on
title('T2 identity reported as T1', 'fontSize', 16)
plot(lags,T1isT2, 'color', [0.7 0.7 0.7]) % plot single subject data
plot(lags,mean(T1isT2)', '-Ok', 'lineWidth', 3) % plot average
ylim([0 1])

set(gca, 'xTick', lags)
xlabel('lag', 'fontSize', 14)
ylabel('proportion of trials', 'fontSize', 14)

%% Plot proportion T1 identity reported as T2

figure('color', 'w')
hold on
title('T1 identity reported as T2', 'fontSize', 16)
plot(lags,T2isT1, 'color', [0.7 0.7 0.7]) % plot single subject data
plot(lags,mean(T2isT1)', '-Ok', 'lineWidth', 3) % plot average
ylim([0 1])

set(gca, 'xTick', lags)
xlabel('lag', 'fontSize', 14)
ylabel('proportion of trials', 'fontSize', 14)