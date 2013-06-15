"use strict"

module.exports = (grunt) ->


  var resourceGenerator #a precompiled template

  #
  # Generate a resource
  #
  function generateResource (sources, folder, resourceName, filename, meta)

    layout = getLayout sources, folder, meta
    grunt.log.debug "  layout = #layout"

    template = grunt.file.read(layout)

    _head = grunt.file.read "sources/layouts/_head.html"
    _nav = grunt.file.read "sources/layouts/_nav.html"
    view = grunt.file.read "partials/resources/#{resourceName}/index.html"
    _foot = grunt.file.read "sources/layouts/_foot.html"

    html = grunt.template.process template, {
      data:
        path: resourceName
        head: _head
        nav: _nav
        view: view
        foot: _foot
    }
 
    grunt.file.write "app/#{resourceName}/index.html", html

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


