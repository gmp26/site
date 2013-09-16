"use strict"

module.exports = (grunt) ->

  #
  # Get layout for a given file
  #
  return (sources, folder, meta) ->

    prefix = 'layouts/'
    postfix = grunt.config.get 'layoutPostfix'
    if postfix is undefined then postfix = '.html'

    layout = meta?.layout
    if !layout
      layout = if !folder
        'home'
      else
        # layout names are singular
        m = folder.match /(^.+)s$/
        m?.1 ? folder

    layout = prefix + layout + postfix

    if grunt.file.exists layout
      layout
    else
      using = (prefix+'default'+postfix)
      grunt.verbose.writeln "#folder layout #layout does not exist, using #using"
      using

