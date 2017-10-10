---
layout: page
title: Installation instructions
---

Download the zip file to a folder somewhere on your computer. Unzip it and place the files (including sub-folders) somewhere. 

The matlab path is a list of all folders where matlab should look for functions. Before you can use the toolbox you need to add the toolbox path to the matlab path.

Let's say you unpacked the toolbox to this folder: `/path_to/wavelet-coherence/`

Then you can add `addpath('/path_to/wavelet-coherence')` at the top of any file using the toolbox. For example:

```matlab
addpath('~/matlab/toolboxes/wavelet-coherence')
wt(randn(100,1))
```

