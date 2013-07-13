"use strict"

jsy = require 'js-yaml'
colorString = require 'color-string'

#
#
# expandMetadata to include
#   station dependents as well as dependencies
#   station primaryResources
#   primaryPervasiveIdeas
#   station resource highlights
#
# This is a similar in intent to populating a database with
# views for later search efficiency, except that here we are
# making the views inside the metadata object.
#
#
module.exports = (grunt) ->

  _ = grunt.util._

  # Please see the Grunt documentation for more information regarding task
  # creation: http://gruntjs.com/creating-tasks
  grunt.registerTask "expandMetadata", "Expand metadata for efficiency.", ->

    #
    # Expand grunt panda generated metadata to make it more useful
    #
    grunt.verbose.writeln "Expanding metadata"

    options = @options({
    })

    partialsDir = grunt.config.get "yeoman.partials"
    sourcesDir = grunt.config.get "yeoman.sources"
    metadata = grunt.config.get "metadata"

    #if !metadata
    metadata = grunt.file.readYAML "#{partialsDir}/sources.yaml"

    grunt.config.set "metadata", metadata


    sources = metadata.sources
    stations = sources.stations 
    pervasiveIdeas = sources.pervasiveIdeas
    resources = sources.resources
    resourceTypes = sources.resourceTypes
    lines = sources.lines

    #
    # Make sure all lines have a valid id and colour
    #
    badLines = {}
    _.each sources.lines, (line, lid)->
      meta = line.meta
      unless _.isString(lid) && lid.match /^\D{1,3}$/
        grunt.log.error "Line #lid has a bad name"
        badLines[lid] = true
      if meta.id != lid
        grunt.log.error "Line #lid has an invalid id #{meta.id}. Using '#lid'."
      meta.id = lid
      try
        rgba = colorString.getRgba meta.colour
      unless rgba
        grunt.log.error "Line #lid has an invalid colour #{meta.colour}. Using grey"
        meta.colour = '#CCCCCC'
    _.each badLines, (b, badLineId) ->
      delete sources.lines[badLineId]
      grunt.log.error "*** Ignoring line #badLineId"

    #
    # Give all resourceTypes a weight
    #
    _.each resourceTypes, (rt, id) ->
      rt.meta.weight = +id.substr(2)

    #
    # filter out any bad pervasive ideas
    #
    badPVs = {}
    _.each pervasiveIdeas, (pv, pvid)->
      meta = pv.meta
      if !meta.title? || meta.title == null || meta.title == ""
        badPVs[pvid] = true
      if !meta.family? || meta.family == null || meta.family == ""
        grunt.log.error "pervasiveIdea #pvid has no family"
      if meta.id? && meta.id != pvid
        grunt.log.error "PervasiveIdea #pvid has incorrect id '#{meta.id}' in metadata"
        meta.id = pvid
    _.each badPVs, (b, badId) ->
      grunt.log.warn "*** Ignoring pervasiveIdea #badId"
      delete pervasiveIdeas[badId]

    #
    # filter out any bad stations
    #
    badStations = {}
    _.each stations, (st, stid) ->
      meta = st.meta
      if !meta.title? || meta.title == null || meta.title == ""
        badStations[stid] = true
        grunt.log.error "Station #stid has no title"

      # filename based stid always wins even if id is given in metadata
      if meta.id? && meta.id != stid
        grunt.log.error "Overriding '#{meta.id}' with #stid in station '#stid'"
      meta.id = stid

      #
      # Check stid syntax and resolve the station line, colour and weight
      #
      m = stid.match /^(\D{1,3})(\d{1,2})([a-z])?$/
      if m
        meta.line = m[1]
        if sources.lines[meta.line]?
          meta.weight =
            +(m[2] + if m[3] then ((m[3]charCodeAt(0) - 'a'.charCodeAt(0) + 1)/100).toFixed(2).substr(1) else '')
          meta.colour = sources.lines[meta.line].meta.colour
        else
          badStations[stid] = true
          grunt.log.error "Station #stid is on a missing line #{meta.line}"

      else
        grunt.log.error "Station #stid has an invalid id - should be in Xn to XXXnnx"
        badStations[stid] = true unless m

    _.each badStations, (b, badId) ->
      grunt.log.warn "*** Ignoring station #badId"
      delete stations[badId]

    #
    # expand lines to include sorted list of station ids they contain
    #
    stationsByLine = _.groupBy stations, (.meta.line)
    _.each _.keys(stationsByLine), (lid) ->
      stationsByLine[lid] = _.sortBy stationsByLine[lid], (.meta.weight)
      lines[lid].meta.stids = _.map stationsByLine[lid], (obj)->(obj.meta.id)

    #
    # Go through all resources, making links back to the
    # resource from their primary and secondary stations
    # and pervasiveIdeas.
    #
    badResources = {}
    _.each resources, (resource, resourceId) ->

      if !resource.index?
        grunt.log.error("#resourceId should be a folder with an index file")
        badResources[resourceId] = true
        return

      meta = resource.index.meta
      meta.id = resourceId

      if !resource.index.meta?
        grunt.log.error!error("#resourceId has no metadata")
        badResources[resourceId] = true
        return

      if !meta.resourceType? || !resourceTypes[meta.resourceType]
        grunt.log.error("#resourceId has missing or bad resourceType")
        badResources[resourceId] = true
        return

      # Expand the primary and secondary resources on objList (a station or a pervasiveIdea list)
      # Warn if any stids or pvids don't exist.
      # If they don't exist then the reference to them is deleted in the expanded metadata
      expandIds = (objList, idPrefix, idNumber) ->
        bad = {}
        srcList = meta[idPrefix+idNumber]
        _.each srcList, (id, index) ->

          # a star postfix implies the resource is to be highlighted
          grunt.log.ok "testing id #id"
          highlight = (idNumber == 1) && id.match /\s*(\w+)\*/ 
          if highlight
            grunt.log.ok "highlight"
            id = highlight.1
            srcList[index] = id

          obj = objList[id]
          if obj && obj.meta?
            objMeta = obj.meta
            resListId = "R"+idNumber+"s"
            objMeta[resListId] ?= []
            oml = objMeta[resListId]
            res = {
              id: resourceId
              rt: meta.resourceType
              highlight: highlight != null
            }
            if meta.title
              res.title = meta.title
              grunt.log.ok "***** writing #{meta.title} to res *****"
            oml.push res

            # sort generated resource list by resource type number
            objMeta[resListId] = _.sortBy oml, (obj)-> +obj.rt.substr(2)
          else
            bad[id] = true

        if srcList
          meta[idPrefix+idNumber] = _.sortBy _.filter srcList, (id)->
            if bad[id]
              grunt.log.error "#resourceId #idPrefix#idNumber refers to missing #id"
              false
            else
              true

      expandIds stations, "stids", 1
      expandIds stations, "stids", 2
      expandIds pervasiveIdeas, "pvids", 1
      expandIds pervasiveIdeas, "pvids", 2

    # edit out bad resources
    _.each badResources, (b, badId) ->
      grunt.log.warn "*** Ignoring resource #badId"
      delete resources[badId]

    # expand prior links to generate later links
    _.each resources, (resource, resourceId) ->
        meta = resource.index.meta
        if meta.priors?
          _.each meta.priors, (priorId, index) ->
            unless (priorMeta = resources[priorId]?.index?.meta)
            && meta.priors.lastIndexOf(priorId) == index
              grunt.log.error "***Deleting prior to missing #priorMeta"
              meta.priors[index] = '!BAD!'
            else
              priorMeta.laters ?= []
              priorMeta.laters.push resourceId

          meta.priors = _.sortBy (_.filter meta.priors, -> (it != '!BAD!')), (id)->
            rtid = resources[id].index.meta.resourceType
            resourceTypes[rtid].meta.weight



    #
    # Go through all stations, doubling up dependency
    # links and building pervasive ideas lists
    #
    _.each stations, (station, id) ->

      # allow a single station dependency
      dependencies = station.meta.dependencies
      if _.isString(dependencies) && stations[dependencies]?
        dependencies = [dependencies]

      # otherwise we must have an array of dependencies
      grunt.fatal "#id dependencies must be a list" if dependencies && !_.isArray dependencies

      #
      # insert dependents by looking through dependencies
      #
      _.each dependencies, (dependencyId, index) ->
        if dependencyId && _.isString(dependencyId) && dependencyId.length > 0
          if dependencyId == id
            grunt.log.error "Station #id is listed in its own dependencies"
            return
          dependency = stations[dependencyId] ? null
          if dependency
            depMeta = dependency.meta
            depMeta.dependents = [] unless depMeta.dependents
            depMeta.dependents.push id if depMeta.dependents.indexOf(id) < 0
          else
            grunt.log.error "Station #id references a missing dependency #dependencyId"
        else
          grunt.log.error "Station #id has an invalid dependency '#dependencyId', ignoring it"
          dependencies.splice index, 1


      #
      # build station pervasive ideas lists by collecting pvids1 and pvids2 of
      # primary station resources.
      #
      station.meta.pervasiveIdeas ?= {}
      stpvs = station.meta.pervasiveIdeas
      R1s = station.meta.R1s
      _.each R1s, (resObj) ->
        resIndex = sources.resources[resObj.id].index
        if resIndex
          pvids1 = resIndex.meta.pvids1
          _.each pvids1, (pvid) ->
            stpvs[pvid] = true
          pvids2 = resIndex.meta.pvids2
          _.each pvids2, (pvid) ->
            stpvs[pvid] = true
        else
          grunt.log.error "Station #{station.meta.id} has missing R1: #{resObj.id}"



    #
    # build pervasive ideas station lists by collecting primary stids of
    # primary resources tagged with this pvid.
    #
    _.each pervasiveIdeas, (pervasiveIdea, id) ->
      pervasiveIdea.meta.stids ?= {}
      pvstids = pervasiveIdea.meta.stids
      R1s = pervasiveIdea.meta.R1s
      _.each R1s, (resObj) ->
        stids1 = sources.resources[resObj.id].index.meta.stids1
        _.each stids1, (stid) ->
          pvstids[stid] = true

    grunt.file.write "#{partialsDir}/expanded.yaml", jsy.safeDump metadata

