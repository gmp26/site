"use strict"

jsy = require 'js-yaml'
expandMetadata = require './expandMetadata.js'

module.exports = (grunt, metadata) ->

  # precompiled page layouts
  var resourceLayout

  # simplify access to lodash
  _ = grunt.util._


  #
  # Run the site generator on grunt panda generated metadata
  #

  grunt.verbose.writeln "Generating site"

  #
  # Todo: This code should be generalised
  #
  metadata = expandMetadata grunt, metadata
  sources = metadata.sources

  sourcesDir = grunt.config.get "yeoman.sources"
  partialsDir = grunt.config.get "yeoman.partials"

  #
  # addDependents as well as dependencies so we have bidirectional links
  #
  #addStationDependents sources

  # Group stations by line ahead of time
  stationsByLine = _.groupBy sources.stations, (station, stationId) ->
    (stationId.split /\d/).0 # lineId is the leading non-numeric bit

  #
  # Call the generators
  #

  for folder, items of sources

    #grunt.log.debug "folder = <#folder>"

    if folder=='resources'
      resources = items
      for resourceName, files of resources
        #grunt.log.debug "  resource = <#resourceName>"
        index = files.index
        fileName = 'index'
        meta = index.meta
        generateResource sources, folder, resourceName, fileName, meta
    else
      for fileName, meta of items
        #grunt.log.debug "  file = <#fileName>"

        if fileName == 'meta'
          generateHTML sources, null, folder, meta
        else
          generateHTML sources, folder, fileName, meta.meta

  # return the metadata
  grunt.file.write "#{partialsDir}/expanded.yaml", jsy.safeDump metadata
  return metadata


  #
  # Get layout for a given file
  #
  function getLayout(sources, folder, meta)

    prefix = grunt.config.get('yeoman.sources') + '/layouts/'
    postfix = '.html'

    layout = meta.layout
    if !layout
      layout = if !folder
        'home'
      else
        # layout names are singular
        m = folder.match /(^.+)s$/
        m?.1 ? folder

    layout = prefix + layout + postfix

    if grunt.file.exists layout then layout else (prefix+'default'+postfix)

  #
  # Generate a resource
  #
  function generateResource (sources, folder, resourceName, fileName, meta)

    layout = getLayout sources, folder, meta

    # make html from resource layout and data
    _head = grunt.file.read "#{sourcesDir}/layouts/_head.html"
    _nav = grunt.file.read "#{sourcesDir}/layouts/_nav.html"
    _foot = grunt.file.read "#{sourcesDir}/layouts/_foot.html"
    html = grunt.template.process grunt.file.read(layout), {
      data:
        _head: _head
        _nav: _nav
        _foot: _foot
        resourceTypeTitle: sources.resourceTypes[meta.resourceType].meta.title
        content: grunt.file.read "#{partialsDir}/resources/#{resourceName}/index.html"
        root: '../..'
        resources: '..'
    }

    grunt.file.write "app/#{folder}/#{resourceName}/index.html", html

  #
  # Generate a single html file
  #
  function generateHTML(sources, folder, fileName, meta)

    layout = getLayout sources, folder, meta
    #grunt.log.debug "folder=#folder file=#fileName layout = #layout"
    #_.each meta, (value, key)->grunt.log.debug "meta.key=#key"

    # make common template from unchanging stuff
    _head = grunt.file.read "#{sourcesDir}/layouts/_head.html"
    _nav = grunt.file.read "#{sourcesDir}/layouts/_nav.html"
    _foot = grunt.file.read "#{sourcesDir}/layouts/_foot.html"
    _linesMenu = grunt.file.read "#{sourcesDir}/layouts/_linesMenu.html"

    if folder && folder.length > 0
      content = grunt.file.read "#{partialsDir}/#{folder}/#{fileName}.html"
      root = ".."
      resources = '../resources'
    else
      content = grunt.file.read "#{partialsDir}/#{fileName}.html"
      root = "."
      resources = './resources'

    html = grunt.template.process grunt.file.read(layout), {
      data:
        _head: _head
        _nav: _nav
        _foot: _foot
        _linesMenu: _linesMenu
        meta: meta
        stationsByLine: stationsByLine
        content: content
        sources: sources
        root: root
        resources: resources
    }

    if folder
      grunt.file.write "app/#{folder}/#{fileName}.html", html
    else
      grunt.file.write "app/#{fileName}.html", html



