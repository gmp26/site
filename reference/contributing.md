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

### Maths environments

Write maths environments as you would in standard LaTeX - i.e. don't wrap them in dollar signs. You do need to pay a bit of attention to white space for this to work correctly.

o To use display math environments such as `eqnarray*`, make sure that the `\begin` and `\end` commands are on a line of their own. They'll then be automatically wrapped in the `$$`s that mathJAX needs in order to see and process them. 

o To use inline math environments such as `array`, make sure that there are non-whitespace characters butting up to the `\begin{}` and `\end{}` before or after, or (before and after). If they have whitespace before and after then `$$` will be inserted into the HTML and things will break.


Writing everything else
-----------------------

Your guide is the [Pandoc User Guide](http://johnmacfarlane.net/pandoc/README.html#pandocs-Markdown).

Creating metadata
-----------------

At the top of the index.md file in your resource folder there is space for some metadata. It begins with 4 backticks at the start of the first line, and ends with 4 more backticks. Between the two sets of backticks you can add data about the resource. The following template may be handy:

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

The markup language for metadata is YAML. Look it up if you must, but it's simple enough to pick up by looking at a few examples.

Making hyperlinks
-----------------

Use the Markdown syntax -- square brackets wrapping the linked text, and parentheses wrapping the URL. When referring to other resources on CMEP, use relative URLs. To refer to other files in your resource folder, simply use the filename. The site home is at `../..`. The G2 station will be at `../../stations/G2.html, and so on. Non local resources should be given their full URL.

Including images
----------------

Similar rules apply when providing the URL for an image file, but you will want to make sure the image is optimised for the web and available locally. Remember also, that paper versions of your resource will require much higher resolution images for good quality reproduction. Go for 600 pixels per inch for paper, 144 pixels per inch for high resolution screens, 72 for the more usual displays. If you provide the highest resolution you might need, the site build process can convert to the needed format. The best graphics format depends on the image. 24 bit `png` is a good all round option that allows transparency if it's needed. 8 bit `png` is good for simple diagrams with few colours. `jpeg` files are usually much smaller than 24 bit `png`s for photographs. 

However, many mathematical diagrams are best provided in a vector graphics format such as SVG. This is resolution independent. The free graphics editor [`Inkscape`](http://inkscape.org) will get you started.


# Extensions to markdown

Pandoc can process raw TeX into LaTeX when making a TeX document, and it can process raw HTML into html when making an HTML document. It can't process HTML into TeX or TeX into HTML. We are generating both HTML and TeX, so please don't include HTML or TeX in the markdown.

Instead the extensions we need to capture special styles, or to embed animations, are written using `lodash templates`.

These are special bracketed commands that wrap javascript. They open with either `<:=` or `<:` and close with `:>`. 

The `:= xxx :>` form of the command inserts something in the document.

The `: xxx :>` form of the command can be used to control whether something should appear or not.
e.g. 
```
<: if(false) { :>
This text will not appear in the document
<: } else { :>
This text does appear in the document
<: } :>

## Styles
<:= style(styleId) :> 
  markdown text
<:= style() :>
```
where styleId is `chalk` or `well` without any quotation marks.

## Two column sections

Use these sections in order - left then right. They should both be present, but they do not both have to contain content. The page will be roughly split down the middle in two columns.

```
<:= column(left) :>
  left column content in markdown
<:= column() :>

<:= column(right) :>
  right column content in markdown
<:= column() :>
```
### Hint/Answer button bars

This provides a 2 button bar. The left button reveals a hit, the right button reveals a possible answer, but you can label them as you wish. The hint and answer are identified by a number which must be unique to the resource. (To the whole resource, not just the resource part.)

```
<:= hintAnswerBar(N, hLabel, aLabel) :>
```

`N` is a positive unique integer for the page, unquoted. Note that it must be unique across all page parts, index, solution, hints, notes etc. It identifies the collapsed areas revealed by pressing the buttons in the bar.

`hLabel` is the label for the hint button. Must be in single or double quotes.
`aLabel` is the label for the answer button. Similarly quoted.

```
<:= hint(N) :>
  collapsed hint text in markdown
<:= hint() :>

<:= answer(N) :>
  collapsed answer text in markdown
<:= answer() :>
```

### Single toggle buttons and their collapsed targets

```
<:= toggle(N, label, type) :>
```

`N` is a positive unique integer identifying a collapsed section.
`label` is a quoted label for the button.
`type` is an unquoted button type which affects the button style. The defined types are

```
  default
  primary
  info
  warning
  danger
  success
  inverse
  link
```
See http://getbootstrap.com/2.3.2/base-css.html#buttons for the resulting button types

```
<:= collapsed(N) :>
  A collapsed markdown section to be revealed by pressing the toggle(N) button
<:= collapsed() :>
```

### Icons

```
<:= icon( name ) :>
```

Inserts an icon by quoted name. The names are listed here, but drop the leading 'icon-' part:
http://getbootstrap.com/2.3.2/base-css.html#icons

## Lodash hyperlinking commands

All urls should be either relative urls, or external http urls. 

Where needed, references to embedded images should be relative urls - normally it's simply the filename of an image located in the same directory as the markdown source. Image filenames must be quoted.

### Text Links

`<:= textLink(text, url) :>` is now the usual way to insert hyperlinked text. Unlike the native markdown command,  it makes the url visible in the pdf document as well a making the link for those people reading pdf printouts.

`[text](url)`
If you don't need the url to be in the pdf, the native markdown command suffices.

### Image Links

`<:= imageLink(image, text, url) :>` embeds the `image` file - captioned with the quoted `text`, and hyperlinks it to the `url`.

### Button Links

`<:= buttonLink(type, text, url, print=false) :>` inserts a button of the given unquoted `type`, labelled with the quoted `text`, which will follow the link to the quoted `url`. `print` may be omitted, in which case the button will be invisible in the pdf. If `print` is set to true, the button displays as a textLink in the pdf.

### iframe embeds

`<:= iframe(text, url, width, height, image="thumbnail.png") :>` inserts an iframe in html, or the thumbnail image in pdf. The url is the url of the page to be inserted in the iframe. The iframe box has width and height specified in pixels by `width` and `height`. In pdf, width and height are ignored, and the thumbnail image is reproduced at its natural size.

## Debugging lodash

Keep an eye on the console log. Helpful error messages appear there if there's a problem.

`<:= warn("message") :>` will print the message on the console during panda:pass2html and panda:pass2printables tasks which run as part of `grunt server` or `grunt dev:printables`. This can be useful when trying to locate a markup problem.


###Linking to another resource

The golden rule is to use a relative link. From resource to resource G2_RT4 goes like this:
```
[Link Text](../G2_RT4/index.html)
```

From resource to station G2 would be:
```
[Link Text](../../stations/G2.html)
```


Making paper copy
-----------------

If you want to make paper copy, you'll need to install LaTeX so you have a chain that ends in a pdf file. Follow the pandoc user guide to get started. Run pandoc from the command line for non-html output formats.

Submitting your resource
------------------------
Email the folder to Vicky. vrn20@cam.ac.uk



