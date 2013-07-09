"use strict"

module.exports = (grunt, common, sources, fileName, metadata) ->

  # simplify access to lodash
  _ = grunt.util._

  # LATER!

  /*
  if folder && folder.length > 0
    content = grunt.file.read "#{partialsDir}/#{folder}/#{fileName}.html"
    root = ".."
    resources = '../resources'
  else
    content = grunt.file.read "#{partialsDir}/#{fileName}.html"
    root = "."
    resources = './resources'

  html = grunt.template.process grunt.file.read(layout), {
    data:
      _head: _head
      _nav: _nav
      _foot: _foot
      _linesMenu: _linesMenu
      meta: meta
      content: content
      sources: sources
      root: root
      resources: resources
  }
  */