````
alias: The part alias name that appears in a tab in a multipart resource. e.g. 'Problem', 'Solution'
weight: The weight determines the order of this part in a multipart tab bar. Heavier parts come later.
id: (optional = can omit if same as filename and url)
title: (optional) but may be identified by resource type
layout: resource (but some resources will have special layouts)
author: (optional. If more than one, make it a yaml list)
date: (of first publication - maybe this should be automated)
clearance: 0
keywords: a yaml list of words or short phrases
resourceType: resourceTypeId
highlight: boolean or a list of station Ids
stids1: primary list of stations ids as yaml list
stids2: secondary list of station ids as yaml list
pvids1: primary list of pervasive idea ids as yaml list
pvids2: secondary list of pervasive ideas ids as yaml list
priors: links back to previous resources (laters get generated)

````

content in markdown (title will be inserted from )
