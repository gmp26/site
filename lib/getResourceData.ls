"use strict"

module.exports = (grunt, sources, partialsDir) ->


  #
  # Generate template data for a site resource
  #
  return (layout, resourceName, files, indexMeta) ->


    _ = grunt.util._

    # fetch all sidebar content for a resource
    sidebarOf = (indexMeta) ->

      rv = null

      stids1 = indexMeta.stids1
      if _.isArray(stids1) && stids1.length > 0
        rv ?= {}
        rv.stMetas = _.sortBy (_.map stids1, (id)->sources.stations[id].meta), (.rank)

      pvids1 = indexMeta.pvids1
      debugger
      if _.isArray(pvids1) && pvids1.length > 0
        rv ?= {}
        rv.pvMetas = _.map pvids1, (id)->sources.pervasiveIdeas[id].meta

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
    tabOf = (fileName, fileMeta) ->
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
          part: tabOf fileName, file.meta
          html: grunt.file.read "#{pDir}/resources/#{rName}/#{fileName}.html"
        }
      _.sortBy content, (cdata) -> weightOf cdata.fileName, cdata.fileMeta

    # return content
    debugger
    return {
      sidebar: sidebarOf indexMeta
      parts: contentOf files
    }

