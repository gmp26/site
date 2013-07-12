#
# grunt-tubemap
#
"use strict"

jsy = require 'js-yaml'
pathUtils = require 'path'

module.exports = (grunt) ->

  _ = grunt.util._

  # Please see the Grunt documentation for more information regarding task
  # creation: http://gruntjs.com/creating-tasks
  grunt.registerMultiTask "tubemap", "Generate the tube map.", ->

    done = @async!

    partials = grunt.config.get "yeoman.partials"

    gvFile = "#{partials}/tubemap/tubemap.dot"

    # Merge task-specific and/or target-specific options with these defaults.
    options = @options(
    )

    # Iterate over all specified file groups.
    _.each @files, (f) ->

      # Warn on and remove invalid source files (if nonull was set).

      # Read file source.
      src = f.src.filter((filepath) ->
        unless grunt.file.exists(filepath)
          grunt.log.warn "Source file \"" + filepath + "\" not found."
          false
        else
          true
      )

      metadata = grunt.file.readYAML(src[0]).sources

      output = ''
      prevlinecolour = ''
      i = 0
      postreplace = []

      for stationname,data of metadata.stations
        linename = stationname.replace /[0-9].*/g, ''
        linecolour = metadata.lines[linename].meta.colour
        for dep of data.meta.dependencies
          for dept of data.meta.dependents
            if data.meta.dependencies[dep] == data.meta.dependents[dept]
              ordered = _.sortBy([stationname,data.meta.dependents[dept]])
              replacement = '"' + ordered[0] + '-' + ordered[1] + '"'
              postreplace[i++] = {"stationname": stationname, "replacement": replacement}
              stationname = replacement
              data.meta.dependents[dept] = ''

        for dept of data.meta.dependents
          if data.meta.dependents[dept] != ''
            if linecolour != prevlinecolour
              output = output+'edge [style=bold ,color="'+linecolour+'"]\n'
              prevlinecolour = linecolour
            output = output + stationname + ' -> ' + data.meta.dependents[dept] + ' ;\n'

      for next of postreplace
        reg = new RegExp postreplace[next].stationname+' ', 'g'
        output = output.replace reg,postreplace[next].replacement

      output = 'digraph CMEP_Tube {
      node [shape=plaintext ,fillcolor="#EEF2FF", fontsize=16, fontname=arial]' + output + '}'
      grunt.file.write gvFile, output

      #dot = '/opt/local/bin/dot'
      #if grunt.file.exists dot

      options = {cmd:'dot',args:['-Tsvg', "-o#{f.dest}", gvFile]}
      grunt.util.spawn options, (error, result, code) ->
        grunt.log.debug code
        if code != 0
          grunt.log.error result.stderr
        done()

      # Print a success message.
      grunt.log.writeln "File \"" + f.dest + "\" created."


