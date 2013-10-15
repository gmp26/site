"use strict"

async = require 'async'

module.exports = (grunt) ->

  metadatapathForPath = (path) ->
    # copied from pass2.ls - should abstract into separate function somewhere...
    p = (path.dirname pathname) + path.sep + (path.basename pathname, '.md')
    replaceKey = "panda.#{configString}.options.metaReplace"
    replacementKey = "panda.#{configString}.options.metaReplacement"
    re = new RegExp "^#{grunt.config.get replaceKey}"
    p = p.replace re, (grunt.config.get(replacementKey) ? "")

    names = (p.split path.sep).filter (name)->name && name.length > 0
    return "metadata.#{names.join '.'}.meta"

  grunt.registerTask "lastUpdated", "", ->
    done = @async!
    cmd = "git log -1 --pretty=format:%ad --date=short"
    async.eachSeries @files, iterator, finalCallback
    finalCallback = -> done! # use this to tell grunt that we're finished!

    iterator = (element, callback) ->
      f.src.filter (path) ->
        unless grunt.file.exists(path)
          grunt.verbose.warn "Input file \"" + path + "\" not found."
          return
        # Find last modified date
        args = path
        child = spawn cmd, args

        grunt.verbose.writeln child.stdin.end input

        child.stderr.on 'data', (data) ->
          grunt.verbose.writeln 'stderr: ' + data

        child.stdout.on 'data', (data) ->
          # The data is the last modified date
          metadatapath = metadatapathForPath(path)
          grunt.config.set metadatapath.lastUpdated, data