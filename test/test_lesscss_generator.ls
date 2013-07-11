/*
global describe, it
*/
"use strict"

should = require("chai").should()
grunt = require 'grunt'
_ = grunt.util._

#
# NB 'it' is a reserved word in livescript, meaning an unspecified parameter,
# so passing (_it) from describe to allow 'it' to be overridden.
#
describe "Testing lesscss generation", (_it)->

  var metadata
  var expanded
  var lines

  before ->
    metadata := grunt.config.get "metadata"
    lines := metadata.sources.lines


  describe "line metadata", (_it) ->
    it "should provide colours for each line", ->

      _.each lines, (line) ->
        meta = line.meta
        meta.should.have.property 'colour'

    it "should generate app/styles/lineVars.less", ->
      grunt.file.exists('app/styles/lineVars.less').should.be.true

    it "should contain a as many lines as there are tube lines", ->
      css = grunt.file.read "app/styles/lineVars.less"
      lineCount = (css.split /\S\n\S/).length
      (lineCount).should.equal _.size(lines)

    it "should contain correct line colours", ->
      css = grunt.file.read "app/styles/lineVars.less"
      cssLines = css.split /\n/
      _.each cssLines, (s)->
        # @lineA: #9467bd;
        m = s.match /@line([A-Z]{1,2}): (#[0-9a-fA-F]+);/
        if m != null
          m.length.should.equal 3
          lid = m.1
          col = m.2
          col.should.equal lines[lid]?.meta.colour

    it "should generate app/styles/lines.less", ->
      grunt.file.exists("app/styles/lines.less").should.be.true

    it "should make .button-line for each line", ->
      css = grunt.file.read "app/styles/lines.less"
      _.each lines, (lines) ->
        meta = lines.meta
        re = new RegExp "\\.button#{meta.id}\\s*\\{\\n\\s*\\.button-line\\(@linecolor#{meta.id}\\)", "m"
        #re = new RegExp "\.button#{meta.id}", "m"
        css.should.match re


   

