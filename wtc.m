function varargout=wtc(x,y,varargin)
%% Wavelet coherence
%
% USAGE: [Rsq,period,scale,coi,sig95]=wtc(x,y,[,settings])
%
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
% .         MonteCarloCount: Number of surrogate data sets in the significance calculation. (default=300)
% .         ArrowDensity (default: [30 30])
% .         ArrowSize (default: 1)
% .         ArrowHeadSize (default: 1)
%
% Settings can also be specified using abbreviations. e.g. ms=MaxScale.
% For detailed help on some parameters type help wavelet.
%
% Example:
%    t=1:200;
%    wtc(sin(t),sin(t.*cos(t*.01)),'ms',16)
%
% Phase arrows indicate the relative phase relationship between the series
% (pointing right: in-phase; left: anti-phase; down: series1 leading
% series2 by 90�)
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
            'MonteCarloCount',300,...
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
%Args.ArrowHeadSize=Args.ArrowHeadSize*Args.ArrowSize*220;
Args.ArrowHeadSize=Args.ArrowHeadSize*120/ad;

if ~strcmpi(Args.Mother,'morlet')
    warning('WTC:InappropriateSmoothingOperator','Smoothing operator is designed for morlet wavelet.')
end

if strcmpi(Args.AR1,'auto')
    Args.AR1=[ar1nv(x(:,2)) ar1nv(y(:,2))];
    if any(isnan(Args.AR1))
        error('Automatic AR1 estimation failed. Specify it manually (use arcov or arburg).')
    end
end

nx=size(x,1);
%sigmax=std(x(:,2));

ny=size(y,1);
%sigmay=std(y(:,2));



%-----------:::::::::::::--------- ANALYZE ----------::::::::::::------------

[X,period,scale,coix] = wavelet(x(:,2),dt,Args.Pad,Args.Dj,Args.S0,Args.J1,Args.Mother);%#ok
[Y,period,scale,coiy] = wavelet(y(:,2),dt,Args.Pad,Args.Dj,Args.S0,Args.J1,Args.Mother);

%Smooth X and Y before truncating!  (minimize coi)
sinv=1./(scale');


sX=smoothwavelet(sinv(:,ones(1,nx)).*(abs(X).^2),dt,period,Args.Dj,scale);
sY=smoothwavelet(sinv(:,ones(1,ny)).*(abs(Y).^2),dt,period,Args.Dj,scale);


% truncate X,Y to common time interval (this is first done here so that the coi is minimized)
dte=dt*.01; %to cricumvent round off errors with fractional timesteps
idx=find((x(:,1)>=(t(1)-dte))&(x(:,1)<=(t(end)+dte)));
X=X(:,idx);
sX=sX(:,idx);
coix=coix(idx);

idx=find((y(:,1)>=(t(1))-dte)&(y(:,1)<=(t(end)+dte)));
Y=Y(:,idx);
sY=sY(:,idx);
coiy=coiy(idx);

coi=min(coix,coiy);

% -------- Cross wavelet -------
Wxy=X.*conj(Y);

% ----------------------- Wavelet coherence ---------------------------------
sWxy=smoothwavelet(sinv(:,ones(1,n)).*Wxy,dt,period,Args.Dj,scale);
Rsq=abs(sWxy).^2./(sX.*sY);

if (nargout>0)||(Args.MakeFigure)
    wtcsig=wtcsignif(Args.MonteCarloCount,Args.AR1,dt,length(t)*2,Args.Pad,Args.Dj,Args.S0,Args.J1,Args.Mother,.6);
    wtcsig=(wtcsig(:,2))*(ones(1,n));
    wtcsig=Rsq./wtcsig;
end

if Args.MakeFigure


    Yticks = 2.^(fix(log2(min(period))):fix(log2(max(period))));

        H=imagesc(t,log2(period),Rsq);%#ok
        %[c,H]=safecontourf(t,log2(period),Rsq,[0:.05:1]);
        %set(H,'linestyle','none')

        set(gca,'clim',[0 1])

        HCB=colorbar;%#ok

        set(gca,'YLim',log2([min(period),max(period)]), ...
            'YDir','reverse', 'layer','top', ...
            'YTick',log2(Yticks(:)), ...
            'YTickLabel',num2str(Yticks'), ...
            'layer','top')
        ylabel('Period')
        hold on

        %phase plot
        aWxy=angle(Wxy);
        aaa=aWxy;
        aaa(Rsq<.5)=NaN; %remove phase indication where Rsq is low
        %[xx,yy]=meshgrid(t(1:5:end),log2(period));

        phs_dt=round(length(t)/Args.ArrowDensity(1)); tidx=max(floor(phs_dt/2),1):phs_dt:length(t);
        phs_dp=round(length(period)/Args.ArrowDensity(2)); pidx=max(floor(phs_dp/2),1):phs_dp:length(period);
        phaseplot(t(tidx),log2(period(pidx)),aaa(pidx,tidx),Args.ArrowSize,Args.ArrowHeadSize);

        if ~all(isnan(wtcsig))
            [c,h] = contour(t,log2(period),wtcsig,[1 1],'k');%#ok
            set(h,'linewidth',2)
        end
        %suptitle([sTitle ' coherence']);
        tt=[t([1 1])-dt*.5;t;t([end end])+dt*.5];
        hcoi=fill(tt,log2([period([end 1]) coi period([1 end])]),'w');
        set(hcoi,'alphadatamapping','direct','facealpha',.5)
        hold off

end

varargout={Rsq,period,scale,coi,wtcsig,t};
varargout=varargout(1:nargout);
