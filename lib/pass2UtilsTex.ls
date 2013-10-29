"use strict"

module.exports = (grunt) ->

  _ = grunt.util._

  # Generate pass2 options configuring Tex translation of lodash templates

  options = 

    delimiters: 'CMEP'
    #
    # Data to pass to lodash templates in pass2
    #
    data:
      #siteUrl: grunt.config.get "siteUrl"

      showLodashed: (expression, interpolated=true) -> 
        escape = (str) -> 
          str = str.replace "{" "\\{"
          str = str.replace "}" "\\}"
          return str
        "\\lodashed#{if interpolated then '[=]' else ''}{" + (escape expression) + "}"

      style: (value) -> switch value
        case void  => @endStack.pop!
        case @chalk => 
          @endStack[*] = "::stopFrame::"
          "::startChalk::"
        case @well  => 
          @endStack[*] = "::stopFrame::"
          "::startWell::"
        case @twoColumn =>
          @endStack[*] = "::stopTwoColumn::"
          "\n\n::startTwoColumn::\n"

      column: (value) ->
        switch value
        | @left => ""
        | @right => "\\columnbreak\n"
        | void => ""

      hintAnswerBar: (id, hLabel, aLabel) -> ''

      hint: (id) ->
        | id? => '###'+"Hint [^#{id}]\n" 
        | _   => ""

      answer: (id) ->
        | id? => "[^#{id}]: "
        | _   => ""

      toggled: []

      # (provisionally) represent a toggle button as a footnote anchor
      # but only if collapsed text exists. We mustn't generate a footnote if
      # there is no collapsed text as pandoc will then echo the source rather
      # than interpret it.
      toggle: (id, label="label me", type="") ->
        if id?
          @toggled[id] = "See footnote[^#{id}]\n\n"
        ""

      # can't use environments here because we want markdown interpretation in printables
      collapsed: (id) -> ""

      # insert an icon
      icon: (iconClass) ->
        "\\icon#{iconClass.replace '-', ''}"

      absolute: (url) ->
        | (url.match /^http/) != null => url
        | ([m, p1, p2] = url.match /(\.?\/)?(.*)/) != null =>
          "#{@resourceUrl}#{p2}"

      # insert an ordinary link
      textLink: (text, url) ->
        "[#{text} \\url#{@absolute url}](#{@absolute url})"

      # insert an image link
      imageLink: (image, text, url) ->
        "[![#{text} #{@absolute url}](#{image})](#{@absolute url})"

      # insert a button link - but only if `print` is true
      buttonLink: (type, text, url, print = false) ->
        if print then @textLink(text, url) else ""

      # if pdf label and link to local url  
      iframe: (text, url, width, height, image="thumbnail.png") ->
        @imageLink image, text, url

      warn: (msg) ->
        grunt.log.write "\n"
        grunt.log.warn msg
        grunt.log.write "..."

  _.extend options.data, require('./pass2Constants.js')
  return options





