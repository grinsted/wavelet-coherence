function [d,dt]=formatts(d)
%
% Usage: [d,dt]=formatts(d)
%
% Helper function for CWT,XWT,WTC
%
% Brings a timeseries into a shape so that it has two columns: [time, value].
%
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




if (ndims(d)>2)
    error('Input time series should be 2 dimensional.');
end
if (numel(d)==length(d))
    d=[(1:length(d))' d(:)];
end
if size(d,1)<size(d,2)
    d=d';
end
if (size(d,2)~=2)
    error('Time series must have 2 columns.')
end

if (d(2,1)-d(1,1)<0)
    d=flipud(d);
end

dt=diff(d(:,1));
if any(abs(dt-dt(1))>1e-1*dt(1))
    error('Time step must be constant.');
end
if (dt==0)
    error('Time step must be greater than zero.')
end

dt=dt(1);
