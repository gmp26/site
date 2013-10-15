"use strict"

async = require 'async'
spawn = require('child_process').spawn
path = require 'path'

metadatapathForPath = (pathname) ->
  # copied from pass2.ls - should abstract into separate function somewhere...
  p = (path.dirname pathname) + path.sep + (path.basename pathname, '.md')
  replaceKey = "panda.#{configString}.options.metaReplace"
  replacementKey = "panda.#{configString}.options.metaReplacement"
  re = new RegExp "^#{grunt.config.get replaceKey}"
  p = p.replace re, (grunt.config.get(replacementKey) ? "")

  names = (p.split path.sep).filter (name)->name && name.length > 0
  return "metadata.#{names.join '.'}.meta"

module.exports = (grunt) ->

  grunt.registerMultiTask "lastUpdated", "", ->
    done = @async!
    cmd = "git log -1 --pretty=format:%ad --date=short "
    async.eachSeries @files, iterator, finalCallback
    
    function finalCallback # js syntax due to hoisting
      done! # use this to tell grunt that we're finished!

    function iterator(element, callback) # js syntax due to hoisting
      element.src.filter (filepath) ->
        unless grunt.file.exists(filepath)
          grunt.verbose.warn "Input file \"" + filepath + "\" not found."
          return
        # Find last modified date
        cmd += "./#{filepath}"
        grunt.log.writeln cmd
        child = spawn cmd

        child.stderr.on 'data', (data) ->
          grunt.verbose.writeln 'stderr: ' + data

        child.stdout.on 'data', (data) ->
          # The data is the last modified date
          metadatapath = metadatapathForPath(filepath)
          grunt.config.set metadatapath.lastUpdated, data