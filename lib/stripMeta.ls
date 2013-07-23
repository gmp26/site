#
# * grunt-stripMeta
# *
# * Copyright (c) 2013 Mike Pearson
# * Licensed the MIT license.
#
"use strict"

pathUtils = require 'path'
jsy = require('js-yaml')
metaStore = require('../lib/metaStore.js') 

module.exports = (grunt) ->

  yamlre = /^````$\n^([^`]*)````/m
  _ = grunt.util._

  grunt.registerMultiTask "stripMeta", "Extract yaml from yaml+content files", ->

    # Merge task-specific and/or target-specific options with these defaults.
    options = @options({
      metaDataPath: "#{partialsDir}/sources.yaml"
      metaDataVar: "metadata"
      stripMeta: '````'
      metaReplace: grunt.config.get "yeoman.sources"
      metaReplacement: "sources"
    })

    isolateFile = ".isolate"
    store = metaStore(grunt, options)
    partialsDir = grunt.config.get "yeoman.partials"
    sourceDir = grunt.config.get "yeoman.sources"
    if grunt.file.exists isolateFile
      isolateToken = grunt.file.read isolateFile
    unless isolateToken.length > 0
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
      if _.isString options.metaDataVar
        grunt.config.set options.metaDataVar, metadata
      if _.isString options.metaDataPath
        grunt.file.write options.metaDataPath, metadata

    appendStation = (stpath, stid) ->
      grunt.log.write "  append station #stid"

      debugger

      src = grunt.file.read(stpath)
      matches = src.match yamlre
      if matches != null
        yaml = matches[1]

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
            sources = store.root[options.metaReplacement]
            sources ?= {}
            sources.stations ?= {} 
            if !sources.stations[depid]? && grunt.file.exists depPath
              appendStation depPath, depid

    appendPervasiveIdea = (pvpath, pvid) ->
      grunt.log.write "  append pervasiveIdea #pvid"

      src = grunt.file.read(pvpath)
      matches = src.match yamlre
      if matches != null
        yaml = matches[1]

        # create object reference from the path
        p = pathUtils.normalize pvpath
        basename = pathUtils.basename p, '.md'
        dirname = pathUtils.dirname p
        pathname = (dirname + "/" + basename)

        # this will throw any syntax error. Let it.
        data = {meta: jsy.safeLoad yaml}

        # append this resource to site metadata store
        store.setPathData pathname, data

    readResources = (files) ->
      for f in files

        fpaths = f.src.filter (path) ->
          unless grunt.file.exists(path)
            grunt.verbose.warn "Input file \"" + path + "\" not found."
            false
          else
            grunt.log.write "#{path}"

            src = grunt.file.read(path)

            # if options.metaDataPath? && yaml.length > 0
            matches = src.match yamlre
            if matches != null

              yaml = matches[1]

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
                if !store.root[options.metaReplacement]?.stations?[stid]? && grunt.file.exists stpath
                  appendStation stpath, stid

              for pvid in data.meta.pvids1 ++ data.meta.pvids2
                pvpath = "#{sourceDir}/pervasiveIdeas/#{pvid}.md"
                if !store.root[options.metaReplacement]?.pervasiveIdeas?[pvid]? && grunt.file.exists pvpath
                  appendPervasiveIdea pvpath, pvid

    readResources(@files)
    grunt.file.write "#{partialsDir}/stripped.html", jsy.safeDump store.root







