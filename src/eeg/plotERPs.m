function plotERPs(subject, session, block)
% PLOTERPS: Plot topographical maps and ERPs for each channel, to inspect
% result of preprocesing.
%
% Loads final preprocessed file (data separated into conditions).
%
% Usage: plotERPs(subject, session, block)
%
% Inputs:
%   - subject: string with subject ID of file (e.g. 'S01' or 'S18')
%   - session: string with tDCS code of file ('B' or 'D')
%   - block: string with block of file ('pre', 'tDCS', or 'post')

%% Load

eeglab;
dataDir = fullfile('data', 'main', 'processed', 'conditions');
fileInfo = dir(fullfile(dataDir, [subject '_*' session '_' block '_conditions.mat']));
load(fullfile(dataDir,fileInfo.name));
eeglab redraw

%% Params

plotTime = [-200 1300]; % limits for ERP line plots
topoTimes = -200:100:1300; % data selection for topoplots, X:Y:Z. Steps from X to Z, takes average of Y ms.
baseTime = [0 200]; % baseline period

condition1 = 'short_T1corr_T2corr'; % no blink short
condition2 = 'short_T1corr_T2err'; % blink short

for iCond = 1:length(conditionLabels) % get index of conditions to contrast
cond1idx(iCond) = strncmp(condition1,conditionLabels{iCond,1}(end-length(condition1)+1:end),length(condition1));
cond2idx(iCond) = strncmp(condition2,conditionLabels{iCond,1}(end-length(condition2)+1:end),length(condition2));
end

colours = get(groot,'DefaultAxesColorOrder');

%% Baseline

for iCond = 1:length(ALLEEG)
ALLEEG(iCond) = pop_rmbase(ALLEEG(iCond), baseTime);
end

%% Plot average topos

EEG = pop_mergeset(ALLEEG,1:length(ALLEEG)); % use trials from all conditions

numPlots = length(topoTimes)-1;
numRows = ceil(sqrt(numPlots)); % number of rows/columns
iPlot = 1; % start counter

for iRows = 1:numRows;
    for iCols = 1:numRows;
        
        [~,timeStart] = min(abs(EEG.times-topoTimes(iPlot)));
        [~,timeEnd] = min(abs(EEG.times-topoTimes(iPlot+1)));
        
        data2plot = squeeze(mean(mean(EEG.data(:,timeStart:timeEnd,:),2),3)); % average across trials and time points
        if iPlot == 1
        clim = max(abs([min(data2plot) max(data2plot)])); % take min and max of first plot for scaling all plots
        end
        
        subplot(numRows,numRows,iPlot) % for each subplot
        topoplot(data2plot,EEG.chanlocs, 'maplimits', [-clim clim]);
        title(sprintf('%g to %g ms', topoTimes(iPlot), topoTimes(iPlot+1))); % title time range

        if iPlot==numPlots
            break
        end
        iPlot = iPlot+1;
    end
end

%% Plot condition average

% ERP for each channel
pop_comperp(ALLEEG,1,1:length(ALLEEG),[],'addavg','on','addstd','off','diffavg','off','diffstd','off','tlim',plotTime,'tplotopt',{'ydir', 1, 'colors', {colours(3,:)}});

%% Plot conditions of interest separately

% ERP for each channel
pop_comperp(ALLEEG,1,find(cond1idx),find(cond2idx),'addavg','on','addstd','off','subavg','on','diffavg','off','diffstd','off','tlim',plotTime,'tplotopt',{'ydir', 1, 'colors', {colours(1,:) colours(2,:)}});
