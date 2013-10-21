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

      showLodashed: (expression, interpolated=true) -> 
        escape = (str) -> 
          str = str.replace "{" "\\{"
          str = str.replace "}" "\\}"
          return str
        "\\lodashed#{if interpolated then '[=]' else ''}{" + (escape expression) + "}"

      style: (value) -> switch value
        case void  => @endStack.pop!
        case @chalk => 
          @endStack[*] = "\n\n::stopFrame::\n"
          "\n::startChalk::\n\n"
        case @well  => 
          @endStack[*] = "::stopFrame::"
          "\n\n::startWell::\n"
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

      collapsed: (id) ->
        | id? && @toggled[id] => "\\begin{small}"
        | otherwise => "\\end{small}"

      # insert an icon
      icon: (iconClass) ->
        "\\icon#{iconClass.replace '-', ''}"

      # create a thumbnail linking to an external site
      linkedImage: (image, url, title) ->
        "[![#{title}](#{image})](#{url})"
  

      linkedButton: (label, url, type = "", print=false) ->
        if print
          "\\href{#{url}}{#{label}}"
        else
          ""

      # embed an iframe
      iframe: (src, alternateText, width, height) ->
        "[#{alternateText}](#{src})"

      warn: (msg) ->
        grunt.log.write "\n"
        grunt.log.warn msg
        grunt.log.write "..."

  _.extend options.data, require('./pass2Constants.js')
  return options





