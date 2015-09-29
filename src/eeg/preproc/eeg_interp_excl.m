% eeg_interp_excl() - interpolate data channels
%
% Usage: EEGOUT = eeg_interp(EEG, badchans, method, nochans);
%
% Inputs: 
%     EEG      - EEGLAB dataset
%     badchans - [integer array] indices of channels to interpolate.
%                For instance, these channels might be bad.
%     nochans    -[integer array] indices of channels that you don't want to
%                include in the interpolation algorithm (e.g. channels that 
%                did not record anything / are pure noise) 
%
% Output: 
%     EEGOUT   - data set with bad electrode data replaced by
%                interpolated data
%
% Author: Arnaud Delorme, CERCO, CNRS, Mai 2006-
% Modified by Leon Reteig, 29-09-2015. Modification based on version of 
% "eeg_interp" in eeglab8_0_3_5b. Only works for epoched data, and only 
% does spherical interpolation.

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

% $Log: eeg_interp.m,v $
% Revision 1.8  2010/02/24 15:21:38  claire
% fix problem zhen missing channels in interp structure
%
% Revision 1.7  2009/08/05 03:20:42  arno
% new interpolation function
%
% Revision 1.6  2009/07/30 03:32:47  arno
% fixed interpolating bad channels
%
% Revision 1.5  2009/07/02 19:30:33  arno
% fix problem with empty channel
%
% Revision 1.4  2009/07/02 18:23:33  arno
% fixing interpolation
%
% Revision 1.3  2009/04/21 21:48:53  arno
% make default spherical in eeg_interp
%
% Revision 1.2  2008/04/16 17:34:45  arno
% added spherical and 3-D interpolation
%
% Revision 1.1  2006/09/12 18:46:30  arno
% Initial revision
%

function EEG = eeg_interp_excl(ORIEEG, bad_elec, rejected_chans)

    if nargin < 2
        help eeg_interp;
        return;
    end;
    EEG = ORIEEG;
    
    badchans  = bad_elec;
    nochans = rejected_chans;
    goodchans = setdiff(1:EEG.nbchan, [badchans nochans]);

    % find non-empty good channels
    % ----------------------------
    nonemptychans = find(~cellfun('isempty', { EEG.chanlocs.theta }));
    [tmp indgood ] = intersect(goodchans, nonemptychans);
    goodchans = goodchans( sort(indgood) );
    badchans  = intersect(badchans, nonemptychans);
    if isempty(badchans), return; end;
    
    % scan data points
    % ----------------
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
        
        EEG.data = reshape(EEG.data, EEG.nbchan, EEG.pnts*EEG.trials);
        %[tmp1 tmp2 tmp3 tmpchans] = spheric_spline_old( xelec, yelec, zelec, EEG.data(goodchans,1));
        %max(tmpchans(:,1)), std(tmpchans(:,1)), 
        %[tmp1 tmp2 tmp3 EEG.data(badchans,:)] = spheric_spline( xelec, yelec, zelec, xbad, ybad, zbad, EEG.data(goodchans,:));
        [tmp1 tmp2 tmp3 EEG.data(badchans,:)] = spheric_spline( xelec, yelec, zelec, xbad, ybad, zbad, EEG.data(goodchans,:));
        %max(EEG.data(goodchans,1)), std(EEG.data(goodchans,1))
        %max(EEG.data(badchans,1)), std(EEG.data(badchans,1))
        EEG.data = reshape(EEG.data, EEG.nbchan, EEG.pnts, EEG.trials);

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

