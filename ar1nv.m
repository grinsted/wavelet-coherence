function [g,a]=ar1nv(x)
% AR1NV - Estimate the parameters for an AR(1) model
% Syntax: [g,a]=ar1nv(x);
%
% Input: x - a time series.
%
% Output: g - estimate of the lag-one autocorrelation.
%         a - estimate of the noise variance.

% (c) Eric Breitenberger

x=x(:);
N=length(x);
m=mean(x);
x=x-m;

% Lag zero and one covariance estimates:
c0=x'*x/N;
c1=x(1:N-1)'*x(2:N)/(N-1);

g=c1/c0;
a=sqrt((1-g^2)*c0);
