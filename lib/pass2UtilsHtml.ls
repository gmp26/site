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
      | void  => "</div>"
      | @chalk => "<div class=\"chalk\">"
      | @well  => "<div class=\"well\">"

    hintAnswer: (hLabel, hint, aLabel, answer) ->"""
<div class='btn-group hint'>
<button type='button' class='btn btn-primary btn-action' data-toggle='collapse' data-target='#{hint}'>
#{hLabel}
</button>
<button type='button' class='btn btn-action' data-toggle='collapse' data-target='#{answer}'>
#{aLabel}
</button>
</div>
""".replace '\n',''

    collapsed: (id) -> switch id
      | void => "</div>"
      | otherwise "<div id=\"#{id}\" class=\"collapse\">"


    

