/*
global describe, it
*/
"use strict"

cssParser = require 'css-parse'

should = require("chai").should()
grunt = require 'grunt'
_ = grunt.util._

#
# NB 'it' is a reserved word in livescript, meaning an unspecified parameter,
# so passing (_it) from describe to allow 'it' to be overridden.
#
describe "Testing line colour generation", (_it)->

  var metadata
  var expanded
  var lines

  before ->
    metadata := grunt.config.get "metadata"
    lines := metadata.sources.lines

    debugger
    foo = cssParser('''
.lineA {
  color: #9467bd
}

.lineC {
  color: #bcbd22
}
''')

  describe "line metadata", (_it) ->
    it "should provide colours for each line", ->

      _.each lines, (line) ->
        meta = line.meta
        meta.should.have.property 'colour'

    it "should generate app/styles/lineVars.less", ->
      grunt.file.exists('app/styles/lineVars.less').should.be.true

    it "app/styles/lineVars.less should contain valid css", ->
      css = grunt.file.read "app/styles/lineVars.less"
      (->cssParser(css)).should.not.throw()

    it "should contain a class for each line", ->
      css = grunt.file.read "app/styles/lineVars.less"
      tree = cssParser(css)
      (_.size tree.stylesheet.rules).should.equal _.size(lines)

    it "should contain correct line colours", ->
      css = grunt.file.read "app/styles/lineVars.less"
      tree = cssParser(css)
      _.each tree.stylesheet.rules, (rule) ->
        lineId = rule.selectors.0
        colour = rule.declarations.0.value
        lineCode =  lineId.substr ".line".length
        grunt.log.ok "line #lineId, colour #colour"
        colour.should.equal lines[lineCode]?.meta.colour


   

