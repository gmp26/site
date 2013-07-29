"use strict"

module.exports = (grunt, sources, partialsDir) ->


  #
  # Generate template data for a site resource
  #
  return (rtid, meta) ->

    _ = grunt.util._

    return {
      title: meta.title
      icon: meta.icon
      html: grunt.file.read "#{partialsDir}/resourceTypes/#{rtid}.html"
    }


    

