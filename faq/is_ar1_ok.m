%% How do I know whether AR1 noise is an appropriate null hypothesis to test against?
% It is usually an appropriate null hypothesis if the theoretical AR1
% spectrum is  degreesa good model degrees for the power decay in the observed spectrum.
% I recommend to simply visually compare the two power spectra:

X=rednoise(200,.8);
[P,freq]=pburg(zscore(X),7,[],1);
aa=ar1(X);
Ptheoretical=(1-aa.^2)./(abs(1-aa.*exp(-2*pi*i*freq))).^2;
semilogy(freq,P/sum(P),freq,Ptheoretical/sum(Ptheoretical),'r');
legend('observed',sprintf('Theoretical AR1=%.2f',aa),'location','best')