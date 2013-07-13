"use strict"

module.exports = (grunt, sources, partialsDir) ->


  #
  # Generate template data for a site resource
  #
  return (resourceName, files, indexMeta) ->


    _ = grunt.util._

    # fetch all sidebar content for a resource
    sidebarOf = (indexMeta) ->

      rv = null

      stids1 = indexMeta.stids1
      if _.isArray(stids1) && stids1.length > 0
        rv ?= {}
        rv.stMetas = _.sortBy (_.map stids1, (id)->sources.stations[id].meta), (.weight)

      pvids1 = indexMeta.pvids1
      if _.isArray(pvids1) && pvids1.length > 0
        rv ?= {}
        rv.pvMetas = _.map pvids1, (id)->sources.pervasiveIdeas[id].meta

      priors = indexMeta.priors
      if _.isArray(priors) && priors.length > 0
        rv ?= {}
        rv.priorMetas = _.sortBy (_.map priors, (priorId) ->
          prMeta = sources.resources[priorId].index.meta
          return {
            id: priorId
            rtMeta: sources.resourceTypes[prMeta.resourceType].meta
          }), (pMeta) -> pMeta.rtMeta.weight

      laters = indexMeta.laters
      if _.isArray(laters) && laters.length > 0
        rv ?= {}
        rv.laterMetas = _.sortBy (_.map laters, (laterId) ->
          lrMeta = sources.resources[laterId].index.meta
          return {
            id: laterId
            rtMeta: sources.resourceTypes[lrMeta.resourceType].meta
          }), (lMeta) -> lMeta.rtMeta.weight

      return rv

    # Weight of a part in a multipart tabbed resource. 
    # Heavier parts appear in later tabs.
    weightOf = (fileName, fileMeta) ->
      if fileName == "index"
        return 0

      unless fileMeta? && fileMeta.weight
        return fileName

      return fileMeta.weight

    # Tab label for a file part
    aliasOf = (fileName, fileMeta) ->
      if fileMeta?.alias? 
        return fileMeta.alias
      else if fileMeta?.id?
        return fileMeta.id
      else return fileName

    # Fetch all main content for a resource
    contentOf = (files, pDir = partialsDir, rName = resourceName) ->
      content = []
      for fileName, file of files
        #grunt.log.ok "fileName = #fileName, tab = #{file.meta.tab} part = #{getPart fileName, file.meta}"
        content[*] = {
          fileName: fileName
          fileMeta: file.meta
          alias: aliasOf fileName, file.meta
          html: grunt.file.read "#{pDir}/resources/#{rName}/#{fileName}.html"
        }
      _.sortBy content, (cdata) -> weightOf cdata.fileName, cdata.fileMeta

    # return content
    return {
      sidebar: sidebarOf indexMeta
      parts: contentOf files
    }

