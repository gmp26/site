"use strict"

jsy = require 'js-yaml'


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
    metadata = grunt.config.get "metadata"

    if !metadata
      metadata = grunt.file.readYAML "#{partialsDir}/sources.yaml"

    grunt.config.set "metadata", metadata

    #metadata = grunt.config.get "metadata"
    sources = metadata.sources
    stations = sources.stations
    pervasiveIdeas = sources.pervasiveIdeas
    resources = sources.resources

    #
    # Go through all resources, making links back to the
    # resource from their primary and secondary stations
    # and pervasiveIdeas.
    #
    _.each resources, (resource, resourceId) ->
      meta = resource.index.meta

      #
      # Add this resource to station highlights if necessary
      #
      highlights = []
      if meta.highlight?
        if _.isBoolean(meta.highlight) && meta.highlight
          # highlight on all stations
          highlights = sources.stations
        else
          if _.isString meta.highlight
            # highlight on one station
            highlights = [sources.stations[meta.highlight]]
          else
            if _.isArray meta.highlight
              # highlight on all stations in array
              highlights = _.map meta.highlight, (stid) -> stations[stid]
      _.each highlights, (station, stid) ->
        st = station.meta
        st.highlights ?= {}
        st.highlights[resourceId] = meta.resourceType

      # list the primary and secondary resources at each station
      _.each meta.stids1, (id) ->
        st = stations[id].meta
        st.R1s ?= {}
        st.R1s[resourceId] = meta.resourceType
      _.each meta.stids2, (id) ->
        st = stations[id].meta
        st.R2s ?= {}
        st.R2s[resourceId] = meta.resourceType

      # list the primary and secondary resources at each pervasiveIdea
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
      # build station pervasive ideas lists by collecting pvids1 and pvids2 of
      # both primary station resources.
      #
      station.meta.pervasiveIdeas ?= {}
      stpvs = station.meta.pervasiveIdeas
      R1s = station.meta.R1s
      _.each R1s, (resourceType, resourceId) ->
        pvids1 = sources.resources[resourceId].index.meta.pvids1
        _.each pvids1, (pvid) ->
          stpvs[pvid] = true
        pvids2 = sources.resources[resourceId].index.meta.pvids2
        _.each pvids2, (pvid) ->
          stpvs[pvid] = true

      #
      # While we're at it, let's resolve the station line and colour and rank
      #
      station.meta.line = (id.split /\d+/).0
      rank = id.substr station.meta.line.length
      m = rank.match /^(.*)([a-z])$/
      if m
        rank = m.1 + ((m.2.charCodeAt(0) - 'a'.charCodeAt(0) + 1)/100).toFixed(2).substr(1)
      station.meta.rank = +rank
      station.meta.colour = sources.lines[station.meta.line].meta.colour

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

    grunt.file.write "#{partialsDir}/expanded.yaml", jsy.safeDump metadata

