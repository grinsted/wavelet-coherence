---
layout: page
title: How should the phase arrows be interpreted?
categories: faq
---

The phase arrows show the relative phasing of two time series in question. This can also be interpreted as a lead\#lag. How it should be interpreted is best illustrated by example:

```matlab
figure('color',[1 1 1])
t=(1:200)';
X=sin(t);
Y=sin(t-1); %X leads Y.
xwt([t X],[t Y]); % phase arrows points south east
```


![IMAGE](images/phase_arrows_01.png)

Phase arrows pointing \*	right: in-phase \* left: anti-phase \* down: X leading Y by 90 degrees \* up: Y leading X by 90 degrees

Note: interpreting the phase as a lead(\#lag) should always be done with care. A lead of 90 degrees can also be interpreted as a lag of 270 degrees or a lag of 90 degrees relative to the anti-phase (opposite sign).

