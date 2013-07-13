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
    sourcesDir = grunt.config.get "yeoman.sources"
    partialsDir = grunt.config.get "yeoman.partials"
    appDir = grunt.config.get "yeoman.app"

    # make html from resource layout and data
    _head = grunt.file.read "layouts/_head.html"
    _nav = grunt.file.read "layouts/_nav.html"
    _foot = grunt.file.read "layouts/_foot.html"

    getResourceData = (require './getResourceData.js') grunt, sources, partialsDir, _head, _nav, _foot

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
          indexMeta = files.index.meta
          layout = getLayout sources, folder, indexMeta
          content = getResourceData resourceName, files, indexMeta
          html = grunt.template.process grunt.file.read(layout), {
            data:
              _head: _head
              _nav: _nav
              _foot: _foot
              resourceTypeMeta: sources.resourceTypes[indexMeta.resourceType].meta
              content: content
              meta: indexMeta
              root: '../..'
              resources: '..'
          }
          grunt.file.write "app/#{folder}/#{resourceName}/index.html", html

      else
        for fileName, meta of items
          #grunt.log.debug "  file = <#fileName>"

          if fileName == 'meta'
            generateHTML sources, null, folder, meta
          else
            generateHTML sources, folder, fileName, meta.meta
    
    generateLess sources

    # return the metadata
    return metadata

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


