%% How do I change the Y-axis to frequency instead of period?
% Here is a short example that does just that. The sampling frequency is
% 100 MHz, and the signal is 5Mhz.

figure('color',[1 1 1])
t=(0:1e-8:500e-8)';
X=sin(t*2*pi*5e6)+randn(size(t))*.1;
Y=sin(t*2*pi*5e6+.4)+randn(size(t))*.1;
wtc([t X],[t Y])
freq=[128 64 32 16 8 4 2 1]*1e6;
set(gca,'ytick',log2(1./freq),'yticklabel',freq/1e6)
ylabel('Frequency (MHz)')
