"use strict"

module.exports = (grunt) ->

  getLayout = (require './getLayout.js') grunt
  fs = require 'fs'
  cheerio = require 'cheerio'

  # simplify access to lodash
  _ = grunt.util._

  # Please see the Grunt documentation for more information regarding task
  # creation: http://gruntjs.com/creating-tasks
  grunt.registerMultiTask "generateHtml", "Generate the site html, javascripts and CSS.", ->

    #
    # Run the site generator on grunt panda generated metadata
    #
    grunt.verbose.writeln "Generating site"
    grunt.config.set "layoutPostfix" ".html"

    #
    # set up some short cut references
    # 
    metadata = grunt.config.data.metadata

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
    appSourcesDir = grunt.config.get "yeoman.appSources"

    #
    # read in ubiquitous layouts
    #
    _head = grunt.file.read "layouts/_head.html"
    _nav = grunt.file.read "layouts/_nav.html"
    _foot = grunt.file.read "layouts/_foot.html"
    _linesMenu = grunt.file.read "layouts/_linesMenu.html"
    _piMenu = grunt.file.read "layouts/_piMenu.html"

    #    
    # read in acknowledgements hash
    #
    metadata.acknowledgements = grunt.file.readYAML "#{sourcesDir}/acknowledgements.yaml"

    #
    # generate template data for site resources
    #
    getExamQuestionPartData = (require './getFilePartData.js') grunt, sources, partialsDir+'/html', 'examQuestions'
    getResourceData = (require './getResourceData.js') grunt, sources, partialsDir+'/html'
    getPervasiveIdeaData = (require './getPervasiveIdeaData.js') grunt, sources, partialsDir+'/html'

    #
    # Generate top level page
    #
    generateTopLevelPage = (fname, ...moreData) ->
      if not sources[fname]?.meta?
        grunt.log.error "source file #{fname}.md has no metadata"
      else
        meta = sources[fname].meta
        meta.id = fname
        layout = getLayout sources, null, meta
        data = {
          data:
            _head: _head
            _nav: _nav
            _foot: _foot
            meta: meta
            sources: sources
            content: grunt.file.read "#{partialsDir}/html/#{fname}.html"
            rootUrl: '.'
            resourcesUrl: './resources'
        }
        if moreData?
          _.extend data.data, moreData.0

        html = grunt.template.process grunt.file.read(layout), data
        grunt.file.write "#{appDir}/#{fname}.html", html 

    #
    # Render individual examQuestions to partialsDir
    #
    referenceFor = (qmeta) -> {
      ref: [
        qmeta.paper ? "null"
        qmeta.year ? "null"
        if qmeta.qno then "Q#{qmeta.qno}" else "null"
      ].join ', '
      ack: if qmeta.source then metadata.acknowledgements[qmeta.source].acknowledgement else void
    }

    #
    # Create a new resourceId for a station from a collection of rendered examQuestions
    #
    createStationRT13s = (stid, rt13Sorted, resid) ->

      # grunt.log.error "createStationRT13s: #stid #resid"
      # for i, r in rt13Sorted
      #   grunt.log.error "#i: #r"

      rt13html = ""
      i = 0
      for eqid in rt13Sorted
        rt13html += (grunt.file.read "#{partialsDir}/html/renderedQuestions/#{eqid}/index.html").replace "!!Problem!!", "#{++i}"


      grunt.file.write "#{partialsDir}/html/resources/#{resid}/index.html", rt13html

      # 
      # locate images to copy
      #
      for eqid in rt13Sorted
        dirFiles = fs.readdirSync "#{sourcesDir}/examQuestions/#{eqid}"
        for f in dirFiles
          ext = f.substr(-4)
          if ('.png.gif.jpg.jpeg.PNG.GIF.JPG.JPEG').indexOf(ext) >= 0
            # copy it to the resource directory
            # grunt.log.debug "#eqid -> #f"
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
            layout: 'resource'
            resourceType: 'RT13'
      }
      #grunt.config.set "metadata.sources.resources.#{resid}" resources[resid]

      # insert the new resource in the station metadata
      R1s = stations[stid].meta?.R1s ? []
      resMeta = {
        id: resid
        rt: 'RT13'
        highlight: null
      }
      insertAt = _.sortedIndex R1s, resMeta, (meta) ->

        if meta.id? && _.isString meta.id
          m = meta.id.match /_(\d+)$/
          if m != null
            idWeight = +m[1]/10
          else
            idWeight = 0
 
        weight =  +meta.rt.substr(2)+ idWeight
        #grunt.log.error "SORT sorting #{meta.id} on weight #weight"
        +meta.rt.substr(2)+idWeight
      R1s.splice insertAt, 0, resMeta
      
    if @target is "topLevelPages"
      #
      # top level pages
      #
      pageNames = new Array()
      _.each @files, (file, key) ->
        destPath = file.dest
        destFile = destPath.split("/")[1]
        destFileName = destFile.split(".")[0]
        pageNames.push destFileName

      if 'index' in pageNames
        generateTopLevelPage 'index'
      if 'map' in pageNames
        generateTopLevelPage 'map' do
          _linesMenu: _linesMenu
          # relative to app directory
          pngUrl: 'images/tubeMap.png'
          # relative to base directory
          svgContent: parseSVG grunt.file.read "#{appDir}/images/tubeMap.svg"
      if 'pervasiveIdeasHome' in pageNames
        generateTopLevelPage 'pervasiveIdeasHome' do
          families: families
          pervasiveIdeas: pervasiveIdeas
      if 'resourceTypesHome' in pageNames
        generateTopLevelPage 'resourceTypesHome' do
          resourceTypes: _.sortBy resourceTypes, ((data, rt) -> +rt.substr 2)
      if 'privacy' in pageNames
        generateTopLevelPage 'privacy'
      if 'cookies' in pageNames
        generateTopLevelPage 'cookies'

    else if @target is "pervasiveIdeas"
      #
      # pervasiveIdeas
      #

      pvNames = new Array()
      _.each @files, (file, key) ->
        destPath = file.dest
        destFile = destPath.split("/")[2]
        destFileName = destFile.split(".")[0]
        pvNames.push destFileName

      for pvid, data of pervasiveIdeas
        if pvid not in pvNames
          # we don't need to recompile
          continue
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

    else if @target is "examQuestions"
      #
      # examQuestions 
      #

      eqNames = new Array()
      _.each @files, (file, key) ->
        destPath = file.dest
        destFileName = destPath.split("/")[3]
        eqNames.push destFileName

      st13s = {}
      pi13s = {}

      for eqid, data of examQuestions
        indexMeta = data.index?.meta
        layout = getLayout sources, 'renderQuestion', null
        unless eqid in eqNames
          # we don't need to recompile
          continue
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
        grunt.file.write "#{partialsDir}/html/renderedQuestions/#{eqid}/index.html", html

        #
        # Collect eqids by station and by pervasiveIdea
        #
        if indexMeta.stids1?
          for id in (indexMeta.stids1)
            st13s[id] ?= {}
            rt13 = st13s[id]
            rt13[eqid] = true
            #grunt.log.error "stid = #{id} equid=#{eqid}"

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

    else if @target is "stations"
      #
      # stations
      #
      stationNames = new Array()
      _.each @files, (file, key) ->
        destPath = file.dest
        destFile = destPath.split("/")[2]
        destFileName = destFile.split(".")[0]
        stationNames.push destFileName

      for stid, data of stations
        meta = data.meta
        layout = getLayout sources, 'stations', meta
        unless stid in stationNames
          # we don't need to recompile
          continue

        html = grunt.template.process grunt.file.read(layout), {
          data:
            _head: _head
            _nav: _nav
            _foot: _foot
            _linesMenu: _linesMenu
            meta: meta
            content: grunt.file.read "#{partialsDir}/html/stations/#{stid}.html"
            sources: sources
            rootUrl: ".."
            resourcesUrl: '../resources'
        }
        grunt.file.write "#{appDir}/stations/#{stid}.html", html

    else if @target is "resources"
      #
      # resources
      #
      resNames = new Array()
      _.each @files, (file, key) ->
        destPath = file.dest
        destFileName = destPath.split("/")[2]
        resNames.push destFileName

      for resourceName, files of resources
        indexMeta = files.index.meta
        layout = getLayout sources, 'resources', indexMeta
        unless resourceName in resNames
          # we don't need to recompile
          continue
        content = getResourceData resourceName, files, indexMeta
        ackText = if indexMeta.source then metadata.acknowledgements[indexMeta.source].acknowledgement else void

        # grunt.log.error "id=#{indexMeta.id}: title=#{indexMeta.title}, lastUpdated=#{indexMeta.lastUpdated}"
        html = grunt.template.process grunt.file.read(layout), {
          data:
            _head: _head
            _nav: _nav
            _foot: _foot
            resourceTypeMeta: sources.resourceTypes[indexMeta.resourceType].meta
            content: content
            meta: indexMeta
            ackText: ackText
            rootUrl: '../..'
            resourcesUrl: '..'
        }
        grunt.file.write "#{appDir}/resources/#{resourceName}/index.html", html

    # this isn't too computationally expensive so can run every time
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

    #
    # Parse SVG for map generation
    #
    function parseSVG(data)
      # Removes titles and generates popover markup
      $ = cheerio.load data 
      popoverData = new Object()
      $('[id ^="node"] title').each (i, elem) ->
        # The title contains the element id according to SVG spec
        # Maybe better to use http://www.graphviz.org/content/preservation-dot-id-svg
        ids = $(elem).text().split("-")
        # grunt.verbose.writeln 'Station ' + ids[0]
        $(elem).parent().attr 'station-id', ids.join("-")
        # Generate appropriate popover data
        content = ''
        dependencies = new Array()
        dependents = new Array()
        for index from 0 til ids.length
          station = sources.stations[ids[index]]
          title = "
          <h3 class=\"popover-title onmap\"><ul class=\"inline\">
            <li class=\"dependency\" data-content=\"#{ids[index]}\">
              <a class=\"button#{station?.meta.line}\" href=\"./stations/#{ids[index]}.html\">
              <span>#{ids[index]}</span>
              </a>
            </li>
          </ul><span class=\"line\">
            #{sources.lines[station?.meta.line]?.meta.title}
          </h3>"
          content = content + title + station?.meta.title 
          dependencies = dependencies ++ station.meta.dependencies # ++ is concat operator
          dependents = dependents ++ station.meta.dependents # ++ is concat operator
          if index != ids.length - 1
            content = content + "<div style='height:5px;'></div>"
        popoverDatum = new Object()
        # no need for title in present implementation
        # popoverDatum.title = title
        popoverDatum.content =  content
        popoverDatum.dependencies = dependencies
        popoverDatum.dependents = dependents
        # associative array
        popoverData[ids.join("-")] = popoverDatum
      # Add it to the map.js file
      javascript = grunt.file.read "#{appSourcesDir}/scripts/map.js"
      javascript = "popoverData = " + JSON.stringify(popoverData) + ";" + javascript
      grunt.file.write "#{appDir}/scripts/map.js", javascript
      # we don't want tooltips
      $('title').remove!
      # we don't want XML headers (first 3 lines)
      return $.html!.split('\n').slice(3).join('\n');
