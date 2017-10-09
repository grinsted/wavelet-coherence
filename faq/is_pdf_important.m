%% When is the probability distribution of the data important?
% The null-hypothesis in the significance tests for WT, XWT and WTC is
% normally distributed AR1 noise. The AR1 coefficient and process variance
% is chosen so that it best fits the observed data. It is therefore quite
% important that the data is close to normal and is reasonably well
% modeled by a Gaussian AR1 process. Otherwise we can trivially reject
% the null-hypothesis and the significance level calculated by the program
% is not appropriate. However, the Central Limit Theorem tells us that the
% distribution tends towards normality as we convolute with longer and longer
% wavelets (_in the absence of long-range persistence_). This means that the
% data distribution is only really important on the shortest scales.
% So, if we are primarily looking at longer scales we do not need to
% worry so much about the distribution. However, for the WT and XWT the
% color of the noise is very important and a very non-normal distribution
% will affect the performance of the ar1 estimators (ar1.m & ar1nv.m).
% The WTC is relatively insensitive to the colour of the noise in the
% significance test (see next question).

