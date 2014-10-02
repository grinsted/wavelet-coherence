function [g,a,mu2]=ar1(x)
%% AR1 - Allen and Smith AR(1) model estimation.
% Syntax: [g,a,mu2]=ar1(x);
%
% INPUTS
%        x: time series (univariate).
%
% OUTPUTS
%        g: lag-one autocorrelation estimate.
%        a: noise variance estimate.
%      mu2: estimated square on the mean.
%
% AR1 is based on the approach described in Allen and Smith 1995. h/t Eric Breitenberger
%
% Alternative AR(1) estimatators: ar1cov, ar1nv, arburg, aryule
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



x=x(:);
N=length(x);
m=mean(x);
x=x-m;

% covariance estimates:
vr=x'*x/N; %zero lag
c1=x(1:N-1)'*x(2:N)/(N-1);%lag1

%how the expression below was derived:
%mu2=(-1/N+(2/N^2)*((N-g^N)/(1-g)-g*(1-g^(N-1))/(1-g)));
%solve('c0t=c0+c0t*(mu2)','c0t')
%c0t=(c0*N^2*(-1+g)/(-N^2+g*N^2+N+N*g-2*g));
%solve('g=(c1+c0t*mu2)/(c0+c0t*mu2)','g')
%g=1/2/c0/N^2*(c1*N+c0*N^2+2*c0-2*c1+c1*N^2-c0*N-(4*c0^2+4*c1^2-4*c1^2*N-6*c0^2*N^3+5*c0^2*N^2+c1^2*N^4+c0^2*N^4-8*c0*c1-4*c0^2*N-3*c1^2*N^2+2*c1^2*N^3-2*c0*c1*N^2-2*c0*N^4*c1+8*c0*c1*N+4*c0*N^3*c1)^(1/2));
%other solution:
%g(2)= 1/2/c0/N^2*(c1*N+c0*N^2+2*c0-2*c1+c1*N^2-c0*N+(4*c0^2+4*c1^2-4*c1^2*N-6*c0^2*N^3+5*c0^2*N^2+c1^2*N^4+c0^2*N^4-8*c0*c1-4*c0^2*N-3*c1^2*N^2+2*c1^2*N^3-2*c0*c1*N^2-2*c0*N^4*c1+8*c0*c1*N+4*c0*N^3*c1)^(1/2));

B=-c1*N-vr*N^2-2*vr+2*c1-c1*N^2+vr*N;
A=vr*N^2;
C=N*(vr+c1*N-c1);
D=B^2-4*A*C;
if D>0
    g=(-B-sqrt(D))/(2*A);
else
    warning('AR1:unboundAR1','Can not place an upperbound on the unbiased AR1.\n\t\t -Series too short or too large a trend.');
    g=nan;
end

if nargout>1
    mu2=-1/N+(2/N^2)*((N-g^N)/(1-g)-g*(1-g^(N-1))/(1-g)); %allen&smith96(footnote4)
    c0t=vr/(1-mu2);
    a=sqrt((1-g^2)*c0t);
end
