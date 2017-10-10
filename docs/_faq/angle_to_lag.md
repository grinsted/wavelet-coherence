---
layout: page
title: How do I convert a phase-angle to a time lag?
categories: faq
---

This can not always be done and when it can, it should be done with care. A 90 degrees lead might as well be a 90 degrees lag to the anti-phase. There is therefore a non-uniqueness problem when doing the conversion. A phase angle can also only be converted to a time lag for a specific wavelength. This equation works best for determining the time lag when the series are near in-phase.

```matlab
wavelength=11;
phaseangle=20*pi/180;
timelag=phaseangle*wavelength/(2*pi)
```


```
timelag =
      0.61111

```

A visual inspection of the time series at the wavelength in question should make it clear if the time lag is right. I also recommend calculating the time lag with other methods for support.

