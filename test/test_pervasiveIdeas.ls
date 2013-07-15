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
describe "Testing pervasive ideas expansion", (_it)->

  var metadata
  var pervasiveIdeas

  before ->
    metadata := grunt.config.get "metadata"
    pervasiveIdeas := metadata.sources.pervasiveIdeas

  describe "pervasiveIdeas", (_it) ->
    it "should have core properties", ->
      _.each pervasiveIdeas, (pi, id) ->
        pi.should.have.property 'meta'
        pi.meta.should.have.property 'id'
        pi.meta.should.have.property 'family'
        pi.meta.should.have.property 'title'


  describe "pervasiveIdea PI1", (_it) ->

    it "should list R1s", ->
      pi = pervasiveIdeas.PI1.meta
      pi.should.have.property 'R1s'
      pi.R1s.length.should.equal 1
      pi.R1s.0.id.should.equal 'PI1_RT15'
    it "should list R2s", ->
      pi = pervasiveIdeas.PI1.meta
      pi.should.have.property 'R2s'
      pi.R2s.length.should.equal 5
      pi.R2s.0.id.should.equal 'G2_RT2'
      pi.R2s.[*-1].id.should.equal 'G2_RT7'
    it "should list stations from R1s and R2s", ->
      pi = pervasiveIdeas.PI1.meta
      pi.should.have.property 'stids'
      pi.stids.should.eql ['G2', 'G3']


