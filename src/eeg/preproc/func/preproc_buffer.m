function EEG = preproc_buffer(EEG,secs2splice)
% PREPROC_BUFFER: Add buffer zones to each end of EEG data to accommodate
% edge artficacts. Buffers are created by mirror data segments from either
% end, and creating new ends by splicing them back on.
%
% Usage: EEG = PREPROC_BUFFER(EEG,secs2splice)
%
% Inputs:
%   - EEG: EEGlab structure with EEG data.
%   - secs2splice: time in seconds to add to each end.
%
% Outputs:
%   - EEG: EEGlab structure with buffered EEG data.
%
% Called in preprocess
%
% See also PREPROCESS, PREPROC_CONFIG

secs2splice = round(secs2splice*EEG.srate)/EEG.srate; % convert input to integer multiple of refresh rate
pnts2splice = secs2splice*EEG.srate+1; % convert time to samples

startSegment = fliplr(EEG.data(:,1:pnts2splice)); % flip the first x seconds of data
endSegment = fliplr(EEG.data(:,end-pnts2splice+1:end)); % flip the final x samples of data

EEG.data = [startSegment(:,1:end-1) EEG.data endSegment(:,2:end)]; % splice segments back to both ends

EEG.pnts = EEG.pnts + 2*(pnts2splice-1); % recompute total amount of samples in data
EEG.xmax = EEG.xmax + 2*secs2splice; % recompute total duration of data data

% move all trigger latencies forward to account for spliced data segment
for ii = 1:length(EEG.event) 
EEG.event(ii).latency = EEG.event(ii).latency + pnts2splice-1;
end
