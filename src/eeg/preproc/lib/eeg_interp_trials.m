% eeg_interp_trials() - interpolate data channels only at certain trials
%                       modified function, original: eeg_interp()
%
% Usage: EEGOUT = eeg_interp(EEG, badchans, method, badtrials, nochan);
%
% Inputs: 
%     EEG      - EEGLAB dataset
%     badchans - [integer array] indices of channels to interpolate.
%                For instance, these channels might be bad. Only integers
%                of the indices of electrodes can be used for this modified
%                function
%     method   - [string] method used for interpolation (default is 'spherical').
%                'invdist' uses inverse distance on the scalp
%                'spherical' uses superfast spherical interpolation. 
%                'spacetime' uses griddata3 to interpolate both in space 
%                and time (very slow and cannot be interupted).
%              - Note: for trial interpolation, use spherical!!!
%     badtrials -[integer array] trials at which channels specified by 
%                badchans need to be interpolated
%     nochan    -[integer array] indices of channels that you don't want to
%                include in the interpolation algorithm (e.g. channels that 
%                are interpolated entirely with function eeg_interp, or 
%                face/neck channels) 
% Output: 
%     EEGOUT   - data set with bad electrode data replaced by
%                interpolated data
%
% Author: Arnaud Delorme, CERCO, CNRS, Mai 2006-
% Modified by Jochem van Kempen & Joram van Driel

% Copyright (C) Arnaud Delorme, CERCO, 2006, arno@salk.edu
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

function EEG = eeg_interp_trials(ORIEEG, bad_elec, method, bad_trials, rejected_chans)

    if nargin < 2
        help eeg_interp;
        return;
    end;
    EEG = ORIEEG;
    
    if nargin < 4
        method = 'spherical';
    end;


    badchans  = bad_elec;
    nochans   = rejected_chans;
    goodchans = setdiff(1:EEG.nbchan, [badchans nochans]);

    % find non-empty good channels
    % ----------------------------
    nonemptychans = find(~cellfun('isempty', { EEG.chanlocs.theta }));
    [tmp indgood ] = intersect(goodchans, nonemptychans);
    goodchans = goodchans( sort(indgood) );
    
    datachans = getdatachans(goodchans,[badchans nochans]);
    badchans  = intersect(badchans, nonemptychans);
    if isempty(badchans), return; end;
    
    % scan data points
    % ----------------
    if strcmpi(method, 'spherical')
        % get theta, rad of electrodes
        % ----------------------------
        xelec = [ EEG.chanlocs(goodchans).X ];
        yelec = [ EEG.chanlocs(goodchans).Y ];
        zelec = [ EEG.chanlocs(goodchans).Z ];
        rad = sqrt(xelec.^2+yelec.^2+zelec.^2);
        xelec = xelec./rad;
        yelec = yelec./rad;
        zelec = zelec./rad;
        xbad = [ EEG.chanlocs(badchans).X ];
        ybad = [ EEG.chanlocs(badchans).Y ];
        zbad = [ EEG.chanlocs(badchans).Z ];
        rad = sqrt(xbad.^2+ybad.^2+zbad.^2);
        xbad = xbad./rad;
        ybad = ybad./rad;
        zbad = zbad./rad;
        
        %EEG.data = reshape(EEG.data, EEG.nbchan, EEG.pnts*EEG.trials);
        %[tmp1 tmp2 tmp3 tmpchans] = spheric_spline_old( xelec, yelec, zelec, EEG.data(goodchans,1));
        %max(tmpchans(:,1)), std(tmpchans(:,1)), 
        %[tmp1 tmp2 tmp3 EEG.data(badchans,:)] = spheric_spline( xelec, yelec, zelec, xbad, ybad, zbad, EEG.data(goodchans,:));
        
        % loop here over trials
        for triali = 1:length(bad_trials)
            [tmp1 tmp2 tmp3 EEG.data(badchans,:,bad_trials(triali))] = spheric_spline( xelec, yelec, zelec, xbad, ybad, zbad, EEG.data(goodchans,:,bad_trials(triali)));
        end % end loop
    
    elseif strcmpi(method, 'spacetime') % 3D interpolation, works but x10 times slower
        disp('Warning: if processing epoch data, epoch boundary are ignored...');
        disp('3-D interpolation, this can take a long (long) time...');
        [xbad ,ybad]  = pol2cart([EEG.chanlocs( badchans).theta],[EEG.chanlocs( badchans).radius]);
        [xgood,ygood] = pol2cart([EEG.chanlocs(goodchans).theta],[EEG.chanlocs(goodchans).radius]);
        pnts = size(EEG.data,2)*size(EEG.data,3);
        zgood = [1:pnts];
        zgood = repmat(zgood, [length(xgood) 1]);    
        zgood = reshape(zgood,prod(size(zgood)),1);
        xgood = repmat(xgood, [1 pnts]); xgood = reshape(xgood,prod(size(xgood)),1);
        ygood = repmat(ygood, [1 pnts]); ygood = reshape(ygood,prod(size(ygood)),1);
        tmpdata = reshape(EEG.data, prod(size(EEG.data)),1);
        zbad = 1:pnts;
        zbad = repmat(zbad, [length(xbad) 1]);     
        zbad = reshape(zbad,prod(size(zbad)),1);
        xbad = repmat(xbad, [1 pnts]); xbad = reshape(xbad,prod(size(xbad)),1);
        ybad = repmat(ybad, [1 pnts]); ybad = reshape(ybad,prod(size(ybad)),1);
        badchansdata = griddata3(ygood, xgood, zgood, tmpdata,...
                                              ybad, xbad, zbad, 'nearest'); % interpolate data                                            
    else 
        % get theta, rad of electrodes
        % ----------------------------
        [xbad ,ybad]  = pol2cart([EEG.chanlocs( badchans).theta],[EEG.chanlocs( badchans).radius]);
        [xgood,ygood] = pol2cart([EEG.chanlocs(goodchans).theta],[EEG.chanlocs(goodchans).radius]);

        fprintf('Points (/%d):', size(EEG.data,2)*size(EEG.data,3));
        badchansdata = zeros(length(badchans), size(EEG.data,2)*size(EEG.data,3));
        
        for t=1:(size(EEG.data,2)*size(EEG.data,3)) % scan data points
            if mod(t,100) == 0, fprintf('%d ', t); end;
            if mod(t,1000) == 0, fprintf('\n'); end;          
        
            %for c = 1:length(badchans)
            %   [h EEG.data(badchans(c),t)]= topoplot(EEG.data(goodchans,t),EEG.chanlocs(goodchans),'noplot', ...
            %        [EEG.chanlocs( badchans(c)).radius EEG.chanlocs( badchans(c)).theta]);
            %end;
            tmpdata = reshape(EEG.data, size(EEG.data,1), size(EEG.data,2)*size(EEG.data,3) );
            [Xi,Yi,badchansdata(:,t)] = griddata(ygood, xgood , tmpdata(datachans,t)',...
                                                    ybad, xbad, method); % interpolate data                                            
        end
        fprintf('\n');
    end;
    
