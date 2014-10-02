function [meantheta,R,sigma,confangle,kappa]=anglemean(theta);
% calculates the mean of angles
%
%    [meantheta,anglestrength,sigma,confangle,kappa]=anglemean(theta);
%
% anglestrength: can be thought of as the inverse variance. [varies between 0 and one]
% sigma: circular standard deviation
% confangle: a 95% confidence angle (confidence of the mean value)
% kappa: an estimate of kappa in the Von Mises distribution
%
% check: http://www.cosy.sbg.ac.at/~reini/huber_dutra_freitas_igarss_01.pdf
%
% Aslak Grinsted 2002-2014
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


theta=mod(theta(:),2*pi);
n=length(theta);
S=sum(sin(theta));
C=sum(cos(theta));
meantheta=atan2(S,C);

if nargout<2
    return
end

Rsum=sqrt(S^2+C^2);
R=Rsum/n;

if (R<.53)
    kappa=2*R+R^3+5*R^5/6;
elseif (R<.85)
    kappa=-0.4+1.39*R+0.43/(1-R);
else
    kappa=1/(R^3-4*R^2+3*R);
end


% circular standard deviation:
sigma=sqrt(-2*log(R));


if nargout<4
    return
end


%conflim=.95;

%this is true if the
chi2=3.841; % = chi2inv(.95,1)
if ((R<.9)&(R>sqrt(chi2/(2*n))))
    confangle=acos(sqrt(2*n*(2*Rsum^2-n*chi2)/(4*n-chi2))/Rsum);
elseif (R>.9)
    confangle=acos(sqrt(n^2-(n^2-Rsum^2)*exp(chi2/n))/Rsum);
else %R is really really small ...
    confangle=pi/2;
    warning('Confidence angle not well determined.')
    %this is not good, but not important because the confidence is so low anyway...
end
