"use strict"

jsy = require('js-yaml')

module.exports = (grunt, metadata) ->

  # precompiled page layouts
  var resourceLayout

  # simplify access to lodash
  _ = grunt.util._


  #
  # Run the site generator on grunt panda generated metadata
  #

  grunt.log.debug "RUNNING GENERATOR"

  #
  # Todo: This code should be generalised
  #
  metadata = expandMetadata metadata
  sources = metadata.sources

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
  return metadata


  #
  # Get layout for a given file
  #
  function getLayout(sources, folder, meta)

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
  function generateResource (sources, folder, resourceName, fileName, meta)

    layout = getLayout sources, folder, meta
    #grunt.log.debug "  layout = #layout"

    if !resourceLayout?
      #grunt.log.debug "Compiling resource layout"

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
  function generateHTML(sources, folder, fileName, meta)

    layout = getLayout sources, folder, meta
    #grunt.log.debug "folder=#folder file=#fileName layout = #layout"
    #_.each meta, (value, key)->grunt.log.debug "meta.key=#key"

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
  # expandMetadata to include
  #   station dependents as well as dependencies
  #   station primaryResources
  #   primaryPervasiveIdeas
  #
  # This is a kind of batch db lookup and could I guess
  # be replaced with some db implementation if we start
  # hitting performance or memory limits.
  #
  function expandMetadata (metadata)
    sources = metadata.sources
    stations = sources.stations
    pervasiveIdeas = sources.pervasiveIdeas
    #
    # Go through all resources, making links back to the
    # resource from their primary and secondary stations
    # and pervasiveIdeas.
    #
    resources = sources.resources
    _.each resources, (resource, resourceId) ->
      meta = resource.index.meta
      _.each meta.stids1, (id) ->
        st = stations[id].meta
        st.R1s ?= {}
        st.R1s[resourceId] = meta.resourceType
      _.each meta.stids2, (id) ->
        st = stations[id].meta
        st.R2s ?= {}
        st.R2s[resourceId] = meta.resourceType
      _.each meta.pvids1, (id) ->
        pv = pervasiveIdeas[id].meta
        pv.R1s ?= {}
        pv.R1s[resourceId] = meta.resourceType
      _.each meta.pvids2, (id) ->
        pv = pervasiveIdeas[id].meta
        pv.R2s ?= {}
        pv.R2s[resourceId] = meta.resourceType
    #
    # Go through all stations, doubling up dependency
    # links and building pervasive ideas lists
    #
    _.each stations, (station, id) ->
      #
      # insert dependents by looking through dependencies
      #
      dependencies = station.meta.dependencies
      _.each dependencies, (dependencyId) ->
        if dependencyId
          dependency = stations[dependencyId] ? null
          grunt.fatal "station #dependencyId not found" unless dependency
          dependency.meta.dependents = [] unless dependency.meta.dependents
          dependents = dependency.meta.dependents
          unless dependents.indexOf(id) >= 0
            #grunt.log.debug "adding dependent #id to #dependencyId"
            dependents.push id
      #
      # build station pervasive ideas lists by collecting pvids of
      # primary resources only.
      #
      station.meta.pervasiveIdeas ?= {}
      stpvs = station.meta.pervasiveIdeas
      R1s = station.meta.R1s
      _.each R1s, (resourceType, resourceId) ->
        pvids1 = sources.resources[resourceId].index.meta.pvids1
        _.each pvids1, (pvid) ->
          stpvs[pvid] = true
    #
    # build pervasive ideas station lists by collecting primary stids of
    # primary resources tagged with this pvid.
    #
    _.each pervasiveIdeas, (pervasiveIdea, id) ->
      pervasiveIdea.meta.stids ?= {}
      pvstids = pervasiveIdea.meta.stids
      R1s = pervasiveIdea.meta.R1s
      _.each R1s, (resourceType, resourceId) ->
        stids1 = sources.resources[resourceId].index.meta.stids1
        _.each stids1, (stid) ->
          pvstids[stid] = true

    #grunt.file.write "partials/doubleLinked.yaml", jsy.safeDump metadata
    metadata

