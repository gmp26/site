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

    # button types
    primary: "primary"
    info: "info"
    warning: "warning"
    danger: "danger"
    success: "success"
    inverse: "inverse"
    link: "link"

    showLodashed: (expression, interpolated=true) -> 
      '<code>&lt;:' + (if interpolated then '= ' else ' ') + expression + ' :&gt;</code>'
      #return "<div class=\"#{if interpolated then 'lodashed-interpolated' else 'lodashed'}\">" + expression + '</div>'

    style: (value) ->
      debugger
      switch value
      | void  => "</div>"
      | @chalk => "<div class=\"chalk\">"
      | @well  => "<div class=\"well\">"

    hintAnswerBar: (id, hLabel, aLabel) ->"""
<div class='btn-group hint'>
<button type='button' class='btn btn-primary btn-action' data-toggle='collapse' data-target='\#hint#{id}'>
#{hLabel}
</button>
<button type='button' class='btn btn-action' data-toggle='collapse' data-target='\#answer#{id}'>
#{aLabel}
</button>
</div>
""".replace '\n',''

    hint: (id) ->
      | id? => "<div id=\"hint#{id}\" class=\"collapse\"><div class=\"chalk\">"
      | _   => "</div></div>"

    answer: (id) ->
      | id? => "<div id=\"answer#{id}\" class=\"collapse\">"
      | _   => "</div>"

    collapsed: (id) ->
      debugger
      switch
      | id? => "<div id=\"collapsed#{id}\" class=\"collapse\">"
      | _   => "</div>"

    warn: (msg) ->
      grunt.log.write "\n"
      grunt.log.warn msg
      grunt.log.write "..."

    # create a button which reveals collapsed text, or hides it if already revealed.
    toggle: (id, label, type) ->
      debugger
      disabled = 'disabled="disabled"'

      if !id? || isNaN id
        grunt.log.error "toggle button has a bad id"
        label = "bad id"
        type = "warning"

      else if !label?
        grunt.log.error "toggle button has no label"
        label = "label me!"
        type = "warning"
      
      disabled = ""

      if grunt.util._.isString(type) and type != ""
        type = "btn-#{type}"
      else
        type = ""

      "<button type=\"button\" class=\"btn #{type} btn-action\" data-toggle=\"collapse\" data-target=\"\#collapsed#{id}\" #{disabled}>#{label}</button>"


