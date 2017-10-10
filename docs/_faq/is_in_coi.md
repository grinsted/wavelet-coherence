---
layout: page
title: How do I determine if a point is inside the COI or not?
categories: faq
---

Here is an example that does just that:

```matlab
t=(0:1:500)';
X=sin(t*2*pi/11)+randn(size(t))*.1;
[Wx,period,scale,coi,sig95]=wt([t X]);
incoi=period(:)*(1./coi)>1;
p=[100 64; 100 10; 50 64]; %are these points in the COI?
ispointincoi=interp2(t,period,incoi,p(:,1),p(:,2),'nearest')
```


```
ispointincoi =
     0
     0
     1

```

