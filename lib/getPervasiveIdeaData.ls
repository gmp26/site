"use strict"

module.exports = (grunt, sources, partialsDir) ->


  #
  # Generate template data for a site resource
  #
  return (resourceName, files, indexMeta) ->

    _ = grunt.util._
    