%     tmpdata               = zeros(length(bad_elec), EEG.pnts, EEG.trials);
%     tmpdata(origoodchans, :,:) = EEG.data;
%     tmpdata(badchans , :) = badchansdata;
%     EEG.data = tmpdata;
    EEG.nbchan = size(EEG.data,1);
    EEG = eeg_checkset(EEG);

% get data channels
% -----------------
function datachans = getdatachans(goodchans, badchans);
      datachans = goodchans;
      badchans  = sort(badchans);
      for index = length(badchans):-1:1
          datachans(find(datachans > badchans(index))) = datachans(find(datachans > badchans(index)))-1;
      end;
        
% -----------------
% spherical splines
% -----------------
function [x, y, z, Res] = spheric_spline_old( xelec, yelec, zelec, values);

SPHERERES = 20;
[x,y,z] = sphere(SPHERERES);
x(1:(length(x)-1)/2,:) = []; x = [ x(:)' ];
y(1:(length(y)-1)/2,:) = []; y = [ y(:)' ];
z(1:(length(z)-1)/2,:) = []; z = [ z(:)' ];

Gelec = computeg(xelec,yelec,zelec,xelec,yelec,zelec);
Gsph  = computeg(x,y,z,xelec,yelec,zelec);

% equations are 
% Gelec*C + C0  = Potential (C unknow)
% Sum(c_i) = 0
% so 
%             [c_1]
%      *      [c_2]
%             [c_ ]
%    xelec    [c_n]
% [x x x x x]         [potential_1]
% [x x x x x]         [potential_ ]
% [x x x x x]       = [potential_ ]
% [x x x x x]         [potential_4]
% [1 1 1 1 1]         [0]

% compute solution for parameters C
% ---------------------------------
meanvalues = mean(values); 
values = values - meanvalues; % make mean zero
C = pinv([Gelec;ones(1,length(Gelec))]) * [values(:);0];

% apply results
% -------------
Res = zeros(1,size(Gsph,1));
for j = 1:size(Gsph,1)
    Res(j) = sum(C .* Gsph(j,:)');
end
Res = Res + meanvalues;
Res = reshape(Res, length(x(:)),1);

function [xbad, ybad, zbad, allres] = spheric_spline( xelec, yelec, zelec, xbad, ybad, zbad, values);

newchans = length(xbad);
numpoints = size(values,2);

%SPHERERES = 20;
%[x,y,z] = sphere(SPHERERES);
%x(1:(length(x)-1)/2,:) = []; xbad = [ x(:)'];
%y(1:(length(x)-1)/2,:) = []; ybad = [ y(:)'];
%z(1:(length(x)-1)/2,:) = []; zbad = [ z(:)'];

Gelec = computeg(xelec,yelec,zelec,xelec,yelec,zelec);
Gsph  = computeg(xbad,ybad,zbad,xelec,yelec,zelec);

% compute solution for parameters C
% ---------------------------------
meanvalues = mean(values); 
values = values - repmat(meanvalues, [size(values,1) 1]); % make mean zero

values = [values;zeros(1,numpoints)];
C = pinv([Gelec;ones(1,length(Gelec))]) * values;
clear values;
allres = zeros(newchans, numpoints);

% apply results
% -------------
for j = 1:size(Gsph,1)
    allres(j,:) = sum(C .* repmat(Gsph(j,:)', [1 size(C,2)]));        
end
allres = allres + repmat(meanvalues, [size(allres,1) 1]);

% compute G function
% ------------------
function g = computeg(x,y,z,xelec,yelec,zelec)

unitmat = ones(length(x(:)),length(xelec));
EI = unitmat - sqrt((repmat(x(:),1,length(xelec)) - repmat(xelec,length(x(:)),1)).^2 +... 
                (repmat(y(:),1,length(xelec)) - repmat(yelec,length(x(:)),1)).^2 +...
                (repmat(z(:),1,length(xelec)) - repmat(zelec,length(x(:)),1)).^2);

g = zeros(length(x(:)),length(xelec));
%dsafds
m = 4; % 3 is linear, 4 is best according to Perrin's curve
for n = 1:7
    L = legendre(n,EI);
    g = g + ((2*n+1)/(n^m*(n+1)^m))*squeeze(L(1,:,:));
end
g = g/(4*pi);    

