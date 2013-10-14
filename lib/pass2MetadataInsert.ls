"use strict"

module.exports = (grunt) ->

  _ = grunt.util._

  pass2MetadataInsert = (pathname, target) ->
    switch target
      when 'html'
        optionsObject = pass2UtilsHtml
        configString = 'pass2html'
      when 'printables'
        optionsObject = pass2UtilsTex
        configString = 'pass2printables'

    # the pathname is a relative one from grunt's cwd to the source .md file
    # this code is rather similar to stuff in grunt-panda
    p = (path.dirname pathname) + path.sep + (path.basename pathname, '.md')
    replaceKey = "panda.#{configString}.options.metaReplace"
    replacementKey = "panda.#{configString}.options.metaReplacement"
    re = new RegExp "^#{grunt.config.get replaceKey}"
    p = p.replace re, (grunt.config.get(replacementKey) ? "")

    names = (p.split path.sep).filter (name)->name && name.length > 0
    objectpath = "metadata.#{names.join '.'}.meta"

    currentMetadata = grunt.config.get objectpath
    # expose the whole file meta under the meta field for now, this could be binned later if desired
    optionsObject.data.meta = currentMetadata

    # expose commonly used fields on the root level
    optionsObject.data.title = grunt.config.get objectpath + '.title'

    optionsObject.data.author = grunt.config.get objectpath + '.author'
    optionsObject.data.acknowledgementText = grunt.config.get objectpath + '.acknowledgementText'
    optionsObject.data.thisClearanceLevel = grunt.config.get objectpath + '.clearance'
    optionsObject.data.section = (text, level) ->
      | _.isString text => '#' * level + " #{text}"
      | otherwise => ""

    optionsObject.data.globalClearanceLevel = grunt.config.get 'clearanceLevel'
    optionsObject.data.lastUpdated = 'NOT YET IMPLEMENTED'

  printableProcess = (src, pathname) ->
    pass2MetadataInsert pathname, 'printables'
    grunt.template.process(src, pass2UtilsTex)

  htmlProcess = (src, pathname) ->
    pass2MetadataInsert pathname, 'html'
    grunt.template.process(src, pass2UtilsHtml)
