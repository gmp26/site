"use strict"

module.exports = (grunt) ->

  getLayout = (require './getLayout.js') grunt
  fs = require 'fs'

  # simplify access to lodash
  _ = grunt.util._

  # Please see the Grunt documentation for more information regarding task
  # creation: http://gruntjs.com/creating-tasks
  grunt.registerTask "generatePrintables", "Generate printable pdf versions of pages in the site.", ->

    #
    # Run the site generator on grunt panda generated metadata
    #
    grunt.verbose.writeln "Generating printables"
    grunt.config.set "layoutPostfix" ".tex"

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
    resourceTypesHome = sources.resourceTypesHome
    stations = sources.stations

    sourcesDir = grunt.config.get "yeoman.sources"
    partialsDir = grunt.config.get "yeoman.partials"
    appDir = grunt.config.get "yeoman.app"

    # make tex from resource layout and data  
    _preamble = grunt.file.read "layouts/_printablesPreamble.tex"

    # a helper function since LaTeX can't access images above the tex file in a folder hierarchy
    copyImage = (filename, targetFolder) ->
        grunt.file.copy "#{appDir}/images/#{filename}" "#{partialsDir}/printables/#{targetFolder}/#{filename}"
    copyResourceAssets = (name) ->
        files = grunt.file.expand("#{sourcesDir}/resources/#{name}/*.png")
        for img in files
            grunt.file.copy img, (img.replace "#{sourcesDir}", "#{partialsDir}/printables")


    #TODO work out what these do and fix them for tex generation
    # getExamQuestionPartData = (require './getFilePartData.js') grunt, sources, partialsDir+'/printables', 'examQuestions'
    getResourceData = (require './getResourceData.js') grunt, sources, partialsDir+'/printables'
    # getPervasiveIdeaData = (require './getPervasiveIdeaData.js') grunt, sources, partialsDir+'/printables'


    #
    # stations
    #
    # Since (on some systems at least) LaTeX can't see images below the .tex file in the hierarchy
    # copy any required images so they're next to the tex files.
    copyImage 'postmark.pdf' 'stations'
    copyImage 'cmep-logo3.pdf' 'stations'
    
    for stid, data of stations
      meta = data.meta
      layout = getLayout sources, 'stations', meta

      markup = grunt.template.process grunt.file.read(layout), {
        data:
          _preamble: _preamble.replace '<%= fontpath %>' '../../../app/fonts/'
          meta: meta
          content: grunt.file.read "#{partialsDir}/printables/stations/#{stid}.tex"
          sources: sources
      }

      texFilename = "#{stid}.printable.tex"
      texPath = "#{partialsDir}/printables/stations/#{texFilename}"
      grunt.file.write texPath, markup

    #
    # resources
    #
    for resourceName, files of resources
      copyResourceAssets resourceName
      copyImage 'cmep-logo3.pdf' "resources/#{resourceName}"

      indexMeta = files.index.meta
      layout = getLayout sources, 'resources', indexMeta

      content = getResourceData resourceName, files, indexMeta
      # cdata has fields
      #   fileName:
      #   fileMeta:
      #   indexMeta:
      #   alias:
      #   markup:
      _.each(content.parts, (cdata, index) -> 
        markup = grunt.template.process grunt.file.read(layout), {
          data:
            _preamble: _preamble.replace '<%= fontpath %>' '../../../../app/fonts/' 
            resourceTypeMeta: sources.resourceTypes[indexMeta.resourceType].meta
            content: cdata.markup
            alias: cdata.alias
            meta: indexMeta
            sidebar: content.sidebar
            icon: (name) -> '\\' + name.replace(/-/g,'')
            stationbutton: (stMeta) -> 
              "\\definecolor{tempcolor}{HTML}{#{(stMeta.colour.substring 1).toUpperCase()}}%\n" + 
                "\\begin{tikzpicture}[baseline=(n.base)]%\n" + 
                "  \\node[rectangle, rounded corners=8pt, fill=tempcolor, text centered] (n) " + 
                "at (0,0) {\\hyperref[station:#{stMeta.id}]{\\large\\sectfont\\color{white} #{stMeta.id}}};%\n" + 
                "\\end{tikzpicture}%\n"
        }

        texFilename = cdata.fileName + ".printable.tex"
        resourcePath = "#{partialsDir}/printables/resources/#{resourceName}"
        texPath = "#{resourcePath}/#{texFilename}"

        grunt.file.write texPath, markup
      )

    # return the metadata
    return metadata


