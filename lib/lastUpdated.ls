"use strict"

async = require 'async'
spawn = require('child_process').spawn
path = require 'path'

module.exports = (grunt) ->

  metadatapathForPath = (pathname, configString) ->
    # copied from pass2.ls - should abstract into separate function somewhere...
    p = (path.dirname pathname) + path.sep + (path.basename pathname, '.md')
    replaceKey = "panda.#{configString}.options.metaReplace"
    replacementKey = "panda.#{configString}.options.metaReplacement"
    re = new RegExp "^#{grunt.config.get replaceKey}"
    p = p.replace re, (grunt.config.get(replacementKey) ? "")

    names = (p.split path.sep).filter (name)->name && name.length > 0
    return "metadata.#{names.join '.'}.meta"

  grunt.registerMultiTask "lastUpdated", "", ->
    done = @async!
    cmd = "git"
    baseArgs = "log -1 --pretty=format:%ad --date=short "
    async.eachSeries @files, iterator, finalCallback
    
    function finalCallback # js syntax due to hoisting
      done! # use this to tell grunt that we're finished!

    function iterator(element, callback) # js syntax due to hoisting
      element.src.filter (filepath) ->
        unless grunt.file.exists(filepath)
          grunt.verbose.warn "Input file \"" + filepath + "\" not found."
          return
        # Find last modified date
        args = baseArgs + "./#{filepath}"

        grunt.verbose.writeln "Running command: #cmd #args"
        child = spawn cmd, args.split " "

        child.stderr.on 'data', (data) ->
          grunt.verbose.writeln 'stderr: ' + data

        child.stdout.on 'data', (data) ->
          # The data is the last modified date
          # TODO make the config string an option
          metadatapath = metadatapathForPath filepath, 'pass2html'
          grunt.config.set "#{metadatapath}.lastUpdated", data

        child.on 'exit', (err) ->
          if err
            grunt.log.error 'Git exited with error ' + err
          callback err