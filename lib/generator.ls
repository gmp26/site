"use strict"

jsy = require('js-yaml')

module.exports = (grunt) ->

  # precompiled page layouts
  var resourceLayout

  # simplify access to lodash
  _ = grunt.util._

  #
  # addStationDependents to incoming metadata as well as their dependencies
  # so we have bidirectional links
  #
  addStationDependents = (metadata) ->
    stations = metadata.sources.stations
    _.each stations, (station, id) ->
      dependencies = station.meta.dependencies
      _.each dependencies, (dependencyId) ->
        if dependencyId
          dependency = stations[dependencyId] ? null
          grunt.fatal "station #dependencyId not found" unless dependency
          dependency.meta.dependents = [] unless dependency.meta.dependents
          dependents = dependency.meta.dependents
          unless dependents.indexOf(id) >= 0
            grunt.log.debug "adding dependent #id to #dependencyId"
            dependents.push id
    #grunt.file.write "foo.yaml", jsy.safeDump metadata
    metadata


  #
  # Run the site generator on grunt panda generated metadata
  #
  return (metadata) ->

    grunt.log.debug "RUNNING"

    #
    # Todo: This code should be generalised
    #
    sources = (addStationDependents metadata).sources

    #
    # addDependents as well as dependencies so we have bidirectional links
    #
    #addStationDependents sources

    # Group stations by line ahead of time
    stationsByLine = _.groupBy sources.stations, (station, stationId) ->
      (stationId.split /\d/).0 # lineId is the leading non-numeric bit

    #
    # Get layout for a given file
    #
    getLayout = (sources, folder, meta) ->

      prefix = 'sources/layouts/'
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
    generateResource = (sources, folder, resourceName, fileName, meta) ->

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
            root: '../..'
            resources: '..'
        }

        # then precompile it
        resourceLayout := _.template common #grunt.file.read(layout)

      content = grunt.file.read "partials/resources/#{resourceName}/index.html"

      html = resourceLayout {
        content: content
      }
      grunt.file.write "app/#{folder}/#{resourceName}/index.html", html

    #
    # Generate a single html file
    #
    generateHTML = (sources, folder, fileName, meta) ->

      layout = getLayout sources, folder, meta
      grunt.log.debug "folder=#folder file=#fileName layout = #layout"
      _.each meta, (value, key)->grunt.log.debug "meta.key=#key"

      # make common template from unchanging stuff
      _head = grunt.file.read "sources/layouts/_head.html"
      _nav = grunt.file.read "sources/layouts/_nav.html"
      _foot = grunt.file.read "sources/layouts/_foot.html"
      _linesMenu = grunt.file.read "sources/layouts/_linesMenu.html"

      if folder && folder.length > 0
        content = grunt.file.read "partials/#{folder}/#{fileName}.html"
        root = ".."
        resources = '../resources'
      else
        content = grunt.file.read "partials/#{fileName}.html"
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


    #
    # Call the generators
    #

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
        for fileName, meta of items
          grunt.log.debug "  file = <#fileName>"

          if fileName == 'meta'
            generateHTML sources, null, folder, meta
          else
            generateHTML sources, folder, fileName, meta.meta

    # return success code to caller
    return 0
