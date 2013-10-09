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
      '<code>&lt;:' + (if interpolated then '= ' else ' ') + expression + ' :&gt;</code>'
      #return "<div class=\"#{if interpolated then 'lodashed-interpolated' else 'lodashed'}\">" + expression + '</div>'

    style: (value) ->
      #grunt.log.error "style called with value #value, chalk == #{this.chalk}"
      switch value
      | void  => "</div>"
      | @chalk => "<div class=\"chalk\">"
      | @well  => "<div class=\"well\">"

    hintAnswer: (hLabel, hint, aLabel, answer) ->"""
<div class='btn-group hint'>
<button type='button' class='btn btn-primary btn-action' data-toggle='collapse' data-target='\##{hint}'>
#{hLabel}
</button>
<button type='button' class='btn btn-action' data-toggle='collapse' data-target='\##{answer}'>
#{aLabel}
</button>
</div>
""".replace '\n',''

    collapsed: (id) -> switch id
      | void => "</div>"
      | otherwise "<div id=\"#{id}\" class=\"collapse\">"

    warn: (msg) ->
      grunt.log.write "\n"
      grunt.log.warn msg
      grunt.log.write "..."

    # create a button which reveals collapsed text, or hides it if already revealed.
    reveal: (id) -> switch id
      | void => "</button>"
      | otherwise "<button type=\"button\" class=\"btn btn-action\" data-toggle=\"collapse\" data-target=\"\##{id}\">"


