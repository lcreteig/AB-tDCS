%% Setup
addpath(genpath(fullfile(pwd,'src'))) % add source code for analysis to matlab path

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