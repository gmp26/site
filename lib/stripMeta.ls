#
# * grunt-stripMeta
# *
# * Copyright (c) 2013 Mike Pearson
# * Licensed the MIT license.
#
"use strict"

async = require 'async'
pathUtils = require 'path'
jsy = require('js-yaml')
metaStore = require('../lib/metaStore.js')

module.exports = (grunt) ->
  lf = grunt.util.linefeed
  lflf = lf + lf
  yamlre = /^````$\n^([^`]*)````/m

  task = ->

  # Please see the Grunt documentation for more information regarding task
  # creation: http://gruntjs.com/creating-tasks
  grunt.registerMultiTask "stripMeta", "Extract yaml from yaml+content files", ->

    store = metaStore(grunt)
    partialsDir = grunt.config.get "yeoman.partials"
    isolateToken = grunt.file.read ".isolate"
    unless isolateToken.length > 0 && isolateToken != ".*"
      isolateRe = new RegExp isolateToken
    else
      isolateRe = null

    isolate = (meta) ->
      return true if meta.resourceType.matches isolateRe
      for stid in meta.stids1
        return true if stid.matches isolateRe
      for pvid in meta.pvids1
        return true if pvid.matches isolateRe
      false

    writeYAML = ->
      metadata = jsy.safeDump store.root
      if _.isString options.metaDataObj
        grunt[options.metaDataObj] = metadata
      if _.isString options.metaDataPath
        grunt.file.write options.metaDataPath, metadata

    # Merge task-specific and/or target-specific options with these defaults.
    options = @options({
      metaDataPath: "#{partialsDir}/sources.yaml"
      metaDataObj: "metadata"
      stripMeta: '````'
      spawnLimit: 1
    })

    appendStation = (stpath, stid) ->
      grunt.log.write "  #append station #stid"

      src = grunt.file.read(stpath)
      yaml = if(src.match yamlre) then matches[1] else ""

      if yaml.length > 0

        # create object reference from the path
        p = pathUtils.normalize stpath
        basename = pathUtils.basename p, '.md'
        dirname = pathUtils.dirname p
        pathname = (dirname + "/" + basename)

        # this will throw any syntax error. Let it.
        data = {meta: jsy.safeLoad yaml}

        # append this resource to site metadata store
        store.setPathData pathname, data

        # and continue to dependencies
        deps = data.meta.dependencies
        if _.isArray(deps) && deps.length > 0
          for depid in deps
            depPath = "#{sourceDir}/stations/#{depid}.md"
            if !store.root.sources.stations[depid]? && grunt.file.exists depPath
              appendStation depPath, depid

    appendPervasiveIdea = (pvpath, pvid) ->
      grunt.log.write "  #append pervasiveIdea #pvid"

      src = grunt.file.read(pvpath)
      yaml = if(src.match yamlre) then matches[1] else ""

      if yaml.length > 0

        # create object reference from the path
        p = pathUtils.normalize pvpath
        basename = pathUtils.basename p, '.md'
        dirname = pathUtils.dirname p
        pathname = (dirname + "/" + basename)

        # this will throw any syntax error. Let it.
        data = {meta: jsy.safeLoad yaml}

        # append this resource to site metadata store
        store.setPathData pathname, data

    readResources = ->
      for f in @files

        fpaths = f.src.filter (path) ->
          unless grunt.file.exists(path)
            grunt.verbose.warn "Input file \"" + path + "\" not found."
            false
          else
            grunt.log.write "#{path}"

            src = grunt.file.read(path)
            yaml = if(src.match yamlre) then matches[1] else ""

            # if options.metaDataPath? && yaml.length > 0
            if yaml.length > 0

              # create object reference from the path
              p = pathUtils.normalize path
              basename = pathUtils.basename p, '.md'
              dirname = pathUtils.dirname p
              pathname = (dirname + "/" + basename)

              try
                data = {meta: jsy.safeLoad yaml}
              catch e
                grunt.log.error "#e parsing metadata in #pathname"
                return false

              # append this resource to site metadata store
              store.setPathData pathname, data

              # Hopefully, we have only been given resources and examQuestions
              # but, just in case...
              if (dirname == "resources" || dirname == "examQuestions")
                if grunt.clearance > data.meta.clearance
                  grunt.log.error "excluding #{path}:#{data.meta.clearance}"
                  return false
                unless isolate data.meta
                  return false

              # Include dependency chain too
              for stid in data.meta.stids1 ++ data.meta.stids2
                stpath = "#{sourceDir}/stations/#{stid}.md"
                if !store.root.sources.stations[stid]? && grunt.file.exists stpath
                  appendStation stpath, stid

              for pvid in data.meta.pvids1 ++ data.meta.pvids2
                pvpath = "#{sourceDir}/pervasiveIdeas/#{pvid}.md"
                if !store.root.sources.pervasiveIdeas[pvid]? && grunt.file.exists pvpath
                  appendPervasiveIdea pvpath, pvid

    







