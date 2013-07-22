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
makeStore = require('../lib/store.js')

module.exports = (grunt) ->
  lf = grunt.util.linefeed
  lflf = lf + lf
  yamlre = /^````$\n^([^`]*)````/m

  # Please see the Grunt documentation for more information regarding task
  # creation: http://gruntjs.com/creating-tasks
  grunt.registerMultiTask "stripMeta", "Extract yaml from yaml+content files", ->

    # tell grunt this is an asynchronous task
    done = @async!

    meta = makeStore(grunt)
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


    # Merge task-specific and/or target-specific options with these defaults.
    options = @options({
      metaDataPath: "#{partialsDir}/sources.yaml"
      metaDataObj: "metadata"
      stripMeta: '````'
      spawnLimit: 1
    })

    # Iterate over all specified file groups.
    if options.spawnLimit == 1
      async.eachSeries @files, reader, writeYAML
    else
      async.eachLimit @files, options.spawnLimit, reader, writeYAML

    function writeYAML
      metadata = jsy.safeDump meta.root!
      if _.isString options.metaDataObj
        grunt[options.metaDataObj] = metadata
      if _.isString options.metaDataPath
        grunt.file.write options.metaDataPath, metadata

      done!

    function reader(f, callback)

      fpaths = f.src.filter (path) ->
        unless grunt.file.exists(path)
          grunt.verbose.warn "Input file \"" + path + "\" not found."
          false
        else
          true

      # build a list of files for further processing in the manifest
      grunt.manifest = []

      for path in fPaths
        grunt.log.write "#{path}"

        src = grunt.file.read(path)
        yaml = if(src.match yamlre) then matches[1] else ""

        # if options.metaDataPath? && yaml.length > 0
        if yaml.length > 0

          # create object reference from the path
          p = pathUtils.normalize path
          basename = pathUtils.basename p, '.md'
          dirname = pathUtils.dirname p

          # this will throw any syntax error. Let it.
          metadata = {meta: jsy.safeLoad yaml}

          if (dirname == "resources" || dirname == "examQuestions")
            if grunt.clearance > metadata.meta.clearance
              grunt.log.error "excluding #{path}:#{metadata.meta.clearance}"
              return ""
            unless isolate metadata.meta
              return ""

          pathname = (dirname + "/" + basename)
          meta.setPathData pathname, metadata



