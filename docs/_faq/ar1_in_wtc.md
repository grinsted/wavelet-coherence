---
layout: page
title: How important is the AR1 coefficient for WTC significance levels?
categories: faq
---

The definition of Wavelet coherence (WTC) effectively normalizes by the local power in time frequency space. Therefore WTC is very insensitive to the noise colour used in the null-hypothesis (see Grinsted et al. 2004). It can easily be demonstrated by example:

```matlab
figure('color',[1 1 1])
set(gcf,'pos',get(gcf,'pos').*[1 .2 1 2]) %make high figure
X=randn(200,1);
Y=randn(200,1);
subplot(3,1,1);
orig_arcoefs=[ar1(X),ar1(Y)]
wtc(X,Y)
subplot(3,1,2);
X2=smooth(X,7);
Y2=smooth(Y,5);
smoothed_arcoefs=[ar1(X2),ar1(Y2)]
wtc(X2,Y2) %make the input data more red, by moving averages of the data.
subplot(3,1,3);
wtc(X2,Y2,'ar1',[0 0]) %Test the red series against white noise.
```


```
orig_arcoefs =
     0.024317    -0.096152
smoothed_arcoefs =
      0.85183      0.77571

```


![IMAGE](images/ar1_in_wtc_01.png)

The three figures are very similar.

