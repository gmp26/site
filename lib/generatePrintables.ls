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
    copyFont = (filename, targetFolder) ->
      grunt.file.copy "#{appDir}/fonts/#{filename}" "#{partialsDir}/printables/#{targetFolder}/#{filename}"
    copyFonts = (targetFolder) ->
      fonts = grunt.file.expand {cwd: "#{appDir}/fonts/"}, ["*.ttc", "*.otf", "*.ttf"]
      for file in fonts
        grunt.file.copy "#{appDir}/fonts/#{file}", "#{partialsDir}/printables/#{targetFolder}/#{file}"
    copyResourceAssets = (name) ->
        files = grunt.file.expand("#{sourcesDir}/resources/#{name}/*.png")
        for img in files
            grunt.file.copy img, (img.replace "#{sourcesDir}", "#{partialsDir}/printables")


    #TODO work out what these do and fix them for tex generation
    # getExamQuestionPartData = (require './getFilePartData.js') grunt, sources, partialsDir+'/printables', 'examQuestions'
    getResourceData = (require './getResourceData.js') grunt, sources, partialsDir+'/printables'
    # getPervasiveIdeaData = (require './getPervasiveIdeaData.js') grunt, sources, partialsDir+'/printables'

    #TODO decide whether we want top level pdfs
    # generateTopLevelPage = (fname, ...moreData) ->
    #   meta = sources[fname].meta
    #   layout = getLayout sources, null, meta
    #   data = {
    #     data:
    #       _head: _head
    #       _nav: _nav
    #       _foot: _foot
    #       meta: meta
    #       content: grunt.file.read "#{partialsDir}/html/#{fname}.html"
    #       sources: sources
    #       rootUrl: '.'
    #       resourcesUrl: './resources'
    #   }
    #   if moreData?
    #     _.extend data.data, moreData.0

    #   html = grunt.template.process grunt.file.read(layout), data
    #   grunt.file.write "#{appDir}/#{fname}.html", html 


    # #
    # # Call the html generators
    # #
    # generateTopLevelPage 'index'
    # generateTopLevelPage 'map' do
    #   _linesMenu: _linesMenu
    # generateTopLevelPage 'index'
    # generateTopLevelPage 'pervasiveIdeasHome' do
    #   families: families
    #   pervasiveIdeas: pervasiveIdeas
    # generateTopLevelPage 'resourceTypesHome' do
    #   resourceTypes: _.sortBy resourceTypes, ((data, rt) -> +rt.substr 2)
    # generateTopLevelPage 'privacy'
    # generateTopLevelPage 'cookies'

    #
    # Call the html generators
    #

    #
    # index (home)
    #
    # meta = sources.index.meta
    # layout = getLayout sources, null, meta
    # html = grunt.template.process grunt.file.read(layout), {
    #   data:
    #     _head: _head
    #     _nav: _nav
    #     _foot: _foot
    #     meta: meta
    #     content: grunt.file.read "#{partialsDir}/index.html"
    #     sources: sources
    #     rootUrl: '.'
    #     resourcesUrl: './resources'
    # }
    # grunt.file.write "#{appDir}/index.html", html 

    #
    # map
    #
    # meta = sources['map'].meta
    # layout = getLayout sources, null, meta
    # content = grunt.file.read "#{partialsDir}/map.html"

    # html = grunt.template.process grunt.file.read(layout), {
    #   data:
    #     _head: _head
    #     _nav: _nav
    #     _foot: _foot
    #     _linesMenu: _linesMenu
    #     meta: meta
    #     content: content
    #     sources: sources
    #     rootUrl: '.'
    #     resourcesUrl: './resources'
    # }
    # grunt.file.write "#{appDir}/map.html", html

    #
    # pervasiveIdeasHome
    #
    # meta = pervasiveIdeasHome.meta
    # layout = getLayout sources, null, meta
    # html = grunt.template.process grunt.file.read(layout), {
    # data:
    #   _head: _head
    #   _nav: _nav
    #   _foot: _foot
    #   content: grunt.file.read "#{partialsDir}/pervasiveIdeasHome.html"
    #   meta: meta
    #   families: families
    #   pervasiveIdeas: pervasiveIdeas
    #   rootUrl: '.'
    #   resourcesUrl: './resources'
    # }
    # grunt.file.write "#{appDir}/pervasiveIdeasHome.html", html

    #
    # resourceTypesHome
    #
    # meta = resourceTypesHome.meta
    # layout = getLayout sources, null, meta

    # html = grunt.template.process grunt.file.read(layout), {
    # data:
    #   _head: _head
    #   _nav: _nav
    #   _foot: _foot
    #   content: grunt.file.read "#{partialsDir}/resourceTypesHome.html"
    #   meta: meta
    #   families: families
    #   resourceTypes: _.sortBy resourceTypes, ((data, rt) -> +rt.substr 2)
    #   rootUrl: '.'
    #   resourcesUrl: './resources'
    # }
    # grunt.file.write "#{appDir}/resourceTypesHome.html", html

    #
    # pervasiveIdeas
    #
    # for pvid, data of pervasiveIdeas

    #   meta = data.meta
    #   layout = getLayout sources, 'pervasiveIdeas', meta
    #   html = grunt.template.process grunt.file.read(layout), {
    #     data:
    #       _piMenu: _piMenu
    #       _head: _head
    #       _nav: _nav
    #       _foot: _foot
    #       meta: meta
    #       content: getPervasiveIdeaData pvid, meta
    #       sources: sources
    #       stations: stations
    #       resources: resources
    #       resourceTypes: resourceTypes
    #       families: metadata.families
    #       rootUrl: '..'
    #       resourcesUrl: '../resources'
    #   }

      # grunt.file.write "#{appDir}/pervasiveIdeas/#{pvid}.html", html

    # #
    # # examQuestions
    # #
    # # examQuestions: 
    # #   Q1: 
    # #     index: 
    # #       meta: 
    # #         source: CamAss
    # #         layout: resource
    # #         clearance: 0
    # #         keywords: null
    # #         year: June 1953
    # #         paper: "Mathematics A level paper 2, 185"
    # #         qno: 2
    # #         stids1: 
    # #           - G2
    # #           - E2
    # #         stids2: null
    # #         pvids1: null
    # #         pvids2: null
    # #     solution: 
    # #       meta: 
    # #         alias: Solution

    # #
    # # Read in acknowledgements
    # #
    # acks = grunt.file.readYAML "#{sourcesDir}/examQuestions/sources.yaml"

    # #
    # # Render individual questions to partialsDir
    # #
    # referenceFor = (qmeta) -> {
    #   ref: [
    #     qmeta.paper ? "null"
    #     qmeta.year ? "null"
    #     if qmeta.qno then "Q#{qmeta.qno}" else "null"
    #   ].join ', '
    #   ack: if qmeta.source then acks[qmeta.source].acknowledgement else void
    # }

    # #
    # # Create a new resourceId for a station from a collection of rendered questions
    # #
    # createStationRT13s = (stid, rt13Sorted, resid) ->

    #   # grunt.log.error "createStationRT13s: #stid #resid"
    #   # for i, r in rt13Sorted
    #   #   grunt.log.error "#i: #r"


    #   rt13html = ""
    #   i = 0
    #   for eqid in rt13Sorted
    #     rt13html += (grunt.file.read "#{partialsDir}/html/renderedQuestions/#{eqid}/index.html").replace "!!Problem!!", "#{++i}"


    #   grunt.file.write "#{partialsDir}/html/resources/#{resid}/index.html", rt13html

    #   # 
    #   # locate images to copy
    #   #
    #   for eqid in rt13Sorted
    #     dirFiles = fs.readdirSync "#{sourcesDir}/examQuestions/#{eqid}"
    #     for f in dirFiles
    #       ext = f.substr(-4)
    #       if ('.png.gif.jpg.jpeg.PNG.GIF.JPG.JPEG').indexOf(ext) >= 0
    #         # copy it to the resource directory
    #         grunt.log.debug "#eqid -> #f"
    #         grunt.file.copy "#{sourcesDir}/examQuestions/#{eqid}/#f", 
    #         "#{appDir}/resources/#{resid}/#f"

    #   # insert the new RT13 resource into the resource metadata
    #   resources[resid] = {
    #     index:
    #       meta:
    #         id: resid
    #         stids1: [
    #           stid
    #         ]
    #         layout: 'eqresource'
    #         resourceType: 'RT13'
    #   }

    #   # insert the new resource in the station metadata
    #   R1s = stations[stid].meta?.R1s ? []
    #   resMeta = {
    #     id: resid
    #     rt: 'RT13'
    #     highlight: null
    #   }
    #   insertAt = _.sortedIndex R1s, resMeta, (meta) ->

    #     if meta.id? && _.isString meta.id
    #       m = meta.id.match /_(\d+)$/
    #       if m != null
    #         idWeight = +m[1]/10
    #       else
    #         idWeight = 0
 
    #     weight =  +meta.rt.substr(2)+ idWeight
    #     #grunt.log.error "SORT sorting #{meta.id} on weight #weight"
    #     +meta.rt.substr(2)+idWeight
    #   R1s.splice insertAt, 0, resMeta


    # #
    # # Scan examQuestions to create rendered Questions
    # #

    # st13s = {}
    # pi13s = {}

    # for eqid, data of examQuestions
    #   indexMeta = data.index?.meta
    #   layout = getLayout sources, 'renderQuestion', null
    #   grunt.log.debug "Calling getExamQuestionPart #eqid"
    #   content = getExamQuestionPartData eqid, data, indexMeta
    #   content.0.alias = "#{eqid}"
    #   html = grunt.template.process grunt.file.read(layout), {
    #     data:
    #       content: content
    #       reference: referenceFor indexMeta
    #       eqid: eqid
    #       rootUrl: '../..'
    #       resourcesUrl: '..'
    #   }
    #   grunt.file.write "#{partialsDir}/html/renderedQuestions/#{eqid}/index.html", html

    #   #
    #   # Collect eqids by station and by pervasiveIdea
    #   #
    #   if indexMeta.stids1?
    #     for id in (indexMeta.stids1)
    #       st13s[id] ?= {}
    #       rt13 = st13s[id]
    #       rt13[eqid] = true

    #   if indexMeta.pvids1?
    #     for id in (indexMeta.pvids1)
    #       pi13s[id] ?= {}
    #       rt13 = pi13s[id]
    #       rt13[eqid] = true

    # #
    # # Create partial html for each station and pi RT13
    # #
    # for stid, rt13 of st13s

    #   rt13Sorted = _.sortBy (_.keys rt13), (k) -> +k.substr(1)

    #   # TODO: paginate instead of truncate
    #   # rt13Sorted = _.filter rt13Sorted, (data, index) -> index < 9

    #   # chop into max 5 questions per page
    #   partition = _.groupBy rt13Sorted, (val, index)->Math.floor(index / 5)
    #   for key, subset of partition
    #     resid = "#{stid}_RT13_EQ_#{key}"
    #     createStationRT13s stid, subset, resid

    #
    # stations
    #
    # Since (on some systems at least) LaTeX can't see images below the .tex file in the hierarchy
    # copy any required images so they're next to the tex files.
    copyImage 'postmark.pdf' 'stations'
    copyImage 'cmep-logo3.pdf' 'stations'
    copyFonts 'stations'
    
    for stid, data of stations
      meta = data.meta
      layout = getLayout sources, 'stations', meta

      markup = grunt.template.process grunt.file.read(layout), {
        data:
          #_preamble: _preamble.replace /<%= fontpath %>/g '../../../app/fonts/'
          _preamble: _preamble.replace /<%= fontpath %>/g './' 
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
      copyFonts "resources/#{resourceName}"

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
            #_preamble: _preamble.replace /<%= fontpath %>/g '../../../../app/fonts/'
            _preamble: _preamble.replace /<%= fontpath %>/g './' 
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


