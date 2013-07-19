How to contribute to CMEP
=========================

What is a CMEP Resource?
------------------------

CMEP resources are maintained in the Pandoc flavour of Markdown. This isn't as scary as it might appear, since Markdown is a wiki-like markup language that you've probably already used.

Each resource lives in its own folder. The main file is called `index.md` -- carrying a `.md` extension since it's expected to be in Markdown. That file can refer to others in the same folder - e.g. images, or other linked content. The `index.md` usually does not contain an index, though it might.

`Pandoc` is a compiler that can convert Markdown to a large number of other document formats. You'll need a copy of `pandoc` installed, together with a good text editor -- we recommend using `Sublime Text 2`.

Preliminary Installations
-------------

Follow the links for downloads and installation instructions.

* [`Pandoc installation`](http://johnmacfarlane.net/pandoc). Do make sure that you have 
the resulting pandoc executable in your PATH. When this is right, executing the command `pandoc` at a console will run the program -- it will sit there waiting for input. Type ctrl-D to give it an end-of-file to finish.
* [`Sublime Text 2`](http://sublimetext.com)

In addition, it's very useful to configure your editor so you can use pandoc to compile HTML previews.
Here's how to do it in sublime text.

* Install the [Package Controller for Sublime](http://wbond.net/sublime_packages/package_control/installation). The console is available on the `View > Show Console` menu in Sublime. This plugin adds a number of package installation commands to sublime. which show up in the command palette when you start typing 'Package Control'. Find them in the `Tools > Command Palette` menu.

* Use your new package installer to install the package `Pandoc (Markdown)`. This will install  commands in the Tools menu of sublime which compile and preview Markdown. Provided pandoc is in your PATH, these should work.

Enabling Maths rendering in preview
-----------------------------------

1. On the menu go to `Sublime Text 2 > Preferences > Browse Packages`. This
will open a window on a folder containing all your sublime packages.

2. Find the folder called Pandoc (Markdown) and open it.

3. Edit the python file 'PandocRender.py' *carefully*.

  - Locate a line that says `cmd.append('--standalone')`
  - Insert after it a line that says `cmd.append('--mathjax')`

4. Save, Quit Sublime, and restart. Maths should now render in pandoc html preview.


Extra instructions for Windows machines
---------------------------------------

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

The pandoc commands should then work.


The pandoc maths commands should then work after a pandoc restart.

Writing Mathematics
-------------------

To write mathematics use LaTeX notation. Actually, I mean that part of LaTeX which is supported by the [MathJax](http://www.mathjax.org) service -- which is more than enough to support school mathematics. Assume the AMSLaTeX package is installed, but little else.

Delimit inline mathematics with single dollar signs as in `$y=x^2$`, which will display as $y=x^2$. Delimit display mathematics with double dollars as in `$$y=\frac{1}{x^2}$$`, which will display on a separate centred line as $$y=\frac{1}{x^2}.$$

Note that the pandoc preview may not centre display mathematics correctly unless you tweak the associated CSS. But you can probably imagine how it will look.

Writing everything else
-----------------------

Your guide is the [Pandoc User Guide](http://johnmacfarlane.net/pandoc/README.html#pandocs-Markdown).

Creating metadata
-----------------

At the top of the index.md file in your resource folder there is space for some metadata. It begins with 4 backticks at the start of the first line, and ends with 4 more backticks. Between the two sets of backticks you can add data about the resource. The following template may be handy:

````
id: (optional = can omit if same as filename and url)
title: (optional) but may be identified by resource type
layout: resource (but some resources will have special layouts)
author: (optional. If more than one, make it a yaml list)
date: (of first publication - maybe this should be automated)
clearance: set to 0 initially.
keywords: a yaml list of words or short phrases
resourceType: resourceTypeId
highlight: boolean or a list of station Ids
stids1: primary list of stations ids as yaml list
stids2: secondary list of station ids as yaml list
pvids1: primary list of pervasive idea ids as yaml list
pvids2: secondary list of pervasive ideas ids as yaml list

````

The markup language for metadata is YAML. Look it up if you must, but it's simple enough to pick up by looking at a few examples.

Making hyperlinks
-----------------

Use the Markdown syntax -- square brackets wrapping the linked text, and parentheses wrapping the URL. When referring to other resources on CMEP, use relative URLs. To refer to other files in your resource folder, simply use the filename. The site home is at `../..`. The G2 station will be at `../../stations/G2.html, and so on. Non local resources should be given their full URL.

Including images
----------------

Similar rules apply when providing the URL for an image file, but you will want to make sure the image is optimised for the web and available locally. Remember also, that paper versions of your resource will require much higher resolution images for good quality reproduction. Go for 600 pixels per inch for paper, 144 pixels per inch for high resolution screens, 72 for the more usual displays. If you provide the highest resolution you might need, the site build process can convert to the needed format. The best graphics format depends on the image. 24 bit `png` is a good all round option that allows transparency if it's needed. 8 bit `png` is good for simple diagrams with few colours. `jpeg` files are usually much smaller than 24 bit `png`s for photographs. 

However, many mathematical diagrams are best provided in a vector graphics format such as SVG. This is resolution independent. The free graphics editor [`Inkscape`](http://inkscape.org) will get you started.

Including specials
------------------

`Pandoc` allows us to insert raw HTML codes in the Markdown source to cope with special needs. These must be styled with CSS (cascading style sheets). The site provides a [Twitter Bootstrap](http://twitter.github.io/bootstrap) stylesheet and JavaScript environment -- you'll find some excellent docs and examples under the link. However be sparing, and do ask what the house style is if unsure. Here's a list of the features that may find a place in your resource. 

* [Fluid grid system](http://twitter.github.io/bootstrap/scaffolding.html#fluidGridSystem)
* [Typography](http://twitter.github.io/bootstrap/base-css.html#typography) e.g. for default header styling and 
  - `<div class="lead">`Lead content to an article.`</div>`
* [Wells](http://twitter.github.io/bootstrap/components.html#misc)
  - `<div class="well">`Content in Markdown to be styled in a box that stands out from the rest of the text.`</div>`
* [Collapse](http://twitter.github.io/bootstrap/JavaScript.html#collapse) is very useful for hide/reveal problems. It can be triggered by a button or by a link as in
this [jsFiddle example](http://jsfiddle.net/gmp26/gD3Vz/5/). 
* [Float left or right](http://twitter.github.io/bootstrap/components.html#misc). 
* [Icons](http://twitter.github.io/bootstrap/base-css.html#icons)
* [Labels and Badges](http://twitter.github.io/bootstrap/components.html#labels-badges)
* [Hero Unit](http://twitter.github.io/bootstrap/components.html#typography) A very prominent box.
* [Page header](http://twitter.github.io/bootstrap/components.html#typography)
* [Thumbnails and Images](http://twitter.github.io/bootstrap/components.html#thumbnails)
* [Alerts](http://twitter.github.io/bootstrap/components.html#alerts) Useful for warnings or attention grabbing notes.
* [Media object](http://twitter.github.io/bootstrap/components.html#media) for icon, header, description. 

Making paper copy
-----------------

If you want to make paper copy, you'll need to install LaTeX so you have a chain that ends in a pdf file. Follow the pandoc user guide to get started. Run pandoc from the command line for non-html output formats.

Submitting your resource
------------------------
Email the folder to Vicky. vrn20@cam.ac.uk



