"use strict"

module.exports = (grunt) ->

  grunt.registerTask "siteUrl", "Set the full URL of the site.", (phase) ->

    grunt.config.set 'siteUrl', if phase == 'dist'
      switch grunt.clearanceLevel
      | -1, 0 => "http://localhost:9000/"
      | 1 => "https://cmep.maths.org/fenman/" 
      | 2 => "https://cmep.maths.org/bittern/" 
      | 3 => "https://cmep.maths.org/swanage/"
      | otherwise => 
        grunt.log.error "bad clearance level: #{grunt.clearanceLevel}"
        "http://localhost:9000/"
    else 
      "http://localhost:9000/" 