"use strict"

module.exports = (grunt) ->

  #
  # Wrap a simple object (actually a function) with some accessor functions so we
  # have somewhere to hang different storage and access mechanisms.
  #
  # example:
  #   makeStore = require('lib/store.js')
  #   meta = makeStore()
  #   meta.setPathData 'foo/bar/index', yamlData
  #
  root = {}

  store = root
  var replaceCount
  var metaReplacement

  store.root = (data, options) ->
    return root unless data?
    if typeof data != 'object'
      throw new Error 'store root must be object'
    root := data

    if options?.metaReplace?
      replaceCount := options.metaReplace.length
      metaReplacement := options.metaReplacement ? ""
    else
      replaceCount := false

    return store


 
  store.setPathData = (path, data) ->

    grunt.log.debug "before: path=#path"
    #grunt.log.debug "data=#data"

    # replace root of path if necessary
    if replaceCount
      path = metaReplacement + path.substr replaceCount

    grunt.log.debug "after: path=#path"

    accPaths = (names, data, acc) ->

      #grunt.log.debug "accPaths: names = #names"

      if names.length == 0
        grunt.fatal "empty store path"

      if names.length == 1
        acc[names.0] = data
      else
        [head, ...tail] = names
        acc[head] = {} unless acc[head]? || typeof acc[head] == 'object'
        accPaths tail, data, acc[head]

    pathToObj = (names, data, obj) ->
      if typeof data != 'object'
        grunt.fatal "data is not an object: #data"
      names = names.filter (name)->name && name.length > 0
      #grunt.log.debug "names = #names"
      accPaths names, data, obj

    pathToObj (path.split '/'), data, root
    return store

  return store
