````
layout: resource
clearance: -1
title: Lodash Markup Documentation
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

<: grunt.log.writeln("Testing lodash widget library") :>

#Introduction

Content for CEMP is written in _markdown_. This is a way of providing
formatting information to the layout engines without too much visual 'noise'.
Below are examples of the markdown we encourage, with some advice about how to
use it.

This file is written in exemplary CMEP markdown style so look at its source for
guidance if you like.

# Metadata

At the top of each source file is a metadata block. When I have time I'll write
more about this.

# Common Markdown Constructs

## Headings
In markdown use hashes (`#`) to make headings of various levels:

    # A Top-level Heading
    ## A Level 2 Heading
    ### A Level 3 Heading

which appear as:

# A Top-level Heading
## A Level 2 Heading
### A Level 3 Heading

_Please refrain from using too many levels, the latex output will not be as
intended if you use level 4 or below_

TODO: write about paragraphs, links, tables, lists, etc. etc.

# Lodash Extensions

Markdown is somewhat limited, and we have a special way of doing extra things:

- Adding metadata from the file in the displayed text
- Applying extra formatting to paragraphs, images etc.

The main thing to know is that we use special tags: <:= showLodashed('') :> or
even <:= showLodashed('', false) :> to access these features.

The tags with the equals sign, namely <:= showLodashed('') :> _interpolate_ 
the code inside; it runs the code and the result appears in place of the whole 
tag. This is useful for metadata, styles and other things that need to provide
some output.

The tags without the equals sign, namely <:= showLodashed('', false) :> 
_evaluate_ the code inside, and won't automatically make output. This is ideal
for _logical statements_ which control what gets displayed. Examples are below
to explain this (somewhat subtle) difference.

## Metadata

The following fields are available, and their expansion for this document is
shown too. _Note that for these expansions to appear you have to define them
in the metadata block._

<: grunt.log.write("  top-level metadata...") :>
- <:= showLodashed('title') :> evaluates to: '<:= title :>'
- <:= showLodashed('author') :> evaluates to: '<:= author :>'
- <:= showLodashed('thisClearanceLevel') :> evaluates to: '<:= thisClearanceLevel :>'
- <:= showLodashed('globalClearanceLevel') :> evaluates to: '<:= globalClearanceLevel :>'
- <:= showLodashed('lastUpdated') :> evaluates to: '<:= lastUpdated :>'
- <:= showLodashed('acknowledgementText') :> evaluates to: '<:= acknowledgementText :>'
<: grunt.log.ok() :>

## Paragraph styles

A style is activated with <:= showLodashed('style(name)') :> and deactivated 
with <:= showLodashed('style()') :>. _Note that nested styles are not allowed and
will break. You must deactivate your last style before activating another._

Below are examples of the syntax, and the output of our paragraph styles.

<:= showLodashed('style(chalk)') :>

This text looks like it's been written in chalk.

<:= showLodashed('style()') :>

<: grunt.log.write("  style(chalk)...") :>
<:= style(chalk) :>

This text looks like it's been written in chalk.

<:= style() :>
<: grunt.log.ok() :>

<:= showLodashed('style(well)') :>

This text looks like it's been written in a well.

<:= showLodashed('style()') :>

<: grunt.log.write("  style(well)...") :>
<:= style(well) :>

This text looks like it's been written in a well.

<:= style() :>
<: grunt.log.ok() :>

## Logical things

Our special tags can do javascript logic. It's best shown by example. The
current clearance is <:= globalClearanceLevel :> and this resource has 
clearance <:= thisClearanceLevel :>. We can include content based on the
global clearance with the following syntax:

<:= showLodashed('if (globalClearanceLevel == -1) {', false) :>

This text will only be seen when the content is processed with clearance -1.

<:= showLodashed('} else {', false) :>

This text will be seen otherwise.

<:= showLodashed('}', false) :>

which provides the following output:

<: if (globalClearanceLevel == -1) { :>

This text will only be seen when the content is processed with clearance -1.

<: } else { :>

This text will be seen otherwise.

<: } :>

_It's important to get the brackets, braces and tags correct, as they are
here._

## Web-only features

Content on a website can be interactive. The following environments give no
output at all when the content is processed by the latex engine for printing
on paper.

### Hint-Answer Group

The code <:= showLodashed("hintAnswer('hLabel', 'hId', 'aLabel', 'aId')") :> 
makes a pair of buttons labelled with hLabel and aLabel. Clicking them reveals
sections with id 'hId' and 'aId' which must be defined elsewhere. To define the
content use, choose some unique ids, e.g. 'hint1' and 'answer1' and put:

<:= showLodashed("collapsed('hint1')") :>

This is text displayed when the hint button is clicked

<:= showLodashed('collapsed()') :>

<:= showLodashed("collapsed('answer1')") :>

This is text displayed when the answer button is clicked

<:= showLodashed('collapsed()') :>

Multiple hint-answer groups can appear on the page, but the ids must be chosen
uniquely for them to work as intended. An example appears below in html output:

<: grunt.log.write("  hintAnswer(hLabel, hint, aLabel, answer)...") :>
<:= hintAnswer('Hint 1', 'hint1', 'A possible response', 'answer1') :>

<:= collapsed("hint1") :>

This is text for the hint 1 reveal.

<:= collapsed() :>

<:= collapsed("answer1") :>

And it's corresponding answer 1.

<:= collapsed() :>

<: grunt.log.ok() :>