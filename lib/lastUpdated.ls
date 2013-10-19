"use strict"

jsy = require 'js-yaml'
async = require 'async'
spawn = require('child_process').spawn

module.exports = (grunt) ->

  # Warning: this task uses in-memory metadata from expandMetadata
  # The expandMetadata task must be run first
  grunt.registerMultiTask "lastUpdated", "", ->
    done = @async!
    cmd = "git"
    baseArgs = "log -1 --pretty=format:%ad --date=short "
    partialsDir = grunt.config.get "yeoman.partials"
    metadata = grunt.config.get "metadata"
    resources = metadata.sources.resources
    resourceKeys = Object.keys resources
    # grunt.log.writeln JSON.stringify resources
    async.eachSeries resourceKeys, iterator, finalCallback
    
    function finalCallback # js syntax due to hoisting
      # Write changes to YAML
      grunt.file.write "#{partialsDir}/expanded.yaml", jsy.safeDump metadata
      grunt.config.set "metadata", metadata
      done! # use this to tell grunt that we're finished!

    function iterator(resourceKey, callback) # js syntax due to hoisting
      resource = resources[resourceKey]
      sourcesDir = grunt.config.get "yeoman.sources"
      id = resource.index.meta.id
      filepath = "#{sourcesDir}/resources/#{id}/index.md"
      args = baseArgs + "./#{filepath}"

      grunt.verbose.writeln "#cmd #args"
      child = spawn cmd, args.split " "

      child.stderr.on 'data', (data) ->
        grunt.verbose.writeln 'stderr: ' + data

      child.stdout.on 'data', (data) ->
        # The data is the last modified date
        resource.index.meta.lastUpdated = "#data"

      child.on 'exit', (err) ->
        if err
          grunt.log.error 'Git exited with error ' + err
        callback err # tell async that we have finished