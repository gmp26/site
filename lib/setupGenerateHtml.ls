"use strict"

module.exports = (grunt) ->

  getLayout = (require './getLayout.js') grunt

  # simplify access to lodash
  _ = grunt.util._

  # Please see the Grunt documentation for more information regarding task
  # creation: http://gruntjs.com/creating-tasks
  grunt.registerTask "setupGenerateHtml", "Configure the generateHtml task using metadata", ->
    #
    # set up some short cut references
    # 
    metadata = grunt.config.data.metadata
    sources = metadata.sources
    pervasiveIdeas = sources.pervasiveIdeas
    examQuestions = sources.examQuestions
    resources = sources.resources
    stations = sources.stations

    partialsDir = grunt.config.get "yeoman.partials"
    appDir = grunt.config.get "yeoman.app"
    
    #
    # configure station src-dest mappings
    #
    stationFiles = new Array()
    config = grunt.config.get(['generateHtml', 'stations']);

    for stid, data of stations
      meta = data.meta
      layout = getLayout sources, 'stations', meta
      srcDest = new Object()
      srcDest.src = ["#{partialsDir}/html/stations/#{stid}.html",  layout, "layouts/_*.html"]
      srcDest.dest = "#{appDir}/stations/#{stid}.html"
      stationFiles.push srcDest

    delete config.src
    delete config.dest
    config.files = stationFiles
    grunt.config.set(['generateHtml', 'stations'], config);

    #
    # configure resource src-dest mappings
    #
    resourceFiles = new Array()
    config = grunt.config.get(['generateHtml', 'resources']);

    for stid, data of stations
      meta = data.meta
      layout = getLayout sources, 'stations', meta
      srcDest = new Object()
      srcDest.src = ["#{partialsDir}/html/stations/#{stid}.html",  layout, "layouts/_*.html"]
      srcDest.dest = "#{appDir}/stations/#{stid}.html"
      stationFiles.push srcDest

    delete config.src
    delete config.dest
    config.files = stationFiles
    grunt.config.set(['generateHtml', 'stations'], config);

