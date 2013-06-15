"use strict"

module.exports = (grunt) ->

  # precompiled page layouts
  var resourceLayout

  #
  # Generate a resource
  #
  function generateResource (sources, folder, resourceName, filename, meta)

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
      resourceLayout := grunt.util._.template common #grunt.file.read(layout)

    content = grunt.file.read "partials/resources/#{resourceName}/index.html"

    html = resourceLayout {
      path: resourceName
      content: content
    }
    grunt.file.write "app/#{folder}/#{resourceName}/index.html", html

  #
  # Generate a single html file
  #
  function generateHTML (sources, folder, filename, meta)

    layout = getLayout sources, folder, meta
    grunt.log.debug "  layout = #layout"

  #
  # Get layout for a given file
  #
  function getLayout (sources, folder, meta)

    prefix = 'sources/layouts/'
    postfix = '.html'

    # if folder=='resources'
    #   debugger

    layout = meta.layout
    if layout && layout.length > 0
      return prefix + layout + postfix

    layout = folder
    return prefix + layout + postfix

  #
  # Run the site generator on grunt panda generated metadata
  #
  return (metadata) ->

    grunt.log.debug "RUNNING"

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
        for filename, meta of items
          grunt.log.debug "  file = <#filename>"
          generateHTML sources, folder, filename, meta

    # return success code to caller
    return 0


