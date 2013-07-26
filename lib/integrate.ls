#
# grunt-integrate: The opposite of isolate. Opens the site to build all sources.
#
"use strict"

module.exports = (grunt) ->

  # register integrate task
  grunt.registerTask "integrate", "remove the isolate file", (token) ->
    isolateFile = ".isolate"
    if grunt.file.exists isolateFile
      grunt.file.delete isolateFile
