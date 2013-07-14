"use strict"

module.exports = (grunt, sources, partialsDir) ->


  #
  # Generate template data for a site resource
  #
  return (pvid, meta) ->

    _ = grunt.util._

    return {
      title: meta.title
      family: meta.family
      html: grunt.file.read "#{partialsDir}/pervasiveIdeas/#{pvid}.html"
    }


    

