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

    for resourceName, files of resources
      meta = files.index.meta
      layout = getLayout sources, 'resources', meta
      srcDest = new Object()
      srcDest.src = ["#{partialsDir}/html/resources/#{meta.id}",  layout, "layouts/_*.html"]
      srcDest.dest = "#{appDir}/resources/#{meta.id}"
      resourceFiles.push srcDest

    delete config.src
    delete config.dest
    config.files = resourceFiles
    grunt.config.set(['generateHtml', 'resources'], config);

    #
    # configure examQuestion src-dest mappings
    #
    examQuestionFiles = new Array()
    config = grunt.config.get(['generateHtml', 'examQuestions']);

    for eqid, data of examQuestions
      meta = data.index?.meta
      layout = getLayout sources, 'renderQuestion', null
      srcDest = new Object()
      srcDest.src = ["#{partialsDir}/html/examQuestions/#{meta.id}",  layout, "layouts/_*.html"]
      srcDest.dest = "#{partialsDir}/html/renderedQuestions/#{meta.id}"
      examQuestionFiles.push srcDest

    delete config.src
    delete config.dest
    config.files = examQuestionFiles
    grunt.config.set(['generateHtml', 'examQuestions'], config);

    #
    # configure pervasiveIdea src-dest mappings
    #
    pervasiveIdeaFiles = new Array()
    config = grunt.config.get(['generateHtml', 'pervasiveIdeas']);

    for pvid, data of pervasiveIdeas
      meta = data.meta
      layout = getLayout sources, 'pervasiveIdeas', meta
      srcDest = new Object()
      srcDest.src = ["#{partialsDir}/html/pervasiveIdeas/#{pvid}.html",  layout, "layouts/_*.html"]
      srcDest.dest = "#{partialsDir}/html/pervasiveIdeas/#{pvid}.html"
      pervasiveIdeaFiles.push srcDest

    delete config.src
    delete config.dest
    config.files = pervasiveIdeaFiles
    grunt.config.set(['generateHtml', 'pervasiveIdeas'], config);
