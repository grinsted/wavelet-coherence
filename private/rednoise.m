function yred=rednoise(N,g,a);
% REDNOISE: A fast rednoise generator using filter.
%
% example: rednoise(N,g);
%
% Description: generates a rednoise series
% with zero process mean.
% note: statistical mean&variance will be different.
%
% Inputs: n - desired length of time series
%         g - lag-1 autocorrelation
%         a - noise innovation variance parameter (optional, default=1)
%
% Example:
%   plot(rednoise(1000,.95))
%
% Aslak Grinsted 2006-2014

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


if nargin<3
    a=1;
end

if g==0
    yred=randn(N,1)*a;
    return
end
tau=ceil(-2/log(abs(g))); %2 x de-correlation time

yred=filter([1 0],[1;-g],randn(tau+N,1)*a);
yred=yred(tau+1:end);
