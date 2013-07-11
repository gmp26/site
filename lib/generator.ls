"use strict"

module.exports = (grunt) ->

  # precompiled page layouts
  var resourceLayout

  # simplify access to lodash
  _ = grunt.util._

  # Please see the Grunt documentation for more information regarding task
  # creation: http://gruntjs.com/creating-tasks
  grunt.registerTask "generator", "Generate the site html, javascripts and CSS.", ->

    #
    # Run the site generator on grunt panda generated metadata
    #
    grunt.verbose.writeln "Generating site"

    options = @options({
    })

    #
    # set up some short cut references
    # 
    metadata = grunt.config.get "metadata"
    sources = metadata.sources
    stations = sources.stations
    pervasiveIdeas = sources.pervasiveIdeas
    resources = sources.resources
    resourceTypes = sources.resourceTypes
    lines = sources.lines

    sourcesDir = grunt.config.get "yeoman.sources"
    partialsDir = grunt.config.get "yeoman.partials"
    appDir = grunt.config.get "yeoman.app"

    #
    # addDependents as well as dependencies so we have bidirectional links
    #
    #addStationDependents sources


    #
    # Call the generators
    #

    lastFolder = null
    for folder, items of sources

      if folder != lastFolder
        grunt.log.writeln "Generating #folder"
        lastFolder = folder

      if folder=='resources'
        resources = items
        for resourceName, files of resources
          #grunt.log.debug "  resource = <#resourceName>"
          meta = files.index.meta
          generateResource sources, folder, resourceName, files, meta
      else
        for fileName, meta of items
          #grunt.log.debug "  file = <#fileName>"

          if fileName == 'meta'
            generateHTML sources, null, folder, meta
          else
            generateHTML sources, folder, fileName, meta.meta

    debugger
    
    generateLineVars sources

    # return the metadata
    return metadata


    #
    # Get layout for a given file
    #
    function getLayout(sources, folder, meta)

      prefix = 'layouts/'
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

      if grunt.file.exists layout
        layout
      else
        using = (prefix+'default'+postfix)
        grunt.verbose.writeln "#folder layout #layout does not exist, using #using"
        using

    #
    # Generate a resource
    #
    function generateResource (sources, folder, resourceName, files, meta)

      layout = getLayout sources, folder, meta

      mainParents = (meta) ->
        stids1 = meta.stids1
        if _.isArray(stids1) && stids1.length > 0
          return {
            type: "st"
            metas: _.sortBy(_.map stids1, (id)->stations[id].meta), (.rank)
          }
        pvids1 = meta.pvids1
        if _.isArray(pvids1) && pvids1.length > 0
          return {
            type: "pv"
            metas: _.map pvids1, (id)->pervasiveIdeas[id].meta
          }
        return null

      # make html from resource layout and data
      _head = grunt.file.read "layouts/_head.html"
      _nav = grunt.file.read "layouts/_nav.html"
      _foot = grunt.file.read "layouts/_foot.html"
      parents = mainParents meta
      if parents
        html = grunt.template.process grunt.file.read(layout), {
          data:
            _head: _head
            _nav: _nav
            _foot: _foot
            resourceTypeMeta: sources.resourceTypes[meta.resourceType].meta
            content: grunt.file.read "#{partialsDir}/resources/#{resourceName}/index.html"
            meta: meta
            solution: files.solution
            parents: parents
            root: '../..'
            resources: '..'
        }
      else
        grunt.log.error "*** Ignoring orphan resource #{folder}/#{resourceName} with no stids1 or pvids1"

      grunt.file.write "app/#{folder}/#{resourceName}/index.html", html

    #
    # Generate a single html file
    #
    function generateHTML(sources, folder, fileName, meta)

      layout = getLayout sources, folder, meta
      #grunt.log.debug "folder=#folder file=#fileName layout = #layout"
      #_.each meta, (value, key)->grunt.log.debug "meta.key=#key"

      # make common template from unchanging stuff
      _head = grunt.file.read "layouts/_head.html"
      _nav = grunt.file.read "layouts/_nav.html"
      _foot = grunt.file.read "layouts/_foot.html"
      _linesMenu = grunt.file.read "layouts/_linesMenu.html"

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
          content: content
          sources: sources
          root: root
          resources: resources
      }

      if folder
        grunt.file.write "#{appDir}/#{folder}/#{fileName}.html", html
      else
        grunt.file.write "#{appDir}/#{fileName}.html", html

    #
    # Generate line colours for less
    #
    function generateLineVars(sources)

      css = ''
      _.each sources.lines, (line, lineId)->
        colour = line.meta.colour
        css += "@linecolor#{lineId}: #colour;\n"
      grunt.file.write "#{appDir}/styles/lineVars.less", css


