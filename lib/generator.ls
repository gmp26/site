"use strict"

module.exports = (grunt) ->

  getLayout = (require './getLayout.js') grunt
  fs = require 'fs'

  # simplify access to lodash
  _ = grunt.util._

  # Please see the Grunt documentation for more information regarding task
  # creation: http://gruntjs.com/creating-tasks
  grunt.registerTask "generator", "Generate the site html, javascripts and CSS.", ->

    #
    # Run the site generator on grunt panda generated metadata
    #
    grunt.verbose.writeln "Generating site"

    #
    # set up some short cut references
    # 
    metadata = grunt.config.get "metadata"

    sources = metadata.sources
    families = metadata.families
    pervasiveIdeas = sources.pervasiveIdeas
    pervasiveIdeasHome = sources.pervasiveIdeasHome
    examQuestions = sources.examQuestions
    resources = sources.resources
    resourceTypes = sources.resourceTypes
    stations = sources.stations

    sourcesDir = grunt.config.get "yeoman.sources"
    partialsDir = grunt.config.get "yeoman.partials"
    appDir = grunt.config.get "yeoman.app"

    # make html from resource layout and data
    _head = grunt.file.read "layouts/_head.html"
    _nav = grunt.file.read "layouts/_nav.html"
    _foot = grunt.file.read "layouts/_foot.html"
    _linesMenu = grunt.file.read "layouts/_linesMenu.html"
    _piMenu = grunt.file.read "layouts/_piMenu.html"
    
    getExamQuestionPartData = (require './getFilePartData.js') grunt, sources, partialsDir, 'examQuestions'
    getResourceData = (require './getResourceData.js') grunt, sources, partialsDir
    getPervasiveIdeaData = (require './getPervasiveIdeaData.js') grunt, sources, partialsDir

    #
    # Call the html generators
    #

    #
    # index (home)
    #
    meta = sources.index.meta
    layout = getLayout sources, null, meta
    html = grunt.template.process grunt.file.read(layout), {
      data:
        _head: _head
        _nav: _nav
        _foot: _foot
        meta: meta
        content: grunt.file.read "#{partialsDir}/index.html"
        sources: sources
        rootUrl: '.'
        resourcesUrl: './resources'
    }
    grunt.file.write "#{appDir}/index.html", html 

    #
    # map
    #
    meta = sources['map'].meta
    layout = getLayout sources, null, meta
    content = grunt.file.read "#{partialsDir}/map.html"

    html = grunt.template.process grunt.file.read(layout), {
      data:
        _head: _head
        _nav: _nav
        _foot: _foot
        _linesMenu: _linesMenu
        meta: meta
        content: content
        sources: sources
        rootUrl: '.'
        resourcesUrl: './resources'
    }
    grunt.file.write "#{appDir}/map.html", html

    #
    # pervasiveIdeasHome
    #
    meta = pervasiveIdeasHome.meta
    layout = getLayout sources, null, meta
    html = grunt.template.process grunt.file.read(layout), {
    data:
      _head: _head
      _nav: _nav
      _foot: _foot
      content: grunt.file.read "#{partialsDir}/pervasiveIdeasHome.html"
      meta: meta
      families: families
      pervasiveIdeas: pervasiveIdeas
      rootUrl: '.'
      resourcesUrl: './resources'
    }
    grunt.file.write "#{appDir}/pervasiveIdeasHome.html", html

    #
    # pervasiveIdeas
    #
    for pvid, data of pervasiveIdeas

      meta = data.meta
      layout = getLayout sources, 'pervasiveIdeas', meta
      html = grunt.template.process grunt.file.read(layout), {
        data:
          _piMenu: _piMenu
          _head: _head
          _nav: _nav
          _foot: _foot
          meta: meta
          content: getPervasiveIdeaData pvid, meta
          sources: sources
          stations: stations
          resources: resources
          resourceTypes: resourceTypes
          families: metadata.families
          rootUrl: '..'
          resourcesUrl: '../resources'
      }

      grunt.file.write "#{appDir}/pervasiveIdeas/#{pvid}.html", html

    #
    # examQuestions
    #
    # examQuestions: 
    #   Q1: 
    #     index: 
    #       meta: 
    #         source: CamAss
    #         layout: resource
    #         clearance: 0
    #         keywords: null
    #         year: June 1953
    #         paper: "Mathematics A level paper 2, 185"
    #         qno: 2
    #         stids1: 
    #           - G2
    #           - E2
    #         stids2: null
    #         pvids1: null
    #         pvids2: null
    #     solution: 
    #       meta: 
    #         alias: Solution

    #
    # Read in acknowledgements
    #
    acks = grunt.file.readYAML "#{sourcesDir}/examQuestions/sources.yaml"

    #
    # Render individual questions to partialsDir
    #
    referenceFor = (qmeta) -> {
      ref: [
        qmeta.source ? eqid
        qmeta.year ? "null"
        qmeta.paper ? "null"
        qmeta.qno ? "null"
      ].join ', '
      ack: if qmeta.source then acks[qmeta.source].acknowledgement else void
    }

    #
    # Create a new resourceId for a station from a collection of rendered questions
    #
    createStationRT13s = (stid, rt13Sorted, resid) ->
      #
      # TODO: Add in code here to limit number of questions per page to 10 (or 5?)
      #
      grunt.log.debug "createStationRT13s: #stid #resid"

      rt13html = ""
      i = 0
      for eqid in rt13Sorted
        rt13html += (grunt.file.read "#{partialsDir}/renderedQuestions/#{eqid}/index.html").replace "!!Problem!!", "#{++i}"


      grunt.file.write "#{partialsDir}/resources/#{resid}/index.html", rt13html

      # 
      # locate images to copy
      #
      for eqid in rt13Sorted
        dirFiles = fs.readdirSync "#{sourcesDir}/examQuestions/#{eqid}"
        for f in dirFiles
          ext = f.substr(-4)
          if ('.png.gif.jpg.jpeg.PNG.GIF.JPG.JPEG').indexOf(ext) >= 0
            # copy it to the resource directory
            grunt.log.debug "#eqid -> #f"
            grunt.file.copy "#{sourcesDir}/examQuestions/#{eqid}/#f", 
            "#{appDir}/resources/#{resid}/#f"

      # insert the new RT13 resource into the resource metadata
      resources[resid] = {
        index:
          meta:
            id: resid
            stids1: [
              stid
            ]
            layout: 'eqresource'
            resourceType: 'RT13'
      }

      # insert the new resource in the station metadata
      R1s = stations[stid].meta?.R1s ? []
      resMeta = {
        id: resid
        rt: 'RT13'
        highlight: null
      }
      insertAt = _.sortedIndex R1s, resMeta, (meta) -> +meta.rt.substr(2)+meta.id[*-1]/10
      stations[stid].meta.R1s = R1s.splice insertAt, 0, resMeta


    #
    # Scan examQuestions to create rendered Questions
    #

    st13s = {}
    pi13s = {}

    for eqid, data of examQuestions
      indexMeta = data.index?.meta
      layout = getLayout sources, 'renderQuestion', null
      grunt.log.debug "Calling getExamQuestionPart #eqid"
      content = getExamQuestionPartData eqid, data, indexMeta
      content.0.alias = "#{eqid}"
      html = grunt.template.process grunt.file.read(layout), {
        data:
          content: content
          reference: referenceFor indexMeta
          eqid: eqid
          rootUrl: '../..'
          resourcesUrl: '..'
      }
      grunt.file.write "#{partialsDir}/renderedQuestions/#{eqid}/index.html", html

      #
      # Collect eqids by station and by pervasiveIdea
      #
      if indexMeta.stids1?
        for id in (indexMeta.stids1)
          st13s[id] ?= {}
          rt13 = st13s[id]
          rt13[eqid] = true

      if indexMeta.pvids1?
        for id in (indexMeta.pvids1)
          pi13s[id] ?= {}
          rt13 = pi13s[id]
          rt13[eqid] = true

    #
    # Create partial html for each station and pi RT13
    #
    for stid, rt13 of st13s

      rt13Sorted = _.sortBy (_.keys rt13), (k) -> +k.substr(1)

      # TODO: paginate instead of truncate
      # rt13Sorted = _.filter rt13Sorted, (data, index) -> index < 9

      # chop into max 5 questions per page
      partition = _.groupBy rt13Sorted, (val, index)->Math.floor(index / 5)
      for key, subset of partition
        resid = "#{stid}_RT13_EQ_#{key}"
        createStationRT13s stid, subset, resid

    #
    # stations
    #
    for stid, data of stations
      #generateHTML sources, folder, stid, meta.meta

      meta = data.meta
      layout = getLayout sources, 'stations', meta
      html = grunt.template.process grunt.file.read(layout), {
        data:
          _head: _head
          _nav: _nav
          _foot: _foot
          _linesMenu: _linesMenu
          meta: meta
          content: grunt.file.read "#{partialsDir}/stations/#{stid}.html"
          sources: sources
          rootUrl: ".."
          resourcesUrl: '../resources'

      }

      grunt.file.write "#{appDir}/stations/#{stid}.html", html

    #
    # resources
    #
    for resourceName, files of resources
      indexMeta = files.index.meta
      layout = getLayout sources, 'resources', indexMeta
      content = getResourceData resourceName, files, indexMeta
      html = grunt.template.process grunt.file.read(layout), {
        data:
          _head: _head
          _nav: _nav
          _foot: _foot
          resourceTypeMeta: sources.resourceTypes[indexMeta.resourceType].meta
          content: content
          meta: indexMeta
          rootUrl: '../..'
          resourcesUrl: '..'
      }
      grunt.file.write "#{appDir}/resources/#{resourceName}/index.html", html

    generateLess sources

    # return the metadata
    return metadata


    #
    # Generate line colours for less
    #
    function generateLess(sources)

      css = ''
      _.each sources.lines, (line, lineId)->
        colour = line.meta.colour
        css += "@linecolor#{lineId}: #colour;\n"
      grunt.file.write "#{appDir}/styles/lineVars.less", css

      css = ''
      _.each sources.lines, (line, lineId)->
        css += ".button#{lineId} {\n  .button-line(@linecolor#{lineId})\n}\n"
      grunt.file.write "#{appDir}/styles/lines.less", css


