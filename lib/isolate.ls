#
# grunt-isolate: Supplies an isolate string which selects a subset of
# site resources and exam questions to process.
#
# The syntax allows a resource through if the given token (a regular expression)
# matches elements in the resource's stids1 or pvids1 lists or its resourceType.
#
"use strict"

module.exports = (grunt) ->

  # register isolate task
  grunt.registerTask "isolate", "set or get the isolate token", (token) ->
    isolateFile = ".isolate"
    if !token?
      token = if grunt.file.exists isolateFile
        grunt.file.read isolateFile
      else
        ".*"

    # save the (new) isolate token
    grunt.log.ok "Isolate token "+token
    grunt.file.write isolateFile, ""+token
