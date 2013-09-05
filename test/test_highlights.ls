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
describe "Testing highlights expansion", (_it)->

  var metadata
  var expanded
  var estations

  before ->
    metadata := grunt.config.get "metadata"
    estations := metadata.sources.stations

  describe "checking metadata", (_it) ->
    it "should yield sources and stations", ->
      metadata.should.have.property('sources')
      (_.size metadata.sources.stations).should.equal 60

  describe "A1", (_it) ->
    it "should have dependent A2", ->
      estations.A1.meta.dependents.should.include('A2')

  describe "A1", (_it) ->
    it "should have no dependencies", ->
      estations.A1.meta.dependencies.should.be.a 'array'
      estations.A1.meta.dependencies.length.should.equal 0

  describe "A1", (_it) ->
    it "should not have highlighted G2_RT7", ->
      should.not.exist(estations.A1.meta.highlights?.G2_RT7)

  describe "A1", (_it) ->
    it "should not have highlighted G2_RT2", ->
      should.not.exist(estations.A1.meta.R1s?.G2_RT2)

  describe "G2", (_it) ->
    it "should have highlighted G2_RT7", ->
      should.exist _.find estations.G2.meta.R1s, (.id == "G2_RT7")

  describe "NA3", (_it) ->
    it "should not have highlighted G2_RT2 since NA3 is not in stids1 for G2_RT2", ->
      should.not.exist _.find estations.NA3.meta.R1s, (.id == "G2_RT2")
 
 


