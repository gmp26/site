#
# exam Question generator - a helper function for a lodash template
#
"use strict"

module.exports = (grunt) ->

  _ = grunt.util._

  (id) -> 

    metadata = grunt.config.get "metadata"
    sources = metadata.sources
    stations = sources.stations
    examQuestions = sources.examQuestions
