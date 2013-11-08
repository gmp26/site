"use strict"

jsy = require 'js-yaml'
async = require 'async'
spawn = require('child_process').spawn
path = require('path')

module.exports = (grunt) ->

  # Warning: this task uses in-memory metadata from expandMetadata
  # The expandMetadata task must be run first
  grunt.registerMultiTask "lastUpdated", "", ->
    done = @async!
    sourcesDir = grunt.config.get "yeoman.sources"
    cmd="git"
    baseArgs = "log -1 --pretty=format:%ad --date=short"
    partialsDir = grunt.config.get "yeoman.partials"
    # we don't need a deep copy
    metadata = grunt.config.data.metadata
    sourceType = @target

    switch sourceType
      when "resources"
        sources = metadata.sources.resources
      when "examQuestions"
        sources = metadata.sources.examQuestions

    sourceKeys = Object.keys sources
    async.eachSeries sourceKeys, sourceIterator, finalCallback
    
    function finalCallback # js syntax due to hoisting
      # Write changes to YAML
      grunt.file.write "#{partialsDir}/expanded.yaml", jsy.safeDump metadata
      # NB no writing of metadata needed because we didn't get a deep copy!
      done! # use this to tell grunt that we're finished!

    function sourceIterator(sourceKey, callback) # js syntax due to hoisting
      source = sources[sourceKey]
      id = sourceKey 
      # Need to have set sourceType appropriately
      filepath = "#{sourceType}/#{id}/index.md"
      args = "#{baseArgs} #{filepath}"
 
      grunt.verbose.writeln "#cmd #args"
      child = spawn cmd, (args.split " "), {cwd: sourcesDir}

      child.stderr.on 'data', (data) ->
        grunt.log.error 'stderr: ' + data

      child.stdout.on 'data', (data) ->
        # The data is the last modified date
        [yyyy, mm, dd] = data.toString!split '-'
        MMM = {
          '01': 'Jan' 
          '02': 'Feb' 
          '03': 'Mar' 
          '04': 'Apr' 
          '05': 'May' 
          '06': 'Jun' 
          '07': 'Jul' 
          '08': 'Aug' 
          '09': 'Sep' 
          '10': 'Oct' 
          '11': 'Nov' 
          '12': 'Dec'
        }[mm]
        # MMM = switch mm
        #   | '01' => 'Jan' 
        #   | '02' => 'Feb' 
        #   | '03' => 'Mar' 
        #   | '04' => 'Apr' 
        #   | '05' => 'May' 
        #   | '06' => 'Jun' 
        #   | '07' => 'Jul' 
        #   | '08' => 'Aug' 
        #   | '09' => 'Sep' 
        #   | '10' => 'Oct' 
        #   | '11' => 'Nov' 
        #   | '12' => 'Dec' 
        source.index.meta.lastUpdated = "#dd #MMM #yyyy"

      child.on 'exit', (err) ->
        if err
          grunt.log.error 'Git exited with error ' + err
        callback err # tell async that we have finished