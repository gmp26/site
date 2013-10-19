"use strict"

module.exports = (grunt) ->


  return {
    delimiters: 'CMEP'
    #
    # Data to pass to lodash templates in pass2
    #
    data:
      # declare constants to avoid needing quotes
      chalk: 0
      well: 1
      left: 2
      right: 3
      twoColumn: 4

      # button types
      primary: "primary"
      info: "info"
      warning: "warning"
      danger: "danger"
      success: "success"
      inverse: "inverse"
      link: "link"

      endStack: []

      showLodashed: (expression, interpolated=true) -> 
        escape = (str) -> 
          str = str.replace "{" "\\{"
          str = str.replace "}" "\\}"
          return str
        "\\lodashed#{if interpolated then '[=]' else ''}{" + (escape expression) + "}"

      style: (value) -> switch value
        case void  => @endStack.pop! #"::stopFrame::"
        case @chalk => 
          @endStack[*] = "::stopFrame::"
          "::startChalk::\n"
        case @well  => 
          @endStack[*] = "::stopFrame::"
          "::startWell::\n"
        case @twoColumn =>
          @endStack[*] = "::stopTwoColumn::"
          "::startTwoColumn::\n"

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

      collapsed: (id) ->
        | id? => "[^#{id}]:"
        | _   => ""

      warn: (msg) ->
        grunt.log.write "\n"
        grunt.log.warn msg
        grunt.log.write "..."

      # (provisionally) represent a toggle button as a footnote anchor
      toggle: (id, label) -> "See footnote[^#{id}]"

      # insert an icon
      icon: (iconClass) ->
        "\\icon#{iconClass.replace '-', ''}"

      # create a thumbnail linking to an external site
      linkedImage: (image, url, title) ->
        "[![#{title}](#{image})](#{url})"
  }




