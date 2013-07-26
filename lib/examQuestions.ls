#
# exam Questions - a helper function for a lodash template
#
"use strict"

module.exports = (grunt) ->

  _ = grunt.util._

  (id) -> 

    metadata = grunt.config.get "metadata"
    sources = metadata.sources
    stations = sources.stations
    examQuestions = sources.examQuestions

    html = ""

    for folder in ["stations"]
      switch folder
      case 'stations'
        _.each examQuestions, (data, qId) ->
          if(data.index?)
            meta = data.index.meta
            if meta.stids1.indexOf(id) >= 0
              # return html for this question
              html += "Insert #qId here"
            else
              html += "Not #qId"
      default
        html = "No questions found"

    return html

