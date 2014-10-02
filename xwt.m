function varargout=xwt(x,y,varargin)
%% Cross wavelet transform
% Creates a figure of cross wavelet power in units of
% normalized variance.
%
% USAGE: [Wxy,period,scale,coi,sig95]=xwt(x,y,[,settings])
%
% x & y: two time series
% Wxy: the cross wavelet transform of x against y
% period: a vector of "Fourier" periods associated with Wxy
% scale: a vector of wavelet scales associated with Wxy
% coi: the cone of influence
%
% Settings: Pad: pad the time series with zeros?
% .         Dj: Octaves per scale (default: '1/12')
% .         S0: Minimum scale
% .         J1: Total number of scales
% .         Mother: Mother wavelet (default 'morlet')
% .         MaxScale: An easier way of specifying J1
% .         MakeFigure: Make a figure or simply return the output.
% .         BlackandWhite: Create black and white figures
% .         AR1: the ar1 coefficients of the series
% .              (default='auto' using a naive ar1 estimator. See ar1nv.m)
% .         ArrowDensity (default: [30 30])
% .         ArrowSize (default: 1)
% .         ArrowHeadSize (default: 1)
%
% Settings can also be specified using abbreviations. e.g. ms=MaxScale.
% For detailed help on some parameters type help wavelet.
%
% Example:
%    t=1:200;
%    xwt(sin(t),sin(t.*cos(t*.01)),'ms',16)
%
% Phase arrows indicate the relative phase relationship between the series
% (pointing right: in-phase; left: anti-phase; down: series1 leading
% series2 by 90deg)
%
% Please acknowledge the use of this software in any publications:
%   "Crosswavelet and wavelet coherence software were provided by
%   A. Grinsted."
%
% (C) Aslak Grinsted 2002-2014
%
% http://www.glaciology.net/wavelet-coherence

% -------------------------------------------------------------------------
%The MIT License (MIT)
%
%Copyright (c) 2014 Aslak Grinsted
%
%Permission is hereby granted, free of charge, to any person obtaining a copy
%of this software and associated documentation files (the "Software"), to deal
%in the Software without restriction, including without limitation the rights
%to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
%copies of the Software, and to permit persons to whom the Software is
%furnished to do so, subject to the following conditions:
%
%The above copyright notice and this permission notice shall be included in
%all copies or substantial portions of the Software.
%
%THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
%IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
%FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
%AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
%LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
%OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
%THE SOFTWARE.
%---------------------------------------------------------------------------


% ------validate and reformat timeseries.
[x,dt]=formatts(x);
[y,dty]=formatts(y);
if dt~=dty
    error('timestep must be equal between time series')
end
t=(max(x(1,1),y(1,1)):dt:min(x(end,1),y(end,1)))'; %common time period
if length(t)<4
    error('The two time series must overlap.')
end


n=length(t);

%----------default arguments for the wavelet transform-----------
Args=struct('Pad',1,...      % pad the time series with zeroes (recommended)
    'Dj',1/12, ...    % this will do 12 sub-octaves per octave
    'S0',2*dt,...    % this says start at a scale of 2 years
    'J1',[],...
    'Mother','Morlet', ...
    'MaxScale',[],...   %a more simple way to specify J1
    'MakeFigure',(nargout==0),...
    'AR1','auto',...
    'ArrowDensity',[30 30],...
    'ArrowSize',1,...
    'ArrowHeadSize',1);
Args=parseArgs(varargin,Args,{'BlackandWhite'});
if isempty(Args.J1)
    if isempty(Args.MaxScale)
        Args.MaxScale=(n*.17)*2*dt; %auto maxscale
    end
    Args.J1=round(log2(Args.MaxScale/Args.S0)/Args.Dj);
end

ad=mean(Args.ArrowDensity);
Args.ArrowSize=Args.ArrowSize*30*.03/ad;
Args.ArrowHeadSize=Args.ArrowHeadSize*Args.ArrowSize*220;


if strcmpi(Args.AR1,'auto')
    Args.AR1=[ar1nv(x(:,2)) ar1nv(y(:,2))];
    if any(isnan(Args.AR1))
        error('Automatic AR1 estimation failed. Specify them manually (use the arcov or arburg estimators).')
    end
end

%nx=size(x,1);
sigmax=std(x(:,2));

%ny=size(y,1);
sigmay=std(y(:,2));



%-----------:::::::::::::--------- ANALYZE ----------::::::::::::------------

