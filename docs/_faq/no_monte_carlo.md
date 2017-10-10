---
layout: page
title: How do I avoid the slow Monte Carlo significance test in wtc?
categories: faq
---

You can do that by simply specifying the MonteCarloCount to be zero. Example:

```matlab
figure('color',[1 1 1])
t=(0:1:500)';
X=sin(t*2*pi/11)+randn(size(t))*.1;
Y=sin(t*2*pi/11+.4)+randn(size(t))*.1;
wtc([t X],[t Y],'mcc',0); %MCC:MonteCarloCount
```


![IMAGE](images/no_monte_carlo_01.png)

Note that the significance contour can not be trusted with out running the Monte Carlo test.

