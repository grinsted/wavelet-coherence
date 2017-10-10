---
layout: page
title: Installation instructions
---


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