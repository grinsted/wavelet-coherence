function [normX,Bx,By]=normalizepdf(X)
% Forces the pdf of data to have a normal distribution using a data adaptive lookup table.
%
% [normX,Bx,By]=normalizepdf(X)
%
% normX=N(X) where N is an data adaptive monotonically increasing function.
% normX will have zero mean and unit variance.
%
% Bx,By describes the lookup table
%
% (c) Aslak Grinsted 2002-2014
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


[Bx,Js]=sort(X(:));
n=size(Bx,1);
d=(diff(Bx)~=0);

I=(1:n)';
I=I([d;true]);
%if (nargout>1)
    Bx=Bx(I);
%end

J=cumsum([1;d]);

n=length(X);
I=[0;I];

By=(.5/n)*(I(1:(end-1))+(I(2:end))); %percentile
By=norminv(By,0,1);

normX=interp1q(Bx,By,X);
