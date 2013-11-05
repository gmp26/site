````
alias: Markdown Guide
weight: 1
clearance: -1
title: Markdown Guide

````
# Intro to Markdown

Content for CMEP is written in _markdown_. This is a way of providing
formatting information to the layout engines without too much visual 'noise'.
Below are examples of the markdown we encourage, with some advice about how to
use it.

This file is written in exemplary CMEP markdown style so look at its source for
guidance if you like.

## The metadata

The first thing in your file is the metadata. This is explained in the [introduction](index.html).

## Starting the resource

On the website the top of the page gets a header, and below that go some words indicating the type of your resource (provided you put the metadata down, that is), and (if necessary) a tab bar to allow navigating the pages in the resource.

## Headings

For longer resources (such as this one) you might want to structure things with headings. In markdown use hashes (`#`) to make headings of various levels:

    # A Top-level Heading
    ## A Level 2 Heading
    ### A Level 3 Heading

which appear as:

# A Top-level Heading
## A Level 2 Heading
### A Level 3 Heading

_Please refrain from using too many levels, the latex output will not be as
intended if you use level 4 or below_

## Links

Use the Markdown syntax -- square brackets wrapping the linked text, and parentheses wrapping the URL: `[link text](link URL)`. When referring to other resources on CMEP, use relative URLs. To refer to other files in your resource folder, simply use the filename. The site home is at `../..`. The G2 station will be at `../../stations/G2.html, and so on. Non-local resources should be given their full URL. So from your resource to resource G2_RT4 goes like this:
```
[Link Text](../G2_RT4/index.html)
```

From resource to station G2 would be:
```
[Link Text](../../stations/G2.html)
```

## Including images

Similar rules apply when providing the URL for an image file, but you will want to make sure the image is optimised for the web and available locally. Remember also, that paper versions of your resource will require much higher resolution images for good quality reproduction. 

For this reason, vector graphics are preferred for web and paper. They 'look right' with very little extra effort. The problem is that you'll need (for now at least) to supply pdf and svg versions of your file. Soon we hope to have a converter and then everyone can just supply lovely svg images. The free graphics editor [Inkscape](http://inkscape.org) might be useful for this, or even just a text editor.

If you must go for bitmap, note that we would like images at 600 pixels per inch for paper, 144 pixels per inch for high resolution screens, 72 for the more usual displays. If you provide the highest resolution you might need, the site build process can convert to the needed format. The best graphics format depends on the image. 24 bit `png` is a good all round option that allows transparency if it's needed. 8 bit `png` is good for simple diagrams with few colours. `jpeg` files are usually much smaller than 24 bit `png`s for photographs.

## Paragraph styling

Markdown is quite limited and beyond inline _emphasis_ (`_emphasis_`) you can't style the text. That is why we have our own syntax for special things, using `lodash` templates. It's explained in the [Lodash Guide](index.html#tab2).

You might be tempted to use HTML snippets which seem to work fine. That is until our latex processor gets hold of the page... If you would like a style that isn't in the lodash library please ask and we'll try to accomodate something.

TODO: write about links, tables, lists, etc. etc.

## Mathematics

To write mathematics use LaTeX notation. Actually, that part of LaTeX which is supported by both pandoc and the [MathJax](http://www.mathjax.org) service -- which is more than enough to support school mathematics. Assume the AMSLaTeX package is installed, but little else.

Delimit inline mathematics with single dollar signs as in `$y=x^2$`, which will display as $y=x^2$. Delimit display mathematics with double dollars as in `$$y=\frac{1}{x^2}$$`, which will display on a separate centred line as $$y=\frac{1}{x^2}.$$

Note that `$` and `$$` are the only mathematics delimiters that are recognised by code running in the browser. Anything in between is assumed to be valid TeX or LaTeX in a mathematics context. 

In true LaTeX there are some LaTeX environments that also bracket the mathematics context - things like `\begin{eqnarray*}` and `\end{eqnarray*}`. When writing for CMEP, you should use these without wrapping them in `$$` because we wrap them up for you so MathJax sees them. We only do this if there's a whitespace character (a space, tab, carriage return, or line feed character) either side of the `\begin{xxx}` and the `\end{xxx}`. This will normally be the case for display maths environments. You can prevent the automatic `$$` wrapping of environments that are used __while already in maths mode__ - like `array` - by not leaving any space around them.

Note that the pandoc preview may not centre display mathematics correctly unless you tweak the associated CSS. But you can probably imagine how it will look.
