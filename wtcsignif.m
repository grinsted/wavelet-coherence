function wtcsig=wtcsignif(mccount,ar1,dt,n,pad,dj,s0,j1,mother,cutoff)
% Wavelet Coherence Significance Calculation (Monte Carlo)
%
% wtcsig=wtcsignif(mccount,ar1,dt,n,pad,dj,s0,j1,mother,cutoff)
%
% mccount: number of time series generations in the monte carlo run (the greater the better)
% ar1: a vector containing the 2 AR(1) coefficients. example: ar1=[.7 .6].
% dt,pad,dj,s0,j1,mother: see wavelet help...
% n: length of each generated timeseries. (obsolete)
%
% cutoff: (obsolete)
%
% RETURNED
% wtcsig: the 95% significance level as a function of scale... (scale,sig95level)
%
% (C) Aslak Grinsted 2002-2014
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



%cachedir=fileparts(mfilename('fullpath'));
%cachedir=fullfile(cachedir,'.cache');
cachedir=tempdir;


%we don't need to do the monte carlo if we have a cached
%siglevel for ar1s that are almost the same. (see fig4 in Grinsted et al., 2004)
aa=round(atanh(ar1(:)')*4); %this function increases the sensitivity near 1 & -1
aa=abs(aa)+.5*(aa<0); %only positive numbers are allowed in the checkvalues (because of log)

% do a check that it is not the same as last time... (for optimization purposes)
checkvalues=single([aa dj s0/dt j1 double(mother)]); %n & pad are not important.
%also the resolution is not important.

checkhash=['' mod(sum(log(checkvalues+1)*127),25)+'a' mod(sum(log(checkvalues+1)*54321),25)+'a'];

cachefilename=fullfile(cachedir,['wtcsignif-cached-' checkhash '.mat']);

%the hash is used to distinguish cache files.
try
    last=load(cachefilename);
    if (last.mccount>=mccount) && (isequal(checkvalues,last.checkvalues))
        wtcsig=last.wtcsig;
        return
    end
catch
end

%choose a n so that largest scale have atleast some part outside the coi
ms=s0*(2^(j1*dj))/dt; %maxscale in units of samples
n=ceil(ms*6);

warned=0;
%precalculate stuff that's constant outside the loop
d1=rednoise(n,ar1(1),1);
[W1,period,scale,coi] = wavelet(d1,dt,pad,dj,s0,j1,mother);
outsidecoi=zeros(size(W1));
for s=1:length(scale)
    outsidecoi(s,:)=(period(s)<=coi);
end
sinv=1./(scale');
sinv=sinv(:,ones(1,size(W1,2)));

if mccount<1
    wtcsig=scale';
    wtcsig(:,2)=.71; %pretty good
    return
end

sig95=zeros(size(scale));

maxscale=1;
for s=1:length(scale)
    if any(outsidecoi(s,:)>0)
        maxscale=s;
    else
        sig95(s)=NaN;
        if ~warned
            warning('Long wavelengths completely influenced by COI. (suggestion: set n higher, or j1 lower)'); warned=1;
        end
    end
end

%PAR1=1./ar1spectrum(ar1(1),period');
%PAR1=PAR1(:,ones(1,size(W1,2)));
%PAR2=1./ar1spectrum(ar1(2),period');
%PAR2=PAR2(:,ones(1,size(W1,2)));

nbins=1000;
wlc=zeros(length(scale),nbins);


timedwaitbar(0,['Running Monte Carlo (significance)... (H=' checkhash ')'])
for ii=1:mccount
    d1=rednoise(n,ar1(1),1);
    d2=rednoise(n,ar1(2),1);
    [W1,period,scale,coi] = wavelet(d1,dt,pad,dj,s0,j1,mother);
    [W2,period,scale,coi] = wavelet(d2,dt,pad,dj,s0,j1,mother);

    sWxy=smoothwavelet(sinv.*(W1.*conj(W2)),dt,period,dj,scale);
    Rsq=abs(sWxy).^2./(smoothwavelet(sinv.*(abs(W1).^2),dt,period,dj,scale).*smoothwavelet(sinv.*(abs(W2).^2),dt,period,dj,scale));

    for s=1:maxscale
        cd=Rsq(s,find(outsidecoi(s,:)));
        cd=max(min(cd,1),0);
        cd=floor(cd*(nbins-1))+1;
        for jj=1:length(cd)
            wlc(s,cd(jj))=wlc(s,cd(jj))+1;
        end
    end
    timedwaitbar(ii/mccount)
end


for s=1:maxscale
    rsqy=((1:nbins)-.5)/nbins;
    ptile=wlc(s,:);
    idx=find(ptile~=0);
    ptile=ptile(idx);
    rsqy=rsqy(idx);
    ptile=cumsum(ptile);
    ptile=(ptile-.5)/ptile(end);
    sig95(s)=interp1(ptile,rsqy,.95);
end
wtcsig=[scale' sig95'];

if any(isnan(sig95))&(~warned)
    warning('Sig95 calculation failed. (Some NaNs)')
else
    try
        save(cachefilename,'mccount','checkvalues','wtcsig'); %save to a cache....
    catch
        warning(['Unable to write to cache file: ' cachefilename])
    end
end
