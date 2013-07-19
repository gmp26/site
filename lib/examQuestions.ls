#
# exam Questions - a helper function for a lodash template
#
"use strict"

module.exports = (grunt) ->

  metadata = grunt.metadata
  sources = metadata.sources
  stations = metadata.stations
  examQuestions = metadata.examQuestions

  return (id) ->

    html = ""

    for folder in ["stations"]
      switch folder
      case 'station'
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

