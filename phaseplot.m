function h = phaseplot(x,y,phase,sz,varargin)
% Plots arrows indicating the phase on current axis.
%
% [h,yy,zz] = PhasePlot(x,y,phase,sz[,ArrowParameters])
%
%
%
% Note: Arrows will get skewed if you resize the axis.
%
% (c) Aslak Grinsted 2003-2014
% http://www.glaciology.net/wavelet-coherence

% -------------------------------------------------------------------------
%The MIT License (MIT)
%
%Copyright (c) 2014-2015 Aslak Grinsted
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


if nargin==0
    close all
    [x,y]=meshgrid(1:10,1:20);
    phase=rand(size(x))*2*pi;
end


x=x(:);
y=y(:);
phase=phase(:);
if (length(x)*length(y)==length(phase))
    [x,y]=meshgrid(x,y);
end;
sz=sz(:);

%remove nans
idx=find(~any(isnan([x(:) y(:) phase]),2));
x=x(idx);
y=y(idx);
phase=phase(idx);
if (length(sz)>1), sz=sz(idx); end;


dataar=get(gca,'DataAspectRatio');
units=get(gca,'units');
set(gca,'units','centimeters');
wh=get(gca,'position'); wh=wh(3:4);
set(gca,'units',units);
ar=wh./dataar(1:2);


ar(2)=ar(1)/ar(2);
ar(1)=1;

dxlim=abs(diff(get(gca,'xlim')));
dx=ar(1).*sz*dxlim*.5;
dy=ar(2).*sz*dxlim*.5;

%shape of an arrow
headsz=1; linew=.1; headw=.5;
shape=[-1 [1 1]-headsz 1 [1 1]-headsz -1;linew linew headw 0 -headw -linew -linew]';

h=[];
for ii=numel(x):-1:1
    s=shape*[cos(phase(ii)) sin(phase(ii));-sin(phase(ii)) cos(phase(ii))];
    h(ii)=patch(x(ii)+s(:,1)*dx,y(ii)+s(:,2)*dy,[0 0 0],'edgecolor','none');
end


if nargout==0
    clearvars h
end
%
%
% h=arrow([x-dx y-dy],[x+dx y+dy],varargin{:});
% set(h,'clipping','on')
% if (nargout<1) clear h; end;
%
