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

    style: (value) -> switch value
      | void  => "\\end{mdframed}"
      | @chalk => "\\begin{mdframed}[style=chalk]"
      | @well  => "\\begin{mdframed}[style=well]"

    hintAnswer: (hLabel, hint, aLabel, answer) -> 
      grunt.log.writeln " "
      grunt.log.warn "The hintAnswer group is not implemented in LaTeX yet"
      grunt.log.write "..."
      "\\textcolor{red}{The hintAnswer group is not implemented in LaTeX yet}"

    collapsed: (id) -> switch id
      | void => "\\end{mdframed}"
      | otherwise "\\begin{mdframed}[style=alert,frametitle={#{id}}]"



