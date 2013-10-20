"use strict"

module.exports = (grunt) ->

  _ = grunt.util._

  # Generate pass2 options suitable for Html/Bootstrap translation of lodash templates

  options = 
    delimiters: 'CMEP'
    #
    # Data to pass to lodash templates in pass2
    #
    data:

      showLodashed: (expression, interpolated=true) -> 
        '<code>&lt;:' + (if interpolated then '= ' else ' ') + expression + ' :&gt;</code>'
        #return "<div class=\"#{if interpolated then 'lodashed-interpolated' else 'lodashed'}\">" + expression + '</div>'

      style: (value) ->
        switch value
        | void  => "</div>"
        | @chalk => "<div class=\"chalk\">"
        | @well  => "<div class=\"well\">"
        | @pullLeft => "<div class=\"pull-left span5\">"
        | @pullRight => "<div class=\"pull-right span6\">"
        | @twoColumn => "<div class=\"row-fluid\">"

      column: (value) ->
        switch value
        | @left => "<div class=\"pull-left span5\">"
        | @right => "<div class=\"pull-right span6\">"
        | void => "</div>"

      hintAnswerBar: (id, hLabel, aLabel) ->
        "<div class='btn-group hint'>\n" +
        "<button type='button' class='btn btn-primary btn-action' data-toggle='collapse' data-target='\#hint#{id}'>\n" +
        "  #{hLabel}\n" +
        "</button>\n" +
        "<button type='button' class='btn btn-action' data-toggle='collapse' data-target='\#answer#{id}'>\n" +
        "  #{aLabel}\n" +
        "</button>\n" +
        "</div>"


      hint: (id) ->
        | id? => "<div id=\"hint#{id}\" class=\"collapse\" style=\"padding:5px 0px\"><div class=\"chalk\"><div class=\"padded\">"
        | _   => "</div></div></div>"

      answer: (id) ->
        | id? => "<div id=\"answer#{id}\" class=\"collapse\"><div class=\"padded\">"
        | _   => "</div></div>"

      collapsed: (id) ->
        switch
        | id? => "<div id=\"collapsed#{id}\" class=\"collapse\"><div class=\"padded\">"
        | _   => "</div></div>"

      warn: (msg) ->
        grunt.log.write "\n"
        grunt.log.warn msg
        grunt.log.write "..."

      # create a button which reveals collapsed text, or hides it if already revealed.
      toggle: (id, label, type) ->

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

      # insert an icon
      icon: (iconClass) ->
        "<span class=\"icon-#{iconClass}\"></span>"

      # create a thumbnail to an external site
      linkedImage: (image, url, alternateText="linked thumbnail") ->
        "<a href=\"#{url}\"><div class=\"thumbnail\">" +
        "<img src=\"#{image}\" alt=\"#{alternateText}\">" +
        "<p class=\"text-center\">#{alternateText}</p>" +
        "</div></a>"

  _.extend options.data, require('./pass2Constants.js')
  return options

