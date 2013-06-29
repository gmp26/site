#
# grunt-clearance
#
"use strict"

module.exports = (grunt) ->

  # register clearance task
  grunt.registerTask "clearance", "set or get the clearance level", (target) ->
    clearanceFile = ".clearance"
    if !target?
      target = if grunt.file.exists clearanceFile
        grunt.file.read clearanceFile
      else
        -1
    target = ~~target #convert to number - we want zero rather than NaN for non-numeric strings - otherwise '+' would do.

    # save the (new) clearance level
    grunt.log.ok "Clearance level "+target
    grunt.file.write clearanceFile, ""+target

    # switch config to use appropriate source directory
    grunt.config.set "yeoman.sources", if target < 0
      grunt.config.get "yeoman.samples"
    else
      grunt.config.get "yeoman.content"
    grunt.log.ok "Content directory is "+grunt.config.get "yeoman.sources"

