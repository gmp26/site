"use strict"

# <div class="accordion-group">
#   <div class="accordion-heading">
#     <a class="accordion-toggle" data-toggle="collapse" data-parent="#linesMenu" href="#line1">
#       Line 1 Title
#     </a>
#   </div>
#   <div id="line1" class="accordion-body collapse in">
#     <div class="accordion-inner">
#       Station List here...
#     </div>
#   </div>
# </div>


module.exports = (grunt) ->

  # precompiled page layouts
  var resourceLayout
  _ = grunt.util._

  #
  # Generate a resource
  #
  function generateResource (sources, folder, resourceName, fileName, meta)

    layout = getLayout sources, folder, meta
    grunt.log.debug "  layout = #layout"

    if !resourceLayout?
      grunt.log.debug "Compiling resource layout"

      # make common template from unchanging stuff
      _head = grunt.file.read "sources/layouts/_head.html"
      _nav = grunt.file.read "sources/layouts/_nav.html"
      _foot = grunt.file.read "sources/layouts/_foot.html"
      common = grunt.template.process grunt.file.read(layout), {
        data:
          _head: _head
          _nav: _nav
          _foot: _foot
          content: '<%= content %>'   # don't remove!
      }

      # then precompile it        
      resourceLayout := _.template common #grunt.file.read(layout)

    content = grunt.file.read "partials/resources/#{resourceName}/index.html"

    html = resourceLayout {
      path: resourceName
      content: content
    }
    grunt.file.write "app/#{folder}/#{resourceName}/index.html", html

  #
  # Generate a single html file
  #
  function generateHTML (sources, folder, fileName, meta)

    layout = getLayout sources, folder, meta
    grunt.log.debug "folder=#folder file=#fileName layout = #layout"

    html = "<p>not yet</p>"

    # make common template from unchanging stuff
    _head = grunt.file.read "sources/layouts/_head.html"
    _nav = grunt.file.read "sources/layouts/_nav.html"
    _foot = grunt.file.read "sources/layouts/_foot.html"
    _linesMenu = grunt.file.read "sources/layouts/_linesMenu.html"

    if folder && folder.length > 0
      content = grunt.file.read "partials/#{folder}/#{fileName}.html"
    else
      content = grunt.file.read "partials/#{fileName}.html"

    html = grunt.template.process grunt.file.read(layout), {
      data:
        _head: _head
        _nav: _nav
        _foot: -> _foot
        _linesMenu: _linesMenu
        linesAccordionGroups: ->
          (for lineId, line of sources.lines
            line.meta.id + ": " + line.meta.title).join '\n' 

        content: content   # don't remove!
    }

    if folder
      x = 1
      #grunt.file.write "app/#{folder}/#{fileName}.html", html
    else
      grunt.file.write "app/#{fileName}.html", html


  #
  # Get layout for a given file
  #
  function getLayout (sources, folder, meta)

    prefix = 'sources/layouts/'
    postfix = '.html'

    layout = meta.layout
    if !layout || layout.length == 0
      layout = folder ? 'home'

    layout = prefix + layout + postfix

    if grunt.file.exists layout then layout else (prefix+'default'+postfix) 


  #
  # Run the site generator on grunt panda generated metadata
  #
  return (metadata) ->

    grunt.log.debug "RUNNING"

    #
    # Todo: This code should be generalised
    #
    sources = metadata.sources

    for folder, items of sources

      grunt.log.debug "folder = <#folder>"

      if folder=='resources'
        resources = items
        for resourceName, files of resources
          grunt.log.debug "  resource = <#resourceName>"
          index = files.index
          fileName = 'index'
          meta = index.meta
          generateResource sources, folder, resourceName, fileName, meta
      else
        for fileName    , meta of items
          grunt.log.debug "  file = <#fileName>"

          if fileName     == 'meta'
            generateHTML sources, null, folder, meta
          else
            generateHTML sources, folder, fileName      , meta

    # return success code to caller
    return 0


