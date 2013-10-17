"use strict"

module.exports = (grunt, path) ->

  _ = grunt.util._

  pass2UtilsHtml = (require './pass2UtilsHtml.js')(grunt)
  pass2UtilsTex = (require './pass2UtilsTex.js')(grunt)

  pass2MetadataInsert = (pathname, target) ->

    switch target
      when 'html'
        optionsObject = pass2UtilsHtml
        configString = 'pass2html'
        html = true
      when 'printables'
        optionsObject = pass2UtilsTex
        configString = 'pass2printables'
        html = false

    # the pathname is a relative one from grunt's cwd to the source .md file
    # this code is rather similar to stuff in grunt-panda
    p = (path.dirname pathname) + path.sep + (path.basename pathname, '.md')
    replaceKey = "panda.#{configString}.options.metaReplace"
    replacementKey = "panda.#{configString}.options.metaReplacement"
    re = new RegExp "^#{grunt.config.get replaceKey}"
    p = p.replace re, (grunt.config.get(replacementKey) ? "")

    names = (p.split path.sep).filter (name)->name && name.length > 0
    objectpath = "metadata.#{names.join '.'}.meta"
    meta = grunt.config.get objectpath

    # The resource may have been culled, so check meta exists before proceeding.
    if meta? 

      # expose the whole file meta under the meta field. 
      # useful for tests.
      optionsObject.data.meta = meta
      data = optionsObject.data

      # expose commonly used fields on the root level for ease of use.
      data.title = meta.title
      data.author = meta.author
      data.acknowledgementText = meta.acknowledgementText = 'Some acknowledgement'
      data.thisClearanceLevel = meta.clearance
      data.globalClearanceLevel = grunt.config.get 'clearanceLevel'
      data.lastUpdated = meta.lastUpdated

      # Add in some support functions 
      data.glossary = (text1, text2) ->

        if text2?
          ref = text2
          link = text1
        else
          ref = text1
          link = text1

        if html
          # replace with an api call which populates a popover
          "[#{link}](/glossaries/#{ref.substr(0,1)}/\##{ref})"
        else
          # provisionally...
          explanation = grunt.config.get "metadata.glossary.#{ref}"
          "[^#{link}]: #{explanation}"

  #
  # Monkey patch grunt.warn for the duration of lodash template processing
  # so it logs the pathname where any error occurred.
  #
  monkeyPatchWarn = (pathname) ->
    oldWarn = grunt.warn 
    grunt.warn = (e, errcode) ->
      message = if _.isString e then e else e.message
      grunt.log.error "Error in #{pathname}: #{message}"

    return oldWarn

  return {

    printableProcess: (src, pathname) ->

      oldWarn = monkeyPatchWarn pathname

      pass2MetadataInsert pathname, 'printables'
      content = grunt.template.process(src, pass2UtilsTex)

      grunt.warn = oldWarn
      return content

    htmlProcess: (src, pathname) ->
      # we're only interested in resources

      oldWarn = monkeyPatchWarn pathname

      pass2MetadataInsert pathname, 'html'
      content = grunt.template.process(src, pass2UtilsHtml)

      grunt.warn = oldWarn
      return content

  }