[X,period,scale,coix] = wavelet(x(:,2),dt,Args.Pad,Args.Dj,Args.S0,Args.J1,Args.Mother);%#ok
[Y,period,scale,coiy] = wavelet(y(:,2),dt,Args.Pad,Args.Dj,Args.S0,Args.J1,Args.Mother);

% truncate X,Y to common time interval (this is first done here so that the coi is minimized)
dte=dt*.01; %to cricumvent round off errors with fractional timesteps
idx=find((x(:,1)>=(t(1)-dte))&(x(:,1)<=(t(end)+dte)));
X=X(:,idx);
coix=coix(idx);

idx=find((y(:,1)>=(t(1)-dte))&(y(:,1)<=(t(end)+dte)));
Y=Y(:,idx);
coiy=coiy(idx);

coi=min(coix,coiy);

% -------- Cross
Wxy=X.*conj(Y);



% sinv=1./(scale');
% sinv=sinv(:,ones(1,size(Wxy,2)));
%
% sWxy=smoothwavelet(sinv.*Wxy,dt,period,dj,scale);
% Rsq=abs(sWxy).^2./(smoothwavelet(sinv.*(abs(wave1).^2),dt,period,dj,scale).*smoothwavelet(sinv.*(abs(wave2).^2),dt,period,dj,scale));
% freq = dt ./ period;

%---- Significance levels
%Pk1=fft_theor(freq,lag1_1);
%Pk2=fft_theor(freq,lag1_2);
Pkx=ar1spectrum(Args.AR1(1),period./dt);
Pky=ar1spectrum(Args.AR1(2),period./dt);


V=2;
Zv=3.9999;
signif=sigmax*sigmay*sqrt(Pkx.*Pky)*Zv/V;
sig95 = (signif')*(ones(1,n));  % expand signif --> (J+1)x(N) array
sig95 = abs(Wxy) ./ sig95;
if ~strcmpi(Args.Mother,'morlet')
    sig95(:)=nan;
end

if Args.MakeFigure
    Yticks = 2.^(fix(log2(min(period))):fix(log2(max(period))));

    H=imagesc(t,log2(period),log2(abs(Wxy/(sigmax*sigmay))));%#ok
    %logpow=log2(abs(Wxy/(sigmax*sigmay)));
    %[c,H]=contourf(t,log2(period),logpow,[min(logpow(:)):.25:max(logpow(:))]);
    %set(H,'linestyle','none')

    clim=get(gca,'clim'); %center color limits around log2(1)=0
    clim=[-1 1]*max(clim(2),3);
    set(gca,'clim',clim)

    HCB=colorbar;
    set(HCB,'ytick',-7:7);
    barylbls=rats(2.^(get(HCB,'ytick')'));
    barylbls([1 end],:)=' ';
    barylbls(:,all(barylbls==' ',1))=[];
    set(HCB,'yticklabel',barylbls);

    set(gca,'YLim',log2([min(period),max(period)]), ...
        'YDir','reverse', ...
        'YTick',log2(Yticks(:)), ...
        'YTickLabel',num2str(Yticks'), ...
        'layer','top')
    %xlabel('Time')
    ylabel('Period')
    hold on

    aWxy=angle(Wxy);

    phs_dt=round(length(t)/Args.ArrowDensity(1)); tidx=max(floor(phs_dt/2),1):phs_dt:length(t);
    phs_dp=round(length(period)/Args.ArrowDensity(2)); pidx=max(floor(phs_dp/2),1):phs_dp:length(period);
    phaseplot(t(tidx),log2(period(pidx)),aWxy(pidx,tidx),Args.ArrowSize,Args.ArrowHeadSize);

    if strcmpi(Args.Mother,'morlet')
        [c,h] = contour(t,log2(period),sig95,[1 1],'k');%#ok
        set(h,'linewidth',2)
    else
        warning('XWT:sigLevelNotValid','XWT Significance level calculation is only valid for morlet wavelet.')
        %TODO: alternatively load from same file as wtc (needs to be coded!)
    end
    tt=[t([1 1])-dt*.5;t;t([end end])+dt*.5];
    hcoi=fill(tt,log2([period([end 1]) coi period([1 end])]),'w');
    set(hcoi,'alphadatamapping','direct','facealpha',.5)
    hold off
end

varargout={Wxy,period,scale,coi,sig95};
varargout=varargout(1:nargout);
