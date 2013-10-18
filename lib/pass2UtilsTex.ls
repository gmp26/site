"use strict"

module.exports = (grunt) ->

  delimiters: 'CMEP'
  #
  # Data to pass to lodash templates in pass2
  #
  data:
    # declare constants to avoid needing quotes
    chalk: 0
    well: 1

    showLodashed: (expression, interpolated=true) -> 
      escape = (str) -> 
        str = str.replace "{" "\\{"
        str = str.replace "}" "\\}"
        return str
      "\\lodashed#{if interpolated then '[=]' else ''}{" + (escape expression) + "}"

    style: (value) -> switch value
      | void  => "::stopFrame::"
      | @chalk => "::startChalk::\n"
      | @well  => "::startWell::\n"

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

    toggle: (id, label) -> "See footnote[^#{id}]"




