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
describe "Testing pervasiveIdea family expansion", (_it)->

  var metadata

  before ->
    metadata := grunt.config.get "metadata"

  describe "families", (_it) ->
    it "should be a non empty array", ->
      metadata.should.have.property 'families'
      metadata.families.should.be.instanceof Array
    it "should contain 2 families", ->
      metadata.families.length.should.equal 2
    it "should contain a concept and a process in order", ->
      metadata.families.0.family.should.equal 'concept'
      metadata.families.0.pvids.length.should.equal 2
      metadata.families.1.family.should.equal 'process'
      metadata.families.1.pvids.length.should.equal 4

