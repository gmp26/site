"use strict"
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
module.exports = (grunt, metadata) ->

  _ = grunt.util._

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

    #
    # Add this resource to station highlights if necessary
    #
    debugger
    highlights = []
    if meta.highlight?
      if _.isBoolean meta.highlight && meta.highlight
        # highlight on all stations
        highlights = sources.stations
      else if _.isString meta.highlight
        # highlight on one station
        highlights = [sources.stations[meta.highlight]]
      else if _.isArray meta.hightlight
        # highlight on all stations in array
        highlights = _.map meta.highlight, (stid) -> stations[stid]
    _.each highlights, (station, stid) ->
      st = station.meta
      st.highlights ?= {}
      st.highlights[resourceId] = meta.resourceType


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

  metadata
