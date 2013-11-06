````
alias: Introduction
weight: 0
layout: resource
clearance: -1
title: CMEP Contribution Documentation
author: Ewan Davies
lastUpdated: NOT YET IMPLEMENTED
acknowledgementText: So long and thanks for all the fish.
keywords:
  - lodash
  - test
resourceType: RT3
stids1:
stids2:
pvids1:
pvids2:
priors:

````

# How to contribute to CMEP

## What does a CMEP resource look like?

Each resource lives in its own folder. The main file is called `index.md` -- carrying a `.md` extension since it's expected to be in Markdown. See the [Markdown Guide](index.html#tab1) for more info. Each file can refer to others in the same folder - e.g. images, or other linked content. The `index.md` usually does not contain an index, though it might. 

On the website the different `.md` files are combined into one `index.html` where each file is shown as a tab. To refer to other tabs you will (when this is implemented) be able to append `#tabN` to the url.`N` is the tab number, counting from `0`. 

To build the CMEP content we use [`Pandoc`](http://johnmacfarlane.net/pandoc/), a compiler that can convert Markdown to a large number of other document formats. To preview your work you'll need a copy of `pandoc` installed, together with a good text editor -- we recommend using `Sublime Text 2`.

## Preliminary Installations

Follow the links for downloads and installation instructions.

* [Pandoc installation](http://johnmacfarlane.net/pandoc). Do make sure that you have 
the resulting pandoc executable in your PATH. When this is right, executing the command `pandoc` at a console will run the program -- it will sit there waiting for input. Type ctrl-D to give it an end-of-file to finish.
* [Sublime Text 2](http://sublimetext.com)

It's useful to configure your editor so you can use pandoc to compile HTML previews. Here's how to do it in sublime text.

* Install the [Package Controller for Sublime](http://wbond.net/sublime_packages/package_control/installation). The console is available on the `View > Show Console` menu in Sublime. This plugin adds a number of package installation commands to sublime. which show up in the command palette when you start typing 'Package Control'. Find them in the `Tools > Command Palette` menu.

* Use your new package installer to install the package `Pandoc (Markdown)`. This will install  commands in the Tools menu of sublime which compile and preview Markdown. Provided pandoc is in your PATH, these should work.

### Enabling Maths rendering in preview

1. On the menu go to `Sublime Text 2 > Preferences > Browse Packages`. This
will open a window on a folder containing all your sublime packages.

2. Find the folder called Pandoc (Markdown) and open it.

3. Edit the python file 'PandocRender.py' *carefully*.

  - Locate a line that says `cmd.append('--standalone')`
  - Insert after it a line that says `cmd.append('--mathjax')`

4. Save, Quit Sublime, and restart. Maths should now render in pandoc html preview.


### Extra instructions for Windows machines

1. In a command prompt, get the path to `pandoc` using
```
where pandoc
```

2. Open sublime, open a markdown file, and check that sublime thinks it is editing markdown by checking the indicator at bottom right of the window.

3. In the menu, go to `Preferences > Package Setting > Pandoc > Settings - User`

4. Type this:

```
{
  "pandoc_path": null,
  "pandoc_bin": "path_to_pandoc_from_step_1 --mathjax"
}

```

5. Adjust the path to `pandoc` by replacing all backslashes `\` with doubled backslashes `\\`.

6. Save.

The pandoc commands should then work. The pandoc maths commands should work after a pandoc restart.

## Starting to write

Most of the things you'll need are in our [Markdown Guide](index.html#tab1) guide and there is a lot more to boot in the [Pandoc User Guide](http://johnmacfarlane.net/pandoc/README.html#pandocs-Markdown). A good place to start is with the top of the file, which contains the _metadata_...

## Creating metadata

At the top of the index.md file (and other .md files, which have _slightly_ different metadata) in your resource folder there is space for some metadata. It begins with 4 backticks (`` ` ``) at the start of the first line, and ends with 4 more backticks. Between the two sets of backticks you can add data about the resource. The following template may be handy:

````
alias: the name that appears in a tab in a multipart resource. e.g. 'Problem', 'Solution'
weight: determines the order of this part in a multipart tab bar. larget numbers come later.
id: (optional = can omit if same as filename and url)
title: (optional) but may be identified by resource type
layout: resource (but some resources will have special layouts)
author: (optional. If more than one, make it a yaml list)
date: (of first publication - this should be automated soon)
clearance: 0 (a number which determines who sees your resource, go with 0 for now)
keywords: a yaml list of words or short phrases
resourceType: resourceTypeId
highlight: boolean or a list of station Ids
stids1: primary list of stations ids as yaml list
stids2: secondary list of station ids as yaml list
pvids1: primary list of pervasive idea ids as yaml list
pvids2: secondary list of pervasive ideas ids as yaml list
priors: links back to previous resources (laters get generated)

````

The language for metadata is YAML. Look it up if you must, but it's simple enough to pick up by looking at a few examples.

## The paper copy

Our system uses pandoc and latex to produce pdfs of certain resources. These are designed to be printed on paper and have much of the interactive content disables for this reason. Don't be afraid to use interactive content, we love it! Just don't expect paper users of CMEP to enjoy it quite so much.

## Submitting your resource

Email the folder to Vicky, vrn20@cam.ac.uk. You might be contacted with questions and suggestions from the technical team as they test the resource to make sure it appears correctly.




