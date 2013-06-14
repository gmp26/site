"use strict"

module.exports = (grunt) ->

  #
  # Generate a resource
  #
  function generateResource (sources, folder, resourceName, filename, meta)

    layout = getLayout sources, folder, meta
    grunt.log.debug "  layout = #layout"

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

    for folder, files of sources
      grunt.log.debug "folder = <#folder>"

      for filename, meta of files
        grunt.log.debug "  file = <#filename>"

        if folder == 'resources'
          resourceName = filename
          filename = 'index'
          meta = meta.meta
          generateResource sources, folder, resourceName, filename, meta
        else
          generateHTML sources, folder, filename, meta

    # return success code to caller
    return 0


