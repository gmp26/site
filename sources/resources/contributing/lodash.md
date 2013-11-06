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

The lodash markup can do javascript logic. It's best shown by example. The current clearance is <:= clearance :> and this resource has 
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

_It's important to get the brackets, braces and tags correct._

## Web and Print

Interactive content can be ignored entirely, or somehow handled specially in print. 

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

<:= toggle(1, "A default button") :>

<:= collapsed(1) :>
Some hidden content. Press the default button again to hide.
<:= collapsed() :>


<:= toggle(2, "A primary button", primary) :>

<:= collapsed(2) :>
Some hidden content. Press the primary button again to hide.
<:= collapsed() :>

<:= toggle(3, "An info button", info) :>

<:= collapsed(3) :>
Hidden info. Press the info button again to hide.
<:= collapsed() :>

<:= toggle(4, "A warning button", warning) :>

<:= collapsed(4) :>
A hidden warning. Press the warning button again to hide.
<:= collapsed() :>

<:= toggle(5, "A danger button", danger) :>

<:= collapsed(5) :>
A hidden danger. Press the danger button again to hide.
<:= collapsed() :>

<:= toggle(6, "A success button", success) :>

<:= collapsed(6) :>
A hidden success. Press the success button again to hide.
<:= collapsed() :>

<:= toggle(7, "An inverse button", inverse) :>

<:= collapsed(7) :>
Press the inverse button again to hide.
<:= collapsed() :>

<:= toggle(8, "A link button", link) :>

<:= collapsed(8) :>
Press the link button again to hide.
<:= collapsed() :>


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
uniquely for them to work as intended. An example appears at resource [NA3_RT5_2](http://cmep.maths.org/fenman/resources/NA3_RT5_2/index.html).

<:= hintAnswerBar(1, 'A possible approach', 'which might lead here') :>
<:= hint(1) :>
You could press the answer button now?
<:= hint() :>

<:= answer(1) :>
Which might reveal this.
<:= answer() :>

### Icons

<:= showLodashed('icon(name)') :>

Inserts an icon by quoted name. The names are listed on the [Bootstrap site](http://getbootstrap.com/2.3.2/base-css.html#icons), but drop the leading 'icon-' part.

For example, <:= showLodashed('icon("file")') :> will produce <:= icon("file") :>.

## Lodash hyperlinking commands

You will normally only need to use standard markdown to make hyperlinks and to include images. 

Urls must be either page relative urls or external http urls. For example, use `../G2_RT2/index.html` to reference that resource from another one. Urls must be quoted.

Image references are similar. If you simply want to include an image from the same folder, just give the filename.

### Image Links

<:= showLodashed('imageLink(image, text, url)') :> embeds the `image` file - captioned with the quoted `text`, and hyperlinks it to the `url`. The image must be available to the site's build system if it's to appear in printable pdfs. 

<:= showLodashed('imageLink("swanage.png", "Swanage", "http://en.wikipedia.org/wiki/Swanage")') :>

<:= imageLink("swanage.png", "Swanage", "http://en.wikipedia.org/wiki/Swanage") :>

### iframe embeds

<:= showLodashed('iframe(text, url, width, height, image="thumbnail.png")') :> inserts an iframe in html, or the thumbnail `image` in pdf. `url` is the url of the page to be inserted in the iframe. The iframe box size is specified in pixels by `width` and `height`. In pdf, width and height are ignored, and the thumbnail image is reproduced at its natural size, and the alternate text is reproduced.

<:= showLodashed('iframe("Sunny Swanage", "http://en.wikipedia.org/wiki/Swanage", 500, 300, image="swanage.png")') :> will generate the following iframe.

<:= iframe("See http://en.wikipedia.org/wiki/Swanage", "http://en.wikipedia.org/wiki/Swanage", 500, 300, image="swanage.png") :>

### Button Links

<:= showLodashed('buttonLink(type, text, url, print=false)') :> inserts a button of the given unquoted `type`, labelled with the quoted `text`, which will follow the link to the quoted `url`. `print` may be omitted, in which case the button will be invisible in the pdf. If `print` is set to true, the button displays as a textLink in the pdf.

For example, <:= showLodashed('buttonLink(info, "Swanage again", "https://cmep.maths.org/swanage")') :> yields
<:= buttonLink(info, "Swanage again", "https://cmep.maths.org/swanage") :>.


## Debugging Lodash commands

Save often and check that the HTML view looks reasonable. Certain errors
cause all the lodash markdown on a page to fail, and so they can be difficult to find if you have made many changes. We're working on making the error reporting better.

If you do get into the situation where nothing appears to work the best plan currently is to use HTML comments to comment out large sections of the text. That way you can move the commented section around to narrow the problem down to its source.



