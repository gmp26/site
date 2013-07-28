"use strict"

module.exports = (grunt, sources, partialsDir, folder) ->

  #
  # Generate template data for a site resource
  #
  return (resourceName, files, indexMeta) ->

    _ = grunt.util._

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
        file.meta.id = rName
        #grunt.log.ok "fileName = #fileName, tab = #{file.meta.tab} part = #{getPart fileName, file.meta}"
        content[*] = {
          fileName: fileName
          fileMeta: file.meta
          indexMeta: indexMeta
          alias: aliasOf fileName, file.meta
          html: grunt.file.read "#{pDir}/#{folder}/#{rName}/#{fileName}.html"
        }
      _.sortBy content, (cdata) -> weightOf cdata.fileName, cdata.fileMeta

    # return content
    return contentOf files

