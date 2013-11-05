````
alias: Lodash Guide
weight: 5
clearance: -1
title: Lodash Markup Documentation
author: Douglas Adams
acknowledgementText: So long and thanks for all the fish.

````

<: grunt.log.writeln('Testing lodash widget library') :>

# Lodash Markup

Markdown isn't quite rich enough to do all that we want. We occasionally need extra markup to insert new styles, interactive elements, or to echo some metadata within the page.

The main thing to know is that we use special tags: <:= showLodashed('') :> or
even <:= showLodashed('', false) :> to construct this extra markup. This markup is
implemented using the [lodash template library](http://lodash.com/docs#template).

The tags with the equals sign, namely <:= showLodashed('') :> _interpolate_ 
the code inside; it runs the javascript code inside and the result appears in place of the whole 
tag. This is useful for metadata, styles and other things that need to provide
some output. We provide a set of javascript variables and functions that can be included to do useful things, and these can be extended as necessary.

The tags without the equals sign, namely <:= showLodashed('', false) :> 
_evaluate_ the code inside, and won't automatically make output. This is ideal
for _logical statements_ which control what gets displayed. Examples are below
to explain this difference.

## Local Page Metadata

The following fields are available, and their expansion for this document is
shown too. _Note that for these expansions to appear you have to define them
in the document's YAML header._

<: grunt.log.write("  top-level metadata...") :>
- <:= showLodashed('title') :> evaluates to: '<:= title :>'.
- <:= showLodashed('author') :> evaluates to: '<:= author :>'
- <:= showLodashed('pageClearance') :> evaluates to: '<:= pageClearance :>'
- <:= showLodashed('clearance') :> evaluates to: '<:= clearance :>'
- <:= showLodashed('lastUpdated') :> evaluates to: the date the document was last changed in git
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

## Two column sections

These divide a section of a page into 2 near equal columns. Use the `twoColumn` style to wrap a `column(left)` and a `column(right)`. Note that the left or right column may be empty, and that text does not flow from the left column to the right column.

<:= showLodashed('style(twoColumn)') :>

<:= showLodashed('column(left)') :>
 Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque vitae elit vel nulla porta porttitor. Nulla eget magna vitae diam rhoncus laoreet. Vivamus quis leo ullamcorper, mattis turpis at, bibendum risus. Pellentesque fermentum eleifend sapien ac dignissim. Aenean sed nisi eu felis placerat commodo id at est. Quisque ut blandit erat. In ullamcorper lacus sit amet ligula feugiat elementum.

<:= showLodashed('column()') :>

<:= showLodashed('column(right)') :>
  Interdum et malesuada fames ac ante ipsum primis in faucibus. Nulla porta, lectus nec gravida fringilla, tellus dolor feugiat risus, vitae ullamcorper lorem tortor facilisis mi. Nunc imperdiet non sem ut pellentesque. Suspendisse condimentum leo at enim congue luctus. Mauris sem tortor, pharetra in libero id, pretium euismod elit. Proin dignissim lorem vitae bibendum pretium.
<:= showLodashed('column()') :>

<:= showLodashed('style()') :>

<:= style(twoColumn) :>
<:= column(left) :>
  Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque vitae elit vel nulla porta porttitor. Nulla eget magna vitae diam rhoncus laoreet. Vivamus quis leo ullamcorper, mattis turpis at, bibendum risus. Pellentesque fermentum eleifend sapien ac dignissim. Aenean sed nisi eu felis placerat commodo id at est. Quisque ut blandit erat. In ullamcorper lacus sit amet ligula feugiat elementum.
<:= column() :>

<:= column(right) :>
  Interdum et malesuada fames ac ante ipsum primis in faucibus. Nulla porta, lectus nec gravida fringilla, tellus dolor feugiat risus, vitae ullamcorper lorem tortor facilisis mi. Nunc imperdiet non sem ut pellentesque. Suspendisse condimentum leo at enim congue luctus. Mauris sem tortor, pharetra in libero id, pretium euismod elit. Proin dignissim lorem vitae bibendum pretium.
<:= column() :>
<:= style() :>




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

Interactive can content be ignored entirely, or somehow handled specially in print. 

### Toggle buttons and collapsed blocks

These are linked to the collapsed content with which they share an id number.

<:= showLodashed("collapsed(N)") :> starts a collapsed block identified by N.

<:= showLodashed("collapsed()") :> ends a collapsed block.

<:= showLodashed("toggle(N, \"label\", type)") :>

- N is the id number referencing the content to be revealed or hidden.
- "label" is the button label - it must be quoted.
- type is a bootstrap button type which changes the button colour - it need not be quoted. The types are:
  - no type parameter present - grey
  - primary - blue
  - info - cyan
  - warning - orange
  - danger - red
  - success - green
  - inverse - white text on black
  - link - appear as a hyperlink


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
