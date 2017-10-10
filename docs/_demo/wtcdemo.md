---
layout: page
title: Demo of the cross wavelet and wavelet coherence toolbox
categories: demo
---

This example illustrates how simple it is to do continuous wavelet transform (CWT), Cross wavelet transform (XWT) and Wavelet Coherence (WTC) plots of your own data.

The time series we will be analyzing are the winter Arctic Oscillation index (AO) and the maximum sea ice extent in the Baltic (BMI).

Load the data
----------------------------------------------------------

First we load the two time series into the matrices d1 and d2.

```matlab
seriesname={'AO' 'BMI'};
d1=load('faq\jao.txt');
d2=load('faq\jbaltic.txt');
```

Change the pdf.
----------------------------------------------------------

The time series of Baltic Sea ice extent is highly bi-modal and we therefore transform the timeseries into a series of percentiles. The transformed series probably reacts 'more linearly' to climate.

```matlab
d2(:,2)=boxpdf(d2(:,2));
```

Continuous wavelet transform (CWT)
----------------------------------------------------------

The CWT expands the time series into time frequency space.

```matlab
figure('color',[1 1 1])
tlim=[min(d1(1,1),d2(1,1)) max(d1(end,1),d2(end,1))];
subplot(2,1,1);
wt(d1);
title(seriesname{1});
set(gca,'xlim',tlim);
subplot(2,1,2)
wt(d2)
title(seriesname{2})
set(gca,'xlim',tlim)
```


![IMAGE](images/wtcdemo_01.png)

Cross wavelet transform (XWT)
----------------------------------------------------------

The XWT finds regions in time frequency space where the time series show high common power.

```matlab
figure('color',[1 1 1])
xwt(d1,d2)
title(['XWT: ' seriesname{1} '-' seriesname{2} ] )
```


![IMAGE](images/wtcdemo_02.png)

Wavelet coherence (WTC)
----------------------------------------------------------

The WTC finds regions in time frequency space where the two time series co-vary (but does not necessarily have high power).

```matlab
figure('color',[1 1 1])
wtc(d1,d2)
title(['WTC: ' seriesname{1} '-' seriesname{2} ] )
```


![IMAGE](images/wtcdemo_03.png)

