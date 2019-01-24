    % eeg_interp_exclude() - interpolate data channels, while excluding others
    % N.B. MODIFIED FUNCTION! original: eeg_interp() from eeglab_13_5_4b
%
% Usage: EEGOUT = eeg_interp_exclude(EEG, bad_elec, excl_elec, method);
%
% Inputs: 
%     EEG       - EEGLAB dataset
%     bad_elec  - [integer array] indices of channels to interpolate.
%                 For instance, these channels might be bad.
%     excl_elec - [integer array] indices of channels that you don't want
%                 to include in the interpolation algorithm (e.g. channels
%                 that did not record anything / are pure noise).
%     method   -  [string] method used for interpolation (default is
%                 'spherical'). 'invdist'/'v4' uses inverse distance on the
%                 scalp 'spherical' uses superfast spherical interpolation.
%                 'spacetime' uses griddata3 to interpolate both in space
%                 and time (very slow and cannot be interupted).
% Output: 
%     EEGOUT   - data set with bad electrode data replaced by
%                interpolated data
%
% Author: Arnaud Delorme, CERCO, CNRS, Mai 2006-
% Modified by Leon Reteig to be able to exclude channels.
% all modifications are marked with "#LCR edit"

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

function OUTEEG = eeg_interp_exclude(ORIEEG, bad_elec, excl_elec, method)
% #LCR edit
    if nargin < 2
        help eeg_interp;
        return;
    end;
    OUTEEG = ORIEEG; % #LCR edit
    
    if nargin < 3 % #LCR edit
        excl_elec = [];
    end
    
    if nargin < 4 % #LCR edit
        disp('Using spherical interpolation');
        method = 'spherical';
    end;

    % check channel structure
    tmplocs = ORIEEG.chanlocs;
    if isempty(tmplocs) || isempty([tmplocs.X])
        error('Interpolation require channel location');
    end;

        goodchans = setdiff_bc(1:ORIEEG.nbchan, [bad_elec excl_elec]); % #LCR edit
        oldelocs  = ORIEEG.chanlocs;
        EEG       = pop_select(ORIEEG, 'nochannel', [bad_elec excl_elec]); % #LCR edit
        EEG.chanlocs = oldelocs;
        disp('Interpolating missing channels...');

    % find non-empty good channels
    % ----------------------------
    origoodchans = goodchans;
    chanlocs     = EEG.chanlocs;
    nonemptychans = find(~cellfun('isempty', { chanlocs.theta }));
    [tmp indgood ] = intersect_bc(goodchans, nonemptychans);
    goodchans = goodchans( sort(indgood) );
    datachans = getdatachans(goodchans,[bad_elec excl_elec]); % #LCR edit
    bad_elec  = intersect_bc(bad_elec, nonemptychans);
    if isempty(bad_elec), return; end;
    
    % scan data points
    % ----------------
    if strcmpi(method, 'spherical')
        % get theta, rad of electrodes
        % ----------------------------
        tmpgoodlocs = EEG.chanlocs(goodchans);
        xelec = [ tmpgoodlocs.X ];
        yelec = [ tmpgoodlocs.Y ];
        zelec = [ tmpgoodlocs.Z ];
        rad = sqrt(xelec.^2+yelec.^2+zelec.^2);
        xelec = xelec./rad;
        yelec = yelec./rad;
        zelec = zelec./rad;
        tmpbadlocs = EEG.chanlocs(bad_elec);
        xbad = [ tmpbadlocs.X ];
        ybad = [ tmpbadlocs.Y ];
        zbad = [ tmpbadlocs.Z ];
        rad = sqrt(xbad.^2+ybad.^2+zbad.^2);
        xbad = xbad./rad;
        ybad = ybad./rad;
        zbad = zbad./rad;
        
        EEG.data = reshape(EEG.data, EEG.nbchan, EEG.pnts*EEG.trials);
        %[tmp1 tmp2 tmp3 tmpchans] = spheric_spline_old( xelec, yelec, zelec, EEG.data(goodchans,1));
        %max(tmpchans(:,1)), std(tmpchans(:,1)), 
        %[tmp1 tmp2 tmp3 EEG.data(bad_elec,:)] = spheric_spline( xelec, yelec, zelec, xbad, ybad, zbad, EEG.data(goodchans,:));
        [tmp1 tmp2 tmp3 badchansdata] = spheric_spline( xelec, yelec, zelec, xbad, ybad, zbad, EEG.data(datachans,:));
        %max(EEG.data(goodchans,1)), std(EEG.data(goodchans,1))
        %max(EEG.data(bad_elec,1)), std(EEG.data(bad_elec,1))
        EEG.data = reshape(EEG.data, EEG.nbchan, EEG.pnts, EEG.trials);
    elseif strcmpi(method, 'spacetime') % 3D interpolation, works but x10 times slower
        disp('Warning: if processing epoch data, epoch boundary are ignored...');
        disp('3-D interpolation, this can take a long (long) time...');
        tmpgoodlocs = EEG.chanlocs(goodchans);
        tmpbadlocs = EEG.chanlocs(bad_elec);
        [xbad ,ybad]  = pol2cart([tmpbadlocs.theta],[tmpbadlocs.radius]);
        [xgood,ygood] = pol2cart([tmpgoodlocs.theta],[tmpgoodlocs.radius]);
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
        tmpchanlocs = EEG.chanlocs;
        [xbad ,ybad]  = pol2cart([tmpchanlocs( bad_elec).theta],[tmpchanlocs( bad_elec).radius]);
        [xgood,ygood] = pol2cart([tmpchanlocs(goodchans).theta],[tmpchanlocs(goodchans).radius]);

        fprintf('Points (/%d):', size(EEG.data,2)*size(EEG.data,3));
        badchansdata = zeros(length(bad_elec), size(EEG.data,2)*size(EEG.data,3));
        
        for t=1:(size(EEG.data,2)*size(EEG.data,3)) % scan data points
            if mod(t,100) == 0, fprintf('%d ', t); end;
            if mod(t,1000) == 0, fprintf('\n'); end;          
        
            %for c = 1:length(bad_elec)
            %   [h EEG.data(bad_elec(c),t)]= topoplot(EEG.data(goodchans,t),EEG.chanlocs(goodchans),'noplot', ...
            %        [EEG.chanlocs( bad_elec(c)).radius EEG.chanlocs( bad_elec(c)).theta]);
            %end;
            tmpdata = reshape(EEG.data, size(EEG.data,1), size(EEG.data,2)*size(EEG.data,3) );
            if strcmpi(method, 'invdist'), method = 'v4'; end;
            [Xi,Yi,badchansdata(:,t)] = griddata(ygood, xgood , double(tmpdata(datachans,t)'),...
                                                    ybad, xbad, method); % interpolate data                                            
        end
        fprintf('\n');
    end;
    
    tmpdata               = zeros(length(bad_elec), EEG.pnts, EEG.trials);
    tmpdata(origoodchans, :,:) = EEG.data;
    %if input data are epoched reshape badchansdata for Octave compatibility...
    if length(size(tmpdata))==3
        badchansdata = reshape(badchansdata,length(bad_elec),size(tmpdata,2),size(tmpdata,3));
    end
    tmpdata(bad_elec,:,:) = badchansdata;
    EEG.data = tmpdata;
    EEG.nbchan = size(EEG.data,1);
    
    OUTEEG.data(bad_elec,:,:) = EEG.data(bad_elec,:,:); % #LCR edit
    OUTEEG = eeg_checkset(OUTEEG); % #LCR edit
    
% get data channels
% -----------------
function datachans = getdatachans(goodchans, bad_elec);
      datachans = goodchans;
      bad_elec  = sort(bad_elec);
      for index = length(bad_elec):-1:1
          datachans(find(datachans > bad_elec(index))) = datachans(find(datachans > bad_elec(index)))-1;
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
    if ismatlab
        L = legendre(n,EI);
    else % Octave legendre function cannot process 2-D matrices
        for icol = 1:size(EI,2)
            tmpL = legendre(n,EI(:,icol));
            if icol == 1, L = zeros([ size(tmpL) size(EI,2)]); end;
            L(:,:,icol) = tmpL;
        end;
    end;
    g = g + ((2*n+1)/(n^m*(n+1)^m))*squeeze(L(1,:,:));
end
g = g/(4*pi);    

