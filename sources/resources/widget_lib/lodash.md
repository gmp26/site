````
alias: Lodash Guide
weight: 5
clearance: -1
title: Lodash Markup Documentation
author: Ewan Davies
lastUpdated: NOT YET IMPLEMENTED
acknowledgementText: So long and thanks for all the fish.

````

<: grunt.log.writeln("Testing lodash widget library") :>

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
- <:= showLodashed('title') :> evaluates to: '<:= title :>'.
- <:= showLodashed('author') :> evaluates to: '<:= author :>'
- <:= showLodashed('pageClearance') :> evaluates to: '<:= pageClearance :>'
- <:= showLodashed('clearance') :> evaluates to: '<:= clearance :>'
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
current clearance is <:= clearance :> and this resource has 
clearance <:= pageClearance :>. We can include content based on the
global clearance with the following syntax:

<:= showLodashed('if (clearance == -1) {', false) :>

This text will only be seen when the content is processed with clearance -1.

<:= showLodashed('} else {', false) :>

This text will be seen otherwise.

<:= showLodashed('}', false) :>

which provides the following output:

<: if (clearance == -1) { :>

This text will only be seen when the content is processed with clearance -1.

<: } else { :>

This text will be seen otherwise.

<: } :>

_It's important to get the brackets, braces and tags correct, as they are
here._

## Web and Print

Interactive has to be ignored entirely, or handled specially in print. 

### Hint-Answer Bar

The code <:= showLodashed("hintAnswerBar(N, 'hLabel', aLabel')") :> where N is a positive integer, makes a pair of buttons labelled with hLabel and aLabel. Clicking them reveals
sections with id 'hintN' and 'answerN' which must be defined elsewhere. If you have more than one hintAnswerBar on a page, make sure to choose a different N for each one.

In print, the hint-answer bar makes a subsection labelled with the `hLabel`, containing the hint. The answer is given in a footnote. Because of this, the answer text must be a single paragraph, though it may contain hard line breaks.

The hint-answer bar connects to its content by the number N. This must therefore be unique on the page. The content may appear anywhere on the page.

To define the content use:

<:= showLodashed("hint(N)") :>

This is text displayed when the hint button in hintAnswerBar N is clicked

<:= showLodashed('hint()') :>

<:= showLodashed("answer(N)") :>

This is text displayed when the answer button in hintAnswerBar N is clicked. The answer must currently be written as one paragraph - i.e. with no empty lines. If you wish to break it up, you can use the pandoc technique to force a hard line break by ending a line with two spaces.

<:= showLodashed('answer()') :>

Multiple hint-answer groups can appear on the page, but the ids must be chosen
uniquely for them to work as intended. An example appears at resource [NA3_RT5_2](http://cmep.maths.org/fenman/reources/NA3_RT5_2/index.html).