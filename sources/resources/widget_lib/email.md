## Grunt commands

`grunt dev:printables` will generate the site pdfs. Start it and go and make some tea.

For normal editing work, use `grunt server` as before. It skips printable generation, but will render a site with links to the printables in place ready for whenever they are generated.

## Maths environments
o To use display math environments such as `eqnarray*`, make sure that the `\begin` and `\end` commands are on a line of their own. They'll then be automatically wrapped in the `$$`s that mathJAX needs in order to see them. I had to make this change because now we are also processing the maths through 'real' LaTeX, and there we do not want the extra `$$`s.

o To use inline math environments such as `array`, make sure that there are non-whitespace characters butting up to the `\begin{}` and `\end{}` before or after, or (before and after). If they have whitespace before and after then `$$` will be inserted into the HTML and things will break.

## Lodash commands

### Styles
<:= style(styleId) :> 
  markdown text
<:= style() :>

where styleId is `chalk` or `well` without any quotation marks.

### Two column sections
<:= column(left) :>
  left column content in markdown
<:= column() :>

<:= column(right) :>
  right column content in markdown
<:= column() :>

### Hint/Answer button bars

<:= hintAnswerBar(N, hLabel, aLabel) :>

N is a positive unique integer for the page, unquoted. Note that it must be unique across all page parts, index, solution, hints, notes etc. It identifies the collapsed areas revealed by pressing the buttons in the bar.

hLabel is the label for the hint button. Must be in single or double quotes.
aLabel is the label for the answer button. Similarly quoted.

<:= hint(N) :>
  collapsed hint text in markdown
<:= hint() :>

<:= answer(N) :>
  collapsed answer text in markdown
<:= answer() :>

### Single toggle buttons and their collapsed targets

<:= toggle(N, label, type) :>

N is a positive unique integer identifying a collapsed section.
`label` is a quoted label for the button.
`type` is an unquoted button type which affects the button style. The defined types are

  default
  primary
  info
  warning
  danger
  success
  inverse
  link

See http://getbootstrap.com/2.3.2/base-css.html#buttons for the resulting button types

<:= collapsed(N) :>
  A collapsed markdown section to be revealed by pressing the toggle(N) button
<:= collapsed() :>

### Icons

<:= icon( name ) :>

Inserts an icon by quoted name. The names are listed here, but drop the leading 'icon-' part:
http://getbootstrap.com/2.3.2/base-css.html#icons

## Lodash hyperlinking commands

Warning: All urls must be either site local absolute ursl, or external http urls. So use `/resources/G2_RT2/index.html` rather than a relatively addressed url such as `../G2_RT2/index.html`. urls must be quoted.

Warning: Where needed, references to embedded images should be relative urls - normally its simply the filename of an image located in the same directory as the markdown source. Image filenames must be quoted.

### Text Links

<:= textLink(text, url) :> is now the usual way to insert hyperlinked text. Unlike the native markdown command,  it makes the url visible in the pdf document as well a making the link. 

[text](url)
If you don't need the url to be in the pdf, the native markdown command suffices and the url need not be absolute.

### Image Links

<:= imageLink(image, text, url) :> embeds the `image` file - captioned with the quoted `text`, and hyperlinks it to the `url`.

### Button Links

<:= buttonLink(type, text, url, print=false) inserts a button of the given unquoted `type`, labelled with the quoted `text`, which will follow the link to the quoted `url`. `print` may be omitted, in which case the button will be invisible in the pdf. If `print` is set to true, the button displays as a textLink in the pdf.

### iframe embeds

<:= iframe(text, url, width, height, image="thumbnail.png") :> inserts an iframe in html, or the thumbnail image in pdf. The url is the url of the page to be inserted in the iframe. The iframe box has width and height specified in pixels by `width` and `height`. In pdf, width and height are ignored, and the thumbnail image is reproduced at its natural size.

## Debugging lodash

Keep an eye on the console log. Helpful error messages appear there if there's a problem.

<:= warn("message") :> will print the message on the console during panda:pass2html and panda:pass2printables tasks which run as part of `grunt server` or `grunt dev:printables`. This can be useful when trying to locate a markup problem.

