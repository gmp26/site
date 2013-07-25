"use strict"

module.exports = (grunt) ->

  getLayout = (require './getLayout.js') grunt

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
      grunt.file.write "app/resources/#{resourceName}/index.html", html

    #
    # Call the generators
    #

    lastFolder = null
    for folder, items of sources

      if folder != lastFolder
        grunt.log.writeln "Generating #folder"
        lastFolder = folder

      switch folder

      case 'lines', 'resourceTypes', 'index', 'map', 'pervasiveIdeasHome', 'pervasiveIdeas', 'resources'
        noop = true



      case 'examQuestions'
        break



      case 'stations'
        for stid, meta of items
          #generateHTML sources, folder, stid, meta.meta

          meta = meta.meta
          layout = getLayout sources, folder, meta

          content = grunt.file.read "#{partialsDir}/#{folder}/#{stid}.html"
          root = ".."
          resources = '../resources'

          html = grunt.template.process grunt.file.read(layout), {
            data:
              _head: _head
              _nav: _nav
              _foot: _foot
              _linesMenu: _linesMenu
              meta: meta
              content: content
              sources: sources
              rootUrl: root
              resourcesUrl: resources
          }

          grunt.file.write "#{appDir}/stations/#{stid}.html", html

      default
        grunt.fail.fatal "***** UNKNOWN FOLDER #folder *****"

    
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


