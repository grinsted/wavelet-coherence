---
layout: home
title: Cross Wavelet and Wavelet Coherence Toolbox
---

This is a toolbox for matlab for making continuous wavelet, cross-wavelet, and wavelet coherence analysis. 

![](/images/wtcdemo_03.png)


Installation instructions
--------------------------

[Download the zip](https://github.com/grinsted/wavelet-coherence/archive/master.zip) file of the toolbox. Unzip it and place the files (including sub-folders) somewhere sensible. 

Before you can use the toolbox you need to add the toolbox path to the matlab path. The matlab path is a list of all folders where matlab should look for functions. 

Let's say you unpacked the toolbox to this folder: `/path_to/wavelet-coherence/`

Then you can add `addpath('/path_to/wavelet-coherence')` at the top of any file using the toolbox. For example:

```matlab
addpath('~/matlab/toolboxes/wavelet-coherence')
wt(randn(100,1))
```

In this way you can add to the path on a project basis. You can also add it permanently to your path if that is more convenient. You can use matlabs `pathtool` for that. 


Contribute
----------
It would be awesome if you would contribute to the project. Some ways you could help:
* Adding a nice & simple demo script. 
* Separate the visualization code to a separate plotwavelet function. 
* Auto update phase arrows when plot is resized. 
* Let wt,wtc,xwt return structures so that a visualization function has all necessary info

